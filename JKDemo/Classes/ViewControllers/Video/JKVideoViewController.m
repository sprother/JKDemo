//
//  JKVideoViewController.m
//  JKDemo
//
//  Created by jackyjiao on 1/17/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import "JKVideoViewController.h"
#import "JKVideoView.h"

@interface JKVideoViewController () <VideoProgressDelegate>

@property (nonatomic, strong) JKVideoView *videoView;
@property (nonatomic, strong) UISlider    *videoSlider;

@end


@implementation JKVideoViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"视频";
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.videoSlider];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
    [super viewDidDisappear:animated];
}

#pragma mark - views' getter
- (JKVideoView *)videoView {
    if (_videoView == nil) {
//        //文件视频
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"some" ofType:@"mp4"];//这个时播放本地的，播放本地的时候还需要改VideoView.m中的代码
//        NSURL *url = [NSURL fileURLWithPath:path];
        
        //网址视频
        NSString *path = @"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA";//这个是播放网络视频
        NSURL    *url  = [NSURL URLWithString:path];
        
        _videoView       = [[JKVideoView alloc] initWithUrl:url delegate:self];
        _videoView.tcTop = DEFAULT_NAVIGATION_BAR_HEIGHT;
    }
    return _videoView;
}

- (UISlider *)videoSlider {
    if (_videoSlider == nil) {
        _videoSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SCREEN_WIDTH, 0)];
        _videoSlider.tcTop = self.videoView.tcBottom;
    }
    return _videoSlider;
}

#pragma mark -
- (void)flushCurrentTime:(NSString *)timeString sliderValue:(float)sliderValue {
    _videoSlider.value = sliderValue;
}

@end

