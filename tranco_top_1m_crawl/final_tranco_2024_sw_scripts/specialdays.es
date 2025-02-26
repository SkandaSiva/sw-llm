/*
*
*  Push Notifications codelab
*  Copyright 2015 Google Inc. All rights reserved.
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License
*
*/

/* eslint-env browser, serviceworker, es6 */

// 'use strict';

// self.addEventListener('push', function(event) {
//   console.log('[Service Worker] Push Received.');
//   console.log(`[Service Worker] Push had this data: "${event.data.text()}"`);

//   const title = 'Push Special Days';
//   const options = {
//     body: 'Visita Nuestra pagina Special Days.',
//     icon: 'images/icon.png',
//     badge: 'images/badge.png'
//   };

//   	const notificationPromise = self.registration.showNotification(title, options);
// 	event.waitUntil(notificationPromise);
// });

// self.addEventListener('notificationclick', function(event) {
//   console.log('[Service Worker] Notification click Received.');

//   event.notification.close();

//   event.waitUntil(
//     clients.openWindow('https://specialdaysbeta.azurewebsites.net')
//   );
// });


self.addEventListener('push', event => {
	// console.log("event");
	const data = event.data.json()
	console.log(data)
	event.waitUntil(
		self.registration.showNotification(data.title,
		{
			body : data.message
		})
	);
});