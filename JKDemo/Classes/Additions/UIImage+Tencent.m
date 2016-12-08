//
//  UIImage+Tencent.m
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <Accelerate/Accelerate.h>
#import "UIImage+Tencent.h"

@implementation UIImage (Tencent)

+ (UIImage *)tc_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGSize imageSize = CGSizeMake(size.width, size.height);

    UIGraphicsBeginImageContext(imageSize);
    [[UIColor clearColor] setFill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGContextAddRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    CGContextClip(ctx);

    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextAddRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    CGContextFillPath(ctx);

    CGContextRestoreGState(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)tc_compositeImageWithBackgroundImage:(UIImage *)backgroundImage logo:(UIImage *)logo logoRect:(CGRect)rect {
    CGFloat scale = [UIScreen mainScreen].scale;

    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, scale);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [logo drawInRect:rect];
    UIImage *compositeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compositeImage;
}

+ (UIImage *)tc_partOfImageWithImage:(UIImage *)image rect:(CGRect)frame {
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    UIImage *partImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return partImage;
}

+ (UIImage *)tc_imageWithTintColor:(UIColor *)color image:(UIImage *)originImage blendMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0.0f);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
    UIRectFill(bounds);
    [originImage drawInRect:bounds blendMode:blendMode alpha:1.0f];
    if (blendMode != kCGBlendModeDestinationIn) {
        [originImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage *)tc_synthetiseImages:(UIImage *)oneImg anotherImg:(UIImage *)anotherImg {
    UIGraphicsBeginImageContext(oneImg.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    [oneImg drawInRect:CGRectMake(0.0f, 0.0f, oneImg.size.width, oneImg.size.height)];
    [anotherImg drawInRect:CGRectMake(0.0f, 0.0f, anotherImg.size.width, anotherImg.size.height)];
    
    CGContextRestoreGState(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)tc_applyBlurWithRadius:(CGFloat)blurRadius {
    if ((blurRadius < 0.0f) || (blurRadius > 1.0f)) {
        blurRadius = 0.5f;
    }
    
    int boxSize = (int)(blurRadius * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef rawImage = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(rawImage);
    inBuffer.height = CGImageGetHeight(rawImage);
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(rawImage);
    outBuffer.height = CGImageGetHeight(rawImage);
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(self.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)tc_getSquareImage {
    UIImage *originImage = self;

    if (originImage.size.width == originImage.size.height) {
        return originImage;
    }

    UIImage *squareImage = nil;
    CGRect  rect         = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
    if (originImage.size.width > originImage.size.height) {
        rect = CGRectMake((originImage.size.width - originImage.size.height) / 2, 0, originImage.size.height, originImage.size.height);
    } else if (originImage.size.height > originImage.size.width) {
        rect = CGRectMake(0, (originImage.size.height - originImage.size.width) / 2, originImage.size.width, originImage.size.width);
    }

    CGImageRef imageRef     = originImage.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, rect);
    squareImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return squareImage;
}

- (UIImage *)tc_getExpectedImageWithRatio:(CGFloat)ratio {
    UIImage *originImage = self;
    
    if (originImage.size.width == 0 || originImage.size.height == 0 || originImage.size.height / originImage.size.width == ratio) {
        return originImage;
    }
    
    CGRect  rect;
    if (originImage.size.height / originImage.size.width > ratio) {
        CGFloat expectedHeight = ceil(originImage.size.width * ratio);
        rect = CGRectMake(0, (originImage.size.height - expectedHeight) / 2, originImage.size.width, expectedHeight);
    } else {
        CGFloat expectedWidth = ceil(originImage.size.height / ratio);
        rect = CGRectMake((originImage.size.width - expectedWidth) / 2, 0, expectedWidth, originImage.size.height);
    }
    
    CGImageRef imageRef     = originImage.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *expectedImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return expectedImage;
}

@end
