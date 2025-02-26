'use strict';
//Neutron
self.addEventListener('fetch', function (event) {
    //leave empty - event must be present for PWA
});


function setupSharedBatchSDK() {
  // Change this to switch the major Batch SDK version you want to use
  // This MUST match the version used in the bootstrap script you put in your page
  const BATCHSDK_MAJOR_VERSION = 3;

  importScripts("https://via.batch.com/v" + BATCHSDK_MAJOR_VERSION + "/worker.min.js");

  const eventsList = ["pushsubscriptionchange", "push", "notificationclick", "message", "install"];
  eventsList.forEach(eventName => {
    self.addEventListener(eventName, event => {
      event.waitUntil(self.handleBatchSDKEvent(eventName, event));
    });
  });
}

setupSharedBatchSDK();
