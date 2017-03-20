//
//  IMSDKUIHTTPAgent.m
//  IMSDK
//
//  Created by jackyjiao on 3/16/17.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "IMSDKUIHTTPAgent.h"
#import "NSString+IMSDK.h"

@interface IMSDKUIHTTPAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;//IMSDK_EDIT

@end

@implementation IMSDKUIHTTPAgent

+ (instancetype)sharedManager {
    static IMSDKUIHTTPAgent *_instance = nil;
    static dispatch_once_t     onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[IMSDKUIHTTPAgent alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //1.创建管理者
        self.manager = [AFHTTPSessionManager manager];//IMSDK_EDIT
        
        //2.设置请求参数的拼接
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];//IMSDK_EDIT
        [self.manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            // 将NSDictionary对象转成JSON字符串
            NSString *jsonString = [NSString jsonStringWithDictionary:parameters];
            return jsonString;
        }];
    }
    return self;
}

#pragma mark - http
- (void)request:(NSString *)url withType:(JKRequestType)type withPara:(NSDictionary *)parameters withCallback:(IMSDKUIResponeCallback)callback {
    if (type == JKRequestTypeGet) {
        [self getRequest:url withPara:parameters withCallback:callback];
        return;
    }
    if (type == JKRequestTypePost) {
        [self postRequest:url withPara:parameters withCallback:callback];
        return;
    }
    if (type == JKRequestTypeDelete) {
        [self deleteRequest:url withPara:parameters withCallback:callback];
        return;
    }
}

- (void)postRequest:(NSString *)url withPara:(NSDictionary *)arguments withCallback:(IMSDKUIResponeCallback)callback {
    NSLog(@"post from url:%@, parameters:%@", url, arguments);
    [self.manager POST:url parameters:arguments success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        NSLog(@"post responseObject is:%@",responseObject);
        NSDictionary *dict = responseObject;
        if (callback) {
            callback(dict, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post error is:%@",error);
        if (callback) {
            callback(nil, error);
        }
    }];
}

- (void)getRequest:(NSString *)url withPara:(NSDictionary *)arguments withCallback:(IMSDKUIResponeCallback)callback {
    NSLog(@"get from url:%@, parameters:%@", url, arguments);
    [self.manager GET:url parameters:arguments success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        NSLog(@"get responseObject is:%@",responseObject);
        NSDictionary *dict = responseObject;
        if (callback) {
            callback(dict, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get error is:%@",error);
        if (callback) {
            callback(nil, error);
        }
    }];
}

- (void)deleteRequest:(NSString *)url withPara:(NSDictionary *)arguments withCallback:(IMSDKUIResponeCallback)callback {
    NSLog(@"delete from url:%@, parameters:%@", url, arguments);
    [self.manager DELETE:url parameters:arguments success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        NSLog(@"delete responseObject is:%@",responseObject);
        NSDictionary *dict = responseObject;
        if (callback) {
            callback(dict, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get error is:%@",error);
        if (callback) {
            callback(nil, error);
        }
    }];
}

@end
