const staticCacheName = 'site-static-v8';
const dynamicCacheName = 'site-dynamic-v2';
const assets = [
  '/assets/js/validatejs/jquery-3.1.1.js',
  '/assets/js/validatejs/autosize.js',
  '/assets/js/validatejs/pwa.js',
  '/offline.html'

];

// install event
self.addEventListener('install', evt => {
  //console.log('service worker installed');
  evt.waitUntil(
    caches.open(staticCacheName).then((cache) => {
      console.log('caching shell assets');
      cache.addAll(assets);
    })
  );
});

// activate event
self.addEventListener('activate', evt => {
  //console.log('service worker activated');
  evt.waitUntil(
    caches.keys().then(keys => {
      //console.log(keys);
      return Promise.all(keys
        .filter(key => key !== staticCacheName && key !== dynamicCacheName)
        .map(key => caches.delete(key))
      );
    })
  );
});

// fetch event
self.addEventListener('fetch', evt => {
  //console.log('fetch event', evt);
  evt.respondWith(
    caches.match(evt.request).then(cacheRes => {
      return cacheRes || fetch(evt.request).then(fetchRes => {
        return caches.open(dynamicCacheName).then(cache => {
         // cache.put(evt.request.url, fetchRes.clone());
          return fetchRes;
        })
     || cacheRes });
    }).catch(() => caches.match('/offline.html'))
  );
});