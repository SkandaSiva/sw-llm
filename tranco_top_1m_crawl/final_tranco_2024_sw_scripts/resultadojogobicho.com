self.addEventListener('install', function(e) {
 e.waitUntil(
   // caches.open('meu-jogo-do-bicho-store').then(function(cache) {
     // return cache.addAll([
       // '/templates/img/logo-resultado-nacional.png'
     // ]);
   // })
 );
});

self.addEventListener('fetch', function(e) {
  // console.log(e.request.url);
  // e.respondWith(
    // caches.match(e.request).then(function(response) {
      // return response || fetch(e.request);
    // })
  // );
});