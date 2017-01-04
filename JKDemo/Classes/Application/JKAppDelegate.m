//
//  AppDelegate.m
//  JKDemo
//
//  Created by jackyjiao on 12/6/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAppDelegate.h"
#import "JKAppDelegate+MainUI.h"

#if defined(DEBUG)
#import "NSThread+Qstack.h"
#import "MainThreadWatchdog.h"
#endif


@interface JKAppDelegate ()

@end

@implementation JKAppDelegate

+ (JKAppDelegate *)shareInstance; {
    return (JKAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    JLog(@"程序开始, launchOptions=%@", launchOptions);
    self.window                 = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColorFromHex(0xffffff);
    [self.window makeKeyAndVisible];
    [self configModules];
    [self configCommonUI];
    [self showMainViewAnimated:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    JLog(@"程序暂停");
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    JLog(@"程序 applicationDidFinishLaunching");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    JLog(@"程序将进入后台");
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
                       JLog(@"程序已进入后台");
                       [app endBackgroundTask:self.bgTask];
                       self.bgTask = UIBackgroundTaskInvalid;
                   }];
    if (self.bgTask == UIBackgroundTaskInvalid) {
        JLog(@"**********后台任务开启失败!");
        return;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    JLog(@"程序进入前台");
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (self.bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    JLog(@"程序再次激活");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    JLog(@"程序意外终止");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    JLog(@"程序收到内存警告");
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification {
    //这里处理通知消息，在前台直接处理，在后台则点击到前台后执行这里；做相应提示或者跳转
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到本地的通知" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    NSDictionary* dic = [[NSDictionary alloc] init];
    
    dic = notification.userInfo;
    JLog(@"application收到本地消息 user info = %@",[dic objectForKey:@"key"]);
}

#pragma mark - UI
- (void)configCommonUI {
    [self configNavigationBar];
    [self configTabBar];
}

- (void)configNavigationBar {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    //方法一，会占位(变透明后不占位)，影响UISearchController/UITableView等
//    UIImage *image = [UIImage tc_imageWithColor:UIColorFromHex(0x303030) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, DEFAULT_NAVIGATION_BAR_HEIGHT)];
//    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    //方法二，不会占位，但不能设置成透明
//    [[UINavigationBar appearance] setBarTintColor:UIColorFromHex(0x303030)];
//    [UINavigationBar appearance].translucent = NO;//需要设置translucent为NO，否则因为半透明颜色会变
    //方法三，透明颜色，不会占位，(能设置成透明)
    UIImage *image = [UIImage tc_imageWithColor:UIColorFromRgbAlpha(0x303030, 254) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, DEFAULT_NAVIGATION_BAR_HEIGHT)];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromHex(0xFFFFFF), NSFontAttributeName: DEFAULT_FONT(20)}];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage tc_imageWithColor:UIColorFromRgbAlpha(0x000000, 0) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, 1)]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)configTabBar {
    //修改TabBarb的背景色的第一种方法
    //不要使用  [[UITabBar appearance] setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [[UITabBar appearance] setBarTintColor:DEFAULT_BACKGROUND_COLOR];
    [UITabBar appearance].translucent = NO;
}

- (void)configModules {
#if defined(DEBUG)
    [NSThread saveMethodDict];
    // Watchdog
    [[MainThreadWatchdog sharedWatchdog] startWithHandler:^{
        JLog(@"好像有点卡...");
    }];
#endif
    

}

#pragma mark - Service Push
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    JLog(@"程序执行Background Fetch.");
    NSURL        *url           = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request       = [NSURLRequest requestWithURL:url];
    NSURLSession *updateSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    [updateSession dataTaskWithRequest:request
                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         NSDictionary *messageInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSLog(@"messageInfo:%@", messageInfo);
         completionHandler(UIBackgroundFetchResultNewData);
     }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    JLog(@"程序接收到Remote Notification.");
}

@end
