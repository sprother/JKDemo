//
//  JKEllipseView.m
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//  实心椭圆
//

#import "JKEllipseView.h"

@implementation JKEllipseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextFillEllipseInRect (context, rect);
    CGContextFillPath(context);
}

@end
