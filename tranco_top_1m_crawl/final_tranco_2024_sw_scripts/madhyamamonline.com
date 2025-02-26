// importScripts('static/js/analytics-helper.js');

const versionMain = '1.0.'+new Date().getUTCDate();
const CACHE_NAME = 'mdm-pwa-v0-'+versionMain;
const CACHE_FILES = ['/','/offline'];
const CACHE_HOSTS = ['www.madhyamam.com','assets.madhyamam.com','english.madhyamam.com','localhost'];

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll(CACHE_FILES);
    })
  );
});

self.addEventListener('activate', function(e) {
    e.waitUntil(
        Promise.all([
            self.clients.claim(),
            caches.keys().then(function(cacheNames) {
                return Promise.all(
                    cacheNames.map(function(cacheName) {
                        if (cacheName !== CACHE_NAME) {
                            return caches.delete(cacheName);
                        }
                    })
                );
            })
        ])
    );
});

self.addEventListener('fetch', function(event) {
    const url = new URL(event.request.url);
    //console.log('fetch:'+url);
    
    if(!navigator.onLine){
        //console.log('offline');
        event.respondWith(
            caches.match(event.request).then(function(response) {
              return response || fetch('/offline');
            }));
        //offline message
    }else if (event.request.method === 'GET' && CACHE_HOSTS.indexOf(url.hostname) !== -1) {
        //   console.log('URL HOSTNAME' + url.hostname)
        if (CACHE_HOSTS.indexOf(url.hostname) !== -1) {
            //console.log('GET');
            event.respondWith(
                caches.open(CACHE_NAME).then(function(cache) {
                  return fetch(event.request).then(function(response) {
                    cache.put(event.request, response.clone());
                    return response;
                  });
                })
            );
        }
    }
});


