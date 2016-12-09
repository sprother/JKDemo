//
//  DMScanCircleView.m
//  DeviceManager
//
//  Created by jackyjiao on 4/1/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "DMScanCircleView.h"

@interface DMScanCircleView ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation DMScanCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _radius              = 100;
        _lineWidth           = 2;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth {
    if (self = [super initWithFrame:CGRectMake(0, 0, 2*(radius+lineWidth), 2*(radius+lineWidth))]) {
        self.backgroundColor = [UIColor clearColor];
        _radius              = radius;
        _lineWidth           = lineWidth;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, UIColorFromHex(0x46dc5f).CGColor);
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetFillColorWithColor(ctx, UIColorFromHex(0x46dc5f).CGColor);
    //设置拐点样式
    //    enum CGLineJoin {
    //        kCGLineJoinMiter, //尖的，斜接
    //        kCGLineJoinRound, //圆
    //        kCGLineJoinBevel //斜面
    //    };
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //Line cap 线的两端的样式
    //    enum CGLineCap {
    //        kCGLineCapButt,
    //        kCGLineCapRound,
    //        kCGLineCapSquare
    //    };
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //光晕效果
    CGContextSetShadowWithColor(ctx, CGSizeZero, 10.0, UIColorFromHex(0x46dc5f).CGColor);
    //画圆、圆弧
    [self drawCircle:ctx];
}

//画圆、圆弧
- (void)drawCircle:(CGContextRef)ctx {
    /* 绘制圆
       void CGContextAddArc (
       CGContextRef c,
       CGFloat x,             //圆心的x坐标
       CGFloat y,    //圆心的x坐标
       CGFloat radius,   //圆的半径
       CGFloat startAngle,    //开始弧度
       CGFloat endAngle,   //结束弧度
       int clockwise          //0表示顺时针，1表示逆时针
       );
     */
    CGContextAddArc(ctx, _radius+_lineWidth, _radius+_lineWidth, _radius, 0, M_PI* 2, 1);  //圆心固定为半径的位置，以应对缩放
    CGContextStrokePath(ctx);
}

@end
