! function() {
	"use strict";
	var e = {
			676: function(e, t, n) {
				var r = this && this.__awaiter || function(e, t, n, r) {
						return new(n || (n = Promise))((function(i, o) {
							function s(e) {
								try {
									a(r.next(e))
								} catch (e) {
									o(e)
								}
							}

							function u(e) {
								try {
									a(r.throw(e))
								} catch (e) {
									o(e)
								}
							}

							function a(e) {
								var t;
								e.done ? i(e.value) : (t = e.value, t instanceof n ? t : new n((function(e) {
									e(t)
								}))).then(s, u)
							}
							a((r = r.apply(e, t || [])).next())
						}))
					},
					i = this && this.__generator || function(e, t) {
						var n, r, i, o, s = {
							label: 0,
							sent: function() {
								if (1 & i[0]) throw i[1];
								return i[1]
							},
							trys: [],
							ops: []
						};
						return o = {
							next: u(0),
							throw: u(1),
							return: u(2)
						}, "function" == typeof Symbol && (o[Symbol.iterator] = function() {
							return this
						}), o;

						function u(o) {
							return function(u) {
								return function(o) {
									if (n) throw new TypeError("Generator is already executing.");
									for (; s;) try {
										if (n = 1, r && (i = 2 & o[0] ? r.return : o[0] ? r.throw || ((i = r.return) && i.call(r), 0) : r.next) && !(i = i.call(r, o[1])).done) return i;
										switch (r = 0, i && (o = [2 & o[0], i.value]), o[0]) {
											case 0:
											case 1:
												i = o;
												break;
											case 4:
												return s.label++, {
													value: o[1],
													done: !1
												};
											case 5:
												s.label++, r = o[1], o = [0];
												continue;
											case 7:
												o = s.ops.pop(), s.trys.pop();
												continue;
											default:
												if (!(i = s.trys, (i = i.length > 0 && i[i.length - 1]) || 6 !== o[0] && 2 !== o[0])) {
													s = 0;
													continue
												}
												if (3 === o[0] && (!i || o[1] > i[0] && o[1] < i[3])) {
													s.label = o[1];
													break
												}
												if (6 === o[0] && s.label < i[1]) {
													s.label = i[1], i = o;
													break
												}
												if (i && s.label < i[2]) {
													s.label = i[2], s.ops.push(o);
													break
												}
												i[2] && s.ops.pop(), s.trys.pop();
												continue
										}
										o = t.call(e, s)
									} catch (e) {
										o = [6, e], r = 0
									} finally {
										n = i = 0
									}
									if (5 & o[0]) throw o[1];
									return {
										value: o[0] ? o[1] : void 0,
										done: !0
									}
								}([o, u])
							}
						}
					};
				t.__esModule = !0, t.trackInstallDetails = t.trackEvent = t.clearUserAssociation = t.associateUser = t.getUserId = t.setInstallId = t.getInstallId = t.assertKeys = t.assertConfigValid = t.Context = t.Service = t.SDKFeature = t.PromptPosition = t.ReminderTimeUnit = t.UiActionType = t.PromptTypeName = t.EventType = void 0;
				var o, s, u, a = n(488),
					c = n(159),
					l = 104,
					f = "2.0.17";
				! function(e) {
					e.MESSAGE_DELIVERED = "k.message.delivered", e.MESSAGE_OPENED = "k.message.opened", e.PUSH_REGISTERED = "k.push.deviceRegistered", e.PUSH_UNSUBSCRIBED = "k.push.deviceUnsubscribed", e.INSTALL_TRACKED = "k.stats.installTracked", e.USER_ASSOCIATED = "k.stats.userAssociated", e.USER_ASSOCIATION_CLEARED = "k.stats.userAssociationCleared"
				}(o = t.EventType || (t.EventType = {})),
				function(e) {
					e.BELL = "bell", e.ALERT = "alert", e.BANNER = "banner", e.DDL_BANNER = "ddl_banner"
				}(t.PromptTypeName || (t.PromptTypeName = {})),
				function(e) {
					e.DECLINE = "decline", e.REMIND = "remind", e.DDL_OPEN_STORE = "openStore", e.DDL_OPEN_DEEPLINK = "openDeeplink"
				}(t.UiActionType || (t.UiActionType = {})),
				function(e) {
					e.HOURS = "hours", e.DAYS = "days"
				}(t.ReminderTimeUnit || (t.ReminderTimeUnit = {})),
				function(e) {
					e.TOP_LEFT = "top-left", e.TOP_CENTER = "top-center", e.TOP_RIGHT = "top-right", e.CENTER_LEFT = "center-left", e.CENTER = "center", e.CENTER_RIGHT = "center-right", e.BOTTOM_LEFT = "bottom-left", e.BOTTOM_CENTER = "bottom-center", e.BOTTOM_RIGHT = "bottom-right", e.TOP = "top", e.BOTTOM = "bottom"
				}(t.PromptPosition || (t.PromptPosition = {})),
				function(e) {
					e.PUSH = "push", e.DDL = "ddl"
				}(s = t.SDKFeature || (t.SDKFeature = {})),
				function(e) {
					e.PUSH = "push", e.DDL = "ddl", e.EVENTS = "events"
				}(u = t.Service || (t.Service = {}));
				var d = function() {
					function e(e) {
						var t, n, r, i;
						this.apiKey = e.apiKey, this.secretKey = e.secretKey, this.vapidPublicKey = e.vapidPublicKey, this.authHeader = "Basic ".concat(btoa("".concat(this.apiKey, ":").concat(this.secretKey))), this.serviceWorkerPath = null !== (n = e.serviceWorkerPath) && void 0 !== n ? n : "/worker.js", this.autoResubscribe = null === (r = e.autoResubscribe) || void 0 === r || r, this.features = null !== (i = e.features) && void 0 !== i ? i : [s.PUSH], this.eventSubscribers = [], this.pushStateSubscribers = [], this.urlMap = ((t = {})[u.PUSH] = "https://push-".concat(e.region, ".kumulos.com"), t[u.EVENTS] = "https://events-".concat(e.region, ".kumulos.com"), t[u.DDL] = "https://links-".concat(e.region, ".kumulos.com"), t)
					}
					return e.prototype.subscribeToEvents = function(e) {
						this.eventSubscribers.push(e)
					}, e.prototype.subscribeToSubscriptionStatus = function(e) {
						this.pushStateSubscribers.push(e)
					}, e.prototype.broadcastEvent = function(e) {
						this.eventSubscribers.forEach((function(t) {
							return t(e)
						}))
					}, e.prototype.broadcastSubscriptionState = function(e) {
						this.pushStateSubscribers.forEach((function(t) {
							return t(e)
						}))
					}, e.prototype.hasFeature = function(e) {
						return this.features.includes(e)
					}, e.prototype.urlForService = function(e) {
						return this.urlMap[e]
					}, e
				}();
				t.Context = d, t.assertConfigValid = function(e, t) {
					if (void 0 === t && (t = !1), "object" != typeof e) throw "Config must be an object";
					var n = Array.isArray(e.features) && e.features.length ? e.features : void 0;
					if (t && !e.tenantId) throw "tenantId is missing";
					if (!n || n.includes(s.PUSH)) return function(e) {
						for (var t = 0, n = ["region"]; t < n.length; t++) {
							var r = n[t];
							if ("string" != typeof e[r] || 0 === e[r].length) throw "Required configuration key '".concat(r, "' must be non-empty string")
						}
						if (e.serviceWorkerPath && "string" != typeof e.serviceWorkerPath && 0 === e.serviceWorkerPath.length) throw "Optional configuration key 'serviceWorkerPath' must be non-empty string (if supplied)";
						if (e.onPushReceived && "function" != typeof e.onPushReceived) throw "Optional configuration key 'onPushReceived' must be a function";
						if (e.onPushOpened && "function" != typeof e.onPushOpened) throw "Optional configuration key 'onPushOpened' must be a function"
					}(e)
				}, t.assertKeys = function(e) {
					if (!(e.keys && e.keys.apiKey && e.keys.secretKey && e.publicKey)) throw "Keys are missing"
				};
				var p = void 0;

				function h() {
					return p || (p = (0, c.get)("installId").then((function(e) {
						return e || v((0, a.uuidv4)())
					})))
				}

				function v(e) {
					return p = (0, c.set)("installId", e)
				}

				function b() {
					return (0, c.get)("userId").then((function(e) {
						return null != e ? e : h()
					}))
				}

				function y(e, t, n) {
					return r(this, void 0, void 0, (function() {
						var r, s, c, l;
						return i(this, (function(i) {
							switch (i.label) {
								case 0:
									return [4, h()];
								case 1:
									return r = i.sent(), [4, b()];
								case 2:
									return s = i.sent(), c = {
											type: t,
											uuid: (0, a.uuidv4)(),
											timestamp: Date.now(),
											data: n,
											userId: s
										}, e.broadcastEvent(c),
										function(e) {
											return Object.values(o).includes(e)
										}(t) ? (l = "".concat(e.urlForService(u.EVENTS), "/v1/app-installs/").concat(r, "/events"), [2, (0, a.performFetch)(l, e.authHeader, {
											method: "POST",
											body: JSON.stringify([c])
										})]) : [2, Promise.resolve()]
							}
						}))
					}))
				}
				t.getInstallId = h, t.setInstallId = v, t.getUserId = b, t.associateUser = function(e, t, n) {
					return r(this, void 0, void 0, (function() {
						var r;
						return i(this, (function(i) {
							switch (i.label) {
								case 0:
									return [4, (0, c.set)("userId", t)];
								case 1:
									return i.sent(), r = {
										id: t,
										attributes: n
									}, [2, y(e, o.USER_ASSOCIATED, r).then((function(e) {}))]
							}
						}))
					}))
				}, t.clearUserAssociation = function(e) {
					return r(this, void 0, void 0, (function() {
						var t;
						return i(this, (function(n) {
							switch (n.label) {
								case 0:
									return [4, b()];
								case 1:
									return t = n.sent(), y(e, o.USER_ASSOCIATION_CLEARED, {
										oldUserIdentifier: t
									}), [2, (0, c.del)("userId")]
							}
						}))
					}))
				}, t.trackEvent = y, t.trackInstallDetails = function(e, t) {
					return r(this, void 0, void 0, (function() {
						var n, r, s, u, d, p, v;
						return i(this, (function(i) {
							switch (i.label) {
								case 0:
									n = t || f, r = {
										app: {
											bundle: location.host,
											version: "0.0.0",
											target: 2
										},
										sdk: {
											id: l,
											version: n
										},
										runtime: {
											id: 8,
											version: navigator.userAgent
										},
										os: {
											id: 0,
											version: "0.0.0"
										},
										device: {
											name: navigator.userAgent,
											tz: "undefined" != typeof Intl && Intl.DateTimeFormat().resolvedOptions().timeZone || null,
											isSimulator: !1,
											locale: navigator.language
										}
									}, s = "", i.label = 1;
								case 1:
									return i.trys.push([1, 3, , 4]), [4, h()];
								case 2:
									return s = i.sent(), [3, 4];
								case 3:
									return u = i.sent(), console.error("Failed to get install ID: ", u), [2, Promise.reject(u)];
								case 4:
									d = [s, n, r.app.bundle, r.device.tz, r.device.locale, r.device.name], p = (0, a.cyrb53)(d.join("|")), i.label = 5;
								case 5:
									return i.trys.push([5, 7, , 8]), [4, (0, c.get)("detailsHash")];
								case 6:
									return i.sent() === p ? [2, Promise.resolve()] : [3, 8];
								case 7:
									return v = i.sent(), [2, Promise.reject(v)];
								case 8:
									return [2, y(e, o.INSTALL_TRACKED, r).then((function() {
										return (0, c.set)("detailsHash", p)
									})).then((function() {}))]
							}
						}))
					}))
				}
			},
			718: function(e, t, n) {
				var r = this && this.__awaiter || function(e, t, n, r) {
						return new(n || (n = Promise))((function(i, o) {
							function s(e) {
								try {
									a(r.next(e))
								} catch (e) {
									o(e)
								}
							}

							function u(e) {
								try {
									a(r.throw(e))
								} catch (e) {
									o(e)
								}
							}

							function a(e) {
								var t;
								e.done ? i(e.value) : (t = e.value, t instanceof n ? t : new n((function(e) {
									e(t)
								}))).then(s, u)
							}
							a((r = r.apply(e, t || [])).next())
						}))
					},
					i = this && this.__generator || function(e, t) {
						var n, r, i, o, s = {
							label: 0,
							sent: function() {
								if (1 & i[0]) throw i[1];
								return i[1]
							},
							trys: [],
							ops: []
						};
						return o = {
							next: u(0),
							throw: u(1),
							return: u(2)
						}, "function" == typeof Symbol && (o[Symbol.iterator] = function() {
							return this
						}), o;

						function u(o) {
							return function(u) {
								return function(o) {
									if (n) throw new TypeError("Generator is already executing.");
									for (; s;) try {
										if (n = 1, r && (i = 2 & o[0] ? r.return : o[0] ? r.throw || ((i = r.return) && i.call(r), 0) : r.next) && !(i = i.call(r, o[1])).done) return i;
										switch (r = 0, i && (o = [2 & o[0], i.value]), o[0]) {
											case 0:
											case 1:
												i = o;
												break;
											case 4:
												return s.label++, {
													value: o[1],
													done: !1
												};
											case 5:
												s.label++, r = o[1], o = [0];
												continue;
											case 7:
												o = s.ops.pop(), s.trys.pop();
												continue;
											default:
												if (!(i = s.trys, (i = i.length > 0 && i[i.length - 1]) || 6 !== o[0] && 2 !== o[0])) {
													s = 0;
													continue
												}
												if (3 === o[0] && (!i || o[1] > i[0] && o[1] < i[3])) {
													s.label = o[1];
													break
												}
												if (6 === o[0] && s.label < i[1]) {
													s.label = i[1], i = o;
													break
												}
												if (i && s.label < i[2]) {
													s.label = i[2], s.ops.push(o);
													break
												}
												i[2] && s.ops.pop(), s.trys.pop();
												continue
										}
										o = t.call(e, s)
									} catch (e) {
										o = [6, e], r = 0
									} finally {
										n = i = 0
									}
									if (5 & o[0]) throw o[1];
									return {
										value: o[0] ? o[1] : void 0,
										done: !0
									}
								}([o, u])
							}
						}
					},
					o = this && this.__rest || function(e, t) {
						var n = {};
						for (var r in e) Object.prototype.hasOwnProperty.call(e, r) && t.indexOf(r) < 0 && (n[r] = e[r]);
						if (null != e && "function" == typeof Object.getOwnPropertySymbols) {
							var i = 0;
							for (r = Object.getOwnPropertySymbols(e); i < r.length; i++) t.indexOf(r[i]) < 0 && Object.prototype.propertyIsEnumerable.call(e, r[i]) && (n[r[i]] = e[r[i]])
						}
						return n
					},
					s = this && this.__importDefault || function(e) {
						return e && e.__esModule ? e : {
							default: e
						}
					};
				t.__esModule = !0, t.notificationFromPayload = t.registerServiceWorker = t.trackOpenFromQuery = t.MessageType = t.TokenType = void 0;
				var u, a, c = n(676),
					l = n(488),
					f = s(n(211)),
					d = s(n(222));
				! function(e) {
					e[e.W3C = 3] = "W3C", e[e.SAFARI = 4] = "SAFARI"
				}(t.TokenType || (t.TokenType = {})),
				function(e) {
					e[e.PUSH = 1] = "PUSH"
				}(u = t.MessageType || (t.MessageType = {})), t.default = function(e) {
					if (a) return a;
					var t = (0, l.getBrowserName)();
					return a = "safari" !== t || "PushManager" in window ? new d.default : new f.default(e.safariPushId)
				}, t.trackOpenFromQuery = function(e) {
					if ("safari" === (0, l.getBrowserName)()) {
						var t = (0, l.parseQueryString)();
						(null == t ? void 0 : t.knid) && (0, c.trackEvent)(e, c.EventType.MESSAGE_OPENED, {
							type: u.PUSH,
							id: Number(t.knid)
						})
					}
				}, t.registerServiceWorker = function(e) {
					return r(this, void 0, void 0, (function() {
						var t, n;
						return i(this, (function(r) {
							switch (r.label) {
								case 0:
									if (!("serviceWorker" in navigator)) return console.error("ServiceWorker is not supported in this browser, aborting..."), [2];
									t = (0, l.getFullUrl)(e), r.label = 1;
								case 1:
									return r.trys.push([1, 3, , 4]), [4, navigator.serviceWorker.register(t)];
								case 2:
									return r.sent(), [3, 4];
								case 3:
									return n = r.sent(), console.error(n), [3, 4];
								case 4:
									return [2]
							}
						}))
					}))
				}, t.notificationFromPayload = function(e) {
					var t, n, r, i = e.data,
						s = (i["k.message"], o(i, ["k.message"]));
					return {
						id: e.data["k.message"].data.id,
						title: e.title,
						message: e.msg,
						data: s,
						url: null !== (t = e.url) && void 0 !== t ? t : void 0,
						iconUrl: null !== (n = e.icon) && void 0 !== n ? n : void 0,
						imageUrl: null !== (r = e.image) && void 0 !== r ? r : void 0
					}
				}
			},
			211: function(e, t, n) {
				var r = this && this.__awaiter || function(e, t, n, r) {
						return new(n || (n = Promise))((function(i, o) {
							function s(e) {
								try {
									a(r.next(e))
								} catch (e) {
									o(e)
								}
							}

							function u(e) {
								try {
									a(r.throw(e))
								} catch (e) {
									o(e)
								}
							}

							function a(e) {
								var t;
								e.done ? i(e.value) : (t = e.value, t instanceof n ? t : new n((function(e) {
									e(t)
								}))).then(s, u)
							}
							a((r = r.apply(e, t || [])).next())
						}))
					},
					i = this && this.__generator || function(e, t) {
						var n, r, i, o, s = {
							label: 0,
							sent: function() {
								if (1 & i[0]) throw i[1];
								return i[1]
							},
							trys: [],
							ops: []
						};
						return o = {
							next: u(0),
							throw: u(1),
							return: u(2)
						}, "function" == typeof Symbol && (o[Symbol.iterator] = function() {
							return this
						}), o;

						function u(o) {
							return function(u) {
								return function(o) {
									if (n) throw new TypeError("Generator is already executing.");
									for (; s;) try {
										if (n = 1, r && (i = 2 & o[0] ? r.return : o[0] ? r.throw || ((i = r.return) && i.call(r), 0) : r.next) && !(i = i.call(r, o[1])).done) return i;
										switch (r = 0, i && (o = [2 & o[0], i.value]), o[0]) {
											case 0:
											case 1:
												i = o;
												break;
											case 4:
												return s.label++, {
													value: o[1],
													done: !1
												};
											case 5:
												s.label++, r = o[1], o = [0];
												continue;
											case 7:
												o = s.ops.pop(), s.trys.pop();
												continue;
											default:
												if (!(i = s.trys, (i = i.length > 0 && i[i.length - 1]) || 6 !== o[0] && 2 !== o[0])) {
													s = 0;
													continue
												}
												if (3 === o[0] && (!i || o[1] > i[0] && o[1] < i[3])) {
													s.label = o[1];
													break
												}
												if (6 === o[0] && s.label < i[1]) {
													s.label = i[1], i = o;
													break
												}
												if (i && s.label < i[2]) {
													s.label = i[2], s.ops.push(o);
													break
												}
												i[2] && s.ops.pop(), s.trys.pop();
												continue
										}
										o = t.call(e, s)
									} catch (e) {
										o = [6, e], r = 0
									} finally {
										n = i = 0
									}
									if (5 & o[0]) throw o[1];
									return {
										value: o[0] ? o[1] : void 0,
										done: !0
									}
								}([o, u])
							}
						}
					};
				t.__esModule = !0;
				var o = n(676),
					s = n(718),
					u = n(488),
					a = n(159);

				function c(e, t) {
					return (0, u.cyrb53)("".concat(e.apiKey, ":").concat(t))
				}
				var l = function() {
					function e(e) {
						this.pushRegisterLock = Promise.resolve(), this.safariPushId = e
					}
					return e.prototype.requestNotificationPermission = function(e) {
						var t, n = "".concat(e.urlForService(o.Service.PUSH), "/safari/").concat(e.apiKey),
							r = (0, u.defer)();
						return null === (t = window.safari) || void 0 === t || t.pushNotification.requestPermission(n, this.safariPushId, {}, (function(e) {
							r.resolve(e.permission)
						})), r.promise
					}, e.prototype.pushRegister = function(e) {
						return r(this, void 0, void 0, (function() {
							var t, n = this;
							return i(this, (function(r) {
								return t = this.pushRegisterLock.then((function() {
									return n.pushRegisterSync(e)
								})), this.pushRegisterLock = t.catch((function() {})), [2, t]
							}))
						}))
					}, e.prototype.attemptPushRegister = function(e) {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(t) {
								switch (t.label) {
									case 0:
										return [4, (0, a.get)("unregisteredAt")];
									case 1:
										return t.sent() ? [2] : [2, this.pushRegister(e)]
								}
							}))
						}))
					}, e.prototype.pushUnregister = function(e) {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(t) {
								switch (t.label) {
									case 0:
										return [4, this.pushUnsubscribe(e, !1)];
									case 1:
										return t.sent(), [4, (0, a.set)("unregisteredAt", Date.now())];
									case 2:
										return t.sent(), e.broadcastSubscriptionState("unregistered"), [2]
								}
							}))
						}))
					}, e.prototype.pushUnsubscribe = function(e, t) {
						return void 0 === t && (t = !0), r(this, void 0, void 0, (function() {
							var n, r;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return [4, (0, o.trackEvent)(e, o.EventType.PUSH_UNSUBSCRIBED)];
									case 1:
										return i.sent(), [4, (0, a.del)("pushTokenHash")];
									case 2:
										return i.sent(), t ? (r = (n = e).broadcastSubscriptionState, [4, this.getCurrentSubscriptionState(e)]) : [2];
									case 3:
										return r.apply(n, [i.sent()]), [2]
								}
							}))
						}))
					}, e.prototype.pushRegisterSync = function(e) {
						var t;
						return r(this, void 0, void 0, (function() {
							var n, r, u;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return [4, (0, a.del)("unregisteredAt")];
									case 1:
										return i.sent(), (n = null === (t = window.safari) || void 0 === t ? void 0 : t.pushNotification.permission(this.safariPushId)) && n.deviceToken ? [4, (0, a.get)("pushTokenHash")] : [2];
									case 2:
										return r = i.sent(), u = c(e, n.deviceToken), r === u ? [2] : [4, (0, o.trackEvent)(e, o.EventType.PUSH_REGISTERED, {
											type: s.TokenType.SAFARI,
											token: n.deviceToken,
											bundleId: this.safariPushId
										})];
									case 3:
										return i.sent(), [4, (0, a.set)("pushTokenHash", u)];
									case 4:
										return i.sent(), e.broadcastSubscriptionState("subscribed"), [2]
								}
							}))
						}))
					}, e.prototype.requestPermissionAndRegisterForPush = function(e) {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(t) {
								switch (t.label) {
									case 0:
										return [4, (0, a.get)("unregisteredAt")];
									case 1:
										return t.sent() ? [2, "unregistered"] : [4, this.requestNotificationPermission(e)];
									case 2:
										switch (t.sent()) {
											case "default":
												return [2, "unsubscribed"];
											case "denied":
												return [2, "blocked"]
										}
										t.label = 3;
									case 3:
										return t.trys.push([3, 5, , 6]), [4, this.pushRegister(e)];
									case 4:
										return t.sent(), [2, "subscribed"];
									case 5:
										return t.sent(), [2, "unsubscribed"];
									case 6:
										return [2]
								}
							}))
						}))
					}, e.prototype.getCurrentSubscriptionState = function(e) {
						var t, n;
						return r(this, void 0, void 0, (function() {
							var r, o, s;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return (r = null === (t = window.safari) || void 0 === t ? void 0 : t.pushNotification.permission(this.safariPushId)) && "denied" !== (null == r ? void 0 : r.permission) ? [4, (0, a.get)("unregisteredAt")] : [2, "blocked"];
									case 1:
										return i.sent() ? [2, "unregistered"] : [4, (0, a.get)("pushTokenHash")];
									case 2:
										return o = i.sent(), s = c(e, null !== (n = r.deviceToken) && void 0 !== n ? n : ""), o === s && "granted" === r.permission ? [2, "subscribed"] : [2, "unsubscribed"]
								}
							}))
						}))
					}, e.prototype.handleAutoResubscription = function(e) {
						var t;
						return r(this, void 0, void 0, (function() {
							var n, r, o;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return e.autoResubscribe && this.safariPushId && ((n = null === (t = window.safari) || void 0 === t ? void 0 : t.pushNotification.permission(this.safariPushId)) && "granted" === n.permission && n.deviceToken) ? [4, (0, a.get)("pushTokenHash")] : [2];
									case 1:
										return r = i.sent(), o = c(e, n.deviceToken), r === o ? [2] : [2, this.attemptPushRegister(e)]
								}
							}))
						}))
					}, e.prototype.isNativePromptShown = function() {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(e) {
								return [2, Promise.resolve(!0)]
							}))
						}))
					}, e
				}();
				t.default = l
			},
			222: function(e, t, n) {
				var r = this && this.__awaiter || function(e, t, n, r) {
						return new(n || (n = Promise))((function(i, o) {
							function s(e) {
								try {
									a(r.next(e))
								} catch (e) {
									o(e)
								}
							}

							function u(e) {
								try {
									a(r.throw(e))
								} catch (e) {
									o(e)
								}
							}

							function a(e) {
								var t;
								e.done ? i(e.value) : (t = e.value, t instanceof n ? t : new n((function(e) {
									e(t)
								}))).then(s, u)
							}
							a((r = r.apply(e, t || [])).next())
						}))
					},
					i = this && this.__generator || function(e, t) {
						var n, r, i, o, s = {
							label: 0,
							sent: function() {
								if (1 & i[0]) throw i[1];
								return i[1]
							},
							trys: [],
							ops: []
						};
						return o = {
							next: u(0),
							throw: u(1),
							return: u(2)
						}, "function" == typeof Symbol && (o[Symbol.iterator] = function() {
							return this
						}), o;

						function u(o) {
							return function(u) {
								return function(o) {
									if (n) throw new TypeError("Generator is already executing.");
									for (; s;) try {
										if (n = 1, r && (i = 2 & o[0] ? r.return : o[0] ? r.throw || ((i = r.return) && i.call(r), 0) : r.next) && !(i = i.call(r, o[1])).done) return i;
										switch (r = 0, i && (o = [2 & o[0], i.value]), o[0]) {
											case 0:
											case 1:
												i = o;
												break;
											case 4:
												return s.label++, {
													value: o[1],
													done: !1
												};
											case 5:
												s.label++, r = o[1], o = [0];
												continue;
											case 7:
												o = s.ops.pop(), s.trys.pop();
												continue;
											default:
												if (!(i = s.trys, (i = i.length > 0 && i[i.length - 1]) || 6 !== o[0] && 2 !== o[0])) {
													s = 0;
													continue
												}
												if (3 === o[0] && (!i || o[1] > i[0] && o[1] < i[3])) {
													s.label = o[1];
													break
												}
												if (6 === o[0] && s.label < i[1]) {
													s.label = i[1], i = o;
													break
												}
												if (i && s.label < i[2]) {
													s.label = i[2], s.ops.push(o);
													break
												}
												i[2] && s.ops.pop(), s.trys.pop();
												continue
										}
										o = t.call(e, s)
									} catch (e) {
										o = [6, e], r = 0
									} finally {
										n = i = 0
									}
									if (5 & o[0]) throw o[1];
									return {
										value: o[0] ? o[1] : void 0,
										done: !0
									}
								}([o, u])
							}
						}
					};
				t.__esModule = !0;
				var o = n(676),
					s = n(718),
					u = n(488),
					a = n(159);

				function c(e, t) {
					var n = t.options.applicationServerKey;
					return !!n && (0, u.base64UrlEncode)(n) === e
				}

				function l(e) {
					return r(this, void 0, void 0, (function() {
						var t, n;
						return i(this, (function(r) {
							switch (r.label) {
								case 0:
									return t = (0, u.getFullUrl)(e), [4, navigator.serviceWorker.getRegistration(t)];
								case 1:
									return (n = r.sent()) ? [2, n] : [2, Promise.reject("No service worker registration")]
							}
						}))
					}))
				}

				function f(e, t) {
					return (0, u.cyrb53)("".concat(e.apiKey, ":").concat(t.endpoint))
				}
				var d = function() {
					function e() {
						this.pushRegisterLock = Promise.resolve()
					}
					return e.prototype.requestNotificationPermission = function() {
						return r(this, void 0, void 0, (function() {
							var e;
							return i(this, (function(t) {
								switch (t.label) {
									case 0:
										if ("undefined" == typeof Notification) return [2, Promise.reject("Notifications are not supported in this browser, aborting...")];
										t.label = 1;
									case 1:
										return t.trys.push([1, 3, , 4]), [4, Notification.requestPermission()];
									case 2:
										return [2, t.sent()];
									case 3:
										return e = t.sent(), console.error(e), [2, Promise.reject(e)];
									case 4:
										return [2]
								}
							}))
						}))
					}, e.prototype.pushRegister = function(e) {
						return r(this, void 0, void 0, (function() {
							var t, n = this;
							return i(this, (function(r) {
								return t = this.pushRegisterLock.then((function() {
									return n.pushRegisterSync(e)
								})), this.pushRegisterLock = t.catch((function() {})), [2, t]
							}))
						}))
					}, e.prototype.attemptPushRegister = function(e) {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(t) {
								switch (t.label) {
									case 0:
										return [4, (0, a.get)("unregisteredAt")];
									case 1:
										return t.sent() ? [2] : [2, this.pushRegister(e)]
								}
							}))
						}))
					}, e.prototype.pushRegisterSync = function(e) {
						return r(this, void 0, void 0, (function() {
							var t;
							return i(this, (function(n) {
								switch (n.label) {
									case 0:
										return [4, (0, a.del)("unregisteredAt")];
									case 1:
										return n.sent(), "PushManager" in window ? [4, l(e.serviceWorkerPath)] : [2, Promise.reject("Push notifications are not supported in this browser")];
									case 2:
										return t = n.sent(), [4, this.unsubscribeIfDifferentVapid(t, e.vapidPublicKey)];
									case 3:
										return n.sent(), [4, this.subscribeAndMaybeTrackRegisteredEvent(t, e)];
									case 4:
										return n.sent(), [2]
								}
							}))
						}))
					}, e.prototype.unsubscribeIfDifferentVapid = function(e, t) {
						return r(this, void 0, void 0, (function() {
							var n;
							return i(this, (function(r) {
								switch (r.label) {
									case 0:
										return [4, e.pushManager.getSubscription()];
									case 1:
										return !(n = r.sent()) || c(t, n) ? [3, 3] : [4, n.unsubscribe()];
									case 2:
										r.sent(), r.label = 3;
									case 3:
										return [2]
								}
							}))
						}))
					}, e.prototype.subscribeAndMaybeTrackRegisteredEvent = function(e, t) {
						return r(this, void 0, void 0, (function() {
							var n, r, o, s;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return [4, e.pushManager.subscribe({
											applicationServerKey: t.vapidPublicKey,
											userVisibleOnly: !0
										})];
									case 1:
										return n = i.sent(), r = f(t, n), [4, (0, a.get)("pushEndpointHash")];
									case 2:
										return o = i.sent(), [4, (0, a.get)("pushExpiresAt")];
									case 3:
										return s = i.sent(), o === r && (!s || s > Date.now()) ? [2] : [4, this.trackAndCachePushRegisteredEvent(t, n, r)];
									case 4:
										return i.sent(), t.broadcastSubscriptionState("subscribed"), [2]
								}
							}))
						}))
					}, e.prototype.pushUnregister = function(e) {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(t) {
								switch (t.label) {
									case 0:
										return [4, this.pushUnsubscribe(e, !1)];
									case 1:
										return t.sent(), [4, (0, a.set)("unregisteredAt", Date.now())];
									case 2:
										return t.sent(), e.broadcastSubscriptionState("unregistered"), [2]
								}
							}))
						}))
					}, e.prototype.pushUnsubscribe = function(e, t) {
						return void 0 === t && (t = !0), r(this, void 0, void 0, (function() {
							var n, r, s;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return "PushManager" in window ? [4, l(e.serviceWorkerPath)] : [2, Promise.reject("Push notifications are not supported in this browser")];
									case 1:
										return [4, i.sent().pushManager.getSubscription()];
									case 2:
										return (n = i.sent()) ? [4, n.unsubscribe()] : [3, 4];
									case 3:
										i.sent(), i.label = 4;
									case 4:
										return [4, (0, o.trackEvent)(e, o.EventType.PUSH_UNSUBSCRIBED)];
									case 5:
										return i.sent(), [4, (0, a.del)("pushEndpointHash")];
									case 6:
										return i.sent(), [4, (0, a.del)("pushExpiresAt")];
									case 7:
										return i.sent(), t ? (s = (r = e).broadcastSubscriptionState, [4, this.getCurrentSubscriptionState(e)]) : [2];
									case 8:
										return s.apply(r, [i.sent()]), [2]
								}
							}))
						}))
					}, e.prototype.trackAndCachePushRegisteredEvent = function(e, t, n) {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(r) {
								switch (r.label) {
									case 0:
										return [4, (0, o.trackEvent)(e, o.EventType.PUSH_REGISTERED, {
											type: s.TokenType.W3C,
											token: t
										})];
									case 1:
										return r.sent(), [4, (0, a.set)("pushEndpointHash", n)];
									case 2:
										return r.sent(), [4, (0, a.set)("pushExpiresAt", t.expirationTime)];
									case 3:
										return r.sent(), [2]
								}
							}))
						}))
					}, e.prototype.requestPermissionAndRegisterForPush = function(e) {
						return r(this, void 0, void 0, (function() {
							return i(this, (function(t) {
								switch (t.label) {
									case 0:
										return [4, (0, a.get)("unregisteredAt")];
									case 1:
										return t.sent() ? [2, "unregistered"] : [4, this.requestNotificationPermission()];
									case 2:
										switch (t.sent()) {
											case "default":
												return [2, "unsubscribed"];
											case "denied":
												return [2, "blocked"]
										}
										t.label = 3;
									case 3:
										return t.trys.push([3, 5, , 6]), [4, this.pushRegister(e)];
									case 4:
										return t.sent(), [2, "subscribed"];
									case 5:
										return t.sent(), [2, "unsubscribed"];
									case 6:
										return [2]
								}
							}))
						}))
					}, e.prototype.getCurrentSubscriptionState = function(e) {
						return r(this, void 0, void 0, (function() {
							var t, n, r;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return "denied" === (t = Notification.permission) ? [2, "blocked"] : [4, (0, a.get)("unregisteredAt")];
									case 1:
										return i.sent() ? [2, "unregistered"] : [4, l(e.serviceWorkerPath)];
									case 2:
										return [4, null == (n = i.sent()) ? void 0 : n.pushManager.getSubscription()];
									case 3:
										return (r = i.sent()) && "granted" === t && c(e.vapidPublicKey, r) ? [2, "subscribed"] : [2, "unsubscribed"]
								}
							}))
						}))
					}, e.prototype.handleAutoResubscription = function(e) {
						return r(this, void 0, void 0, (function() {
							var t, n, r, o, s;
							return i(this, (function(i) {
								switch (i.label) {
									case 0:
										return e.autoResubscribe ? "granted" !== (t = Notification.permission) ? ("Auto-resubscribe: permission not granted, aborting: ".concat(t), [2]) : [4, (0, a.get)("pushEndpointHash")] : [2];
									case 1:
										return n = i.sent(), [4, (0, a.get)("pushExpiresAt")];
									case 2:
										return r = i.sent(), [4, l(e.serviceWorkerPath)];
									case 3:
										return [4, i.sent().pushManager.getSubscription()];
									case 4:
										if (o = i.sent(), s = void 0, o && (s = f(e, o)), void 0 !== n && n === s && o && c(e.vapidPublicKey, o) && (null == r || r > Date.now())) return [2];
										try {
											return [2, this.attemptPushRegister(e)]
										} catch (e) {
											console.error(e)
										}
										return [2]
								}
							}))
						}))
					}, e.prototype.isNativePromptShown = function() {
						return "chrome" !== (0, u.getBrowserName)() ? Promise.resolve(!0) : new Promise((function(e) {
							var t = !1,
								n = function() {
									t || (clearTimeout(r), window.removeEventListener("blur", n), t = !0, e(!0))
								};
							window.addEventListener("blur", n);
							var r = setTimeout((function() {
								window.removeEventListener("blur", n), e(!1)
							}), 1e3)
						}))
					}, e
				}();
				t.default = d
			},
			432: function(e, t) {
				t.__esModule = !0, t.keys = t.clear = t.del = t.set = t.get = t.Store = void 0;
				var n, r = function() {
					function e(e, t) {
						void 0 === e && (e = "keyval-store"), void 0 === t && (t = "keyval"), this.storeName = t, this._dbp = new Promise((function(n, r) {
							var i = indexedDB.open(e, 1);
							i.onerror = function() {
								return r(i.error)
							}, i.onsuccess = function() {
								return n(i.result)
							}, i.onupgradeneeded = function() {
								i.result.createObjectStore(t)
							}
						}))
					}
					return e.prototype._withIDBStore = function(e, t) {
						var n = this;
						return this._dbp.then((function(r) {
							return new Promise((function(i, o) {
								var s = r.transaction(n.storeName, e);
								s.oncomplete = function() {
									return i()
								}, s.onabort = s.onerror = function() {
									return o(s.error)
								}, t(s.objectStore(n.storeName))
							}))
						}))
					}, e
				}();

				function i() {
					return n || (n = new r), n
				}
				t.Store = r, t.get = function(e, t) {
					var n;
					return void 0 === t && (t = i()), t._withIDBStore("readonly", (function(t) {
						n = t.get(e)
					})).then((function() {
						return n.result
					}))
				}, t.set = function(e, t, n) {
					return void 0 === n && (n = i()), n._withIDBStore("readwrite", (function(n) {
						n.put(t, e)
					}))
				}, t.del = function(e, t) {
					return void 0 === t && (t = i()), t._withIDBStore("readwrite", (function(t) {
						t.delete(e)
					}))
				}, t.clear = function(e) {
					return void 0 === e && (e = i()), e._withIDBStore("readwrite", (function(e) {
						e.clear()
					}))
				}, t.keys = function(e) {
					void 0 === e && (e = i());
					var t = [];
					return e._withIDBStore("readonly", (function(e) {
						(e.openKeyCursor || e.openCursor).call(e).onsuccess = function() {
							this.result && (t.push(this.result.key), this.result.continue())
						}
					})).then((function() {
						return t
					}))
				}
			},
			159: function(e, t, n) {
				var r = this && this.__awaiter || function(e, t, n, r) {
						return new(n || (n = Promise))((function(i, o) {
							function s(e) {
								try {
									a(r.next(e))
								} catch (e) {
									o(e)
								}
							}

							function u(e) {
								try {
									a(r.throw(e))
								} catch (e) {
									o(e)
								}
							}

							function a(e) {
								var t;
								e.done ? i(e.value) : (t = e.value, t instanceof n ? t : new n((function(e) {
									e(t)
								}))).then(s, u)
							}
							a((r = r.apply(e, t || [])).next())
						}))
					},
					i = this && this.__generator || function(e, t) {
						var n, r, i, o, s = {
							label: 0,
							sent: function() {
								if (1 & i[0]) throw i[1];
								return i[1]
							},
							trys: [],
							ops: []
						};
						return o = {
							next: u(0),
							throw: u(1),
							return: u(2)
						}, "function" == typeof Symbol && (o[Symbol.iterator] = function() {
							return this
						}), o;

						function u(o) {
							return function(u) {
								return function(o) {
									if (n) throw new TypeError("Generator is already executing.");
									for (; s;) try {
										if (n = 1, r && (i = 2 & o[0] ? r.return : o[0] ? r.throw || ((i = r.return) && i.call(r), 0) : r.next) && !(i = i.call(r, o[1])).done) return i;
										switch (r = 0, i && (o = [2 & o[0], i.value]), o[0]) {
											case 0:
											case 1:
												i = o;
												break;
											case 4:
												return s.label++, {
													value: o[1],
													done: !1
												};
											case 5:
												s.label++, r = o[1], o = [0];
												continue;
											case 7:
												o = s.ops.pop(), s.trys.pop();
												continue;
											default:
												if (!(i = s.trys, (i = i.length > 0 && i[i.length - 1]) || 6 !== o[0] && 2 !== o[0])) {
													s = 0;
													continue
												}
												if (3 === o[0] && (!i || o[1] > i[0] && o[1] < i[3])) {
													s.label = o[1];
													break
												}
												if (6 === o[0] && s.label < i[1]) {
													s.label = i[1], i = o;
													break
												}
												if (i && s.label < i[2]) {
													s.label = i[2], s.ops.push(o);
													break
												}
												i[2] && s.ops.pop(), s.trys.pop();
												continue
										}
										o = t.call(e, s)
									} catch (e) {
										o = [6, e], r = 0
									} finally {
										n = i = 0
									}
									if (5 & o[0]) throw o[1];
									return {
										value: o[0] ? o[1] : void 0,
										done: !0
									}
								}([o, u])
							}
						}
					};
				t.__esModule = !0, t.getMostRecentlyOpenedPushPayload = t.persistOpenedPushPayload = t.getContextFromStoredConfig = t.getPromptReminder = t.persistPromptReminder = t.persistDDLConfig = t.persistConfig = t.del = t.set = t.get = void 0;
				var o = n(676),
					s = n(432),
					u = new s.Store("kumulos", "default");

				function a(e) {
					return (0, s.get)(e, u)
				}

				function c(e, t) {
					return (0, s.set)(e, t, u).then((function() {
						return t
					}))
				}

				function l(e) {
					return (0, s.del)(e, u)
				}
				t.get = a, t.set = c, t.del = l, t.persistConfig = function(e) {
					return c("config", {
						region: e.region,
						apiKey: e.apiKey,
						secretKey: e.secretKey,
						vapidPublicKey: e.vapidPublicKey,
						serviceWorkerPath: e.serviceWorkerPath,
						autoResubscribe: e.autoResubscribe,
						tenantId: e.tenantId
					})
				}, t.persistDDLConfig = function(e) {
					return c("ddlconfig", e)
				}, t.persistPromptReminder = function(e, t) {
					return c("reminder.".concat(e), t)
				}, t.getPromptReminder = function(e) {
					return r(this, void 0, void 0, (function() {
						return i(this, (function(t) {
							switch (t.label) {
								case 0:
									return [4, a("reminder.".concat(e))];
								case 1:
									return [2, t.sent()]
							}
						}))
					}))
				}, t.getContextFromStoredConfig = function() {
					return a("config").then((function(e) {
						return e ? new o.Context(e) : void 0
					}))
				}, t.persistOpenedPushPayload = function(e) {
					return c("mostRecentOpenedPushPayload", e)
				}, t.getMostRecentlyOpenedPushPayload = function() {
					return r(this, void 0, void 0, (function() {
						var e;
						return i(this, (function(t) {
							switch (t.label) {
								case 0:
									return [4, a("mostRecentOpenedPushPayload")];
								case 1:
									return e = t.sent(), [4, l("mostRecentOpenedPushPayload")];
								case 2:
									return t.sent(), [2, null != e ? e : void 0]
							}
						}))
					}))
				}
			},
			488: function(e, t, n) {
				var r, i = this && this.__extends || (r = function(e, t) {
						return r = Object.setPrototypeOf || {
							__proto__: []
						}
						instanceof Array && function(e, t) {
							e.__proto__ = t
						} || function(e, t) {
							for (var n in t) Object.prototype.hasOwnProperty.call(t, n) && (e[n] = t[n])
						}, r(e, t)
					}, function(e, t) {
						if ("function" != typeof t && null !== t) throw new TypeError("Class extends value " + String(t) + " is not a constructor or null");

						function n() {
							this.constructor = e
						}
						r(e, t), e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
					}),
					o = this && this.__assign || function() {
						return o = Object.assign || function(e) {
							for (var t, n = 1, r = arguments.length; n < r; n++)
								for (var i in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, i) && (e[i] = t[i]);
							return e
						}, o.apply(this, arguments)
					},
					s = this && this.__spreadArray || function(e, t, n) {
						if (n || 2 === arguments.length)
							for (var r, i = 0, o = t.length; i < o; i++) !r && i in t || (r || (r = Array.prototype.slice.call(t, 0, i)), r[i] = t[i]);
						return e.concat(r || Array.prototype.slice.call(t))
					};
				t.__esModule = !0, t.isMobile = t.onDOMReady = t.parseQueryString = t.defer = t.getFullUrl = t.base64UrlEncode = t.performJsonFetch = t.FetchError = t.performFetch = t.escapeRegExp = t.cyrb53 = t.isBrowserSupported = t.getBrowserName = t.uuidv4 = void 0;
				var u = n(676),
					a = [typeof Promise, typeof fetch, typeof indexedDB],
					c = {
						push: function() {
							var e, t = s([], a, !0);
							"safari" !== l() || "PushManager" in window ? t.push.apply(t, [typeof Notification, typeof navigator.serviceWorker, typeof PushManager]) : t.push(typeof(null === (e = window.safari) || void 0 === e ? void 0 : e.pushNotification));
							return f(t)
						},
						ddl: function() {
							return f(a)
						}
					};

				function l() {
					for (var e = navigator.userAgent.toLowerCase(), t = 0, n = ["edge", "firefox", "chrome", "safari"]; t < n.length; t++) {
						var r = n[t];
						if (e.indexOf(r) > -1) return r
					}
					return ""
				}

				function f(e) {
					return e.reduce((function(e, t) {
						return e && "undefined" !== t
					}), !0)
				}
				t.uuidv4 = function() {
					return "undefined" == typeof crypto ? "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, (function(e) {
						var t = 16 * Math.random() | 0;
						return ("x" == e ? t : 3 & t | 8).toString(16)
					})) : (1e7.toString() + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (function(e) {
						return (Number(e) ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> Number(e) / 4).toString(16)
					}))
				}, t.getBrowserName = l, t.isBrowserSupported = function(e) {
					return (e = null != e ? e : []).length || e.push(u.SDKFeature.PUSH), e.filter((function(e) {
						return c[e]()
					})).length > 0
				};
				var d = Math.imul || function(e, t) {
					var n = (4194303 & e) * (t |= 0);
					return 4290772992 & e && (n += (4290772992 & e) * t | 0), 0 | n
				};

				function p(e, t, n) {
					var r;
					void 0 === n && (n = {
						method: "GET"
					});
					var i = null !== (r = n.headers) && void 0 !== r ? r : {};
					return n.headers = o(o({
						"Content-Type": "application/json",
						Accept: "application/json"
					}, t ? {
						Authorization: t
					} : {}), i), fetch(e, n)
				}
				t.cyrb53 = function(e, t) {
					void 0 === t && (t = 0);
					for (var n = 3735928559 ^ t, r = 1103547991 ^ t, i = 0, o = void 0; i < e.length; i++) o = e.charCodeAt(i), n = d(n ^ o, 2654435761), r = d(r ^ o, 1597334677);
					return n = d(n ^ n >>> 16, 2246822507) ^ d(r ^ r >>> 13, 3266489909), 4294967296 * (2097151 & (r = d(r ^ r >>> 16, 2246822507) ^ d(n ^ n >>> 13, 3266489909))) + (n >>> 0)
				}, t.escapeRegExp = function(e) {
					return e.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
				}, t.performFetch = p;
				var h = function(e) {
					function t(t, n) {
						return e.call(this, "fetch failed: ".concat(t, ", ").concat(n)) || this
					}
					return i(t, e), t
				}(Error);
				t.FetchError = h, t.performJsonFetch = function(e, t, n) {
					return p(e, t, n).then((function(e) {
						if (!e.ok) throw new h(e.status, e.statusText);
						return e.json()
					}))
				}, t.base64UrlEncode = function(e) {
					var t = new Uint8Array(e);
					return btoa(t.reduce((function(e, t) {
						return e + String.fromCharCode(t)
					}), "")).replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "")
				}, t.getFullUrl = function(e) {
					return new URL(e, location.origin).href
				}, t.defer = function() {
					var e = {
						resolve: null,
						reject: null,
						promise: null
					};
					return e.promise = new Promise((function(t, n) {
						e.resolve = t, e.reject = n
					})), e
				}, t.parseQueryString = function(e, t) {
					void 0 === e && (e = location.search), void 0 === t && (t = []);
					var n = void 0;
					return e.length > 0 && (n = e.substring(1).split("&").map((function(e) {
						return e.split("=")
					})).map((function(e) {
						return e.map(decodeURIComponent)
					})).filter((function(e) {
						return -1 === t.indexOf(e[0])
					})).reduce((function(e, t) {
						var n;
						return o(o({}, e), ((n = {})[t[0]] = t[1], n))
					}), {})), n
				}, t.onDOMReady = function(e) {
					"loading" !== document.readyState ? e() : document.addEventListener("DOMContentLoaded", e)
				}, t.isMobile = function() {
					return /android|iPhone|iPad|iPod|mobile/i.test(navigator.userAgent)
				}
			},
			484: function(e, t, n) {
				var r = this && this.__importDefault || function(e) {
					return e && e.__esModule ? e : {
						default: e
					}
				};
				t.__esModule = !0;
				var i = n(676),
					o = n(159),
					s = n(999),
					u = n(546),
					a = r(n(718));

				function c(e) {
					return (0, o.getContextFromStoredConfig)().then((function(t) {
						return t ? e(t) : self.KUMULOS_INIT ? ((0, i.assertConfigValid)(self.KUMULOS_INIT), (0, o.persistConfig)(self.KUMULOS_INIT).then((function(n) {
							return t = new i.Context(n), e(t)
						}))) : void 0
					}))
				}
				self.addEventListener("install", (function() {
					self.skipWaiting()
				})), self.addEventListener("activate", (function(e) {
					e.waitUntil(self.clients.claim())
				})), self.addEventListener("push", (function(e) {
					var t = c((function(t) {
						var n, r;
						if (e.data) {
							var o = e.data.json();
							if (o) {
								var a = o.data;
								if (a && a["k.message"]) {
									var c = a["k.message"],
										l = (0, i.trackEvent)(t, i.EventType.MESSAGE_DELIVERED, {
											type: c.type,
											id: c.data.id
										}),
										f = (0, u.broadcastFromWorker)({
											type: s.WorkerMessageType.KPushReceived,
											data: o
										}),
										d = self.registration.showNotification(o.title, {
											body: o.msg,
											data: o,
											icon: null !== (n = o.icon) && void 0 !== n ? n : void 0,
											image: null !== (r = o.image) && void 0 !== r ? r : void 0,
											requireInteraction: !0
										});
									return Promise.all([d, f, l])
								}
							}
						}
					}));
					e.waitUntil(t)
				})), self.addEventListener("notificationclick", (function(e) {
					var t = c((function(t) {
						var n, r = e.notification,
							s = r.data;
						if (s) {
							var u = s.data;
							if (u && u["k.message"]) {
								r.close();
								var a = u["k.message"],
									c = (0, i.trackEvent)(t, i.EventType.MESSAGE_OPENED, {
										type: a.type,
										id: a.data.id
									}),
									l = null !== (n = s.url) && void 0 !== n ? n : "/";
								return (0, o.persistOpenedPushPayload)(s).then((function() {
									var e = self.clients.openWindow(l);
									return Promise.all([e, c])
								}))
							}
						}
					}));
					e.waitUntil(t)
				})), self.addEventListener("pushsubscriptionchange", (function(e) {
					if ("granted" === Notification.permission) {
						var t = c((function(e) {
							return (0, a.default)(e).attemptPushRegister(e)
						}));
						e.waitUntil(t)
					}
				}))
			},
			999: function(e, t) {
				var n;
				t.__esModule = !0, t.isKumulosWorkerMessage = t.WorkerMessageType = void 0,
					function(e) {
						e.KPushReceived = "KPushReceived"
					}(n = t.WorkerMessageType || (t.WorkerMessageType = {})), t.isKumulosWorkerMessage = function(e) {
						return void 0 !== e.type && void 0 !== n[e.type]
					}
			},
			546: function(e, t) {
				function n(e, t) {
					t.postMessage(e)
				}
				t.__esModule = !0, t.broadcastFromWorker = t.postEventToClient = void 0, t.postEventToClient = n, t.broadcastFromWorker = function(e) {
					var t = function(t) {
						return n(e, t)
					};
					return self.clients.matchAll().then((function(e) {
						e.forEach(t)
					}))
				}
			}
		},
		t = {};
	(function n(r) {
		var i = t[r];
		if (void 0 !== i) return i.exports;
		var o = t[r] = {
			exports: {}
		};
		return e[r].call(o.exports, o, o.exports, n), o.exports
	})(484)
}();