const options = {"workboxURL":"https://cdn.jsdelivr.net/npm/workbox-cdn@5.1.4/workbox/workbox-sw.js","importScripts":[],"config":{"debug":false},"cacheOptions":{"cacheId":"@vue-storefront/shopify-theme-prod","directoryIndex":"/","revision":"p53PQ0f7kw4p"},"clientsClaim":true,"skipWaiting":true,"cleanupOutdatedCaches":true,"offlineAnalytics":false,"preCaching":[{"revision":"p53PQ0f7kw4p","url":"/?standalone=true"},{"revision":"p53PQ0f7kw4p","url":"/fonts/AvenirHeavy.woff2"},{"revision":"p53PQ0f7kw4p","url":"/fonts/AvenirMedium.woff2"},{"revision":"p53PQ0f7kw4p","url":"/fonts/GellatioRegular.woff2"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/bullet.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/li-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/pagination-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/pagination-icon1.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/star-icon1.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/star-icon2.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/subtract-bottom.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/subtract-top.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/texture-collective-top.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/texture-faq.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/img/Tim_and_Seb_Signature.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/cmspage/certified-b-corporation-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/cmspage/co2-carbon-neutral-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/cmspage/fair-for-life-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/cmspage/fair-wild-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/cmspage/for-the-planet-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/cmspage/soil-association-icon.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/error/error.svg"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-articles-bottom-640w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-articles-bottom-1280w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-articles-bottom-2560w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-articles-bottom-3680w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-articles-top-640w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-articles-top-1280w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-articles-top-1840w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-faq-bottom-640w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-faq-bottom-1280w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-faq-bottom-1840w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-faq-top-640w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-faq-top-1280w.png"},{"revision":"p53PQ0f7kw4p","url":"/uk/productpage/texture-pdp-faq-top-1840w.png"}],"runtimeCaching":[{"urlPattern":{},"handler":"CacheFirst","options":{"cacheName":"PukkaAssets","expiration":{"maxEntries":100,"maxAgeSeconds":7200}},"method":"GET","strategyPlugins":[]},{"urlPattern":"//www.pukkaherbs.com/.*","handler":"CacheFirst","method":"GET","strategyOptions":{"cacheableResponse":{"statuses":[0,200]}},"strategyPlugins":[]},{"urlPattern":"//assets.ctfassets.net/.*","handler":"CacheFirst","method":"GET","strategyPlugins":[]},{"urlPattern":"/_nuxt/","handler":"CacheFirst","method":"GET","strategyPlugins":[]},{"urlPattern":"/","handler":"NetworkFirst","method":"GET","strategyPlugins":[]}],"offlinePage":null,"pagesURLPattern":"/","offlineStrategy":"NetworkFirst"}

importScripts(...[options.workboxURL, ...options.importScripts])

initWorkbox(workbox, options)
workboxExtensions(workbox, options)
precacheAssets(workbox, options)
cachingExtensions(workbox, options)
runtimeCaching(workbox, options)
offlinePage(workbox, options)
routingExtensions(workbox, options)

function getProp(obj, prop) {
  return prop.split('.').reduce((p, c) => p[c], obj)
}

function initWorkbox(workbox, options) {
  if (options.config) {
    // Set workbox config
    workbox.setConfig(options.config)
  }

  if (options.cacheNames) {
    // Set workbox cache names
    workbox.core.setCacheNameDetails(options.cacheNames)
  }

  if (options.clientsClaim) {
    // Start controlling any existing clients as soon as it activates
    workbox.core.clientsClaim()
  }

  if (options.skipWaiting) {
    workbox.core.skipWaiting()
  }

  if (options.cleanupOutdatedCaches) {
    workbox.precaching.cleanupOutdatedCaches()
  }

  if (options.offlineAnalytics) {
    // Enable offline Google Analytics tracking
    workbox.googleAnalytics.initialize()
  }
}

function precacheAssets(workbox, options) {
  if (options.preCaching.length) {
    workbox.precaching.precacheAndRoute(options.preCaching, options.cacheOptions)
  }
}


function runtimeCaching(workbox, options) {
  const requestInterceptor = {
    requestWillFetch({ request }) {
      if (request.cache === 'only-if-cached' && request.mode === 'no-cors') {
        return new Request(request.url, { ...request, cache: 'default', mode: 'no-cors' })
      }
      return request
    },
    fetchDidFail(ctx) {
      ctx.error.message =
        '[workbox] Network request for ' + ctx.request.url + ' threw an error: ' + ctx.error.message
      console.error(ctx.error, 'Details:', ctx)
    },
    handlerDidError(ctx) {
      ctx.error.message =
        `[workbox] Network handler threw an error: ` + ctx.error.message
      console.error(ctx.error, 'Details:', ctx)
      return null
    }
  }

  for (const entry of options.runtimeCaching) {
    const urlPattern = new RegExp(entry.urlPattern)
    const method = entry.method || 'GET'

    const plugins = (entry.strategyPlugins || [])
      .map(p => new (getProp(workbox, p.use))(...p.config))

    plugins.unshift(requestInterceptor)

    const strategyOptions = { ...entry.strategyOptions, plugins }

    const strategy = new workbox.strategies[entry.handler](strategyOptions)

    workbox.routing.registerRoute(urlPattern, strategy, method)
  }
}

function offlinePage(workbox, options) {
  if (options.offlinePage) {
    // Register router handler for offlinePage
    workbox.routing.registerRoute(new RegExp(options.pagesURLPattern), ({ request, event }) => {
      const strategy = new workbox.strategies[options.offlineStrategy]
      return strategy
        .handle({ request, event })
        .catch(() => caches.match(options.offlinePage))
    })
  }
}

function workboxExtensions(workbox, options) {
  
}

function cachingExtensions(workbox, options) {
  
}

function routingExtensions(workbox, options) {
  
}
