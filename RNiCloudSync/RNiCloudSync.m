#import "RNiCloudSync.h"

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RNiCloudSync

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(subscribe)
{
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    if (store != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateKVStoreItems:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:store];
        [store synchronize];
    }
}

RCT_EXPORT_METHOD(save:(NSString *)key
                  value:(NSString *)value)
{
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    if (store != nil) {
        [store setObject:value forKey:key];
        [store synchronize];
    }
}

- (void)updateKVStoreItems:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *changeReason = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // Is a Reason Specified?
    if (!changeReason) {
        return;
    }
    reason = [changeReason integerValue];

    if ((reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        NSArray *changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        [_bridge.eventDispatcher sendDeviceEventWithName:@"update"
                                                    body:@{
                                                           @"reason": @(reason),
                                                           @"keys": changedKeys
                                                        }];
    }
}

- (NSDictionary *)constantsToExport
{
  return @{
   @"ServerChange": @(NSUbiquitousKeyValueStoreServerChange),
    @"InitialSync": @(NSUbiquitousKeyValueStoreInitialSyncChange),
  };
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end