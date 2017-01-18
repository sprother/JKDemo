//
//  http://www.jianshu.com/p/5016b72c52bd
//  JKDemo
//
//  JKVideoView
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPVolumeView.h>
#import "JKVideoView.h"

@interface JKVideoView ()

@property (nonatomic, readwrite) AVPlayerItem  *item;
@property (nonatomic, readwrite) AVPlayerLayer *playerLayer;
@property (nonatomic, readwrite) AVPlayer      *player;
@property (nonatomic, strong)  id              timeObser;
@property (nonatomic, assign) float            videoLength;
@property (nonatomic, assign) CGPoint          lastPoint;

@end

@implementation JKVideoView

- (id)initWithUrl:(NSURL *)url delegate:(id<VideoProgressDelegate>)delegate {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, APPLICATION_SCREEN_WIDTH, APPLICATION_SCREEN_WIDTH*9.0/16.0);
        [self setBackgroundColor:[UIColor blackColor]];
        self.playerUrl = url;
        self.delegate  = delegate;
        [self setUpPlayer];
    }
    return self;
}

- (void)setUpPlayer {
    NSLog(@"video url %@", self.playerUrl);

    self.item                     = [[AVPlayerItem alloc] initWithURL:self.playerUrl];
    self.player                   = [AVPlayer playerWithPlayerItem:self.item];
    self.playerLayer              = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:self.playerLayer];

    [self addVideoKVO];
    [self addVideoTimerObserver];
    [self addVideoNotic];
}

#pragma mark - KVO
- (void)addVideoKVO {
    //KVO
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeVideoKVO {
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = self.item.status;
        switch (status) {
        case AVPlayerItemStatusReadyToPlay:
        {
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            [self.player play];
            self.videoLength = floor(self.item.asset.duration.value * 1.0/ self.item.asset.duration.timescale);
        }
        break;
        case AVPlayerItemStatusUnknown:
        {
            NSLog(@"AVPlayerItemStatusUnknown");
        }
        break;
        case AVPlayerItemStatusFailed:
        {
            NSLog(@"AVPlayerItemStatusFailed");
            NSLog(@"%@", self.item.error);
        }
        break;
        default:
            break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
    }
}

#pragma mark - Notification
- (void)addVideoNotic {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieJumped:) name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStalle:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backGroundPauseMoive) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeVideoNotic {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)movieToEnd:(NSNotification *)notic {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)movieJumped:(NSNotification *)notic {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)movieStalle:(NSNotification *)notic {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)backGroundPauseMoive {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - TimerObserver
- (void)addVideoTimerObserver {
    __weak typeof (self) weakSelf = self;
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        float currentTimeValue = time.value*1.0/time.timescale/weakSelf.videoLength;
        NSString *currentString = [weakSelf getStringFromCMTime:time];
        NSLog(@"VideoTimerObserver currentTimeValue(%f), currentString(%@)", currentTimeValue, currentString);
        if (currentTimeValue > 1.0 || currentTimeValue < 0) {
            return;
        }

        if ([weakSelf.delegate respondsToSelector:@selector(flushCurrentTime:sliderValue:)]) {
         [weakSelf.delegate flushCurrentTime:currentString sliderValue:currentTimeValue];
        } else {
         NSLog(@"VideoTimerObserver no delegate");
        }
    }];
}

- (void)removeVideoTimerObserver {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.player removeTimeObserver:self.timeObser];
}

#pragma mark - Utils
- (NSString *)getStringFromCMTime:(CMTime)time {
    float currentTimeValue = (CGFloat)time.value/time.timescale;//得到当前的播放时间

    NSDate           *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTimeValue];
    NSCalendar       *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger        unitFlags    = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components  = [calendar components:unitFlags fromDate:currentDate];

    if (currentTimeValue >= 3600) {
        return [NSString stringWithFormat:@"%ld:%ld:%ld", components.hour, components.minute, components.second];
    } else {
        return [NSString stringWithFormat:@"%ld:%ld", components.minute, components.second];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - release
- (void)dealloc {
    NSLog(@"JKVideoView %@", NSStringFromSelector(_cmd));
    [self removeVideoTimerObserver];
    [self removeVideoNotic];
    [self removeVideoKVO];
}

@end


