importScripts("https://www.gstatic.com/firebasejs/7.9.1/firebase-app.js");
            importScripts("https://www.gstatic.com/firebasejs/7.9.1/firebase-messaging.js");
            importScripts("https://www.gstatic.com/firebasejs/7.9.1/firebase-analytics.js");
            var Config = {
                apiKey: "AIzaSyCAtm6ZhZPRPBuROsL6rfkYG7A3oLZzW10",
                authDomain: "wavepush3.firebaseapp.com",
                databaseURL: "https://wavepush3.firebaseapp.com",
                projectId: "wavepush3",
                storageBucket: "wavepush3.appspot.com",
                messagingSenderId: "526657213145",
                appId: "1:526657213145:web:533086c2973d1aab80a4c8",
                measurementId: "G-89SFZ32F1K",
            };
            firebase.initializeApp(Config);
            const messaging = firebase.messaging();
            messaging.setBackgroundMessageHandler(function (payload) {
                var title = payload.data.title;
                var options = { name: payload.data.name, body: payload.data.body, click_action: payload.data.click_action, icon: payload.data.icon, data: { time: new Date(Date.now()).toString(), click_action: payload.data.click_action } };
                return self.registration.showNotification(title, options);
            });
            self.addEventListener("notificationclick", function (event) {
                var action_click = event.notification.data.click_action;
                event.notification.close();
                event.waitUntil(clients.openWindow(action_click));
            });