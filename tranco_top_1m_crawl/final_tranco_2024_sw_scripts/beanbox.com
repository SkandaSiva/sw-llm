var CACHE_VERSION   = 'v1';
var CACHE_NAME      = CACHE_VERSION + ':sw-cache-';

function onInstall(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function prefill(cache) {
      return cache.addAll([
        '/assets/gesha/framework/beanbox-logo.png',
        '/assets/gesha/hero/bags.jpg',
        '/offline.htm'
      ]);
    })
  );
}

function onActivate(event) {
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.filter(function(cacheName) {
          return cacheName.indexOf(CACHE_VERSION) !== 0;
        }).map(function(cacheName) {
          return caches.delete(cacheName);
        })
      );
    })
  );
}

function onFetch(event) {
  event.respondWith(
    fetch(event.request).catch(function() {
      return caches.match(event.request).then(function(response) {
        if (response) {
          return response;
        }
        if (event.request.mode === 'navigate' ||
          (event.request.method === 'GET' && event.request.headers.get('accept').includes('text/html'))) {
          return caches.match('/offline.html');
        }
      })
    })
  );
}

self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);
