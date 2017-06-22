//
//  NSString+IMSDK.m
//  JKDemo
//
//  Created by jackyjiao on 3/20/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import "NSString+IMSDK.h"
#import <CommonCrypto/CommonCryptor.h> 

@implementation NSString (IMSDK)

+ (NSString *)jsonStringWithString:(NSString *) string {
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}

+ (NSString *)jsonStringWithArray:(NSArray *)array {
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *)jsonStringWithObject:(id)object {
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidCode {//六位数字
    NSString    *codeRegex = @"[0-9]{6}";
    NSPredicate *codePred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", codeRegex];
    
    return [codePred evaluateWithObject:self];
}

- (NSDictionary *)parseURLParams {
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return [params copy];
}

#pragma mark - forward
////test消息转发
//JKAppDelegate *dele = (JKAppDelegate *)str;
//[dele configCommonUI];
//
//Class deleClass = NSClassFromString(@"NSString");
//[deleClass shareInstance];

//对象方法调用时，如果没有会转发到这里1，返回NO表示无法处理
+ (BOOL) resolveInstanceMethod:(SEL)aSel
{
    JLog(@"===resolveInstanceMethod %@", NSStringFromSelector(aSel));
    return [super resolveInstanceMethod:aSel];
}

//类方法调用时，如果没有会转发到这里
+ (BOOL) resolveClassMethod:(SEL)aSel
{
    JLog(@"===resolveClassMethod %@", NSStringFromSelector(aSel));
    return [super resolveInstanceMethod:aSel];
}

//对象方法调用时，如果没有实现，1无法处理，返回NO，转发到这里2，返回nil表示无法处理
- (id)forwardingTargetForSelector:(SEL)aSel
{
    JLog(@"===forwardingTargetForSelector %@", NSStringFromSelector(aSel));
    
    return [super forwardingTargetForSelector:aSel];
}

//对象方法调用时，如果没有实现，2无法处理，返回nil，转发到这里3，返回nil表示无法处理
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSel
{
    JLog(@"===methodSignatureForSelector %@", NSStringFromSelector(aSel));
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

//对象方法调用时，如果没有实现，2无法处理，返回nil，3返回可用签名，转发到这里4，调用不再crash
- (void)forwardInvocation:(NSInvocation *)invocation
{
    JLog(@"===forwardInvocation %@", invocation);
    
}

#pragma mark - AES
/*!
 *  @abstract AES128加密，采用，ECB模式，PKCS7Padding/PKCS5Padding，IV为NULL
 *  参考 http://www.cnblogs.com/leotangcn/p/4248414.html
 */
- (NSString *)aes128_encrypt:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [resultData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
    }
    free(buffer);
    return nil;
}

- (NSString *)aes128_decrypt:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

@end
