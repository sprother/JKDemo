//
//  JKMemoTest.m
//  JKDemo
//
//  Created by jackyjiao on 2018/5/2.
//  Copyright © 2018年 jackyjiao. All rights reserved.
//

#import "JKMemoTest.h"
#import <mach/mach.h>

@interface JKMemoTest ()

@property (nonatomic, assign) BOOL isStop;

@end


@implementation JKMemoTest

+ (instancetype)sharedInstance {
    static JKMemoTest *_instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[JKMemoTest alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    if ([super init]) {
        _isStop = YES;
    }
    return self;
}

#pragma mark - Interface
- (void)start {
    _isStop = NO;
    [self measureOnce];
}

- (void)measureOnce {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_isStop) {
            [self measureResidentMemory];
            [self availableMemory];
            [self measureOnce];
        }
    });
}

- (void)stop {
    _isStop = YES;
}

- (double)measureResidentMemory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info,                                    &size);
    double vm = 0.f;
    if( kerr == KERN_SUCCESS ) {
        vm = (double)info.resident_size/1024.f/1024.f;
        NSLog(@"===========");
        NSLog(@"virtual memory (in MB): %gMB", (double)info.virtual_size/1024.f/1024.f);
        NSLog(@"resident memory in use (in MB): %gMB", (double)info.resident_size/1024.f/1024.f);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    return vm;
    
}

- (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        NSLog(@"availableMemory Error with NSNotFound");
        return NSNotFound;
    }
    NSLog(@"availableMemory (in MB): %gMB", ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0);
    NSLog(@"===========");
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
    
}
@end
