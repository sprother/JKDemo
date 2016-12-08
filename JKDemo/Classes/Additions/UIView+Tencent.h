//
//  UIView+Tencent.h
//  DeviceManager
//
//  Created by hth on 11/23/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

@interface UIView (Tencent)

typedef NS_OPTIONS(NSUInteger, BorderPosition) {
    BorderPositionNone          = 0,
    BorderPositionTop           = 1,
    BorderPositionBottom        = 2,
    BorderPositionLeft          = 3,
    BorderPositionRight         = 4,
};

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = tcLeft
 */
@property (nonatomic) CGFloat tcLeft;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = tcTop
 */
@property (nonatomic) CGFloat tcTop;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = tcRight - frame.size.width
 */
@property (nonatomic) CGFloat tcRight;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = tcBottom - frame.size.height
 */
@property (nonatomic) CGFloat tcBottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = tcWidth
 */
@property (nonatomic) CGFloat tcWidth;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = tcHeight
 */
@property (nonatomic) CGFloat tcHeight;

/**
 * Shortcut for center.x
 *
 * Sets center.x = tcCenterX
 */
@property (nonatomic) CGFloat tcCenterX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = tcCenterY
 */
@property (nonatomic) CGFloat tcCenterY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat tcScreenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat tcScreenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect tcScreenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint tcOrigin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize tcSize;

- (UIImage *)tc_screenshot;

- (void)tc_removeAllSubviews;

- (void)addOneRetinaPixelBorderWithBorderColor:(UIColor *)borderColor;
- (void)addOneRetinaPixelBorderWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (void)removeOneRetinaPixelBorder;
- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor;
- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor edgeInsets:(UIEdgeInsets)edgeInsets;
- (void)removeBorderAtPosition:(BorderPosition)position;
- (void)removeAllBorders;

@end