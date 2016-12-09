//
//  DMNumberPickerView.m
//  DeviceManager
//
//  Created by jackyjiao on 3/28/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#define DMNumberPickerPointHeight   72
#define DMNumberPickerMainHeight    42
#define DMNumberPickerSubHeight     24
#define DMNumberPickerDefaultHeight 106.0
#define DMNumberCount               301
#define DMNumberDefaultValue        175
#define DMNumberPickerViewMargin    SCALE_WIDTH(15)

#import "DMNumberPickerView.h"

@interface DMNumberPickerView () <UIScrollViewDelegate>

@property (nonatomic, assign) int          defaultValue;
@property (nonatomic, assign) int          maxValue;
@property (nonatomic, strong) UIScrollView *numberView;
@property (nonatomic, strong) UIView       *pointLine;
@property (nonatomic, assign) float        getScrollHeight;

@end

@implementation DMNumberPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _delegate     = nil;
        _defaultValue = DMNumberDefaultValue;
        _maxValue     = DMNumberCount;
        _value        = _defaultValue;
        if (frame.size.height > DMNumberPickerDefaultHeight) {
            _getScrollHeight = DMNumberPickerDefaultHeight;
        }
        else {
            _getScrollHeight = frame.size.height;
        }
        [self addSubview:self.numberView];
        [self addSubview:self.pointLine];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _numberView.contentOffset = CGPointMake((187/667.0*APPLICATION_SCREEN_HEIGHT)-12.5*DMNumberPickerViewMargin+DMNumberPickerViewMargin*_defaultValue, 0);
        });
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame defaultValue:(int)defaultValue maxValue:(int)maxValue {
    if (self = [super initWithFrame:frame]) {
        _delegate     = nil;
        _defaultValue = defaultValue;
        _maxValue     = maxValue;
        _value        = _defaultValue;
        if (frame.size.height > DMNumberPickerDefaultHeight) {
            _getScrollHeight = DMNumberPickerDefaultHeight;
        }
        else {
            _getScrollHeight = frame.size.height;
        }
        [self addSubview:self.numberView];
        [self addSubview:self.pointLine];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//jacky_todo 矫正
            _numberView.contentOffset = CGPointMake(SCALE_WIDTH(187)-12.5*DMNumberPickerViewMargin+DMNumberPickerViewMargin*_defaultValue, 0);
        });
    }
    return self;
}

//- (void)dealloc {
//    DMLogInfo(@"DMNumberPickerView dealloc.");
//}

- (UIView *)pointLine {
    if (_pointLine == nil) {
        _pointLine                 = [[UIView alloc] initWithFrame:CGRectMake(12.5*DMNumberPickerViewMargin, 0, 1, ((DMNumberPickerPointHeight)/(DMNumberPickerDefaultHeight)*self.getScrollHeight))];
        _pointLine.backgroundColor = UIColorFromHex(0x46dc5f);
    }
    return _pointLine;
}

- (UIScrollView *)numberView {
    if (_numberView == nil) {
        _numberView             = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.tcWidth, self.tcHeight)];
        _numberView.contentSize = CGSizeMake(DMNumberPickerViewMargin*_maxValue + SCALE_WIDTH(375), 0);
        for (int i = 0; i < _maxValue+1; i++) {
            if (i%5 == 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCALE_WIDTH(187)+DMNumberPickerViewMargin*i, (DMNumberPickerPointHeight-DMNumberPickerMainHeight)/(DMNumberPickerDefaultHeight)*self.getScrollHeight, 1, DMNumberPickerMainHeight/(DMNumberPickerDefaultHeight)*self.getScrollHeight)];
                line.backgroundColor = UIColorFromRgbFloatAlpha(0xffffff, 0.5);
                [_numberView addSubview:line];
                UILabel *num = [UILabel tc_labelWithFrame:CGRectMake(0, 0, self.tcWidth, 21) textColor:UIColorFromRgbFloatAlpha(0xffffff, 0.5) font:[UIFont fontWithName:@"Roboto-Light" size:14] textAlignment:NSTextAlignmentCenter];
                num.tcCenterX = line.tcCenterX;
                num.tcTop     = line.tcBottom + ((13)/(DMNumberPickerDefaultHeight)*self.getScrollHeight);
                num.text      = [NSString stringWithFormat:@"%d", i];
                [_numberView addSubview:num];
                continue;
            }
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCALE_WIDTH(187)+DMNumberPickerViewMargin*i, (DMNumberPickerPointHeight-4-DMNumberPickerSubHeight)/(DMNumberPickerDefaultHeight)*self.getScrollHeight, 1, DMNumberPickerSubHeight/(DMNumberPickerDefaultHeight)*self.getScrollHeight)];
            line.backgroundColor = UIColorFromRgbFloatAlpha(0xffffff, 0.3);
            [_numberView addSubview:line];
        }
        _numberView.backgroundColor                = [UIColor clearColor];
        _numberView.showsHorizontalScrollIndicator = false;
        _numberView.delegate                       = self;
        _numberView.contentOffset                  = CGPointMake(SCALE_WIDTH(187)-12.5*DMNumberPickerViewMargin+DMNumberPickerViewMargin*(_defaultValue), 0);
    }

    return _numberView;
}

// When scroll views finish moving, we can check their value.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    JLog(@"scrollViewDidEndDecelerating 减速已停止，即停止滚动了");//减速已停止，即停止滚动了
    [self scrollViewScrollEnd:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {//有惯性，还在滚动
        return;
    }
    JLog(@"scrollViewDidEndDragging decelerate ?%@ 没有惯性，已经停止", decelerate ? @"yes" : @"no");//没有惯性，已经停止
    [self scrollViewScrollEnd:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float getValue = (scrollView.contentOffset.x - SCALE_WIDTH(187))/DMNumberPickerViewMargin+13;
    int nGetValue = (int)getValue;
    if (nGetValue == _value) {
        return;
    }
    _value = nGetValue;
    __weak typeof(self) weakSelf = self;
    if (_delegate == nil) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(numberPickerViewDidChangeValue:)]) {
        [self.delegate numberPickerViewDidChangeValue:weakSelf];
    }
}

- (void)scrollViewScrollEnd:(UIScrollView *)scrollView {
    float getValue = (scrollView.contentOffset.x - SCALE_WIDTH(187))/DMNumberPickerViewMargin+13;
    float duration = 0.1+0.1*(getValue-(int)getValue);

    _value                       = (int)getValue;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
         _numberView.contentOffset = CGPointMake(SCALE_WIDTH(187)-12.5*DMNumberPickerViewMargin+DMNumberPickerViewMargin*_value, 0);
     } completion:^(BOOL finished){
         if (!finished) {
             return;
         }
         if (_delegate == nil) {
             return;
         }
         if ([self.delegate respondsToSelector:@selector(numberPickerViewDidChangeValue:)]) {
             [self.delegate numberPickerViewDidChangeValue:weakSelf];
         }
     }];
}

@end
