
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>
#import <AVFoundation/AVFoundation.h>
#import <ImSDK_Plus/ImSDK_Plus.h>
#import <ImSDK_Plus/V2TIMManager.h>


@interface RNTencentIM : RCTEventEmitter <RCTBridgeModule,V2TIMSimpleMsgListener,V2TIMAdvancedMsgListener,V2TIMGroupListener,V2TIMFriendshipListener,V2TIMAdvancedMsgListener>

@end
  
