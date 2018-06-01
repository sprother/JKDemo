//
//  JKWebViewController.m
//  JKDemo
//
//  Created by jackyjiao on 2018/6/1.
//  Copyright © 2018年 jackyjiao. All rights reserved.
//

#import "JKWebViewController.h"

@interface JKWebViewController ()

@property (nonatomic, strong) UIBarButtonItem *rightBtn;

@end

@implementation JKWebViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"网页11";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.rightBtn;
}

- (void)dealloc {
    JLog(@"JKWebViewController dealloc!!");
}

- (UIBarButtonItem *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target: self  action:@selector(close:)];
    }
    return _rightBtn;
}

- (void)close:(id)sender {
    JLog(@"close btn clicked");
    [self dismissViewControllerAnimated:YES completion:^{
        JLog(@"dismissViewControllerAnimated finished");
    }];
}

@end
