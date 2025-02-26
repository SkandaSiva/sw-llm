
importScripts('https://www.gstatic.com/firebasejs/8.3.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.3.2/firebase-messaging.js');

firebase.initializeApp({
    apiKey: 'AIzaSyDM8T4aVU9Vma3Fg9pIfO-MCpsq1KNtCBs',
    authDomain: 'aplu-f.firebaseapp.com',
    projectId: 'aplu-f',
    storageBucket: 'aplu-f.appspot.com',
    messagingSenderId: '907915035035',
    appId: '1:907915035035:web:2b87cdb65c6c57319fa13e'
});

function notificationClickAlert(notificationId){
    fetch('https://push.aplu.io/post-tes-data', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
         body: JSON.stringify({'fcmMessageId':notificationId})
    }).then(function(response) {
        if (!response.ok) {
            throw new Error('Network response was not ok.')
        }
        return response.json();
    }).then(function(data) {
        console.log('Successfully sent data to API:', data)
    }).catch(function(error) {
        console.error('Failed to send data to API:', error)
    })
}

self.addEventListener('notificationclick', function(event) {
    const notification = event.notification;
    const urls = event.notification.data.FCM_MSG.notification.data.url;
    const url = typeof(urls) == 'string' ? urls : urls[0];
    let url2 = typeof(urls) == 'object' ? urls[1] : urls[0];
    const notifyIdd = event.notification.data.FCM_MSG.notification.data.notification_id;
    if (event.action === 'open_url') {
        event.waitUntil(
            notificationClickAlert(notifyIdd),
            clients.openWindow(url)
        );
    }
    else if(event.action === 'open_url_2')
    {
        event.waitUntil(
            notificationClickAlert(notifyIdd),
            clients.openWindow(url2)
        );
    }
    else if(event.action === 'close')
    {
        notification.close();
    }else{
        event.waitUntil(
            notificationClickAlert(notifyIdd),
            clients.openWindow(url)
        );
    }
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    console.log('Message received.', payload);
    const title = 'You have a notification';
    const options = {
        body: 'Please check notification message.',
        icon: '/firebase-logo.png',
    };
    return self.registration.showNotification(
        title,
        options,
    );
    });
    