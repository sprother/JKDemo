//
//  JKRunBall.m
//  JKDemo
//
//  Created by jackyjiao on 12/23/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKRunBall.h"
#import "JKEllipseView.h"
#import <math.h>

@interface JKRunBall () <CAAnimationDelegate>

@property (nonatomic, strong) JKEllipseView  *ballView;
@property (nonatomic, assign) CGFloat        boundHeith;

@property (nonatomic, strong) JKEllipseView  *ballViewBezier;
@property (nonatomic, assign) CGFloat        boundHeithBezier;

@end

@implementation JKRunBall

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:[self rectLayer]];
        [self addSubview:self.ballView];
    }
    return self;
}

#pragma mark - EllipseLine
- (CAShapeLayer *)rectLayer {
    CAShapeLayer     *solidLine = [CAShapeLayer layer];
    CGMutablePathRef solidPath  = CGPathCreateMutable();
    
    solidLine.lineWidth   = 2.0f;
    solidLine.strokeColor = [UIColor blackColor].CGColor;
    solidLine.fillColor   = [UIColor clearColor].CGColor;
    CGPathAddRect(solidPath, nil, self.bounds);
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    return solidLine;
}

#define JKRunBallRadiu 10

- (JKEllipseView *)ballView {
    if (_ballView == nil) {
        _ballView = [[JKEllipseView alloc] initWithFrame:CGRectMake(0, 0, 2*JKRunBallRadiu, 2*JKRunBallRadiu) color:RANDOM_COLOR];
        _ballView.tcCenterX = self.tcCenterX;
        _ballView.tcCenterY = self.tcCenterY;
    }
    return _ballView;
}

- (JKEllipseView *)ballViewBezier {
    if (_ballViewBezier == nil) {
        _ballViewBezier = [[JKEllipseView alloc] initWithFrame:CGRectMake(0, 0, 2*JKRunBallRadiu, 2*JKRunBallRadiu) color:RANDOM_COLOR];
        _ballViewBezier.tcCenterX = self.tcWidth/4;
        _ballViewBezier.tcCenterY = self.tcCenterY;
    }
    return _ballViewBezier;
}

#pragma mark - 自由落体回弹效果
#define JKRunBallFallSpeed       1.0
#define JKRunBallFallBoundFactor 0.7

- (void)startFallAnimation {
    self.boundHeith = self.tcHeight-JKRunBallRadiu;
    CAKeyframeAnimation *positionAnimation = [self positionAnimationFromZeroToPoint:self.boundHeith];
    [self.ballView.layer addAnimation:positionAnimation forKey:@"fallAnimation1"];
//    //使用Bezier曲线来实现时间控制的方式
//    [self addSubview:self.ballViewBezier];
//    [self startFallAnimationByBezier];
}

- (CAKeyframeAnimation *)positionAnimationFromZeroToPoint:(CGFloat)point2 {//第一次下降
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration            = JKRunBallFallSpeed/self.tcHeight*fabs(point2);
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode            = kCAFillModeForwards;
    positionAnimation.delegate            = self;
    positionAnimation.values              = [self animationFallValueFromPoint:CGPointMake(self.tcCenterX, 0) toPoint:CGPointMake(self.tcCenterX, point2) accelerate:YES];
    positionAnimation.autoreverses        = NO;
    return positionAnimation;
}

- (CAKeyframeAnimation *)positionAnimationFromPoint:(CGFloat)point1 toPoint:(CGFloat)point2 {//之后的上升和下降
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    positionAnimation.duration            = JKRunBallFallSpeed*2/self.tcHeight*fabs(point1-point2);
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode            = kCAFillModeForwards;
    positionAnimation.delegate            = self;
    positionAnimation.values              = [self animationFallValueFromPoint:CGPointMake(self.tcCenterX, point1) toPoint:CGPointMake(self.tcCenterX, point2) accelerate:NO];
    positionAnimation.autoreverses        = YES;
    return positionAnimation;
}

- (NSArray *)animationFallValueFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2 accelerate:(BOOL)accelerate {
    int pointCount = 30;
    CGFloat deltaX = (point2.x - point1.x);
    CGFloat deltaY = (point2.y - point1.y);
    NSMutableArray *mArray = [NSMutableArray new];
    for (int i = 0; i < pointCount+1; i++) {
        CGFloat iRate;
        NSValue *point;
        if (accelerate) {
            iRate = 1.0*i/pointCount;
            point = [NSValue valueWithCGPoint:CGPointMake(point1.x+deltaX*iRate, point1.y+deltaY*(iRate*iRate))];//Point1 + Delta * X^2
        }
        else {
            iRate = 1.0*i/pointCount;
            point = [NSValue valueWithCGPoint:CGPointMake(point1.x+deltaX*iRate, point1.y+deltaY*(1-(1-iRate)*(1-iRate)))];//Point1 + Delta * (1 - (1-X)^2)
        }
        [mArray addObject:point];
    }
    return [mArray copy];
}

