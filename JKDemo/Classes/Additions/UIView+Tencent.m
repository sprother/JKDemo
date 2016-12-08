//
//  UIView+Tencent.m
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "UIView+Tencent.h"

static NSUInteger const UIViewBorderViewTagBase = 1000;

@implementation UIView (Tencent)

#pragma mark - tcLeft
- (CGFloat)tcLeft {
    return self.frame.origin.x;
}

- (void)setTcLeft:(CGFloat)tcLeft {
    CGRect frame = self.frame;
    frame.origin.x = tcLeft;
    self.frame     = frame;
}

#pragma mark - tcRight
- (CGFloat)tcRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTcRight:(CGFloat)tcRight {
    CGRect frame = self.frame;
    frame.origin.x = tcRight - frame.size.width;
    self.frame     = frame;
}

#pragma mark - tcTop
- (CGFloat)tcTop {
    return self.frame.origin.y;
}

- (void)setTcTop:(CGFloat)tcTop {
    CGRect frame = self.frame;
    frame.origin.y = tcTop;
    self.frame     = frame;
}

#pragma mark - tcBottom
- (CGFloat)tcBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTcBottom:(CGFloat)tcBottom {
    CGRect frame = self.frame;
    frame.origin.y = tcBottom - frame.size.height;
    self.frame     = frame;
}

#pragma mark - tcWidth
- (CGFloat)tcWidth {
    return self.frame.size.width;
}

- (void)setTcWidth:(CGFloat)tcWidth {
    CGRect frame = self.frame;
    frame.size.width = tcWidth;
    self.frame       = frame;
}

#pragma mark - tcHeight
- (CGFloat)tcHeight {
    return self.frame.size.height;
}

- (void)setTcHeight:(CGFloat)tcHeight {
    CGRect frame = self.frame;
    frame.size.height = tcHeight;
    self.frame        = frame;
}

#pragma mark - tcCenterX
- (CGFloat)tcCenterX {
    return self.center.x;
}

- (void)setTcCenterX:(CGFloat)tcCenterX {
    self.center = CGPointMake(tcCenterX, self.center.y);
}

#pragma mark - tcCenterY
- (CGFloat)tcCenterY {
    return self.center.y;
}

- (void)setTcCenterY:(CGFloat)tcCenterY {
    self.center = CGPointMake(self.center.x, tcCenterY);
}

#pragma mark - screenView
- (CGFloat)tcScreenViewX {
    CGFloat x = 0;
    for (UIView *view = self; view; view = view.superview) {
        x += view.tcLeft;

        if ([view.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view.superview;
            x -= scrollView.contentOffset.x;
        }
    }

    return x;
}

- (CGFloat)tcScreenViewY {
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.tcTop;

        if ([view.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view.superview;
            y -= scrollView.contentOffset.y;
        }
    }

    return y;
}

- (CGRect)tcScreenFrame {
    return CGRectMake(self.tcScreenViewX, self.tcScreenViewY, self.tcWidth, self.tcHeight);
}

#pragma mark - tcOrigin
- (CGPoint)tcOrigin {
    return self.frame.origin;
}

- (void)setTcOrigin:(CGPoint)tcOrigin {
    CGRect frame = self.frame;
    frame.origin = tcOrigin;
    self.frame   = frame;
}

#pragma mark - tcSize
- (CGSize)tcSize {
    return self.frame.size;
}

- (void)setTcSize:(CGSize)tcSize {
    CGRect frame = self.frame;
    frame.size = tcSize;
    self.frame = frame;
}

- (UIImage *)tc_screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIColor clearColor] setFill];
    [[UIBezierPath bezierPathWithRect:self.bounds] fill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    
    UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return anImage;
}

- (void)tc_removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)addOneRetinaPixelBorderWithBorderColor:(nonnull UIColor *)borderColor {
    [self addOneRetinaPixelBorderWithBorderColor:borderColor borderWidth:1];
}

- (void)addOneRetinaPixelBorderWithBorderColor:(nonnull UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth * 1.0f / [[UIScreen mainScreen] scale];
    self.layer.borderColor = borderColor.CGColor;
}

- (void)removeOneRetinaPixelBorder {
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor {
    [self addBorderWithBorderPosition:position borderColor:borderColor borderWidth:1.0 edgeInsets:UIEdgeInsetsZero];
}

- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor edgeInsets:(UIEdgeInsets)edgeInsets {
    [self addBorderWithBorderPosition:position borderColor:borderColor borderWidth:1.0 edgeInsets:edgeInsets];
}

- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth edgeInsets:(UIEdgeInsets)edgeInsets {
//    CGFloat scale = [[UIScreen mainScreen] scale];
    if (borderWidth < 1) {
        borderWidth = 1.0;
    }
    
    NSUInteger tag = [self tagForPosition:position];
    UIView *border = [self viewWithTag:tag];
    if (border == nil) {
        border = [[UIView alloc] initWithFrame:CGRectZero];
        border.tag = tag;
        [self addSubview:border];
    }
    border.backgroundColor = borderColor;
    border.translatesAutoresizingMaskIntoConstraints = NO;
    switch (position) {
        case BorderPositionTop: {
            //            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), borderWidth);
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:edgeInsets.left]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeTrailing multiplier:1 constant:edgeInsets.right]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInsets.top]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
            
        }
            break;
            
        case BorderPositionBottom: {
            //            border.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - borderWidth, CGRectGetWidth(self.bounds), borderWidth);
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:edgeInsets.left]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeTrailing multiplier:1 constant:edgeInsets.right]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInsets.bottom]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
        }
            break;
            
        case BorderPositionLeft: {
            //            border.frame = CGRectMake(0, 0, borderWidth, CGRectGetHeight(self.bounds));
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:edgeInsets.left]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInsets.top]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInsets.bottom]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
        }
            break;
            
        case BorderPositionRight: {
            //            border.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeTrailing multiplier:1 constant:edgeInsets.right]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInsets.top]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInsets.bottom]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
        }
            break;
            
        default:
            break;
    }
}

- (void)removeBorderAtPosition:(BorderPosition)position {
    NSUInteger tag = [self tagForPosition:position];
    [[self viewWithTag:tag] removeFromSuperview];
}

- (void)removeAllBorders {
    [self removeBorderAtPosition:BorderPositionTop];
    [self removeBorderAtPosition:BorderPositionBottom];
    [self removeBorderAtPosition:BorderPositionLeft];
    [self removeBorderAtPosition:BorderPositionRight];
}

- (NSUInteger)tagForPosition:(BorderPosition)position {
    NSUInteger tag = UIViewBorderViewTagBase;
    
    switch (position) {
        case BorderPositionTop:
            return tag + 1;
        case BorderPositionBottom:
            return tag + 2;
        case BorderPositionLeft:
            return tag + 3;
        case BorderPositionRight:
            return tag + 4;
        default:
            return tag;
            break;
    }
    
    NSAssert(NO, @"invalid position");
    return 0;
}

@end