(function () {
    'use strict';

    // Update 'version' if you need to refresh the cache
    var version = 'v1.1::CacheFirstSafe';
    var offlineUrl = "offline.html";
    var urlsToCache = [
        '/',
        'favicon.ico',
        offlineUrl,
        '/Content/images/pwa-icons/icon-512x512.png'
    ];

    // Store core files in a cache (including a page to display when offline)
    function updateStaticCache() {
        return caches.open(version)
            .then(function (cache) {
                return cache.addAll(urlsToCache);
            });
    }

    function addToCache(request, response) {
        if (!response.ok || response.type === 'opaque') {
            return;
        }

        var copy = response.clone();
        caches.open(version)
            .then(function (cache) {
                if (copy.headers.get('Vary') == '*') {
                    return;
                }
                cache.put(request, copy);
            });
    }

    function serveOfflineImage(request) {
        if (request.headers.get('Accept').indexOf('image') !== -1) {
            return new Response('<svg role="img" aria-labelledby="offline-title" viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg"><title id="offline-title">Offline</title><g fill="none" fill-rule="evenodd"><path fill="#D8D8D8" d="M0 0h400v300H0z"/><text fill="#9B9B9B" font-family="Helvetica Neue,Arial,Helvetica,sans-serif" font-size="72" font-weight="bold"><tspan x="93" y="172">offline</tspan></text></g></svg>', { headers: { 'Content-Type': 'image/svg+xml' } });
        }
    }
    
    self.addEventListener('install', function (event) {
        event.waitUntil(updateStaticCache());
    });

    self.addEventListener('activate', function (event) {
        event.waitUntil(
            caches.keys()
                .then(function (keys) {
                    // Remove caches whose name is no longer valid
                    return Promise.all(keys
                        .filter(function (key) {
                            return key.indexOf(version) !== 0;
                        })
                        .map(function (key) {
                            return caches.delete(key);
                        })
                    );
                })
        );
    });

    self.addEventListener('fetch', function (event) {
        var request = event.request;

        // Always fetch non-GET requests from the network
        if (request.method !== 'GET' || request.url.match(/\/browserLink/ig)) {
            return;
        }

        // For HTML requests, try the network first, fall back to the cache, finally the offline page
        if (request.headers.get('Accept').indexOf('text/html') !== -1) {
            event.respondWith(
                fetch(request)
                    .then(function (response) {
                        // Stash a copy of this page in the cache
                        addToCache(request, response);
                        return response;
                    })
                    .catch(function () {
                        return caches.match(request)
                            .then(function (response) {
                                return response || caches.match(offlineUrl);
                            });
                    })
            );
            return;
        }

        // cache first for fingerprinted resources
        if (request.url.match(/(\?|&)v=/ig)) {
            event.respondWith((async () => {
                const cachedResponse = await caches.match(request);
                if (cachedResponse) {
                    return cachedResponse;
                }
                
                const response = await fetch(request);
                if (!response || response.status !== 200 || response.type !== 'basic') {
                    return response || serveOfflineImage(request);
                }

                addToCache(request, response);

                return response || serveOfflineImage(request);
            })());
            
            return;
        }

        // network first for non-fingerprinted resources
        event.respondWith((async () => {
            try {
                const response = await fetch(request);
                
                if (!response || response.status !== 200 || response.type !== 'basic') {
                    const cachedResponse = await caches.match(request);
                    if (cachedResponse) {
                        return cachedResponse;
                    }

                    return response || serveOfflineImage(request);
                }

                addToCache(request, response);

                return response;
            } catch (error) {
                return new Response(null, {
                    status: 200,
                });
            }
        })());
    });
})();