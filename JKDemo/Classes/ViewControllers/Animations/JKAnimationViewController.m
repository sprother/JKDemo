//
//  JKAnimationViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAnimationViewController.h"
#import "JKRunTrackView.h"
#import "JKEllipseView.h"
#import "JKEllipseLineView.h"
#import "DMScanCircleView.h"

@interface JKAnimationViewController () 

@property (nonatomic, strong) JKRunTrackView *runTrackView;
@property (nonatomic, strong) JKEllipseView  *ellipseView;
@property (nonatomic, strong) JKEllipseLineView  *ellipseLineView;
@property (nonatomic, strong) DMScanCircleView  *circleView;

@end

@implementation JKAnimationViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"动画";
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.runTrackView];
//    [self.runTrackView startAnimation];
    
//    [self.view addSubview:self.ellipseView];
    
//    [self.view addSubview:self.ellipseLineView];
    
    [self.view addSubview:self.circleView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//
}

#pragma mark - ui getter
- (JKRunTrackView *)runTrackView {
    if (_runTrackView == nil) {
        _runTrackView = [[JKRunTrackView alloc] init];
        _runTrackView.tcTop = 350;
    }
    return _runTrackView;
}

- (JKEllipseView *)ellipseView {
    if (_ellipseView == nil) {
        _ellipseView = [[JKEllipseView alloc] initWithFrame:CGRectMake(0, 300, APPLICATION_SCREEN_WIDTH, 200)];
    }
    return _ellipseView;
}

- (JKEllipseLineView *)ellipseLineView {
    if (_ellipseLineView == nil) {
        _ellipseLineView = [[JKEllipseLineView alloc] initWithFrame:CGRectMake(0, 300, APPLICATION_SCREEN_WIDTH, 200)];
    }
    return _ellipseLineView;
}

- (DMScanCircleView *)circleView {
    if (_circleView == nil) {
        _circleView = [[DMScanCircleView alloc] initWithFrame:CGRectMake(0, 300, 204, 204)];
        _circleView.tcCenterX = self.view.tcCenterX;
    }
    return _circleView;
}

@end
