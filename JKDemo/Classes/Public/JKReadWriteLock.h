//
//  JKReadWriteLock.h
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKReadWriteLock : NSObject

- (void)readLock;
- (void)readUnlock;
- (void)writeLock;
- (void)writeUnlock;

@end
