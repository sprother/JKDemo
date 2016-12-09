//
//  DMNumberPickerView.h
//  DeviceManager
//
//  Created by jackyjiao on 3/28/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMNumberPickerView;

@protocol DMNumberPickerViewDelegate <NSObject>

@required
- (void)numberPickerViewDidChangeValue:(DMNumberPickerView *)picker;

@end

@interface DMNumberPickerView : UIView

@property (nonatomic, assign, readonly) int                  value;
@property (nonatomic, weak) id<DMNumberPickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame defaultValue:(int)defaultValue maxValue:(int)maxValue;
- (instancetype)initWithFrame:(CGRect)frame;

@end
