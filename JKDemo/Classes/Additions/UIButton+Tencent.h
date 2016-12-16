//
//  UIButton+Tencent.h
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

@interface UIButton (Tencent)
+ (UIButton *)tc_buttonWithFrame:(CGRect)frame
                           image:(UIImage *)image
                     tappedImage:(UIImage *)tappedImage
                          target:(id)target
                          action:(SEL)action;

+ (UIButton *)tc_buttonWithFrame:(CGRect)frame
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
             titleHighlightColor:(UIColor *)titleHighlightColor
                            font:(UIFont *)font
                          target:(id)target
                          action:(SEL)action;

+ (UIButton *)tc_buttonWithFrame:(CGRect)frame
                    contentImage:(UIImage *)contentImage
                          target:(id)target
                          action:(SEL)selector
       showsTouchWhenHighlighted:(BOOL)showsTouchWhenHighlighted;
@end