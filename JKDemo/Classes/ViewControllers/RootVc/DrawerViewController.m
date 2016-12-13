//
//  DrawerViewController.m
//  TabDemo
//
//  Created by jackyjiao on 6/15/15.
//  Copyright (c) 2015 jackyjiao. All rights reserved.
//

#import "DrawerViewController.h"
#import "JKAssitPointView.h"

#define SLIDE_OUT_MAX 210

@interface DrawerViewController () <UIGestureRecognizerDelegate>
{//这种定义方法需要改进
    UIViewController       *_subVC;
    UIView                 *_bgView;
    CGFloat                _distance;
    BOOL                   _slideIn;
    BOOL                   _slideOutFinish;
    UITapGestureRecognizer *_oneTapGestureReognizer;
}

@property (nonatomic, strong) JKAssitPointView *myAssit;

@end

@implementation DrawerViewController

- (id)initWithSubvc:(UIViewController *)vc {
    if (self = [super init]) {
        _subVC                  = vc;
        _distance               = 0;
        _slideOutFinish         = NO;
        _slideIn                = YES;
        _oneTapGestureReognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapGestureRecognizer:)];
    }
    return self;
}

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"容器";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bgView                 = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = UIColorFromHex(0x24212d);
    _bgView.alpha           = 1.0;

    [self.view addSubview:_bgView];
    [self.view addSubview:_subVC.view];

    //增加侧滑响应
    UIPanGestureRecognizer *myPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureTriggered:)];
    myPanGesture.delegate = self;
    [_subVC.view addGestureRecognizer:myPanGesture];
}

#pragma mark - GestureRecognizer
- (void)oneTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    //JLog(@"MyNavigationController PanGestureTriggered, panGestureRecognizer:%@, x", tapGestureRecognizer);
    if (!_slideIn) {
        [self slideIn];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //JLog(@"gestureRecognizerShouldBegin");
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint                p    = [pan locationInView:_subVC.view];
        return p.x < 100;
    }
    return NO;
}

- (void)onPanGestureTriggered:(UIPanGestureRecognizer *)panGestureRecognizer {
    //    JLog(@"MyNavigationController PanGestureTriggered, panGestureRecognizer:%@", panGestureRecognizer);
    CGFloat x            = [panGestureRecognizer translationInView:self.view].x;
    CGFloat realDistance = x+_distance;

    switch (panGestureRecognizer.state) {
    case UIGestureRecognizerStateBegan: {
        //CGPoint start = [panGestureRecognizer locationInView:self.view];
        //JLog(@"MyNavigationController PanGestureTriggered, panGestureRecognizer:%@, x = %f, distance = %f, _subVC.view.center = (%f, %f)", panGestureRecognizer, x, _distance, self.view.center.x, self.view.center.y);
        //JLog(@"start point = (%f, %f)", start.x, start.y);
    }
    break;

    case UIGestureRecognizerStateChanged: {
        CGFloat scale = 1.0;
        if (realDistance < 10) {
            if (_slideIn) {
                //JLog(@"has slideIn.");
            } else {
                //slide in
                //JLog(@"MyNavigationController PanGestureTriggered, panGestureRecognizer:%@, x = %f, distance = %f, _subVC.view.center = (%f, %f)", panGestureRecognizer, x, _distance, self.view.center.x, self.view.center.y);
                _subVC.view.center    = CGPointMake(self.view.center.x, self.view.center.y);
                scale                 = 1.0;
                _subVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                _bgView.alpha         = 0;
                _slideIn              = YES;
                _slideOutFinish       = NO;
                [_subVC.view removeGestureRecognizer:_oneTapGestureReognizer];
            }
        } else {
            if (realDistance > SLIDE_OUT_MAX) {
                if (_slideOutFinish) {
                    //JLog(@"has slideOut.");
                } else {
                    //finish slide out
                    //JLog(@"MyNavigationController PanGestureTriggered, panGestureRecognizer:%@, x = %f, distance = %f, _subVC.view.center = (%f, %f)", panGestureRecognizer, x, _distance, self.view.center.x, self.view.center.y);
                    _subVC.view.center    = CGPointMake(self.view.center.x + SLIDE_OUT_MAX, self.view.center.y);
                    scale                 = 1.0-0.23;
                    _subVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                    _bgView.alpha         = 1.0;
                    _slideIn              = NO;
                    _slideOutFinish       = YES;
                    [_subVC.view addGestureRecognizer:_oneTapGestureReognizer];
                }
            } else {
                //sliding
                //JLog(@"MyNavigationController PanGestureTriggered, panGestureRecognizer:%@, x = %f, distance = %f, _subVC.view.center = (%f, %f)", panGestureRecognizer, x, _distance, self.view.center.x, self.view.center.y);
                _subVC.view.center    = CGPointMake(self.view.center.x + realDistance, self.view.center.y);
                scale                 = 1.0-realDistance/SLIDE_OUT_MAX*0.23;
                _subVC.view.transform = CGAffineTransformMakeScale(scale, scale);
                _bgView.alpha         = realDistance/SLIDE_OUT_MAX;
                if (_slideIn) _slideIn = NO;
                if (_slideOutFinish) _slideOutFinish = NO;
            }
        }
    }
    break;

    case UIGestureRecognizerStateEnded: {
        if (_slideIn) {
            _distance = 0;
        } else if (_slideOutFinish) {
            _distance = SLIDE_OUT_MAX;
        } else {
            CGFloat velocity = [panGestureRecognizer velocityInView:self.view].x;
            if (realDistance < SLIDE_OUT_MAX/2.0) {
                if (velocity > 600) {
                    [self slideOut];
                } else {
                    [self slideIn];
                }
            } else {
                if (velocity < -600) {
                    [self slideIn];
                } else {
                    [self slideOut];
                }
            }
        }
        //JLog(@"MyNavigationController PanGestureTriggered END _distance = %f", _distance);
    }
    break;
    default: {
        //JLog(@"Default : MyNavigationController PanGestureTriggered");
    }
    }
}

#pragma mark - slide
- (void)slideIn {
    [UIView animateWithDuration:0.2 animations:^{
         _subVC.view.center = CGPointMake(_bgView.center.x, _bgView.center.y);
         _subVC.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
         _bgView.alpha = 0;
         _slideIn = YES;
         _slideOutFinish = NO;
         _distance = 0;
         [_subVC.view removeGestureRecognizer:_oneTapGestureReognizer];
     } completion:^(BOOL finished){
         [self addAssitPoint];
     }];
}

- (void)slideOut {
    [self removeAssitPoint];
    [UIView animateWithDuration:0.2 animations:^{
         _subVC.view.center = CGPointMake(_bgView.center.x + SLIDE_OUT_MAX, _bgView.center.y);
         _subVC.view.transform = CGAffineTransformMakeScale(0.77, 0.77);
         _bgView.alpha = 1.0;
         _slideIn = NO;
         _slideOutFinish = YES;
         _distance = SLIDE_OUT_MAX;
         [_subVC.view addGestureRecognizer:_oneTapGestureReognizer];
     } completion:nil];
}

- (void)slide {
    if (_slideIn) [self slideOut];
    else if (_slideOutFinish) [self slideIn];
}

#pragma mark - AssisPoint
- (void)addAssitPoint {
    if (self.myAssit == nil) {
        self.myAssit = [[JKAssitPointView alloc] init];
        [self.view addSubview:self.myAssit];
    }
}

- (void)removeAssitPoint {
    if (self.myAssit) {
        [self.myAssit removeFromSuperview];
        self.myAssit = nil;
    }
}

@end
