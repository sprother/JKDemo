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

@end

@implementation JKEllipseLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.ellipseLayer];
    }
    return self;
}

#pragma mark - EllipseLine
- (CAShapeLayer *)ellipseLayer {
    CAShapeLayer     *solidLine = [CAShapeLayer layer];
    CGMutablePathRef solidPath  = CGPathCreateMutable();
    
    solidLine.lineWidth   = 2.0f;
    solidLine.strokeColor = [UIColor redColor].CGColor;
    solidLine.fillColor   = [UIColor orangeColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, self.bounds);
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    return solidLine;
}

@end
