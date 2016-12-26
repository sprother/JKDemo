//
//  JKPlayBall.m
//  JKDemo
//
//  Created by jackyjiao on 12/26/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKPlayBall.h"
#import "JKEllipseView.h"
#import <math.h>

@interface JKPlayBall () <CAAnimationDelegate>

@property (nonatomic, strong) JKEllipseView *ballView;
@property (nonatomic, assign) CGPoint       pointA;
@property (nonatomic, assign) CGFloat       Vx;
@property (nonatomic, assign) CGFloat       Vy;

@end

@implementation JKPlayBall

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
        _ballView           = [[JKEllipseView alloc] initWithFrame:CGRectMake(0, 0, 2*JKRunBallRadiu, 2*JKRunBallRadiu) color:RANDOM_COLOR];
        _ballView.tcCenterX = self.tcWidth/2.0;
        _ballView.tcCenterY = self.tcHeight/2.0;
    }
    return _ballView;
}

#pragma mark - 碰壁回弹效果
#define JKPlayBallSpeed 300.0//每秒x像素

- (void)stopAnimation {
    [self.ballView.layer removeAllAnimations];
}

- (void)startAnimation {
    CGPoint pointA = CGPointMake(self.tcWidth/2.0, self.tcHeight/2.0);
    CGPoint pointB = CGPointMake(arc4random()%(int)self.tcHeight, arc4random()%(int)self.tcHeight);
    CGFloat Sx     = pointB.x - pointA.x;
    CGFloat Sy     = pointB.y - pointA.y;

    self.pointA = pointA;
    self.Vx     = Sx/sqrt(Sx*Sx+Sy*Sy);
    self.Vy     = Sy/sqrt(Sx*Sx+Sy*Sy);

    CAKeyframeAnimation *positionAnimation = [self positionAnimation];
    [self.ballView.layer addAnimation:positionAnimation forKey:@"playAnimation"];
}

- (CAKeyframeAnimation *)positionAnimation {
    NSArray             *values            = [self animationValue];
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    positionAnimation.duration            = [values count]/JKPlayBallSpeed;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode            = kCAFillModeForwards;
    positionAnimation.delegate            = self;
    positionAnimation.values              = values;
    positionAnimation.autoreverses        = NO;
    positionAnimation.repeatCount         = 0;
    return positionAnimation;
}

- (NSArray *)animationValue {
    CGFloat        deltaTime = 1;
    NSMutableArray *mArray   = [NSMutableArray new];
    NSValue        *point    = [NSValue valueWithCGPoint:self.pointA];

    [mArray addObject:point];

    while (YES) {
        CGFloat nextX = self.pointA.x + deltaTime*self.Vx;
        CGFloat nextY = self.pointA.y + deltaTime*self.Vy;
        if (nextX < JKRunBallRadiu || nextX > (self.tcWidth-JKRunBallRadiu)) {
            self.Vx = -1*self.Vx;
            break;
        }
        if (nextY < JKRunBallRadiu || nextY > (self.tcHeight-JKRunBallRadiu)) {
            self.Vy = -1*self.Vy;
            break;
        }
        self.pointA = CGPointMake(nextX, nextY);
        NSValue *point = [NSValue valueWithCGPoint:self.pointA];
        [mArray addObject:point];
    }
    return [mArray copy];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.ballView.layer animationForKey:@"playAnimation"]) {
        [self.ballView.layer removeAllAnimations];

        CAKeyframeAnimation *positionAnimation = [self positionAnimation];
        [self.ballView.layer addAnimation:positionAnimation forKey:@"playAnimation"];
        return;
    }
}

@end
