//
//  JKFindViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/8/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKFindViewController.h"
#import "DMNumberPickerView.h"

@interface JKFindViewController ()

@property (nonatomic, strong) DMNumberPickerView *numberPickerView;

@end

@implementation JKFindViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title = @"发现";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = NO;
    [self.view addSubview:self.numberPickerView];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
    [super viewDidDisappear:animated];
}

#pragma mark - NumberPickerView
- (DMNumberPickerView *)numberPickerView {
    if (_numberPickerView == nil) {
        _numberPickerView = [[DMNumberPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.tcWidth, (106+0))
                                                         defaultValue:100
                                                             maxValue:300];
        _numberPickerView.backgroundColor = UIColorFromHex(0x24212d);
        _numberPickerView.delegate = nil;
        _numberPickerView.tcTop    = 10;
    }
    return _numberPickerView;
}


@end
