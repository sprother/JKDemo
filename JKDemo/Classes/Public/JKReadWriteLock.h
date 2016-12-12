//
//  JKReadWriteLock.h
//  JKDemo
//
//  Created by jackyjiao on 12/9/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//
//  可以使用dispatch_barrier_async栅栏块来同步写操作
//  一个dispatch barrier 允许在一个并发队列中创建一个同步点,当在并发队列中遇到一个barrier, 他会等待所有在barrier之前提交的blocks执行结束,再开始执行barrier block自己。 之后队列继续正常的执行操作。
//
/*
    方案二: 将写操作放入栅栏快中，让他们单独执行；将读取操作并发执行。
 
    _syncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//全局并行队列
 
    - (NSString *)someString {//读取字符串
        __block NSString *localSomeString;
        dispatch_sync(_syncQueue, ^{
            localSomeString = _someString;
        });
        return localSomeString;
    }
 
    - (void)setSomeString:(NSString *)someString {//设置字符串
        dispatch_barrier_async(_syncQueue, ^{//
            _someString = someString;
        });
    }
 */

#import <Foundation/Foundation.h>

@interface JKReadWriteLock : NSObject

- (void)readLock;
- (void)readUnlock;
- (void)writeLock;
- (void)writeUnlock;

@end
