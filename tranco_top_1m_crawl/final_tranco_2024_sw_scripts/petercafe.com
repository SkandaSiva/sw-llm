const FW_MANIFEST_CACHE_REVISION = '2411201348';
const NAVIGATE_CACHE = 'cafe24-navigate-cache';
const IGNORE_QUERYSTRING_PATTERNS = [/^utm_/, /^cafe_mkt/, /^a2hs/];

/**
* URL 에서 해당 QueryString Key 를 제거
*
* @param {string} sUrl
* @param {array} aPatterns
*/
const removeQueryPatterns = function (sUrl, aPatterns) {
    let oUrl = new URL(sUrl);

    if (oUrl.search) {
        let sFilteredParams = oUrl.search.slice(1)
            .split('&')
            .map(function (sSearchKeyValue) {
                return sSearchKeyValue.split('=');
            })
            .filter(function (aKeyValues) {
                return aPatterns.every(function (oIgnoreRegex) {
                    return oIgnoreRegex.test(aKeyValues[0]) === false;
                });
            })
            .map(function (aKeyValues) {
                return aKeyValues.join('=');
            })
            .join('&');

        oUrl.search = '?' + sFilteredParams;
    }

    return oUrl.toString();
};

/**
* install event listener
*
* @param {*} oInstallEvent
*/
const installListener = function (oInstallEvent) {
    oInstallEvent.waitUntil(self.skipWaiting());
};

/**
* activate event listener
*
* @param {*} oActivateEvent
*/
const activateListener = function (oActivateEvent) {
    oActivateEvent.waitUntil(
        caches.keys().then(function (aKeys) {
            return Promise.all(aKeys.map(function (sKey) {
                if (sKey !== NAVIGATE_CACHE) {
                    return caches.delete(sKey);
                }
            }))
        })
        .then(function () {
            return self.clients.claim();
        })
    );
};

/**
* fetch event listener
*
* @param {*} oFetchEvent
*/
const fetchListener = function (oFetchEvent) {
    let sRequestUrl = oFetchEvent.request.url;
    let oUrl = new URL(sRequestUrl);

    // https 가 아닌 경우 예외처리
    if (oUrl.protocol !== 'https:') {
        return;
    }

    if (oFetchEvent.request.method === 'GET') {
        // 메인 페이지 요청의 경우만 network first 캐싱
        if (oFetchEvent.request.mode === 'navigate' && oUrl.pathname === '/') {
            let sNormalizedUrl = removeQueryPatterns(sRequestUrl, IGNORE_QUERYSTRING_PATTERNS);

            if (navigator.onLine === true) {
                oFetchEvent.respondWith(
                    fetch(oFetchEvent.request).then(function (oResponse) {
                        if (oResponse.ok) {
                            return caches.open(NAVIGATE_CACHE).then(function (cache) {
                                cache.put(sNormalizedUrl, oResponse.clone());
                                return oResponse;
                            }).catch(function (oError) {
                                console.warn('CacheStorageError => ', oError, oError.message, oError.name);
                                return oResponse;
                            });
                        } else {
                            console.warn('ResponseError => ', sRequestUrl);
                            return oResponse;
                        }
                    }).catch(function (oError) {
                        console.warn('fetchError => ', oError, oError.message, oError.name);
                    })
                );
            } else {
                oFetchEvent.respondWith(
                    caches.open(NAVIGATE_CACHE).then(function (cache) {
                        return cache.match(sNormalizedUrl).then(function (oCachedResponse) {
                            return oCachedResponse;
                        });
                    })
                );
            }
        }
    }
};

// init serviceWorker
self.addEventListener('install', installListener);
self.addEventListener('activate', activateListener);
self.addEventListener('fetch', fetchListener);
