//
//  IMSDKSession.m
//  JKDemo
//
//  Created by jackyjiao on 3/17/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import "IMSDKUISession.h"

@interface IMSDKUISession ()

@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) NSString *sessionId;

@end

@implementation IMSDKUISession

- (instancetype)initWithTarget:(NSString *)target sessionId:(NSString *)sessionId {
    if (self = [super init]) {
        self.target = target;
        self.sessionId = sessionId;
    }
    return self;
}

//- (void)dealloc {
//    [self closeSessionWithCallback:nil];
//}

#pragma mark -
- (void)fetchWindowSizeWithCallback:(IMSDKUIResponeCallback)callback {
    NSString *subUrl = @"/window/size";
    NSString *url = [NSString stringWithFormat:@"%@/session/%@%@", self.target, self.sessionId, subUrl];
    [[IMSDKUIHTTPAgent sharedManager] getRequest:url withPara:nil withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (callback == nil) {
            return;
        }
        if (ret != 0) {
            callback(rsp, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        callback(rsp, nil);
    }];
}

- (void)closeSessionWithCallback:(IMSDKUIOperationCallback)callback {
    NSString *subUrl = @"";
    NSString *url = [NSString stringWithFormat:@"%@/session/%@%@", self.target, self.sessionId, subUrl];
    [[IMSDKUIHTTPAgent sharedManager] deleteRequest:url withPara:nil withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (callback == nil) {
            return;
        }
        if (ret != 0) {
            callback(NO, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        callback(YES, nil);
    }];

}

#pragma mark -
- (void)findElementByXpath:(NSString *)xpath withCallback:(IMSDKUIFindElementCallback)callback {
    NSDictionary *parameters = @{@"using":@"xpath", @"value":xpath};
    NSString *subUrl = @"/elements";
    NSString *url = [NSString stringWithFormat:@"%@/session/%@%@", self.target, self.sessionId, subUrl];
    [[IMSDKUIHTTPAgent sharedManager] postRequest:url withPara:parameters withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (callback == nil) {
            return;
        }
        if (ret != 0) {
            callback(nil, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        NSDictionary *eleDict = [rsp[@"value"] firstObject];
        NSString *elementsId = eleDict[@"ELEMENT"];
        callback(elementsId, nil);
    }];
}

- (void)tapElementById:(NSString *)elementId withCallback:(IMSDKUIOperationCallback)callback {
    NSString *subUrl = [NSString stringWithFormat:@"/element/%@/click", elementId];
    NSString *url = [NSString stringWithFormat:@"%@/session/%@%@", self.target, self.sessionId, subUrl];
    [[IMSDKUIHTTPAgent sharedManager] postRequest:url withPara:nil withCallback:^(NSDictionary *rsp, NSError *error) {
        NSInteger ret = [rsp[WDA_Status] integerValue];
        if (callback == nil) {
            return;
        }
        if (ret != 0) {
            callback(NO, [NSError errorWithDomain:@"" code:ret userInfo:nil]);
            return;
        }
        callback(YES, nil);
    }];
}

- (void)tapElementByXpath:(NSString *)xpath withCallback:(IMSDKUIOperationCallback)callback {
    [self findElementByXpath:xpath withCallback:^(NSString *elementId, NSError *error) {
        if (error == nil) {
            [self tapElementById:elementId withCallback:^(BOOL success, NSError *error) {
                if (callback == nil) {
                    return;
                }
                callback(success, error);
            }];
            return;
        }
        if (callback == nil) {
            return;
        }
        callback(NO, error);
    }];
}

@end
