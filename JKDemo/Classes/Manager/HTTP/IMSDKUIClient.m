//
//  IMSDKClient.m
//  JKDemo
//
//  Created by jackyjiao on 3/17/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import "IMSDKUIClient.h"

#define LocalDevice @"http://localhost:8100"

@interface IMSDKUIClient ()

@property (nonatomic, strong) NSString *target;

@end

@implementation IMSDKUIClient

- (instancetype)initWithTarget:(NSString *)target {
    if (self = [super init]) {
        self.target = target;
    }
    return self;
}

- (instancetype)init {
    return [self initWithTarget:LocalDevice];
}

#pragma mark -
- (void)createSessionWithBundleId:(NSString *)bundleId withCallback:(IMSDKUISessionCallback)callback {
    if (callback == nil) {
        return;
    }
    NSString *subUrl = @"/session";
    NSString *url = [NSString stringWithFormat:@"%@%@", self.target, subUrl];
    NSDictionary *parameters = @{WDA_Desire:@{WDA_BundleId:bundleId}};
    [[IMSDKUIHTTPAgent sharedManager] postRequest:url withPara:parameters withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (ret != 0) {
            callback(nil, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        NSString *sessionId = (NSString *)rsp[WDA_SessionId];
        IMSDKUISession *session = [[IMSDKUISession alloc] initWithTarget:self.target sessionId:sessionId];
        callback(session, nil);
    }];
}

- (void)fetchSessionWithCallback:(IMSDKUISessionCallback)callback {
    if (callback == nil) {
        return;
    }
    NSString *subUrl = @"/status";
    NSString *url = [NSString stringWithFormat:@"%@%@", self.target, subUrl];
    [[IMSDKUIHTTPAgent sharedManager] getRequest:url withPara:nil withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (ret != 0) {
            callback(nil, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        NSString *sessionId = (NSString *)rsp[WDA_SessionId];
        IMSDKUISession *session = [[IMSDKUISession alloc] initWithTarget:self.target sessionId:sessionId];
        callback(session, nil);
    }];
}

- (void)clickHomeWithCallback:(IMSDKUIOperationCallback)callback {
    if (callback == nil) {
        return;
    }
    NSString *subUrl = @"/wda/homescreen";
    NSString *url = [NSString stringWithFormat:@"%@%@", self.target, subUrl];
    [[IMSDKUIHTTPAgent sharedManager] postRequest:url withPara:nil withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (ret != 0) {
            callback(nil, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        NSString *sessionId = (NSString *)rsp[WDA_SessionId];
        IMSDKUISession *session = [[IMSDKUISession alloc] initWithTarget:self.target sessionId:sessionId];
        callback(session, nil);
    }];
}

- (void)checkStatusWithCallback:(IMSDKUIOperationCallback)callback {
    if (callback == nil) {
        return;
    }
    NSString *subUrl = @"/status";
    NSString *url = [NSString stringWithFormat:@"%@%@", self.target, subUrl];
    [[IMSDKUIHTTPAgent sharedManager] getRequest:url withPara:nil withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (ret != 0) {
            callback(NO, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        callback(YES, nil);
    }];
}

@end
