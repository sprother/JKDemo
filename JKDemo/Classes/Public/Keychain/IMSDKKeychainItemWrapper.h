//
//  IMSDKKeychainItemWrapper.h
//  pbxTest
//
//  Created by brightwan on 16/4/27.
//  Copyright © 2016年 tencent. All rights reserved.
//
//  Modified from KeychainItemWrapper V1.2
//  KeychainItemWrapper: https://developer.apple.com/library/ios/samplecode/GenericKeychain/Introduction/Intro.html
//  fix two issues:
//      1. set kSecAttrSynchronizable kCFBooleanTrue in query dictionary
//      2. use kSecAttrAccount and kSecAttrService as key in query dictionary
//

#import <Foundation/Foundation.h>

@interface IMSDKKeychainItemWrapper : NSObject 
// he actual keychain item data backing store.
@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
// A placeholder for the generic keychain item query used to locate the item.
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;
@property (nonatomic, retain) NSString *keychainIdentifier;

/*!
 *  @brief  获取 keychain item 对象
 *
 *  @param identifier   IMSDKKeychainItemWrapper identifier
 *  @param accessGroup  Keychain sharing group
 *  @return IMSDKKeychainItemWrapper object
 */
- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup;

/*!
 *  @brief  设置 keychain item 对象属性
 *
 *  @param object   value of key
 *  @param key      key of value
 */
- (void)setObject:(id)object forKey:(id)key;

/*!
 *  @brief  获取 keychain item 对象指定属性的值
 *
 *  @param key  key of value
 *  @return     value of key
 */
- (id)objectForKey:(id)key;

/*!
 *  @brief  重置 Keychain item 数据
 */
- (void)resetKeychainItem;

@end
