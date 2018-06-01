//
//  AppDelegate.m
//  JKDemo
//
//  Created by jackyjiao on 12/6/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAppDelegate.h"
#import "JKAppDelegate+MainUI.h"
#import <JKSayHi.h>

#import "NSString+IMSDK.h"
#import "NSDictionary+Tencent.h"
#import "DMBLECentralManager.h"

#if defined(DEBUG)
#import "NSThread+Qstack.h"
#import "MainThreadWatchdog.h"
#endif

#import <TwitterKit/TwitterKit.h>

#import <objc/runtime.h>

#import "JKMemoTest.h"


void getClassInfo(NSString* className) {
    const char * cClassName = [className UTF8String];
    
    id classM = objc_getClass(cClassName);
    if (!classM) {
        return;
    }
    unsigned int outProptyCount, outMethodCount, outIvarCount, outProtocolCount, i;
    objc_property_t * properties = class_copyPropertyList(classM, &outProptyCount);
    Method *methods = class_copyMethodList(classM, &outMethodCount);
    Ivar *ivars = class_copyIvarList(classM, &outIvarCount);
    Protocol *__unsafe_unretained*protocols = class_copyProtocolList(classM, &outProtocolCount);
    
    NSLog(@"CaptainHook: hook %@ ; outProptyCount = %ud, outMethodCount = %ud, outIvarCount = %ud, outProtocolCount = %ud .", className, outProptyCount, outMethodCount, outIvarCount, outProtocolCount);
    //
    for (i = 0; i < outProptyCount; i++) {
        objc_property_t property = properties[i];
        // 获得属性名称
        NSString * attributeName = [NSString stringWithUTF8String:property_getName(property)];
        NSLog(@"CaptainHook: property %ud : %@ .",i, attributeName);
    }
    
    for (i = 0; i < outMethodCount; i++) {
        Method method = methods[i];
        // 获得方法名称
        NSString * attributeName = NSStringFromSelector(method_getName(method));
        NSLog(@"CaptainHook: method %ud : %@ .",i, attributeName);
    }
    
    for (i = 0; i < outIvarCount; i++) {
        Ivar ivar = ivars[i];
        // 获得变量名称
        NSString * attributeName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"CaptainHook: ivar %ud : %@ .",i, attributeName);
    }
    
    for (i = 0; i < outProtocolCount; i++) {
        Protocol *protocol = protocols[i];
        // 获得协议名称
        NSString * attributeName = [NSString stringWithUTF8String:protocol_getName(protocol)];
        NSLog(@"CaptainHook: protocol %ud : %@ .",i, attributeName);
    }
}

@interface JKAppDelegate ()

@end

@implementation JKAppDelegate

