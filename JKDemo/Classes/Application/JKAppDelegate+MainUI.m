//
//  JKAppDelegate+MainUI.m
//  JKDemo
//
//  Created by jackyjiao on 12/7/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAppDelegate+MainUI.h"
#import "JKLoginViewController.h"
#import "JKDemoViewController.h"

@implementation JKAppDelegate (MainUI)

#pragma mark - UI
- (void)showLoginViewAnimated:(BOOL)animated {
    JKLoginViewController *loginViewController = [[JKLoginViewController alloc] init];

    [self setRootViewController:loginViewController animated:animated];
}

- (void)showMainViewAnimated:(BOOL)animated {
    [self createRootTabBarController];
    [self setRootViewController:self.rootTabBarController animated:animated];
}

#pragma mark - setRoot
- (void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated {
    if (rootViewController == nil) {
        return;
    }
    self.window.rootViewController = rootViewController;
    if (!animated) {
        return;
    }
    self.window.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
         self.window.alpha = 1;
     } completion:nil];
}

#pragma mark - lazzyLoad
- (JKTabBarController *)createRootTabBarController {
    JKLoginViewController          *firstVC  = [[JKLoginViewController alloc] init];
    JKBaseNavigationViewController *firstNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:firstVC];

    firstVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_icon_at"] selectedImage:[UIImage imageNamed:@"tabbar_icon_at_click"]];

    JKDemoViewController           *secondVC  = [[JKDemoViewController alloc] init];
    JKBaseNavigationViewController *secondNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:secondVC];
    secondVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"演示" image:[UIImage imageNamed:@"tabbar_icon_auth"] selectedImage:[UIImage imageNamed:@"tabbar_icon_auth_click"]];

    JKLoginViewController          *thirdVC  = [[JKLoginViewController alloc] init];
    JKBaseNavigationViewController *thirdNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:thirdVC];
    thirdVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_icon_space"] selectedImage:[UIImage imageNamed:@"tabbar_icon_space_click.png"]];

    JKLoginViewController          *fourthVC  = [[JKLoginViewController alloc] init];
    JKBaseNavigationViewController *fourthNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:fourthVC];
    fourthVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"tabbar_icon_more"] selectedImage:[UIImage imageNamed:@"tabbar_icon_more_click"]];

    // 加入tabBarController
    self.rootTabBarController       = [[JKTabBarController alloc] init];
    self.rootTabBarController.title = @"TabBarVC";

    self.rootTabBarController.viewControllers = [NSArray arrayWithObjects:firstNav, secondNav, thirdNav, fourthNav, nil];
    return self.rootTabBarController;
}

@end
