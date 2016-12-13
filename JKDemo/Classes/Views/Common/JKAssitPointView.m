//
//  JKAssitPointView.m
//  JKDemo
//
//  Created by jackyjiao on 12/12/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKAssitPointView.h"
#import "JKFPSCount.h"

#define JKAssitPointHeight 40

@interface JKAssitPointView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation JKAssitPointView

- (void)dealloc {
    [[JKFPSCount sharedInstance] stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//iOS 9.0不remove也没有问题
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFPS:) name:JKFPSNotification object:nil];
        [[JKFPSCount sharedInstance] start];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 100, JKAssitPointHeight, JKAssitPointHeight)];
}

#pragma mark - getter
- (UILabel *)label {
    if (_label == nil) {
        _label                     = [[UILabel alloc] initWithFrame:self.bounds];
        _label.backgroundColor     = [UIColor colorWithRed:0.253 green:0.917 blue:0.476 alpha:1.000];
        _label.layer.masksToBounds = YES;
        _label.layer.cornerRadius  = 20;
        _label.textAlignment       = NSTextAlignmentCenter;
    }
    return _label;
}

#pragma mark - Move
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.superview];

    self.tcCenterX = point.x;
    self.tcCenterY = point.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

#pragma mark - notification
- (void)didReceiveFPS:(NSNotification *)notification {
    if (notification.object && [notification.object isKindOfClass:[NSNumber class]]) {
        int fps = [notification.object intValue];
        self.label.text = [NSString stringWithFormat:@"%d", fps];
    }
}

@end
