# react-native-icloud-sync

A react-native wrapper for syncing with icloud.

### Add it to your project

1. Run `npm install react-native-icloud-sync --save`
2. Open your project in XCode, right click on `Libraries` and click `Add
   Files to "Your Project Name"` [(Screenshot)](http://url.brentvatne.ca/jQp8) then [(Screenshot)](http://url.brentvatne.ca/1gqUD).
3. Add `libRNiCloudSync.a` to `Build Phases -> Link Binary With Libraries`
   [(Screenshot)](http://url.brentvatne.ca/17Xfe).
4. Whenever you want to use it within React code now you can: `var icloud = require('react-native-icloud-sync')`


## Example
```javascript
var icloud = require('react-native-icloud-sync');

//store.js
var store = {};

//handle icloud progress.
icloud.eventEmitter.on('update', (update) => {
  
  //reason for this update?
  if([icloud.ServerChange, icloud.InitialSync].indexOf(update.reason) > -1) {
    //update asyncStorage.
    AsyncStorage.multiSet(STORAGE_KEYS);
  }

});

// subscribe for progress notifications.
icloud.subscribe();

//save the progress to icloud
icloud.save(key, value);

module.exports = store;
```
