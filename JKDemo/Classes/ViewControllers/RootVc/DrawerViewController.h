//
//  DrawerViewController.h
//  TabDemo
//
//  Created by jackyjiao on 6/15/15.
//  Copyright (c) 2015 jackyjiao. All rights reserved.
//

#import "JKBaseViewController.h"

@interface DrawerViewController : JKBaseViewController

- (instancetype)initWithSubvc:(UIViewController *)vc;
- (void)slide;

@end
