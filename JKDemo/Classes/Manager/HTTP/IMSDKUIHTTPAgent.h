//
//  IMSDKUIHTTPAgent.h
//  IMSDK
//
//  Created by jackyjiao on 3/16/17.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"//IMSDK_EDIT

typedef NS_ENUM (NSInteger, JKRequestType) {
    JKRequestTypeGet    = 0,
    JKRequestTypePost   = 1,
    JKRequestTypeDelete = 2
};

#define WDA_Status      @"status"
#define WDA_SessionId   @"sessionId"
#define WDA_Value       @"value"
#define WDA_Desire      @"desiredCapabilities"
#define WDA_BundleId    @"bundleId"

typedef void (^IMSDKUIResponeCallback)(NSDictionary *rsp, NSError *error);
typedef void (^IMSDKUIOperationCallback)(BOOL success, NSError *error);

@interface IMSDKUIHTTPAgent : NSObject

+ (instancetype)sharedManager;

- (void)request:(NSString *)url withType:(JKRequestType)type withPara:(NSDictionary *)parameters withCallback:(IMSDKUIResponeCallback)callback;
- (void)getRequest:(NSString *)url withPara:(NSDictionary *)parameters withCallback:(IMSDKUIResponeCallback)callback;
- (void)postRequest:(NSString *)url withPara:(NSDictionary *)parameters withCallback:(IMSDKUIResponeCallback)callback;
- (void)deleteRequest:(NSString *)url withPara:(NSDictionary *)arguments withCallback:(IMSDKUIResponeCallback)callback;

@end
