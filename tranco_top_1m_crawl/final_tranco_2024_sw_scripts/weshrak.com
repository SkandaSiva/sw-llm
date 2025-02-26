'use strict';

const version = 14;
const CACHE_NAME = "PRECACHE-" + version;
// Customize this with a different URL if needed.

const OFFLINE_URL = '/index.php?offlinepage';
let langue = "en";
const filesToCache = [
	OFFLINE_URL,
  '/fr/offline',
  'https://pictures.isn-services.com/websites/styles/ISNServices.min.css'
];

console.log("SW VERSION:"+version);

self.addEventListener('install', (event) => {
	console.log('Install caches');
	event.waitUntil((async () => {
		langue = await new URL(location).searchParams.get('lang');
		console.log('lang',langue);
		const cache = await caches.open(CACHE_NAME);
		// Setting {cache: 'reload'} in the new request will ensure that the response
		// isn't fulfilled from the HTTP cache; i.e., it will be from the network.
		await cache.add(new Request(OFFLINE_URL+'&lang='+langue, {cache: 'reload'}));
	})());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    // Enable navigation preload if it's supported.
    // See https://developers.google.com/web/updates/2017/02/navigation-preload
    if ('navigationPreload' in self.registration) {
      await self.registration.navigationPreload.enable();
    }
  })());
  // Tell the active service worker to take control of the page immediately.
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  // We only want to call event.respondWith() if this is a navigation request
  // for an HTML page.
  if (event.request.mode === 'navigate' && !event.request.referrer.includes("advertise")) {
    event.respondWith((async () => {
      try {
        // First, try to use the navigation preload response if it's supported.
        const preloadResponse = await event.preloadResponse;
        if (preloadResponse) {
          return preloadResponse;
        }
        const networkResponse = await fetch(event.request);
        return networkResponse;
      } catch (error) {
        // catch is only triggered if an exception is thrown, which is likely
        // due to a network error.
        // If fetch() returns a valid HTTP response with a response code in
        // the 4xx or 5xx range, the catch() will NOT be called.
        console.log('Fetch failed; returning offline page instead.', error);

        const cache = await caches.open(CACHE_NAME);
        const cachedResponse = await cache.match(OFFLINE_URL+'&lang='+langue);
        return cachedResponse;
      }
    })());
  }
  // If our if() condition is false, then this fetch handler won't intercept the
  // request. If there are any other fetch handlers registered, they will get a
  // chance to call event.respondWith(). If no fetch handlers call
  // event.respondWith(), the request will be handled by the browser as if there
  // were no service worker involvement.
});
/************Notifications*********************/
self.addEventListener('push', function(event) {
    const dataJSON = event.data.json();
    const notificationOptions = {
		tag: 'preset',
		icon: dataJSON.icon,
        body: dataJSON.body,
        data: {
            url: dataJSON.url,
        }
    };
	event.waitUntil(self.registration.showNotification(dataJSON.title, notificationOptions));
});
self.addEventListener('notificationclick', event => {
    const url = event.notification.data.url;
    event.notification.close();
    event.waitUntil(clients.openWindow(url));
});
/***********************************************/