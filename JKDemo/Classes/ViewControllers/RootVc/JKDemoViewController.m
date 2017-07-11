//
//  JKDemoViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/8/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAppDelegate+MainUI.h"
#import "JKDemoViewController.h"
#import "JKTableViewCell.h"
#import "ImageCollectViewController.h"
#import "JKAnimationViewController.h"
#import "JKVideoViewController.h"
#import "DMPullToRefreshControl.h"
#import "PeriListViewController.h"
#import <FLEX/FLEXManager.h>
#import "IMSDKUIClient.h"
#import <MessageUI/MessageUI.h>

#define ROW_NAME_SCAN_BLE   @"扫描BLE周边"
#define ROW_NAME_SCAN_MFI   @"扫描MFI"

#define ROW_NAME_CALC       @"计算器"
#define ROW_NAME_ANIMATION  @"动画"
#define ROW_NAME_PHOTOS     @"相册"

#define ROW_NAME_SPLASH     @"闪屏引导"
#define ROW_NAME_LOGOUT     @"退出登录"
#define ROW_NAME_GEN_NOTIFY @"产生ANCS通知"
#define ROW_NAME_FLEX       @"FLEX"

#define ROW_NAME_VIDEO      @"视频"
#define ROW_NAME_NET        @"访问网络"
#define ROW_NAME_SHAREW     @"分享到whatsapp"
#define ROW_NAME_SHAREL     @"分享到Line"
#define ROW_NAME_SHAREE     @"分享到Email"
#define ROW_NAME_SHAREM     @"分享到iMessage"
#define ROW_NAME_NONE       @"其他"

int UICmdIndex = 0;

@interface JKDemoViewController () <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, copy) NSArray <NSArray *> *dataSource;

@property (nonatomic, strong) DMPullToRefreshControl *refreshControl;

@property (nonatomic, assign) BOOL isNavInvisible;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation JKDemoViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"工具";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = NO;
    [self buildDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
    [self resetNavColor];
    [super viewDidDisappear:animated];
}

#pragma mark - DataSource
- (void)buildDataSource {
//    [immutableObject copy] // 浅复制，copy得到不可变对象 (immutableObject比如NSObject)
//    [immutableObject mutableCopy] //深复制，mutableCopy得到可变对象
//    [mutableObject copy] //深复制，copy得到不可变对象 (mutableObject比如NSString)
//    [mutableObject mutableCopy] //深复制,对于容器类里面的内容，拷贝的都是指针
    NSMutableArray *mDataSource       = [NSMutableArray array];
    NSArray        *sectionDataSource = nil;

    sectionDataSource = [NSArray arrayWithObjects:ROW_NAME_SCAN_BLE, ROW_NAME_SCAN_MFI, nil];
    [mDataSource addObject:sectionDataSource];

    sectionDataSource = [NSArray arrayWithObjects:ROW_NAME_CALC, ROW_NAME_ANIMATION, ROW_NAME_PHOTOS, nil];
    [mDataSource addObject:sectionDataSource];

    sectionDataSource = [NSArray arrayWithObjects:ROW_NAME_SPLASH, ROW_NAME_LOGOUT, ROW_NAME_GEN_NOTIFY, ROW_NAME_FLEX, nil];
    [mDataSource addObject:sectionDataSource];
    
    sectionDataSource = [NSArray arrayWithObjects:ROW_NAME_VIDEO, ROW_NAME_NET, ROW_NAME_SHAREW, ROW_NAME_SHAREL, ROW_NAME_SHAREE, ROW_NAME_SHAREM, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, ROW_NAME_NONE, nil];
    [mDataSource addObject:sectionDataSource];

    self.dataSource = mDataSource;
}

#pragma mark - views' getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SCREEN_WIDTH, APPLICATION_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        //[_tableView setSeparatorColor:UIColorFromHex(0xE0E0E0)];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, DEFAULT_PADDING_LEFT, 0, 0)];
        [_tableView setContentInset:UIEdgeInsetsMake(DEFAULT_NAVIGATION_BAR_HEIGHT, 0, 0, 0)];
        [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(DEFAULT_NAVIGATION_BAR_HEIGHT, 0, 0, 0)];
        
        [_tableView addSubview:self.refreshControl];
    }
    return _tableView;
}

#pragma mark TableView header
//TableView layoutSubviews时会执行reloadData
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DEFAULT_TABLE_VIEW_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DEFAULT_TABLE_VIEW_FOOTER_HEIGHT;
}

#pragma mark TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = NSStringFromClass([self class]);

    JKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[JKTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    NSString *cellName = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text  = cellName;
    cell.imageView.image = [UIImage tc_imageWithColor:RANDOM_COLOR size:CGSizeMake(30, 30)];

    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_TABLE_VIEW_ROW_HEIGHT;
}

