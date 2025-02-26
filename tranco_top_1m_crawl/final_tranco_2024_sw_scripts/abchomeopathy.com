


//var version = "0.04";

// do not rename or service worker wont ever be found. service worksers are tricksy like that.

const PRECACHE = 'precache-v1.01';
const RUNTIME = 'runtime';

// A list of local resources we always want to be cached.
const PRECACHE_URLS = [

            
            '/styles10.css',
            '/shoptions19-min.js',
            '/header25-min.js',
            '/JSdata/glossary8.js',
            '/shiptimes2.js',
            '/JSdata/equivalents2.js',
            '/go3.css',
            '/images/shim.gif',
            '/go14-min.js',
            '/images/ABCHomeopathy.png'
          
];

// The install handler takes care of precaching the resources we always need.
self.addEventListener('install', event => {
        console.log ('installing SW');
  event.waitUntil(
    caches.open(PRECACHE)
      .then(cache => cache.addAll(PRECACHE_URLS))
      .then(self.skipWaiting())
  );
});

// The activate handler takes care of cleaning up old caches.
self.addEventListener('activate', event => {
    //onsole.log ('activating SW');
  const currentCaches = [PRECACHE, RUNTIME];
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return cacheNames.filter(cacheName => !currentCaches.includes(cacheName));
    }).then(cachesToDelete => {
      return Promise.all(cachesToDelete.map(cacheToDelete => {
        return caches.delete(cacheToDelete);
      }));
    }).then(() => self.clients.claim())
  );
});

// The fetch handler serves responses for same-origin resources from a cache.
// If no response is found, it populates the runtime cache with the response
// from the network before returning it to the page.

/*
causes issues with post data

self.addEventListener('fetch', event => {
  // Skip cross-origin requests, like those for Google Analytics.
  //onsole.log ('fetching from SW');
  if (event.request.url.startsWith(self.location.origin)) {
    event.respondWith(
      caches.match(event.request).then(cachedResponse => {
        if (cachedResponse) {
            //onsole.log ('returning cached response from SW');
          return cachedResponse;
        }

        return caches.open(RUNTIME).then(cache => {
          return fetch(event.request).then(response => {
            // Put a copy of the response in the runtime cache.
            return cache.put(event.request, response.clone()).then(() => {
              return response;
            });
          });
        });
      })
    );
  }
});


*/


