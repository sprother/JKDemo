//
//  JKSplashViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/16/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKSplashViewController.h"
#import "JKAppDelegate+MainUI.h"

#define JKSpashCount 3 // JKSpashCount > 2

@interface JKSplashViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *viewEnd;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) NSArray<UIView *> *viewArray;
@property (nonatomic, assign) int currentPage;

@end

@implementation JKSplashViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title = @"闪屏";
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    _currentPage = -1;
    self.currentPage = 0;
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
        [_scrollView setContentOffset:CGPointMake(self.view.tcWidth, 0)];
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

#pragma mark - scrollAction
- (void)scrollViewScrollEnd:(UIScrollView *)scrollView {
    int offset = (scrollView.contentOffset.x)/self.view.tcWidth;
    JLog(@"offset %d", offset);
    if (offset == 0) {
        self.currentPage = self.currentPage-1;
    }
    if (offset == 2) {
        self.currentPage = self.currentPage+1;
    }
    self.pageControl.currentPage = self.currentPage;
}

- (void)setCurrentPage:(int)currentPage {
    if (_currentPage == currentPage) {
        return;
    }
    if (currentPage < 0) {
        currentPage = JKSpashCount-1;
    }
    else if (currentPage > JKSpashCount-1) {
        currentPage = 0;
    }
    int nextPage, prePage;
    if (currentPage == 0) {
        prePage = JKSpashCount-1;
        nextPage = 1;
    }
    else if (currentPage == JKSpashCount-1) {
        prePage = JKSpashCount-2;
        nextPage = 0;
    }
    else {
        prePage = currentPage-1;
        nextPage = currentPage+1;
    }
    _currentPage = currentPage;
    UIView *view1 = [self.viewArray objectAtIndex:prePage];
    UIView *view2 = [self.viewArray objectAtIndex:currentPage];
    UIView *view3 = [self.viewArray objectAtIndex:nextPage];
    for (UIView *tmpView in self.scrollView.subviews) {
        [tmpView removeFromSuperview];
    }
    view1.tcLeft = 0*self.view.tcWidth;
    view2.tcLeft = 1*self.view.tcWidth;
    view3.tcLeft = 2*self.view.tcWidth;
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
    [self.scrollView addSubview:view3];
    [self.scrollView setContentOffset:CGPointMake(self.view.tcWidth, 0)];
}

#pragma mark - viewArray
- (NSArray<UIView *> *)viewArray {
    if (_viewArray == nil) {
        NSMutableArray<UIView *> *mArray = [NSMutableArray new];
        for(int i = 1; i < JKSpashCount; i++) {
            [mArray addObject:[self viewWithCount:i]];
        }
        [mArray addObject:self.viewEnd];
        _viewArray = [mArray copy];
    }
    return _viewArray;
}

#pragma mark - views
- (UIView *)viewWithCount:(int)count {
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.text = [NSString stringWithFormat:@"%d", count];
    label.textAlignment = NSTextAlignmentCenter;
    label.tcBottom = self.view.tcHeight;
    view.backgroundColor = RANDOM_COLOR;
    [view addSubview:label];
    return view;
}

- (UIView *)viewEnd {
    if (_viewEnd == nil) {
        _viewEnd = [[UIView alloc] initWithFrame:self.view.bounds];
        _viewEnd.backgroundColor = RANDOM_COLOR;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        label.text = [NSString stringWithFormat:@"%d", JKSpashCount];
        label.textAlignment = NSTextAlignmentCenter;
        label.tcBottom = self.view.tcHeight;
        [_viewEnd addSubview:self.button];
        [_viewEnd addSubview:label];
    }
    return _viewEnd;
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
        _button.tcCenterX = _viewEnd.tcCenterX;
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
        _pageControl.numberOfPages = JKSpashCount;
        _pageControl.currentPage = 0;
        _pageControl.tcCenterX = self.view.tcCenterX;
        _pageControl.tcBottom = self.view.tcHeight - SCALE_HEIGHT(30);
    }
    return _pageControl;
}

@end