#pragma mark - 自由落体回弹效果(Bezier)

- (void)startFallAnimationByBezier {
    self.boundHeithBezier = self.tcHeight-JKRunBallRadiu;
    CAKeyframeAnimation *positionAnimation = [self positionAnimationByBezierFromZeroToPoint:self.boundHeithBezier];
    [self.ballViewBezier.layer addAnimation:positionAnimation forKey:@"fallAnimationByBezier1"];
}

- (CAKeyframeAnimation *)positionAnimationByBezierFromZeroToPoint:(CGFloat)point2 {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    UIBezierPath *strokePath = [UIBezierPath bezierPath];
    [strokePath moveToPoint:CGPointMake(self.tcWidth/4, 0)];
    [strokePath addLineToPoint:CGPointMake(self.tcWidth/4, point2)];
    
    positionAnimation.path                = strokePath.CGPath;
    positionAnimation.duration            = JKRunBallFallSpeed/self.tcHeight*fabs(point2);
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.timingFunction      = [CAMediaTimingFunction functionWithControlPoints:0.5 :0 :1.0 :1.0];
    positionAnimation.fillMode            = kCAFillModeForwards;
    positionAnimation.autoreverses        = NO;
    positionAnimation.repeatCount         = 0;
    positionAnimation.delegate            = self;
    return positionAnimation;
}

- (CAKeyframeAnimation *)positionAnimationByBezierFromPoint:(CGFloat)point1 toPoint:(CGFloat)point2 {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    UIBezierPath *strokePath = [UIBezierPath bezierPath];
    [strokePath moveToPoint:CGPointMake(self.tcWidth/4, point1)];
    [strokePath addLineToPoint:CGPointMake(self.tcWidth/4, point2)];
    
    positionAnimation.path                = strokePath.CGPath;
    positionAnimation.duration            = JKRunBallFallSpeed*2/self.tcHeight*fabs(point2-point1);
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.timingFunction      = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.5 :1.0];
    positionAnimation.fillMode            = kCAFillModeForwards;
    positionAnimation.autoreverses        = YES;
    positionAnimation.repeatCount         = 0;
    positionAnimation.delegate            = self;
    return positionAnimation;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.ballView.layer animationForKey:@"fallAnimation1"]) {
        [self.ballView.layer removeAllAnimations];
        //2. 上升下降
        self.boundHeith = JKRunBallFallBoundFactor*self.boundHeith;
        CAKeyframeAnimation *positionAnimation = [self positionAnimationFromPoint:self.tcHeight-JKRunBallRadiu toPoint:self.tcHeight-JKRunBallRadiu-self.boundHeith];
        [self.ballView.layer addAnimation:positionAnimation forKey:@"fallAnimation2"];
        return;
    }
    if (anim == [self.ballView.layer animationForKey:@"fallAnimation2"]) {
        [self.ballView.layer removeAllAnimations];
        //3~. 上升下降
        self.boundHeith = JKRunBallFallBoundFactor*self.boundHeith;
        if (self.boundHeith < 1) {
            self.ballView.tcBottom = self.tcHeight;
            JLog(@"ball bound finish.");
            return;
        }
        CAKeyframeAnimation *positionAnimation = [self positionAnimationFromPoint:self.tcHeight-JKRunBallRadiu toPoint:self.tcHeight-JKRunBallRadiu-self.boundHeith];
        [self.ballView.layer addAnimation:positionAnimation forKey:@"fallAnimation2"];
        return;
    }
    //boundHeithBezier
    if (anim == [self.ballViewBezier.layer animationForKey:@"fallAnimationByBezier1"]) {
        [self.ballViewBezier.layer removeAllAnimations];
        //2. 上升下降
        self.boundHeithBezier = JKRunBallFallBoundFactor*self.boundHeithBezier;
        CAKeyframeAnimation *positionAnimation = [self positionAnimationByBezierFromPoint:self.tcHeight-JKRunBallRadiu toPoint:self.tcHeight-JKRunBallRadiu-self.boundHeithBezier];
        [self.ballViewBezier.layer addAnimation:positionAnimation forKey:@"fallAnimationByBezier2"];
        return;
    }
    if (anim == [self.ballViewBezier.layer animationForKey:@"fallAnimationByBezier2"]) {
        [self.ballViewBezier.layer removeAllAnimations];
        //3~. 上升下降
        self.boundHeithBezier = JKRunBallFallBoundFactor*self.boundHeithBezier;
        if (self.boundHeithBezier < 1) {
            self.ballViewBezier.tcBottom = self.tcHeight;
            JLog(@"ballViewBezier bound finish.");
            return;
        }
        CAKeyframeAnimation *positionAnimation = [self positionAnimationByBezierFromPoint:self.tcHeight-JKRunBallRadiu toPoint:self.tcHeight-JKRunBallRadiu-self.boundHeithBezier];
        [self.ballViewBezier.layer addAnimation:positionAnimation forKey:@"fallAnimationByBezier2"];
        return;
    }
}
@end
