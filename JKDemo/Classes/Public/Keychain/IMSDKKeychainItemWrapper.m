//
//  IMSDKKeychainItemWrapper.m
//  pbxTest
//
//  Created by brightwan on 16/4/27.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "IMSDKKeychainItemWrapper.h"
#import <Security/Security.h>

#define kKeychainServiceName @"com.tencent.imsdk"

@interface IMSDKKeychainItemWrapper ()

// kSecValueData 在 NSStringwhat 和 Keychain API 接受的合法结构类型之间转换
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

// 更新到keychain中，如果不存在则新增
- (void)writeToKeychain;

@end

@implementation IMSDKKeychainItemWrapper

@synthesize keychainItemData, genericPasswordQuery, keychainIdentifier;

- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup {
    if (self = [super init]) {
        keychainIdentifier = identifier;
        genericPasswordQuery = [[NSMutableDictionary alloc] init];
        
        [genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [genericPasswordQuery setObject:identifier forKey:(__bridge id)kSecAttrAccount];
        [genericPasswordQuery setObject:kKeychainServiceName forKey:(__bridge id)kSecAttrService];
        if (YES) {//[[IMSDKUtils getAppPlistInfo][@"KeychainSync"] boolValue]
            NSLog(@"activate kSecAttrSynchronizable while query");
            [genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecAttrSynchronizable];
        } else {
            NSLog(@"deactivate kSecAttrSynchronizable while query");
        }
        
        if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
            // 忽略模拟器的 Keychain sharing
            // 因为模拟器中运行的app没有被签名，没有沙箱限制
            // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
            // simulator will return -25243 (errSecNoAccessForItem).
#else
            [genericPasswordQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
        }
        
        // 返回第一个匹配的项，并返回所有属性
        [genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        [genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
        
        CFDictionaryRef retDict = NULL;
        OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery, (CFTypeRef*)&retDict);
        if (result != errSecSuccess) {
            [self resetKeychainItem];
            
            // Add the generic attribute and the keychain access group.
            [keychainItemData setObject:identifier forKey:(__bridge id)kSecAttrAccount];
            [keychainItemData setObject:kKeychainServiceName forKey:(__bridge id)kSecAttrService];
            [keychainItemData setObject:kKeychainServiceName forKey:(__bridge id)kSecAttrLabel];
            if (YES) {//[[IMSDKUtils getAppPlistInfo][@"KeychainSync"] boolValue]
                NSLog(@"activate kSecAttrSynchronizable while initialize");
                [keychainItemData setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecAttrSynchronizable];
            } else {
                NSLog(@"deactivate kSecAttrSynchronizable while initialize");
            }
            
            if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
#else
                [keychainItemData setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
            }
        } else {
            self.keychainItemData = [self secItemFormatToDictionary:(__bridge_transfer NSDictionary*)retDict];
        }
    }
    
    return self;
}

- (void)setObject:(id)object forKey:(id)key {
    if (object == nil)
        return;
    
    id currentObject = [keychainItemData objectForKey:key];
    if (![currentObject isEqual:object]) {
        [keychainItemData setObject:object forKey:key];
        [self writeToKeychain];
    }
}

- (id)objectForKey:(id)key {
    return [keychainItemData objectForKey:key];
}

- (void)resetKeychainItem {
    OSStatus stat = errSecSuccess;
    if (!keychainItemData) {
        self.keychainItemData = [[NSMutableDictionary alloc] init];
    } else if (keychainItemData) {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:keychainItemData];
        stat = SecItemDelete((__bridge CFDictionaryRef)tempDictionary);
        if (stat == errSecItemNotFound) {
            NSLog(@"SecItemDelete, Problem deleting current %@ dictionary error : %d", self.keychainIdentifier, (int)stat);
        }
    }
    
    // Default attributes for keychain item.
    [keychainItemData setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [keychainItemData setObject:@"" forKey:(__bridge id)kSecAttrService];
    [keychainItemData setObject:@"" forKey:(__bridge id)kSecAttrLabel];
    [keychainItemData setObject:@"" forKey:(__bridge id)kSecAttrDescription];
    
    // Default data for keychain item.
    [keychainItemData setObject:@"" forKey:(__bridge id)kSecValueData];
}

#pragma mark - private method

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the proper search key and class attribute.
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    CFDataRef passwordData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary, (CFTypeRef*)&passwordData) == errSecSuccess) {
        [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
        
        // 将存储的数据转换为 NSString，赋值给 kSecValueData
        NSString *password = [[NSString alloc] initWithData:(__bridge_transfer NSData*)passwordData encoding:NSUTF8StringEncoding];
        if (password) {
            [returnDictionary setObject:password forKey:(__bridge id)kSecValueData];
        }        
    } else {
        NSLog(@"Serious error, no matching item found %@ in the keychain.", self.keychainIdentifier);
    }
    
    return returnDictionary;
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    // 为了匹配 kSecValueData 类型，将 NSString 转换为 NSData，该字段会被加密
    NSString *passwordString = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    return returnDictionary;
}

- (void)writeToKeychain {
    CFDictionaryRef attributes = NULL;
    NSMutableDictionary *queryItem = nil;
    OSStatus result;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery, (CFTypeRef*)&attributes) == errSecSuccess) {    // 更新现有数据
        // 从匹配的结果构建查询字典
        queryItem = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary*)attributes];
        // 添加合适的查询 key/value
        [queryItem setObject:[genericPasswordQuery objectForKey:(__bridge id)kSecClass] forKey:(__bridge id)kSecClass];
        
        // 构建更新字典，删除不需要的 key
        NSMutableDictionary *attributesToUpdate = [self dictionaryToSecItemFormat:keychainItemData];
        [attributesToUpdate removeObjectForKey:(__bridge id)kSecClass];
        
#if TARGET_IPHONE_SIMULATOR
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
        //
        // The access group attribute will be included in items returned by SecItemCopyMatching,
        // which is why we need to remove it before updating the item.
        [attributesToUpdate removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
#endif
        
        // 每次只能更新一条数据
        result = SecItemUpdate((__bridge CFDictionaryRef)queryItem, (__bridge CFDictionaryRef)attributesToUpdate);
        if (result != errSecSuccess) {
            NSLog(@"SecItemUpdate %@ error : %d",self.keychainIdentifier,(int)result);
        } else {
            NSLog(@"SecItemUpdate %@ succeed",self.keychainIdentifier);
        }
    } else {    // 新增数据
        result = SecItemAdd((__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:keychainItemData], NULL);
        if (result != errSecSuccess) {
            NSLog(@"SecItemAdd %@ error : %d",self.keychainIdentifier,(int)result);
        } else {
            NSLog(@"SecItemAdd %@ succeed",self.keychainIdentifier);
        }
    }
}

@end
