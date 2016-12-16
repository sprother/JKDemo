//
//  JKAppDelegate+MainUI.m
//  JKDemo
//
//  Created by jackyjiao on 12/7/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAppDelegate+MainUI.h"
#import "JKLoginViewController.h"
#import "JKFirstViewController.h"
#import "JKDemoViewController.h"
#import "JKFindViewController.h"
#import "JKMoreViewController.h"
#import "JKSplashViewController.h"

@implementation JKAppDelegate (MainUI)

#pragma mark - UI
- (void)showLoginViewAnimated:(BOOL)animated {
    JKLoginViewController *loginViewController = [[JKLoginViewController alloc] init];

    [self setRootViewController:loginViewController animated:animated];
}

- (void)showMainViewAnimated:(BOOL)animated {
    [self createRootTabBarController];
    [self setRootViewController:self.drawerViewController animated:animated];
}

- (void)showSplashViewAnimated:(BOOL)animated {
    JKSplashViewController *splashViewController = [[JKSplashViewController alloc] init];
    
    [self setRootViewController:splashViewController animated:animated];
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
    if (self.rootTabBarController) {
        return self.rootTabBarController;
    }
    JKFirstViewController          *firstVC  = [[JKFirstViewController alloc] init];
    JKBaseNavigationViewController *firstNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:firstVC];
    firstVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_icon_at"] selectedImage:[UIImage imageNamed:@"tabbar_icon_at_click"]];

    JKDemoViewController           *secondVC  = [[JKDemoViewController alloc] init];
    JKBaseNavigationViewController *secondNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:secondVC];
    secondVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"演示" image:[UIImage imageNamed:@"tabbar_icon_auth"] selectedImage:[UIImage imageNamed:@"tabbar_icon_auth_click"]];

    JKFindViewController          *thirdVC  = [[JKFindViewController alloc] init];
    JKBaseNavigationViewController *thirdNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:thirdVC];
    thirdVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_icon_space"] selectedImage:[UIImage imageNamed:@"tabbar_icon_space_click.png"]];

    JKMoreViewController          *fourthVC  = [[JKMoreViewController alloc] init];
    JKBaseNavigationViewController *fourthNav = [[JKBaseNavigationViewController alloc] initWithRootViewController:fourthVC];
    fourthVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"tabbar_icon_more"] selectedImage:[UIImage imageNamed:@"tabbar_icon_more_click"]];

    // 加入tabBarController
    self.rootTabBarController       = [[JKTabBarController alloc] init];
    self.rootTabBarController.title = @"TabBarVC";

    self.rootTabBarController.viewControllers = [NSArray arrayWithObjects:firstNav, secondNav, thirdNav, fourthNav, nil];
    [self.rootTabBarController setSelectedIndex:1];

//    //修改TabBarb的背景色的第二种方法
//    UIView *backView = [[UIView alloc] initWithFrame:self.rootTabBarController.tabBar.bounds];
//    backView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
//    [self.rootTabBarController.tabBar insertSubview:backView atIndex:0];
//    self.rootTabBarController.tabBar.opaque = YES;
    
    //修改TabBarb选中时的背景色
    CGSize indicatorImageSize = CGSizeMake(self.rootTabBarController.tabBar.bounds.size.width/self.rootTabBarController.tabBar.items.count, self.rootTabBarController.tabBar.bounds.size.height);
    self.rootTabBarController.tabBar.selectionIndicatorImage = [UIImage tc_imageWithColor:DEFAULT_BACKGROUND_COLOR size:indicatorImageSize];
    
    self.drawerViewController = [[DrawerViewController alloc] initWithSubvc:self.rootTabBarController];
    
    return self.rootTabBarController;
}

@end
