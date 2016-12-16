//
//  UIButton+Tencent.m
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "UIButton+Tencent.h"

@implementation UIButton (Tencen)

+ (UIButton *)tc_buttonWithFrame:(CGRect)frame
                           image:(UIImage *)image
                     tappedImage:(UIImage *)tappedImage
                          target:(id)target
                          action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setFrame:frame];

    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }

    if (tappedImage) {
        [button setBackgroundImage:tappedImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:tappedImage forState:UIControlStateSelected];
    }

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)tc_buttonWithFrame:(CGRect)frame
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
             titleHighlightColor:(UIColor *)titleHighlightColor
                            font:(UIFont *)font
                          target:(id)target
                          action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setFrame:frame];

    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }

    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }

    if (titleHighlightColor) {
        [button setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
        [button setTitleColor:titleHighlightColor forState:UIControlStateSelected];
    }
    
    [button.titleLabel setFont:font];

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)tc_buttonWithFrame:(CGRect)frame
                    contentImage:(UIImage *)contentImage
                          target:(id)target
                          action:(SEL)selector
       showsTouchWhenHighlighted:(BOOL)showsTouchWhenHighlighted {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setFrame:frame];

    if (contentImage) {
        [button setImage:contentImage forState:UIControlStateNormal];
    }

    [button setShowsTouchWhenHighlighted:showsTouchWhenHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end