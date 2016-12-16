//
//  JKSplashViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/16/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKSplashViewController.h"
#import "JKAppDelegate+MainUI.h"

@interface JKSplashViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation JKSplashViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title = @"闪屏";
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
    [super viewDidDisappear:animated];
}

#pragma mark - scrollView
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(self.view.tcWidth*3, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        self.view1.tcLeft = 0*self.view.tcWidth;
        [_scrollView addSubview:self.view1];
        self.view2.tcLeft = 1*self.view.tcWidth;
        [_scrollView addSubview:self.view2];
        self.view3.tcLeft = 2*self.view.tcWidth;
        [_scrollView addSubview:self.view3];
    }
    return _scrollView;
}

#pragma mark - scrollViewDelegate
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

- (void)scrollViewScrollEnd:(UIScrollView *)scrollView {
    float offset = (scrollView.contentOffset.x)/self.view.tcWidth;
    JLog(@"offset %f", offset);
    self.pageControl.currentPage = (int)offset;
}

#pragma mark - views
- (UIView *)view1 {
    if (_view1 == nil) {
        _view1 = [[UIView alloc] initWithFrame:self.view.bounds];
        _view1.backgroundColor = RANDOM_COLOR;
    }
    return _view1;
}

- (UIView *)view2 {
    if (_view2 == nil) {
        _view2 = [[UIView alloc] initWithFrame:self.view.bounds];
        _view2.backgroundColor = RANDOM_COLOR;
    }
    return _view2;
}

- (UIView *)view3 {
    if (_view3 == nil) {
        _view3 = [[UIView alloc] initWithFrame:self.view.bounds];
        _view3.backgroundColor = RANDOM_COLOR;
        [_view3 addSubview:self.button];
    }
    return _view3;
}

#pragma mark - button
- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton tc_buttonWithFrame:CGRectMake(0, 0, self.view.tcWidth/3.0, 50)
                               title:@"进入"
                          titleColor:UIColorFromRgbFloatAlpha(0xffffff, 0.8)
                 titleHighlightColor:UIColorFromRgbFloatAlpha(0xffffff, 0.5)
                                font:DEFAULT_FONT(14)
                              target:self
                              action:@selector(enterMainView:)];
        _button.backgroundColor = UIColorFromHex(0x90452d);
        _button.layer.cornerRadius = 5;
        _button.layer.masksToBounds = YES;
        _button.tcCenterX = _view3.tcCenterX;
        _button.tcBottom = self.view.tcHeight - SCALE_HEIGHT(100);
    }
    return _button;
}

- (void)enterMainView:(UIButton *)sender {
    JLog(@"enterMainView");
    [[JKAppDelegate shareInstance] showMainViewAnimated:NO];
}

#pragma mark - pageControl
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.view.tcWidth/3.0, 30)];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.tcCenterX = self.view.tcCenterX;
        _pageControl.tcBottom = self.view.tcHeight - SCALE_HEIGHT(30);
    }
    return _pageControl;
}

@end
