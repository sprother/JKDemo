//
//  JKRunTrackView.m
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//  ref DMLastRunningTrackView.m
//

#import "JKRunTrackView.h"

@interface JKRunTrackView () <CAAnimationDelegate>

@property (nonatomic, copy) NSArray <NSNumber *> *defaultPointYArray;
@property (nonatomic, strong) UIBezierPath       *strokePath;
@property (nonatomic, strong) UIBezierPath       *linePath;
@property (nonatomic, strong) CAShapeLayer       *shadowLayer;
@property (nonatomic, strong) CAShapeLayer       *lineLayer;
@property (nonatomic, strong) UIImageView        *torchView;

@end

@implementation JKRunTrackView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, APPLICATION_SCREEN_WIDTH, 140)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildStokePathByDefault];
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.shadowLayer];
        [self addSubview:self.torchView];
        [self.layer setTransform:CATransform3DMakeScale(1, -1, 1)];
    }
    return self;
}

- (void)startAnimation {
    //1. 直线寻迹动画
    self.lineLayer.hidden = NO;
    CABasicAnimation *strokeAnimation = [self basicAnimationFromValue:@(0)
                                                              toValue:@(1)
                                                             duration:0.8
                                                              keyPath:@"strokeEnd"
                                                            beginTime:0];
    [self.lineLayer addAnimation:strokeAnimation forKey:@"strokeAnimation"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.lineLayer animationForKey:@"strokeAnimation"]) {
        [self.lineLayer removeAllAnimations];
        //2. UIBezierPath变形
        self.lineLayer.hidden   = YES;
        self.shadowLayer.hidden = NO;
        CABasicAnimation *pathAnimation = [self basicAnimationFromValue:(__bridge id _Nullable)(self.linePath.CGPath)
                                                                toValue:(__bridge id _Nullable)(self.strokePath.CGPath)
                                                               duration:1.0
                                                                keyPath:@"path"
                                                              beginTime:0];
        [self.shadowLayer addAnimation:pathAnimation forKey:@"pathAnimation"];
        return;
    }
    if (anim == [self.shadowLayer animationForKey:@"pathAnimation"]) {
        [self.shadowLayer removeAllAnimations];
        //2. 轨迹动画
        self.torchView.hidden = NO;
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        positionAnimation.path                = self.strokePath.CGPath;
        positionAnimation.duration            = 3;
        positionAnimation.removedOnCompletion = NO;
        positionAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fillMode            = kCAFillModeForwards;
        positionAnimation.delegate            = self;
        
        [self.torchView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        return;
    }
    if (anim == [self.torchView.layer animationForKey:@"positionAnimation"]) {
        [self.torchView.layer removeAllAnimations];
        //3.动画结束
        self.torchView.hidden = YES;
        return;
    }
}

#pragma mark - ui getter
- (CAShapeLayer *)lineLayer {
    if (_lineLayer == nil) {
        _lineLayer = [self shapeLayerPath:self.linePath.CGPath
                              strokeColor:[UIColor redColor].CGColor
                              shadowColor:[UIColor clearColor].CGColor
                            shadowOpacity:1.0
                             shadowOffset:CGSizeMake(0, 6)
                             shadowRadius:5];
        _lineLayer.hidden = YES;
    }
    
    return _lineLayer;
}

- (CAShapeLayer *)shadowLayer {
    if (_shadowLayer == nil) {
        _shadowLayer = [self shapeLayerPath:self.strokePath.CGPath
                                strokeColor:[UIColor redColor].CGColor
                                shadowColor:[UIColor clearColor].CGColor
                              shadowOpacity:1.0
                               shadowOffset:CGSizeMake(0, -5)
                               shadowRadius:5.0];
        _shadowLayer.hidden = YES;
    }
    
    return _shadowLayer;
}

- (UIImageView *)torchView {
    if (_torchView == nil) {
        UIImage *image = [UIImage tc_imageWithColor:[UIColor greenColor] size:CGSizeMake(5, 5)];
        _torchView        = [[UIImageView alloc] initWithImage:image];
        _torchView.hidden = YES;
    }
    
    return _torchView;
}

