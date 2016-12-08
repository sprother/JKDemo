//
//  UINavigationController+Tencent.m
//  DeviceManager
//
//  Created by jayceyang on 2016/9/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "UINavigationController+Tencent.h"

@implementation UINavigationController (Tencent)

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    return [[self topViewController] prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self topViewController];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self topViewController];
}

@end
