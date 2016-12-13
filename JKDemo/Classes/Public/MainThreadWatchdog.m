//
//  MainThreadWatchdog.m
//  miniStation
//
//  Created by jayceyang on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "MainThreadWatchdog.h"

@interface MainThreadWatchdog ()

@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic) CFRunLoopObserverRef observer;
@property (nonatomic) CFRunLoopActivity activity;
@property (nonatomic) NSUInteger timeoutCount;

@end

@implementation MainThreadWatchdog

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public

+ (instancetype)sharedWatchdog {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startWithHandler:(void (^)(void))handler {
    if (!self->_observer) {
        self.semaphore = dispatch_semaphore_create(0);
        
        CFRunLoopObserverContext context;
        memset (&context, 0, sizeof (context));
        context.info = (__bridge void *)(self);
        self->_observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallback, &context);
        CFRunLoopAddObserver(CFRunLoopGetMain(), self->_observer, kCFRunLoopCommonModes);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (YES) {
                long result = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)));
                if (result != 0) {
                    if (self.activity == kCFRunLoopBeforeSources || self.activity == kCFRunLoopAfterWaiting) {
                        if (++ self.timeoutCount < 3) {
                            continue;
                        } else {
                            // Callback
                            if (handler) {
                                handler();
                            }
                        }
                    }
                }
                self.timeoutCount = 0;
            }
        });
    }
    
}

- (void)stop {
    if (self->_observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self->_observer, kCFRunLoopCommonModes);
        CFRelease(self->_observer);
        self->_observer = NULL;
    }
}

#pragma mark - Run loop callback

static void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    MainThreadWatchdog *watchdog = (__bridge MainThreadWatchdog *)(info);
    watchdog.activity = activity;
    dispatch_semaphore_t semaphore = watchdog.semaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