#pragma mark - properties getter
- (NSArray *)defaultPointYArray {
    if (!_defaultPointYArray) {
        _defaultPointYArray = @[@(4), @(15), @(39), @(64), @(85), @(92), @(79),
                                @(65), @(52), @(47), @(44), @(35), @(27), @(33), @(46),
                                @(65), @(83), @(82), @(70), @(64), @(75), @(85), @(80),
                                @(71), @(64), @(63), @(74), @(88), @(108), @(115), @(98),
                                @(67), @(33), @(38), @(53), @(62), @(45), @(14), @(3)];
    }
    return _defaultPointYArray;
}

#pragma mark - build path
- (void)buildStokePathByDefault {
    CGPoint prePrePoint = CGPointZero;
    CGPoint prePoint    = CGPointZero;
    CGPoint curPoint    = CGPointZero;
    CGPoint nextPoint   = CGPointZero;
    
    CGFloat itemWidth = (APPLICATION_SCREEN_WIDTH-40) / (self.defaultPointYArray.count - 1);
    
    UIBezierPath *strokePath = [UIBezierPath bezierPath];
    
    strokePath.lineJoinStyle = kCGLineJoinRound;
    strokePath.lineCapStyle  = kCGLineCapRound;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    for (int i = 0; i < self.defaultPointYArray.count; i++) {
        prePrePoint = prePoint;
        prePoint    = curPoint;
        curPoint    = nextPoint;
        
        if (i == 0) {
            curPoint    = CGPointMake(i * itemWidth + 20, [self.defaultPointYArray[i] floatValue] + 10);
            prePrePoint = curPoint;
            prePoint    = curPoint;
            nextPoint   = curPoint;
        }
        
        if (i + 1 < self.defaultPointYArray.count) {
            nextPoint = CGPointMake((i+1) * itemWidth + 20, [self.defaultPointYArray[i+1] floatValue] + 10);
        }
        
        if (i == 0) {
            [strokePath moveToPoint:curPoint];
            [linePath moveToPoint:CGPointMake(curPoint.x, 10)];
            self.torchView.center = curPoint;
        } else {
            float   coefficient = 6.8; //常量系数
            CGFloat preDx       = (curPoint.x - prePrePoint.x)/coefficient;
            CGFloat preDy       = (curPoint.y - prePrePoint.y)/coefficient;
            CGFloat curDx       = (nextPoint.x - prePoint.x)/coefficient;
            CGFloat curDy       = (nextPoint.y - prePoint.y)/coefficient;
            
            CGPoint controlPoint1 = CGPointMake(prePoint.x + preDx, prePoint.y + preDy);
            CGPoint controlPoint2 = CGPointMake(curPoint.x - curDx, curPoint.y - curDy);
            [strokePath addCurveToPoint:curPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
            [linePath addLineToPoint:CGPointMake(curPoint.x, 10)];
        }
    }
    
    self.strokePath = strokePath;
    self.linePath   = linePath;
}

#pragma mark - layer
- (CAShapeLayer *)shapeLayerPath:(CGPathRef)path
                     strokeColor:(CGColorRef)color
                     shadowColor:(CGColorRef)shadowColor
                   shadowOpacity:(CGFloat)opacity
                    shadowOffset:(CGSize)offset
                    shadowRadius:(CGFloat)radius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path          = path;
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.shadowColor   = shadowColor;
    shapeLayer.shadowOpacity = opacity;
    shapeLayer.shadowOffset  = offset;
    shapeLayer.shadowRadius  = radius;
    shapeLayer.strokeColor   = color;
    shapeLayer.lineWidth     = 3.0;
    shapeLayer.lineJoin      = kCALineJoinRound;
    shapeLayer.lineCap       = kCALineCapRound;
    return shapeLayer;
}

#pragma mark - animation
- (CABasicAnimation *)basicAnimationFromValue:(id)fromValue
                                      toValue:(id)toValue
                                     duration:(float)duration
                                      keyPath:(NSString *)keyPath
                                    beginTime:(float)beginTime {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    
    animation.fromValue           = fromValue;
    animation.toValue             = toValue;
    animation.duration            = duration;
    animation.repeatCount         = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode            = kCAFillModeForwards;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.beginTime           = beginTime;
    animation.delegate            = self;
    return animation;
}

@end
