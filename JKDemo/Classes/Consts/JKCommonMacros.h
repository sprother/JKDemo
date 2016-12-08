//
//  JKCommonMacros.h
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#ifndef JKCommonMacros_h
#define JKCommonMacros_h

#define CGRectGetCenter(rect)                        CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))

//颜色
#define UIColorFromHex(hexValue)                     [UIColor colorWithRed : ((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue : (float)((hexValue & 0xFF)) / 255.0 alpha : 1.0f]

#define UIColorFromHexAndAlpha(hexValue, alphaValue) [UIColor colorWithRed : ((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue : (float)((hexValue & 0xFF)) / 255.0 alpha : alphaValue]

#define UIColorFromRgbAlpha(rgb, halpha)             [UIColor colorWithRed : ((float)((rgb & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgb & 0xFF00) >> 8)) / 255.0 blue : (float)((rgb & 0xFF)) / 255.0 alpha : (float)((halpha & 0xFF)) / 255.0]

#define UIColorFromRgbFloatAlpha(rgb, falpha)        [UIColor colorWithRed : ((float)((rgb & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgb & 0xFF00) >> 8)) / 255.0 blue : (float)((rgb & 0xFF)) / 255.0 alpha : falpha]
#define RANDOM_COLOR             UIColorFromHex(arc4random()%0x1000000)
#define DEFAULT_BACKGROUND_COLOR UIColorFromHex(0xF0F0F0)

//NSUserDefault
#define USER_DEFAULT             [NSUserDefaults standardUserDefaults]

//Path
#define CACHE_PATH               [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define DOCUMENT_PATH            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define LIBRARY_PATH             [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
#define TEMP_PATH                NSTemporaryDirectory()

//多线程相关
#define  BACK(block)      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define  MAIN(block)      dispatch_async(dispatch_get_main_queue(), block)

//日志
#ifdef DEBUG
#   define JLog(fmt, ...) NSLog((@"%s:%d || " fmt), __FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define JLog(fmt, ...) {}
#endif

#endif /* JKCommonMacros_h */
