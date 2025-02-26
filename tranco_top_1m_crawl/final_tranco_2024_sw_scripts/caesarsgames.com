var sharedLib = {};
sharedLib.IndexedDBAdapter = function (database, logger) {
    this.__parent = typeof window === "undefined" ? self : window;
    this.__database = database;
    this.__logger = logger
};
sharedLib.IndexedDBAdapter.DATABASES = {
    SERVICE_WORKER_STORAGE: {
        DATABASE_NAME: "AppboyServiceWorkerAsyncStorage",
        VERSION: 2,
        OBJECT_STORES: {DATA: "data", PUSH_CLICKS: "pushClicks"}
    }
};
sharedLib.IndexedDBAdapter.prototype._getIndexedDB = function () {
    if ("indexedDB" in this.__parent) return this.__parent.indexedDB
};
sharedLib.IndexedDBAdapter.prototype._isSupported = function () {
    return this._getIndexedDB() != null
};
sharedLib.IndexedDBAdapter.prototype._withDatabase = function (action) {
    var openRequest = this._getIndexedDB().open(this.__database.DATABASE_NAME, this.__database.VERSION);
    if (openRequest == null) return false;
    var self = this;
    openRequest.onupgradeneeded = function (event) {
        self.__logger.info("Upgrading indexedDB database " + self.__database.DATABASE_NAME + " to v" + self.__database.VERSION + "...");
        var db = event.target.result;
        for (var key in self.__database.OBJECT_STORES) if (!db.objectStoreNames.contains(self.__database.OBJECT_STORES[key])) db.createObjectStore(self.__database.OBJECT_STORES[key])
    };
    openRequest.onsuccess = function (event) {
        self.__logger.info("Opened indexedDB database " + self.__database.DATABASE_NAME + " v" + self.__database.VERSION);
        var db = event.target.result;
        db.onversionchange = function () {
            db.close();
            self.__logger.error("Needed to close the database unexpectedly because of an upgrade in another tab")
        };
        action(db)
    };
    openRequest.onerror = function (event) {
        self.__logger.info("Could not open indexedDB database " + self.__database.DATABASE_NAME + " v" + self.__database.VERSION + ": " + event.target.errorCode);
        return true
    };
    return true
};
sharedLib.IndexedDBAdapter.prototype.setItem = function (objectStore, key, item) {
    if (!this._isSupported()) return false;
    var self = this;
    var success = this._withDatabase(function (db) {
        if (!db.objectStoreNames.contains(objectStore)) {
            self.__logger.error("Could not store object " + key + " in " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME + " because " + objectStore + " is not a valid objectStore");
            return
        }
        var transaction = db.transaction([objectStore], "readwrite");
        var store = transaction.objectStore(objectStore);
        var putRequest = store.put(item, key);
        putRequest.onerror = function () {
            self.__logger.error("Could not store object " + key + " in " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME)
        };
        putRequest.onsuccess = function () {
            self.__logger.info("Stored object " + key + " in " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME)
        }
    });
    return success
};
sharedLib.IndexedDBAdapter.prototype.getItem = function (objectStore, key, callback) {
    if (!this._isSupported()) return false;
    var self = this;
    var success = this._withDatabase(function (db) {
        if (!db.objectStoreNames.contains(objectStore)) {
            self.__logger.error("Could not retrieve object " + key + " in " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME + " because " + objectStore + " is not a valid objectStore");
            return
        }
        var transaction = db.transaction([objectStore], "readonly");
        var store = transaction.objectStore(objectStore);
        var getRequest = store.get(key);
        getRequest.onerror = function () {
            self.__logger.error("Could not retrieve object " + key + " in " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME)
        };
        getRequest.onsuccess = function (event) {
            self.__logger.info("Retrieved object " + key + " in " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME);
            var object = event.target.result;
            if (object != null) callback(object)
        }
    });
    return success
};
sharedLib.IndexedDBAdapter.prototype.getLastItem = function (objectStore, callback) {
    if (!this._isSupported()) return false;
    var self = this;
    var success = this._withDatabase(function (db) {
        if (!db.objectStoreNames.contains(objectStore)) {
            self.__logger.error("Could not retrieve last record from " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME + " because " + objectStore + " is not a valid objectStore");
            return
        }
        var transaction = db.transaction([objectStore], "readonly");
        var store = transaction.objectStore(objectStore);
        var cursorRequest = store.openCursor(null, "prev");
        cursorRequest.onerror = function () {
            self.__logger.error("Could not open cursor for " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME)
        };
        cursorRequest.onsuccess = function (event) {
            var result = event.target.result;
            if (result != null && result.value != null && result.key != null) {
                self.__logger.info("Retrieved last record " + result.key + " in " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME);
                callback(result.key, result.value)
            }
        }
    });
    return success
};
sharedLib.IndexedDBAdapter.prototype.deleteItem = function (objectStore, key) {
    if (!this._isSupported()) return false;
    var self = this;
    var success = this._withDatabase(function (db) {
        if (!db.objectStoreNames.contains(objectStore)) {
            self.__logger.error("Could not delete record " + key + " from " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME + " because " + objectStore + " is not a valid objectStore");
            return
        }
        var transaction = db.transaction([objectStore], "readwrite");
        var store = transaction.objectStore(objectStore);
        var deleteRequest = store["delete"](key);
        deleteRequest.onerror = function () {
            self.__logger.error("Could not delete record " + key + " from " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME)
        };
        deleteRequest.onsuccess = function () {
            self.__logger.info("Deleted record " + key + " from " + objectStore + " on indexedDB database " + self.__database.DATABASE_NAME)
        }
    });
    return success
};
var NONE_ACTION = "ab_none";
var URI_ACTION = "ab_uri";
var showNotification = function (payload) {
    if (payload == null || Object.keys(payload).length === 0) {
        console.log("Appboy: server has no pending push message for this registration. Ignoring push event.");
        return
    }
    var title = payload.t;
    var body = payload.a;
    var icon = payload.i;
    var image = payload.img;
    var shouldFetchTriggers = payload.ab_push_fetch_test_triggers_key;
    var data = {url: payload.u, ab_ids: {cid: payload.cid}, extra: payload.e};
    if (shouldFetchTriggers) {
        console.log("Appboy: service worker 1.6.12 found trigger fetch key in push payload.");
        data["fetchTriggers"] = true
    }
    var actions = payload.pab || [];
    var actionTargets = {};
    for (var i = 0; i < actions.length; i++) if (actions[i] != null && actions[i].action != null) {
        var url;
        var actionType = actions[i].a;
        switch (actionType) {
            case NONE_ACTION:
                url = null;
                break;
            case URI_ACTION:
                url = actions[i].u;
                if (url == null || url === "") url = "/"
        }
        actionTargets[actions[i].action] = url
    }
    data.actionTargets = actionTargets;
    console.log("Appboy: Displaying push notification!");
    return self.registration.showNotification(title, {
        body: body,
        icon: icon,
        image: image,
        data: data,
        actions: actions
    })
};
self.addEventListener("install", function (event) {
    event.waitUntil(self.skipWaiting())
});

