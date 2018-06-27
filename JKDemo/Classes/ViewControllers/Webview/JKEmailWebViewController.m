//
//  JKEmailWebViewController.m
//  JKDemo
//
//  Created by jackyjiao on 2018/5/30.
//  Copyright © 2018年 jackyjiao. All rights reserved.
//

#import "JKEmailWebViewController.h"
#import <WebKit/WebKit.h>

@interface JKEmailWebViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, strong) UIBarButtonItem *leftBtn;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation JKEmailWebViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"网页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.webView];

    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"login_test" withExtension:@"html"];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLayoutSubviews {
    JLog(@"viewDidLayoutSubviews");
    [super viewDidLayoutSubviews];
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    CGRect rect = self.view.frame;
//    CGFloat height = CGRectGetHeight(rect);
//    CGFloat width  = CGRectGetWidth(rect);
//
//    CGRect webRect = self.webView.frame;
//    CGFloat webY = CGRectGetMinY(webRect);
//    CGFloat webHeight = CGRectGetHeight(webRect);
//    CGFloat webWidth  = CGRectGetWidth(webRect);
//    if (UIInterfaceOrientationIsPortrait(orientation)) {
//        self.webView.frame = CGRectMake(0, webY, webWidth, webHeight);
//        self.view.frame = CGRectMake(0, 0, width, height);
//        [self.webView reload];
//    } else {
//        self.webView.frame = CGRectMake(0, webY, webHeight, webWidth);
//        self.view.frame = CGRectMake(0, 0, height, width);
//        [self.webView reload];
//    }
//
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
}

#pragma mark - views
- (UIBarButtonItem *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target: self  action:@selector(close:)];
    }
    return _rightBtn;
}

- (UIBarButtonItem *)leftBtn {
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target: self  action:@selector(back:)];
        [_leftBtn setEnabled:NO];
    }
    return _leftBtn;
}

- (void)close:(id)sender {
    JLog(@"close btn clicked");
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"IMSDKEmailOnToken"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"IMSDKEmailShowMessage"];
    [self dismissViewControllerAnimated:YES completion:^{
        JLog(@"dismissViewControllerAnimated finished");
    }];
//    //native执行js代码
//    [self.webView evaluateJavaScript:@"testNativeInvoke('testMessage')" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
//        JLog(@"evaluateJavaScript data=%@, error=%@", data, error);
//    }];
}

- (void)back:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}



- (WKWebViewConfiguration *)config {
    if (_config == nil) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.userContentController = [[WKUserContentController alloc] init];
        [_config.userContentController addScriptMessageHandler:self name:@"IMSDKEmailOnToken"];
        [_config.userContentController addScriptMessageHandler:self name:@"IMSDKEmailShowMessage"];
    }
    return _config;
}

- (UIProgressView *)progressView {
    if (_progressView == nil) {
        //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，然并卵-->>几乎无区别
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
        _progressView.frame = CGRectMake(0, DEFAULT_NAVIGATION_BAR_HEIGHT, APPLICATION_SCREEN_WIDTH, 20);
        //设置进度条颜色
        _progressView.trackTintColor = [UIColor whiteColor];
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        _progressView.progress = 0.0;
        _progressView.alpha = 0.0;
        //设置进度条上进度的颜色
        _progressView.progressTintColor = [UIColor grayColor];
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, DEFAULT_NAVIGATION_BAR_HEIGHT, APPLICATION_SCREEN_WIDTH, APPLICATION_SCREEN_HEIGHT - DEFAULT_NAVIGATION_BAR_HEIGHT) configuration:self.config];
        [_webView setOpaque:NO];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_webView setMultipleTouchEnabled:YES];
        [_webView setAutoresizesSubviews:YES];
        //
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object != self.webView) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    } else {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            if (self.webView.estimatedProgress > self.progressView.progress ) {
                [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            }
        } else if ([keyPath isEqualToString:@"title"]) {
            self.title = self.webView.title;
        } else if ([keyPath isEqualToString:@"canGoBack"]) {
            [self.leftBtn setEnabled:[[change valueForKey:NSKeyValueChangeNewKey] boolValue]];
        } else {
            NSLog(@"error keyPath = %@", keyPath);
        }
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"didReceiveScriptMessage message.name = %@, message.body = %@, message.body.type = %@, ", message.name, message.body, NSStringFromClass([message.body class]));
    if ([message.name isEqualToString:@"IMSDKEmailOnToken"]) {
        NSLog(@"%@", message.body);
        [self close:nil];
        return;
    }
    if ([message.name isEqualToString:@"IMSDKEmailShowMessager"]) {
        NSLog(@"IMSDKEmailShowMessager %@", message.body);
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"webView didStartProvisionalNavigation");
    self.progressView.alpha = 1.0f;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"webView didCommitNavigation");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"webView didFinishNavigation");
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_progressView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [_progressView setProgress:0.0f animated:NO];
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"webView didFailProvisionalNavigation");
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"webView didReceiveServerRedirectForProvisionalNavigation");
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"decidePolicyForNavigationResponse %@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"decidePolicyForNavigationAction %@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSLog(@"WKUIDelegate webView createWebViewWithConfiguration");
    return [[WKWebView alloc] init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"WKUIDelegate webView runJavaScriptTextInputPanelWithPrompt");
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"WKUIDelegate webView runJavaScriptConfirmPanelWithMessage");
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"runJavaScriptAlertPanelWithMessage %@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {completionHandler();}];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
