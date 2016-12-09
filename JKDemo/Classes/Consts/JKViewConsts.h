//
//  JKViewConsts.h
//  JKDemo
//
//  Created by jackyjiao on 12/6/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#ifndef JKViewConsts_h
#define JKViewConsts_h

#define APPLICATION_SCREEN_HEIGHT        ([UIScreen mainScreen].bounds.size.height)
#define APPLICATION_SCREEN_WIDTH         ([UIScreen mainScreen].bounds.size.width)
#define APPLICATION_BOUNDS               ([UIScreen mainScreen].bounds)

#define SCALE_OF_SCREEN_HEIGHT_TO_IPHONE6       ([UIScreen mainScreen].bounds.size.height / 667)
#define SCALE_OF_SCREEN_WIDTH_TO_IPHONE6        ([UIScreen mainScreen].bounds.size.width / 375)
#define SCALE_HEIGHT(h)                         floor((h) * SCALE_OF_SCREEN_HEIGHT_TO_IPHONE6)
#define SCALE_WIDTH(w)                          floor((w) * SCALE_OF_SCREEN_WIDTH_TO_IPHONE6)

#define DEFAULT_FONT(s) ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)] ? [UIFont systemFontOfSize : s weight:UIFontWeightLight] :[UIFont systemFontOfSize:s])

#define DEFAULT_STATUS_BAR_HEIGHT        ([UIApplication sharedApplication].statusBarFrame.size.height)
#define DEFAULT_NAVIGATION_BAR_HEIGHT    (44 + DEFAULT_STATUS_BAR_HEIGHT)
#define DEFAULT_PADDING_LEFT             20.0

#define DEFAULT_TABLE_VIEW_HEADER_HEIGHT 15.0
#define DEFAULT_TABLE_VIEW_FOOTER_HEIGHT 5.0
#define DEFAULT_TABLE_VIEW_ROW_HEIGHT    50.0

#endif /* JKViewConsts_h */
