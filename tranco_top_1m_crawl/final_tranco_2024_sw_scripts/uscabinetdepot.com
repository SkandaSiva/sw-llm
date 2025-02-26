importScripts('https://storage.googleapis.com/workbox-cdn/releases/5.1.2/workbox-sw.js');
workbox.setConfig({ skipWaiting: true, clientsClaim: true, debug: 0
});
const version = "2.0.0";
const {registerRoute} = workbox.routing;
const {CacheFirst} = workbox.strategies;
const {CacheableResponsePlugin} = workbox.cacheableResponse;
const FALLBACK_HTML_URL = self.location.pathname.replace('service-worker.js', 'no-route');
const MANIFEST_JSON = self.location.pathname.replace('service-worker.js', 'pwa/manifest');
workbox.loadModule('workbox-expiration');
workbox.loadModule('workbox-background-sync');
// cache name setting
workbox.core.setCacheNameDetails({ prefix: 'workbox-cache', precache: 'precache', suffix: `v${version}`, });
// precache manifest and fallback html
workbox.precaching.precacheAndRoute([ {url: FALLBACK_HTML_URL, revision: null}, {url: MANIFEST_JSON, revision: null}
]);
// Fallback offline page
workbox.routing.setCatchHandler(({event}) => { switch (event.request.destination) { case 'document': return caches.match(FALLBACK_HTML_URL); break; default: return Response.error(); }
});
//Backgroud sync for search page offline
const bgSyncPlugin = new workbox.backgroundSync.BackgroundSyncPlugin('offlineQueryQueue', { maxRetentionTime: 10, onSync: async ({queue}) => { let entry; while (entry = await queue.shiftRequest()) { try { const response = await fetch(entry.request); const cache = await caches.open('offline-search-responses'); const offlineUrl = entry.request.url + '?notification=true'; cache.put(offlineUrl, response); if (offlineUrl.includes('catalogsearch')) { showSearchNotification(offlineUrl); } if (offlineUrl.includes('checkout')) { showCheckoutNotification(offlineUrl); } } catch (error) { await this.unshiftRequest(entry); throw error; } } }
});
/** * removing cache if the cache version in updated */ let currentCacheNames = Object.assign( { precacheTemp: workbox.core.cacheNames.precache + "-temp" }, workbox.core.cacheNames
);
// clean up old SW caches
self.addEventListener("activate", function(event) { event.waitUntil( caches.keys().then(function(cacheNames) { let validCacheSet = new Set(Object.values(currentCacheNames)); return Promise.all( cacheNames .filter(function(cacheName) { return !validCacheSet.has(cacheName); }) .map(function(cacheName) { return caches.delete(cacheName); }) ); }) );
});
/** * installing service worker */
self.addEventListener('install', function(event) { event.waitUntil(self.skipWaiting());
});
// runtime cache
// 1. stylesheet
registerRoute( new RegExp('\.css$'), new workbox.strategies.CacheFirst({ cacheName: `workbox-cache-stylesheets-v${version}`, plugins: [ new CacheableResponsePlugin({ statuses: [0, 200], }) ] })
);
// 2. js files
registerRoute( new RegExp('\.js$'), new workbox.strategies.CacheFirst({ cacheName: `workbox-cache-javascript-v${version}`, plugins: [ new workbox.expiration.ExpirationPlugin({ maxAgeSeconds: 30 * 24 * 60 * 60 }), new CacheableResponsePlugin({ statuses: [0, 200], }) ] })
);
// 3. images
registerRoute( new RegExp('\.(png|svg|jpg|jpeg|ico|gif)$'), new workbox.strategies.CacheFirst({ cacheName: `workbox-cache-images-v${version}`, plugins: [ new CacheableResponsePlugin({ statuses: [0, 200], }), new workbox.expiration.ExpirationPlugin({ maxAgeSeconds: 30 * 24 * 60 * 60 }) ] })
);
// 4. html
registerRoute( new RegExp('\.(html)$'), new workbox.strategies.StaleWhileRevalidate({ cacheName: `workbox-cache-html-v${version}` })
);
// 5. third party urls
registerRoute( ({url}) => url.origin === 'https://fonts.googleapis.com' || url.origin === 'https://cdnjs.cloudflare.com' || url.origin === 'https://cdn.loom.com' || url.origin === 'https://storage.googleapis.com', new CacheFirst({ cacheName: 'workbox-crosorigin-cache', plugins: [ new CacheableResponsePlugin({ statuses: [0, 200], }) ] })
);
// 6. Fonts
registerRoute( /\.(?:woff|woff2|ttf|otf)$/, new workbox.strategies.CacheFirst({ cacheName: `workbox-cache-fonts-v${version}`, plugins: [ new workbox.expiration.ExpirationPlugin({ maxAgeSeconds: 30 * 24 * 60 * 60, maxEntries: 10 }), new CacheableResponsePlugin({ statuses: [0, 200], }) ] })
);
// Match url not searched
const nonSearchUrl = ({url, request}) => { const notificationParam = url.searchParams.get('notification'); return (request.destination == 'document' && (!url.pathname.includes('catalogsearch')) && !(notificationParam === 'true'));
};
//cache non search urls
registerRoute( nonSearchUrl, new workbox.strategies.NetworkFirst({ cacheName: `workbox-cache-document-v${version}`, plugins: [ new workbox.expiration.ExpirationPlugin({ maxEntries: 20, }), new CacheableResponsePlugin({ statuses: [0, 200], }) ], })
);
//Match search url
const matchSearchUrl = ({url, request}) => { const notificationParam = url.searchParams.get('notification'); return (request.destination == 'document' && (url.pathname.includes('catalogsearch')) && !(notificationParam === 'true'));
};
registerRoute( matchSearchUrl, new workbox.strategies.NetworkOnly({ plugins: [bgSyncPlugin] })
);
const matchNotificationUrl = ({url}) => { const notificationParam = url.searchParams.get('notification'); return (url.pathname.includes('catalogsearch') && (notificationParam === 'true'));
};
registerRoute( matchNotificationUrl, new workbox.strategies.CacheFirst({ cacheName: 'offline-search-responses', })
);
function showSearchNotification(notificationUrl) { if(Notification.permission) { self.registration.showNotification('Your search is ready!', { body: "Click to see you search result", icon: '', data: { url: notificationUrl } }); }
}
function showCheckoutNotification(notificationUrl) { if(Notification.permission) { self.registration.showNotification('Your checkout is ready!', { body: "Click to see you checkout result", icon: '', data: { url: notificationUrl } }); }
}
self.addEventListener('notificationclick', function(event) { event.notification.close(); var url; if (event.notification.data) { url = event.notification.data.url; } else { url = event.notification.actions[0].action; } event.waitUntil( clients.openWindow(url) );
});
/** * listener for push notification */
self.addEventListener( 'push', function (event) { Logging(event.data); Logging(event.data.text()); console.log(event.data.json()); var dataa = {}; try { const data = event.data?.json() ?? {}; try { dataa = JSON.parse(data.notification); } catch (e) { if (typeof data.notification !== "undefined") { dataa = data.notification; } else { dataa = data.data.notification; } } var actions = [{"action":dataa.click_action, "title":"Go to the Site"}]; event.waitUntil( self.registration.showNotification( dataa.title, { body: dataa.body, icon: dataa.icon, vibrate: 1, actions: actions } ) ); } catch(e) { console.error(e, e.stack); try { dataa = JSON.parse(event.data.text()); dataa = dataa.notification; var actions = [{"action":dataa.click_action, "title":"Go to the Site"}]; event.waitUntil( self.registration.showNotification( dataa.title, { body: dataa.body, icon: dataa.icon, vibrate: 1, actions: actions } ) ); } catch(e) { console.error(e, e.stack); event.waitUntil( self.registration.showNotification( event.data.text() ) ); } } }
);
/** * Logging function to log * * @param {mixed} $log */
function Logging()
{ var canLog = 0; if (canLog) { console.log(arguments); }
};
function ext(url)
{ return (url = url.substr(1 + url.lastIndexOf("/")).split('?')[0]).split('#')[0].substr(url.lastIndexOf("."));
}
function isValidHttpUrl(string) { let url; try { url = new URL(string); } catch (_) { return false; } return url.protocol === "http:" || url.protocol === "https:";
}