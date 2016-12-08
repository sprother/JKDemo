//
//  MBProgressHUD+Tencent.m
//  DeviceManager
//
//  Created by hth on 11/26/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "MBProgressHUD+Tencent.h"

@implementation MBProgressHUD (Tencent)
+ (void)tc_showDefaultIndicatorWithText:(NSString *)text {
    [MBProgressHUD tc_hideDefaultIndicator];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.labelFont              = DEFAULT_FONT(15);
    hud.labelText              = text;
    hud.userInteractionEnabled = NO;
}

+ (void)tc_hideDefaultIndicator {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];
}

+ (void)tc_showIndicatorMessage:(NSString *)message {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode                   = MBProgressHUDModeText;
    hud.labelFont              = DEFAULT_FONT(15);
    hud.labelText              = message;
    hud.userInteractionEnabled = NO;

    [hud hide:YES afterDelay:2.0];
}

+ (void)tc_showBottomIndicatorMessage:(NSString *)message {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode                   = MBProgressHUDModeText;
    hud.labelFont              = DEFAULT_FONT(15);
    hud.labelText              = message;
    hud.userInteractionEnabled = NO;
    hud.yOffset                = keyWindow.frame.size.height / 4.0 + 60;

    [hud hide:YES afterDelay:2.0];
}

+ (void)tc_showBottomMultilineIndicatorMessage:(NSString *)message {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode                   = MBProgressHUDModeText;
    hud.detailsLabelFont       = DEFAULT_FONT(15);
    hud.detailsLabelText       = message;
    hud.userInteractionEnabled = NO;
    hud.yOffset                = keyWindow.frame.size.height / 4.0 + 60;
    
    [hud hide:YES afterDelay:2.0];
}

+ (void)tc_showMultilineIndicatorMessage:(NSString *)message {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode                   = MBProgressHUDModeText;
    hud.detailsLabelFont       = DEFAULT_FONT(15);
    hud.detailsLabelText       = message;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:2.0];
}

+ (void)tc_showIndicatorInView:(UIView *)view withText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelFont              = DEFAULT_FONT(15);
    hud.labelText              = text;
    hud.userInteractionEnabled = NO;
}

+ (void)tc_hideIndicatorInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
