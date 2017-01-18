//
//  http://www.jianshu.com/p/5016b72c52bd
//  JKDemo
//
//  JKVideoView
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoProgressDelegate <NSObject>

@required
- (void)flushCurrentTime:(NSString *)timeString sliderValue:(float)sliderValue;

@end


@interface JKVideoView : UIView

@property (nonatomic, strong) NSURL                    *playerUrl;
@property (nonatomic, readonly) AVPlayerItem           *item;
@property (nonatomic, readonly) AVPlayerLayer          *playerLayer;
@property (nonatomic, readonly) AVPlayer               *player;
@property (nonatomic, weak) id <VideoProgressDelegate> delegate;

- (id)initWithUrl:(NSURL *)url delegate:(id<VideoProgressDelegate>)delegate;

@end

