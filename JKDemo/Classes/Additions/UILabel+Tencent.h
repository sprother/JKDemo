//
//  UILabel+Tencent.h
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

@interface UILabel (Tencent)
+ (UILabel *)tc_labelWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;

+ (UILabel *)tc_labelWithFrame:(CGRect)frame
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
                 textAlignment:(NSTextAlignment)textAlignment;

- (void)tc_fixWidthWithText:(NSString *)text;
@end
