//
//  JKEllipseView.m
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//  实心椭圆
//

#import "JKEllipseView.h"

@interface JKEllipseView ()

@property (nonatomic, strong) UIColor *color;

@end

@implementation JKEllipseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor blueColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = color;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillEllipseInRect (context, rect);
    CGContextFillPath(context);
}

@end
