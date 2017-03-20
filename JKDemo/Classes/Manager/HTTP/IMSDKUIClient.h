//
//  IMSDKClient.h
//  JKDemo
//
//  Created by jackyjiao on 3/17/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSDKUISession.h"
#import "IMSDKUIHTTPAgent.h"

typedef void (^IMSDKUISessionCallback)(IMSDKUISession *session, NSError *error);

@interface IMSDKUIClient : NSObject

- (instancetype)initWithTarget:(NSString *)target;
- (void)createSessionWithBundleId:(NSString *)bundleId withCallback:(IMSDKUISessionCallback)callback;
- (void)fetchSessionWithCallback:(IMSDKUISessionCallback)callback;
- (void)clickHomeWithCallback:(IMSDKUIOperationCallback)callback;
- (void)checkStatusWithCallback:(IMSDKUIOperationCallback)callback;

@end
