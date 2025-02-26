var assetsToCache = [];

//对request url 进行匹配的，而不是当前的页面地址匹配
const caceheList = [
    "usr/themes/handsome/assets/",//handsome内置js
    "usr/uploads/",// 文章中的图片
    "vditor",
    "jquery",
    "bootstrap",
    "mathjax",
    "mdui",
    "?action=get_search_cache",
    "hm.js" //百度统计js
];

const notCacheList = [
    "/admin/"
]
//添加缓存
self.addEventListener('install', function(event) {
    event.waitUntil(self.skipWaiting()) //这样会触发activate事件
});

// self.addEventListener('message', function (event) {
//     console.log("recv message" + event.data);
//     if (event.data === 'skipWaiting') {
//         self.skipWaiting();
//         console.log("skipwaiting");
//     }
// })



//可以进行版本修改，删除缓存
var version = "10.0.0";
var versionTag = "66f63542bfc51";

var CACHE_NAME = version+versionTag;

self.addEventListener('activate', function(event) {
    // console.log('activated!');
    var mainCache = [CACHE_NAME];
    event.waitUntil(
        caches.keys().then(function(cacheNames) {
            return Promise.all(
                cacheNames.map(function(cacheName) {
                    if ( mainCache.indexOf(cacheName) === -1) {//没有找到该版本号下面的缓存
                        // When it doesn't match any condition, delete it.
                        console.info('version changed, clean the cache, SW: deleting ' + cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
    return self.clients.claim();
});


function isExitInCacheList(list,url){
    return list.some(function (value) {
        return url.indexOf(value) !== -1
    })
}

var CDN_ADD = "" //博客本地图片资源替换
var BLOG_URL = "https://www.ihewro.com" //博客本地图片资源替换


function fetchLocal(event){

    // console.log("fectch error",CDN_ADD,BLOG_URL)
    // 判断地址前缀是否是CDN_ADD，进行回退
    if (CDN_ADD!="" && BLOG_URL!= CDN_ADD && event.request.url.indexOf(CDN_ADD)!==-1){
        const new_request_url = event.request.url.replace(CDN_ADD,BLOG_URL);

        return caches.open(CACHE_NAME).then(function(cache) {
            return fetch(new_request_url).then(function (response) {
                if (response.status < 400) {//回退成功，则进行缓存，这个地方肯定是可以获取到status因为地址替换成本地的了
                    // console.log("【yes2】 put in the cache" + event.request.url);
                    console.log("fetch retry [success],old_url:%s ,new_url:%s",event.request.url,new_request_url);

                    cache.put(event.request, response.clone());
                }else{
                    console.warn("fetch retry [error:%s],old_url:%s,new_url:%s",response.status,event.request.url,new_request_url);
                }
                // console.log(response);
                return response;
            }).catch(function (error){
                console.warn("fetch retry [error2:%s],old_url:%s,new_url:%s",error,event.request.url,new_request_url);
                // throw error;
            });
        })
    }else{
        console.warn("fetch error and [not retry]",event.request.url);
        return false;
    }
}

function is_same_request(urla,urlb){
    const white_query =new Set([// 除了这这些参数，其它的查询参数必须要一致，才认为是同一个请求
        "t",
        "v",
        "version",
        "time",
        "ts",
        "timestamp"
    ]);

    const a_url = urla.split('?');
    const b_url = urlb.split('?');
    if (a_url[0] !== b_url[0] ){
        return false;
    }

    const a_params = new URLSearchParams('?' + a_url[1]);
    const b_params = new URLSearchParams('?' + b_url[1]);

    // 显示所有的键
    for (var key of a_params.keys()) {
        if (white_query.has(key)){//对于版本号的key 忽略
            continue;
        }
        if (a_params.get(key) !== b_params.get(key)){//其它key的值必须相等，比如type=POST 这种
            return false;
        }
    }

    return true;
}

function getMatchRequestResponse(cache_response_list,request_url) {
    if (cache_response_list){
        for (const cache_response of cache_response_list) {
            // console.log(cache_response.url,request_url)
            if (is_same_request(cache_response.url,request_url)){
                return cache_response;
            }
        }
    }
    return null;
}
// 拦截请求使用缓存的内容
self.addEventListener('fetch', function(event) {
    // console.log('Handling fetch event for', event.request.url);
    if(event.request.method !== "GET") {
        return false;
    }else{
        if (isExitInCacheList(caceheList, event.request.url) && !isExitInCacheList(notCacheList, event.request.url)){
            // 只捕获需要加入cache的请求
            // 劫持 HTTP Request
            // console.log(event.request.url);
            event.respondWith(
                caches.open(CACHE_NAME).then(function(cache) {
                    // var start = performance.now();
                    // return cache.match(event.request,{"ignoreSearch":true}).then(function(cache_response) {
                    return cache.matchAll(event.request,{"ignoreSearch":true}).then(function(cache_response_list) {
                        const cache_response = getMatchRequestResponse(cache_response_list,event.request.url);
                        // var end = performance.now();
                        // console.log("match all cost:",end - start,"ms",event.request.url)
                        if (cache_response && cache_response.url === event.request.url) {//地址（包含查询参数）完全一致才返回缓存
                            // 使用 Service Worker 回應
                            // console.log("【cache】use the cache " + event.request.url)
                            return cache_response;
                        } else {
                            // console.log("not use cache",event.request.url);
                            return fetch(event.request)
                                .then(function(response) {
                                    //判断查询参数里面是否存在type参数，如果存在
                                    // 由于跨域访问导致获得response是非透明响应无法获取响应码（响应码是0
                                    //https://fetch.spec.whatwg.org/#concept-filtered-response-opaque
                                    if (response.status < 400){//对于响应码为0，暂时无法进一步判断，只能全部认为加载成功
                                        //跨域的地址 服务器端的错误目前不会回退，只能直接加到cache里面，如果服务器问题解除需要更新缓存
                                        // console.log("【yes】 put in the cache" + event.request.url);
                                        if (cache_response && is_same_request(cache_response.url,event.request.url)){//删除旧版本号的资源
                                            // console.log("存在缓存，但是可查询的字符串版本号不一致，所以需要删除缓存",cache_response.url,event.request.url)
                                            cache.delete(cache_response.url);
                                        }
                                        cache.put(event.request, response.clone());
                                    }else{
                                        console.warn("response is not ok",response.status,response.statusText,event.request.url);
                                        const new_response =  fetchLocal(event);
                                        if (new_response){
                                            return new_response;
                                        }else {//在获取response 失败的时候，优先考虑可以回退旧版本的response里面
                                            if (cache_response && is_same_request(cache_response.url,event.request.url)){
                                                return cache_response;
                                            }
                                            return response;
                                        }
                                    }
                                    return response;
                                })
                                .catch(function(error) {
                                    console.error(error)
                                    const response =  fetchLocal(event);
                                    if (response){
                                        return response;
                                    }else {
                                        // console.log('Fetching request url ,' +event.request.url+' failed:', error);
                                        // throw error;
                                    }
                                });
                        }
                    })
                })
            );
        }else{
            return false;
        }
    }
});
