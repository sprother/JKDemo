//
//  UIViewController+Tencent.m
//  DeviceManager
//
//  Created by jayceyang on 2016/9/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "UIViewController+Tencent.h"

@implementation UIViewController (Tencent)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma clang diagnostic pop

@end
