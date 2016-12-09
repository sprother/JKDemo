//
//  JKReadWriteLock.m
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKReadWriteLock.h"

@interface JKReadWriteLock ()

@property (nonatomic, strong) NSLock *readFlagLock;
@property (nonatomic, assign) NSUInteger readCount;
@property (nonatomic, strong) NSLock *writeFlagLock;

@end

@implementation JKReadWriteLock

- (instancetype)init {
    self = [super init];
    if (self) {
        self.readFlagLock = [[NSLock alloc] init];
        self.readCount = 0;
        self.writeFlagLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)readLock {
    [self.readFlagLock lock];
    
    if (self.readCount == 0) {
        [self.writeFlagLock lock];
    }
    self.readCount++;
    [self.readFlagLock unlock];
}

- (void)readUnlock {
    [self.readFlagLock lock];
    
    self.readCount--;
    if (self.readCount == 0) {
        [self.writeFlagLock unlock];
    }
    
    [self.readFlagLock unlock];
}

- (void)writeLock {
    [self.writeFlagLock lock];
}

- (void)writeUnlock {
    [self.writeFlagLock unlock];
}

@end
