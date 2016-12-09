//
//  UILabel+Tencent.m
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "UILabel+Tencent.h"

@implementation UILabel (Tencent)

+ (UILabel *)tc_labelWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];

    [label setFont:font];
    [label setTextColor:textColor];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}

+ (UILabel *)tc_labelWithFrame:(CGRect)frame
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
                 textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[self class] tc_labelWithFrame:frame textColor:textColor font:font];

    label.textAlignment = textAlignment;
    return label;
}

- (void)tc_fixWidthWithText:(NSString *)text {
    CGFloat height = self.frame.size.height;

    self.text = text;
    [self sizeToFit];

    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}

@end