+ (JKAppDelegate *)shareInstance; {
    return (JKAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    getClassInfo(@"Twitter");
    //其他初始化
    [[Twitter sharedInstance] startWithConsumerKey:@"D9Qhy7jWIxjVKKLBnfw78RSt9" consumerSecret:@"6O3Ag0EAdFQJLlY3GDbneTWeXooQBepYC8Z8a8nebfc4iQn66j"];
    
    [[[JKSayHi alloc] init] speek];
    self.window                 = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColorFromHex(0xffffff);
    [self.window makeKeyAndVisible];
    [self configModules];
    [self configCommonUI];
    [self showMainViewAnimated:NO];
    [self testFunction];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    JLog(@"openURL:(%@) annotation:(%@)", url, annotation);
    JLog(@"params:(%@)", [[url query] parseURLParams]);
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary*)options {
    JLog(@"openURL:(%@) options:(%@)", url, options);
    JLog(@"scheme:%@", url.scheme);
    JLog(@"host:%@", url.host);
    JLog(@"port:%@", url.port);
    JLog(@"path:%@", url.path);
    JLog(@"query:%@", url.query);
    [[Twitter sharedInstance] application:app openURL:url options:options];
    return YES;
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
    //[NSThread saveMethodDict];
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

#pragma mark - testFunction
- (void)testFunction {
    //测试邮件合法验证
    NSString *str = @"hellos%1-+df_h.he@q.-q.com";
    JLog(@"==testFunction==%@ is %@valid Email.", str, [str isValidEmail]? @"" : @"not ");
    
    //测试字典与json字符串互转
    NSDictionary *dict = @{@"通用功能":@[@"是否登录",@"渠道是否安装／是否支持",@"注销登录",@"得到登录信息",@"检查和登录",@"快速登录",@"得到绑定信息",@"自动登录"],
                           @"Facebook":@[@"登录",@"绑定"],
                           @"WeChat":@[@"登录",@"绑定"],
                           @"GameCenter":@[@"登录",@"绑定",@"loadFriends",@"reportScore",@"loadLeaderboard",@"showLeaderboard",@"reportAchivement",@"loadArchivement",@"showArchivement"],
                           @"Guest":@[@"登录",@"绑定"],
                           @"Link":@[@"登录",@"快速登录",@"查询连接状态",@"删除帐户",@"Connect SNS",@"Restore SNS",@"Connect&Restore GameCenter"],
                           @"Garena":@[@"登录Garena Gas",@"登录Garena BeeTalk",@"登录Garena Guest",@"登录Facebook",@"Garena Guest 绑定 Garena Gas",@"Garena Guest 绑定 Facebook",@"获取mshop URL", @"打开mshop"],
                           @"VK":@[@"登录",@"绑定"],
                           @"Toy":@[@"Toy登入",@"Toy extend",@"Toy Bind"],
                           @"Efun":@[@"Efun登入",@"EfunExtend"],
                           @"Kakao":@[@"登录",@"绑定",@"获取kakao个人信息",@"获取个人游戏信息",@"修改用户数据",@"查询是否kakao-story",@"发story",@"获取未加入游戏好友",@"获取加入游戏的好友",@"获取聊天群",@"解绑"],
                           @"新鉴权模式":@[@"auth",@"conncet Facebook",@"connect GameCenter", @"reconnect",@"restore",@"recover from Facebook", @"recover from GameCenter",@"getMigrateCode",@"migrate",@"getMigrateInfo",@"disconnect Facebook",@"disconnect GameCenter", @"deleteDeviceAccount",@"deleteAllAccount",@"getAuthResult",@"getConnectInfo",@"Signout FB",@"Signout GC", @"SendCode", @"BindConnect", @"BindRecover"],
                           @"Stove":@[@"initialize",@"Login",@"logout",@"CheckAndLogin",@"launchUI_1",@"launchUI_2",@"launchUI_3",@"get config",@"set push yes",@"set push no",@"get push"],
                           @"Netmarble":@[@"initialize",@"showTerms",@"Login",@"Connect Kakao",@"Disconnect Kakao", @"unRegisterKakao", @"resetsession",@"requestMyProfile",@"getFriends",@"inviteFriends",@"sendMeassge",@"postStory",@"sendMessage With image",@"设置消息屏蔽"]};
    NSString *jsonString = [dict toJsonString];
    JLog(@"==testFunction==dict toJsonString:%@", jsonString);
    NSDictionary *dict2 = [NSDictionary fromString:jsonString];
    JLog(@"==testFunction==dict fromString is:%@", dict2);//默认的description是输出Unicode编码
    
    //test消息转发
    JKAppDelegate *dele = (JKAppDelegate *)str;
    [dele configCommonUI];
    
    NSString *aesStr = @"easingboy@qq.com";
    NSString *aesEncode = [aesStr aes128_encrypt:@"a5c860746110df01"];
    NSString *aesDecode = [aesEncode aes128_decrypt:@"a5c860746110df01"];
    JLog(@"====%@ aes128_encrypt is %@, aes128_decrypt is %@.", aesStr, aesEncode, aesDecode);
    
    NSString *password = @"a@1#1$1%1^1&1*2+3/4=5.6!7?8-9_2(6)7a-aa$zA1111!5@4#3$5%44^5&6*6(66)4v+66=v/v?v-v.v_v1Z222<11>11,11.11:11;11|1222[]";//@#$%^&*+/=!?-_()
    //NSString *codeRegex = @"[a-zA-Z0-9!@#$%^&*()+=/?-_<>,.:;|]+";//!@#$%^&*()+=-_/?<>,.:;|
      NSString *codeRegex = @"[a-zA-Z0-9!@#$%^&*()+=/?\\-_<>,.:;|]*";


    NSPredicate *codePred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", codeRegex];
    BOOL valid = [codePred evaluateWithObject:password];
    JLog(@"%@ validcheck %@", password, valid?@"YES":@"NO");
    
//    Class deleClass = NSClassFromString(@"NSString");
//    [deleClass shareInstance];
//    DMBLECentralManager *manger = nil;
//    manger = [DMBLECentralManager sharedManager];
//    JLog(@"[DMBLECentralManager sharedManager]1 :%@", manger);
//    manger = [[DMBLECentralManager alloc] init];
//    JLog(@"[[DMBLECentralManager alloc] init] :%@", manger);
//    manger = [DMBLECentralManager new];
//    JLog(@"[DMBLECentralManager sharedManager]2 :%@", manger);
//
//    NSString *errorMsg = @"error params(bindType), must be 1 or 2";
//    NSError* _error = [NSError errorWithDomain:errorMsg code:-1 userInfo:@{ NSLocalizedDescriptionKey : errorMsg }];
//    
//    JLog(@"===%@===", _error.localizedDescription);
    
    double timestamp = CFAbsoluteTimeGetCurrent();
    double timestamp2 = (int)[[NSDate date] timeIntervalSince1970];
    
    NSString *urlString = @"http://www.qq.com:80/news/recent?name=testName&roomId=1001";
    NSURL *url = [NSURL URLWithString:urlString];
    JLog(@"scheme:%@", url.scheme);
    JLog(@"host:%@", url.host);
    JLog(@"port:%@", url.port);
    JLog(@"path:%@", url.path);
    JLog(@"query:%@", url.query);
    
    //
    //[[JKMemoTest sharedInstance] start];
    
}


@end



