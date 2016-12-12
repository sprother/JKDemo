//
//  AppDelegate.h
//  JKDemo
//
//  Created by jackyjiao on 12/6/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKBaseNavigationViewController.h"
#import "JKTabBarController.h"
#import "DrawerViewController.h"

@interface JKAppDelegate : UIResponder <UIApplicationDelegate>
+ (JKAppDelegate *)shareInstance;

@property (nonatomic, strong) UIWindow                              *window;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic, strong) JKTabBarController                    *rootTabBarController;
@property (nonatomic, strong) DrawerViewController                  *drawerViewController;

@end

