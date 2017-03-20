//
//  IMSDKSession.h
//  JKDemo
//
//  Created by jackyjiao on 3/17/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSDKUIHTTPAgent.h"

typedef void (^IMSDKUIFindElementCallback)(NSString *elementId, NSError *error);

@interface IMSDKUISession : NSObject

- (instancetype)initWithTarget:(NSString *)target sessionId:(NSString *)sessionId;

- (void)fetchWindowSizeWithCallback:(IMSDKUIResponeCallback)callback;
- (void)findElementByXpath:(NSString *)xpath withCallback:(IMSDKUIFindElementCallback)callback;
- (void)tapElementById:(NSString *)elementId withCallback:(IMSDKUIOperationCallback)callback;
- (void)tapElementByXpath:(NSString *)xpath withCallback:(IMSDKUIOperationCallback)callback;

@end
