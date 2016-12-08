//
//  MBProgressHUD+Tencent.h
//  DeviceManager
//
//  Created by hth on 11/26/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Tencent)
+ (void)tc_showDefaultIndicatorWithText:(NSString *)text;
+ (void)tc_hideDefaultIndicator;
+ (void)tc_showIndicatorMessage:(NSString *)message;
+ (void)tc_showBottomIndicatorMessage:(NSString *)message;
+ (void)tc_showBottomMultilineIndicatorMessage:(NSString *)message;
+ (void)tc_showMultilineIndicatorMessage:(NSString *)message;
+ (void)tc_showIndicatorInView:(UIView *)view withText:(NSString *)text;
+ (void)tc_hideIndicatorInView:(UIView *)view;
@end
