'use strict';

var {
  DeviceEventEmitter,
  NativeModules: {
    RNiCloudSync,
  }
} = require('react-native');
var EventEmitter = require('events').EventEmitter;

var iCloudEventEmitter = new EventEmitter();
DeviceEventEmitter.addListener('update', (updates) => {
  iCloudEventEmitter.emit('update', updates);
});

module.exports = {
  eventEmitter: iCloudEventEmitter,
  subscribe: RNiCloudSync.subscribe,
  save: RNiCloudSync.save,
  ServerChange: RNiCloudSync.ServerChange,
  InitialSync: RNiCloudSync.InitialSync,
};
