//
//  JKBaseViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/6/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKBaseViewController.h"

@interface JKBaseViewController ()

@end

@implementation JKBaseViewController

- (void)dealloc {
    JLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    JLog(@"%@ viewWillAppear", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    JLog(@"%@ viewDidAppear", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated {
    JLog(@"%@ viewWillDisappear", NSStringFromClass([self class]));
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    JLog(@"%@ viewDidDisappear", NSStringFromClass([self class]));
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