self.addEventListener("fetch",(event) => {
    event.respondWith(fetch(event.request));
})
self.addEventListener("activate", function () {
    return self.clients.claim()
});
self.addEventListener("push", function (event) {
    console.log("Appboy: service worker 1.6.12 received push");
    if (event.data != null && event.data.json != null) event.waitUntil(showNotification(event.data.json())); else {
        var promise = new Promise(function (resolve, reject) {
            var db = sharedLib.IndexedDBAdapter.DATABASES.SERVICE_WORKER_STORAGE;
            (new sharedLib.IndexedDBAdapter(db, {
                info: function (m) {
                    console.log(m)
                }, error: function (m) {
                    console.log(m)
                }
            })).getLastItem(db.OBJECT_STORES.DATA, function (key, dbEntry) {
                var data = dbEntry.data;
                fetch(dbEntry.baseUrl + "/web_push/", {
                    method: "POST",
                    headers: {"Content-type": "application/json"},
                    body: JSON.stringify(data)
                }).then(function (response) {
                    if (!response.ok) {
                        console.error("Appboy SDK Error: Unable to retrieve push payload from server: " + response.status);
                        reject();
                        return
                    }
                    return response.json()
                }).then(function (json) {
                    console.log("Appboy: Retrieved push payload from server");
                    showNotification(json);
                    resolve()
                })["catch"](function (err) {
                    console.error("Appboy SDK Error: Unable to retrieve push payload from server: " +
                        err);
                    reject(err)
                })
            })
        });
        event.waitUntil(promise)
    }
});
self.addEventListener("notificationclick", function (event) {
    if (!event || !event.notification) return;
    event.notification.close();
    if (Notification != null && Notification.prototype.hasOwnProperty("data")) {
        if (!event.notification.data || !event.notification.data.ab_ids) return;
        var isPushButtonClick = event.action != null && event.action !== "";
        var db = sharedLib.IndexedDBAdapter.DATABASES.SERVICE_WORKER_STORAGE;
        var dbAdapter = new sharedLib.IndexedDBAdapter(db, {
            info: function (m) {
                console.log(m)
            }, error: function (m) {
                console.log(m)
            }
        });
        dbAdapter.getLastItem(db.OBJECT_STORES.DATA, function (key, dbEntry) {
            var now = Math.floor(Date.now() / 1E3);
            var data = dbEntry.data;
            data.time = now;
            if (isPushButtonClick) data.events = [{
                name: "ca",
                time: now,
                data: {cid: event.notification.data.ab_ids.cid, a: event.action}
            }]; else data.events = [{name: "pc", time: now, data: {cid: event.notification.data.ab_ids.cid}}];
            data.sdk_version = "1.6.12";
            fetch(dbEntry.baseUrl + "/data/", {
                method: "POST",
                headers: {"Content-type": "application/json"},
                body: JSON.stringify(data)
            }).then(function (response) {
                if (!response.ok) console.error("Appboy SDK Error: Unable to log push click: " +
                    response.status);
                return response.json()
            }).then(function (json) {
                if (json.error) console.error("Appboy SDK Error: Unable to log push click:", json.error); else console.log("Appboy: Successfully logged push click")
            })["catch"](function (err) {
                console.error("Appboy SDK Error: Unable to log push click:", err)
            })
        });
        if (!isPushButtonClick) {
            var pushClickedData = {"lastClick": Date.now(), "trackingString": event.notification.data.ab_ids.cid};
            if (event.notification.data.fetchTriggers) pushClickedData["fetchTriggers"] = true;
            var PUSH_CLICKS_STORAGE_ID = 1;
            dbAdapter.setItem(db.OBJECT_STORES.PUSH_CLICKS, PUSH_CLICKS_STORAGE_ID, pushClickedData)
        }
        var url;
        if (isPushButtonClick) url = event.notification.data.actionTargets[event.action]; else {
            url = event.notification.data.url;
            if (url == null || url === "") url = "/"
        }
        if (url != null && url !== "") event.waitUntil(clients.matchAll({type: "window"}).then(function () {
            if (clients.openWindow) return clients.openWindow(url)
        }))
    }
});
self.addEventListener("pushsubscriptionchange", function (event) {
    console.log("Appboy: Subscription expired, resubscribing user");
    event.waitUntil(self.registration.pushManager.subscribe({userVisibleOnly: true}).then(function (subscription) {
        var db = sharedLib.IndexedDBAdapter.DATABASES.SERVICE_WORKER_STORAGE;
        (new sharedLib.IndexedDBAdapter(db, {
            info: function (m) {
                console.log(m)
            }, error: function (m) {
                console.log(m)
            }
        })).getLastItem(db.OBJECT_STORES.DATA, function (key, dbEntry) {
            var data = dbEntry.data;
            var publicKey, userAuth;
            if (subscription.getKey) {
                publicKey = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey("p256dh"))));
                userAuth = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey("auth"))))
            }
            data.time = Math.floor(Date.now() / 1E3);
            data.attributes = [{
                push_token: subscription.endpoint,
                custom_push_public_key: publicKey,
                custom_push_user_auth: userAuth
            }];
            return fetch(dbEntry.baseUrl + "/data/", {
                method: "POST",
                headers: {"Content-type": "application/json"},
                body: JSON.stringify(data)
            }).then(function (response) {
                if (!response.ok) console.error("Appboy SDK Error: Unable to resubscribe user: " +
                    response.status);
                return response.json()
            }).then(function (json) {
                if (json.error) console.error("Appboy SDK Error: Unable to resubscribe user:", json.error); else console.log("Appboy: Successfully resubscribed user after expiration", subscription.endpoint)
            })["catch"](function (err) {
                console.error("Appboy SDK Error: Unable to resubscribe user:", err)
            })
        })
    }))
});