//
//  UIImage+Tencent.h
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

@interface UIImage (Tencent)
+ (UIImage *)tc_imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)tc_compositeImageWithBackgroundImage:(UIImage *)backgroundImage
                                             logo:(UIImage *)logo
                                         logoRect:(CGRect)rect;

+ (UIImage *)tc_partOfImageWithImage:(UIImage *)image rect:(CGRect)frame;

+ (UIImage *)tc_imageWithTintColor:(UIColor *)color image:(UIImage *)originImage blendMode:(CGBlendMode)blendMode;

+ (UIImage *)tc_synthetiseImages:(UIImage *)oneImg anotherImg:(UIImage *)anotherImg;

- (UIImage *)tc_applyBlurWithRadius:(CGFloat)blurRadius;

- (UIImage *)tc_getSquareImage;

- (UIImage *)tc_getExpectedImageWithRatio:(CGFloat)ratio; //ratio = expectedHeight / expectedWidth;

@end