#pragma mark - click
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    //该方法响应列表中行的点击事件
    NSString *rowName = self.dataSource[indexPath.section][indexPath.row];
    if ([rowName isEqualToString:ROW_NAME_SCAN_BLE]) {
        PeriListViewController *vc = [[PeriListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([rowName isEqualToString:ROW_NAME_SCAN_MFI]) {
    } else if ([rowName isEqualToString:ROW_NAME_CALC]) {
    } else if ([rowName isEqualToString:ROW_NAME_ANIMATION]) {
        JKAnimationViewController *vc = [[JKAnimationViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([rowName isEqualToString:ROW_NAME_PHOTOS]) {
        ImageCollectViewController *vc = [[ImageCollectViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([rowName isEqualToString:ROW_NAME_LOGOUT]) {
        [[JKAppDelegate shareInstance] showLoginViewAnimated:NO];
    } else if ([rowName isEqualToString:ROW_NAME_SPLASH]) {
        [[JKAppDelegate shareInstance] showSplashViewAnimated:NO];
    } else if ([rowName isEqualToString:ROW_NAME_GEN_NOTIFY]) {
        [self genNotify:@"你有一条没有用的新消息。"];
    } else if ([rowName isEqualToString:ROW_NAME_FLEX]) {
        if ([FLEXManager sharedManager].isHidden) {
            [[FLEXManager sharedManager] showExplorer];
        } else {
            [[FLEXManager sharedManager] hideExplorer];
        }
    } else if ([rowName isEqualToString:ROW_NAME_VIDEO]) {
        JKVideoViewController *vc = [[JKVideoViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([rowName isEqualToString:ROW_NAME_NET]) {
        [self uicontrol];
    } else if ([rowName isEqualToString:ROW_NAME_SHAREW]) {
        NSString *msg = @"HelloWorld! jkdemo://?name=jackyw&phone=13988888888";
        msg = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)msg, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
        NSString *urlString = [NSString stringWithFormat:@"whatsapp://send?text=%@", msg];
        NSURL *url = [NSURL URLWithString:urlString];
        //        if ([[UIApplication sharedApplication] canOpenURL:url]) {
        //            [[UIApplication sharedApplication] openURL:url];
        //        }
        //        [[UIApplication sharedApplication] openURL:url];
        
        [[UIApplication sharedApplication] openURL:url options:@{@"key":@"value"} completionHandler:^(BOOL success) {
            JLog(@"===success %d", success);
        }];
        
        
        //        NSString *savePath = [[NSBundle mainBundle] pathForResource:@"tabbar_icon_at@2x" ofType:@"png"];;
        //
        //        UIDocumentInteractionController *controller = [UIDocumentInteractionController new];
        //        controller.name = @"hello";
        //        controller.UTI = @"public.plain-text";
        //
        //        [controller presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        //        self.documentInteractionController = controller;
        
    } else if ([rowName isEqualToString:ROW_NAME_SHAREL]) {
        NSString *msg = @"HelloWorld! jkdemo://?name=jackyL&phone=13988888888 哈哈";
        msg = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)msg, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
        NSString *urlString = [NSString stringWithFormat:@"line://msg/text/%@", msg];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [[UIApplication sharedApplication] openURL:url options:@{@"key":@"value"} completionHandler:^(BOOL success) {
            JLog(@"===success %d", success);
        }];
    } else if ([rowName isEqualToString:ROW_NAME_SHAREE]) {
        [self sendEmail];
    } else if ([rowName isEqualToString:ROW_NAME_SHAREM]) {
        [self sendMessage];
    } else {
    }
}

- (void)sendMessage {
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    //判断是否有短信功能
    if (messageClass == nil) {
        //有发送功能要做的事情
        JLog(@"MFMessageComposeViewController is nil");
        return;
    }
    if (![messageClass canSendText]) {
        JLog(@"MFMessageComposeViewController can NOT SendText.");
        return;
    }
    //实例化MFMessageComposeViewController,并设置委托
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    //拼接并设置短信内容
    NSString *messageContent = @"HelloWorld! jkdemo://?name=jackym&phone=13888888888";
    messageController.body = messageContent;
    //设置发送给谁
    messageController.recipients = @[];
    //推到发送试图控制器
    //UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentViewController:messageController animated:YES completion:^{}];
}

- (void)sendEmail {
    Class emailClass = (NSClassFromString(@"MFMailComposeViewController"));
    //判断是否有email功能
    if (emailClass == nil) {
        //有发送功能要做的事情
        JLog(@"MFMailComposeViewController is nil");
        return;
    }
    if (![emailClass canSendMail]) {
        JLog(@"用户没有设置邮件账户");
        return;
    }
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"eMail主题"];
//    //添加收件人
//    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
//    [mailPicker setToRecipients: toRecipients];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailPicker setCcRecipients:ccRecipients];
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailPicker setBccRecipients:bccRecipients];
    
//    // 添加一张图片
//    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
//    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
//    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
//    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
//    
//    //添加一个pdf附件
//    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
    NSString *emailBody = @"正文:HelloWorld! jkdemo://?name=jackyL&phone=13988888888 哈哈";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:^{JLog(@"email presentViewController");}];
}

//通过openUrl发邮件
-(void)sendMailByOpenUrl {
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"easingboy@qq.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];//注意这里的mailto:
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:@"?&subject=EmailTitle"];//注意这里的?
    //添加邮件内容
    [mailUrl appendString:@"&body=email_body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSString *tipContent;
    switch (result) {
        case MessageComposeResultCancelled:
            tipContent = @"发送短信已取消";
            break;
        case MessageComposeResultFailed:
            tipContent = @"发送短信失败";
            break;
        case MessageComposeResultSent:
            tipContent = @"发送成功";
            break;
        default:
            break;
    }
    JLog(@"%@, didFinishWithResult %ld.", tipContent, (long)result);
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:^{JLog(@"email dismissViewController");}];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    JLog(@"%@", msg);
}

- (void)uicontrol {
    UICmdIndex++;
    if (UICmdIndex == 1) {
        [[[IMSDKUIClient alloc] init] fetchSessionWithCallback:^(IMSDKUISession *session, NSError *error) {
            NSLog(@"error %@", error);
        }];
        return;
    }
    if (UICmdIndex == 2) {
        [[[IMSDKUIClient alloc] init] createSessionWithBundleId:@"com.tencent.xin" withCallback:^(IMSDKUISession *session, NSError *error) {
            NSLog(@"error %@", error);
            [session tapElementByXpath:@"//XCUIElementTypeButton[@name='登录']" withCallback:^(BOOL success, NSError *error) {
                NSLog(@"error %@", error);
            }];
        }];
        return;
    }
    if (UICmdIndex == 3) {
        [[[IMSDKUIClient alloc] init] clickHomeWithCallback:^(BOOL success, NSError *error) {
            NSLog(@"error %@", error);
        }];
        UICmdIndex = 0;
        return;
    }
    if (UICmdIndex == 4) {
        return;
    }
    if (UICmdIndex == 5) {
        return;
    }
    if (UICmdIndex == 6) {
        return;
    }
}

#pragma mark - longClick
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && indexPath.row == 0;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return indexPath.section == 0 && indexPath.row == 0;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(cut:)){

    } else if(action == @selector(copy:)){

    } else if(action == @selector(paste:)){

    } else if(action == @selector(select:)){

    } else if(action == @selector(selectAll:)){

    } else  {

    }
}

#pragma mark - leftSlide
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        // 从数据源中删除
        NSMutableArray *mDataSource = [self.dataSource mutableCopy];
        NSMutableArray *mSectionData = [mDataSource[indexPath.section] mutableCopy];
        [mSectionData removeObjectAtIndex:indexPath.row];
        [mDataSource[indexPath.section] = mSectionData copy];
        self.dataSource = mDataSource;
        // 从列表中删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Loacal Notify
- (void)genNotify:(NSString *)info {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification != nil) {
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:4]; //触发通知的时间
        notification.repeatInterval = 0; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = info;
        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        //下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}


#pragma mark - hideNavigation
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if(velocity.y > 0) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    } else {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//}

#pragma mark - refreshControl
- (DMPullToRefreshControl *)refreshControl {
    if (_refreshControl == nil) {
        _refreshControl =  [[DMPullToRefreshControl alloc] initWithFrame:CGRectMake(0, -24, 24, 24)];
        _refreshControl.tcCenterX = _tableView.tcCenterX;
    }
    return _refreshControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y + DEFAULT_NAVIGATION_BAR_HEIGHT;
    if(offset > 0 && offset < DEFAULT_NAVIGATION_BAR_HEIGHT) {
        UIImage *bgImage = [UIImage tc_imageWithColor:UIColorFromRgbFloatAlpha(0x303030, 1.0-offset/DEFAULT_NAVIGATION_BAR_HEIGHT) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, DEFAULT_NAVIGATION_BAR_HEIGHT)];
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.isNavInvisible = YES;
        return;
    }
    if (offset >= DEFAULT_NAVIGATION_BAR_HEIGHT) {
        if (self.isNavInvisible) {
            return;
        }
        UIImage *bgImage = [UIImage tc_imageWithColor:UIColorFromRgbAlpha(0x303030, 0) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, DEFAULT_NAVIGATION_BAR_HEIGHT)];
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.isNavInvisible = YES;
    }
    if (!self.isNavInvisible) {
        return;
    }
    [self resetNavColor];
}

- (void)resetNavColor {
    UIImage *bgImage = [UIImage tc_imageWithColor:UIColorFromRgbAlpha(0x303030, 254) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, DEFAULT_NAVIGATION_BAR_HEIGHT)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.isNavInvisible = NO;
}

@end
