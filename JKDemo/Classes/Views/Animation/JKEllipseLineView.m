//
//  JKEllipseLineView.m
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKEllipseLineView.h"

@interface JKEllipseLineView ()

@property (nonatomic, strong) CAShapeLayer *ellipseLayer;
@property (nonatomic, strong) UIColor *color;

@end

@implementation JKEllipseLineView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame color:[UIColor redColor]];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = color;
        [self.layer addSublayer:self.ellipseLayer];
    }
    return self;
}

#pragma mark - EllipseLine
- (CAShapeLayer *)ellipseLayer {
    CAShapeLayer     *solidLine = [CAShapeLayer layer];
    CGMutablePathRef solidPath  = CGPathCreateMutable();
    
    solidLine.lineWidth   = 2.0f;
    solidLine.strokeColor = self.color.CGColor;
    solidLine.fillColor   = [UIColor orangeColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, self.bounds);
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    return solidLine;
}

@end
