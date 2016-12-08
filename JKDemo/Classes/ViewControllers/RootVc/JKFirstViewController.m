//
//  JKFirstViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/8/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKFirstViewController.h"

@interface JKFirstViewController ()

@end

@implementation JKFirstViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title = @"首页";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
