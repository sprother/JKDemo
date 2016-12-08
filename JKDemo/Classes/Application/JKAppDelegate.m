//
//  AppDelegate.m
//  JKDemo
//
//  Created by jackyjiao on 12/6/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAppDelegate.h"
#import "JKAppDelegate+MainUI.h"

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

#pragma mark - UI
- (void)configCommonUI {
    UIImage *image = [UIImage tc_imageWithColor:UIColorFromHex(0x303030) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, DEFAULT_NAVIGATION_BAR_HEIGHT)];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromHex(0xFFFFFF), NSFontAttributeName: DEFAULT_FONT(20)}];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage tc_imageWithColor:UIColorFromRgbAlpha(0x000000, 0) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, 1)]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
