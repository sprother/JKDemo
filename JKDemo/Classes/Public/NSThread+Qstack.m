//
//  NSThread+Qstack.m
//  TabDemo
//
//  Created by jackyjiao on 5/14/15.
//  Copyright (c) 2015 jackyjiao. All rights reserved.
//

#import "NSThread+Qstack.h"

static NSDictionary *methodDict = nil;

@implementation NSThread (Qstack)

#pragma mark - saveMethodDict Interface
+ (void)saveMethodDict {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self class] saveMethodDictAction];
    });
}

+ (void)printCallStack {
    NSArray *callStack = [NSThread callStackSymbols];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (methodDict) {
            JLog(@"callQstack : %@", [[self class] translateCallStack:callStack]);
            return;
        }
        JLog(@"callstack : %@", callStack);
    });
}

#pragma mark - generalMethedDict (backQueue)
+ (void)generalMethedDict {
    //获取符号映射表
    NSMutableDictionary *tmpMethodDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    int numClasses;
    Class * classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        unsigned int outMethodCount;
        classes = (Class * )malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i<numClasses; i++) {
            Class classinst = classes[i];
            NSString *className = [NSString stringWithFormat:@"%s",class_getName(classinst)];
            Method *methods = class_copyMethodList(classinst, &outMethodCount);
            for (int j = 0; j < outMethodCount; j++) {
                Method method = methods[j];
                // 获得属性名称
                NSString * attributeName = NSStringFromSelector(method_getName(method));
                NSString *methodInfo = [NSString stringWithFormat:@"[%@ %@]", className, attributeName];
                IMP imp = method_getImplementation(method);
                NSNumber* impAdd = [NSNumber numberWithUnsignedLong:(unsigned long)imp];
                [tmpMethodDict setObject:methodInfo forKey:impAdd];
            }
        }
        free(classes);
    }
    methodDict = tmpMethodDict;//为了避免深拷贝，不用copy
    JLog(@"generalMethedDict finished(total %d class).", numClasses);
    return;
}

#pragma mark - saveMethodDict (backQueue)
+ (NSString *)methodDictFielPath {
    return [DOCUMENT_PATH stringByAppendingPathComponent:@"methodDict.plist"];
}

+ (void)saveMethodDictAction {
    if (!methodDict) {
        [[self class] generalMethedDict];
    }
    NSString* methodDictFielPath = [[self class] methodDictFielPath];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL dir = NO;
    if (![manager fileExistsAtPath:methodDictFielPath isDirectory:&dir]) {
        JLog(@"Qstack create dict file:%@ .", methodDictFielPath);
        [manager createFileAtPath:methodDictFielPath contents:nil attributes:nil];
    }
    //[methodDict writeToFile:methodDictFielPath atomically:YES];
    NSFileHandle *_fileHandle = [NSFileHandle fileHandleForWritingAtPath:methodDictFielPath];
    if (_fileHandle == nil){
        JLog(@"Qstack filehandle is nil when create filehandle.");
        return;
    }
    [_fileHandle seekToFileOffset:0];
    for (NSNumber *key in methodDict) {
        NSString *info = [methodDict objectForKey:key];
        NSString* keyInfo = [NSString stringWithFormat:@"%@ : %@\n", key, info];
        NSData* data = [keyInfo dataUsingEncoding:NSUTF8StringEncoding];
        [_fileHandle writeData:data];
    }
    [_fileHandle synchronizeFile];
    JLog(@"saveMethodDict finished.");
    return;
}

#pragma mark - translateCallStack (backQueue)
+ (NSArray<NSString *> *)translateCallStack:(NSArray<NSString *> *)callStack {
    //还原
    NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSString* regTags = @"(.*)(0x\\w*)(.*) \\+ (\\d+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive    // 还可以加一些选项，例如：不区分大小写
                                                                             error:0];
    for (NSString* pgnText in callStack){
        NSString* newText;
        // 执行匹配的过程
        NSArray *matches = [regex matchesInString:pgnText
                                          options:0
                                            range:NSMakeRange(0, [pgnText length])];
        if (matches)
        {
            NSTextCheckingResult *match = [matches objectAtIndex:0];
            NSString *strProcess = [pgnText substringWithRange:[match rangeAtIndex:1]];
            NSString *strAddress = [pgnText substringWithRange:[match rangeAtIndex:2]];
            NSString *strMethod = [pgnText substringWithRange:[match rangeAtIndex:3]];
            NSString *strOffset = [pgnText substringWithRange:[match rangeAtIndex:4]];
            unsigned long ulong = strtoul([strAddress UTF8String], 0, 16)-strtoul([strOffset UTF8String], 0, 10);
            NSNumber* methodAddr = [NSNumber numberWithUnsignedLong:ulong];
            NSString* destMethod = [methodDict objectForKey:methodAddr];
            if (destMethod) {
                //JLog(@"%@%@ -%@ + %@ - %@", strProcess, strAddress, destMethod, strOffset, strMethod);
                newText = [NSString stringWithFormat:@"%@%@ -%@ + %@ - %@", strProcess, strAddress, destMethod, strOffset, strMethod];
            }
            else {
                newText = [NSString stringWithFormat:@"%@", pgnText];
            }
        }
        else {
            newText = [NSString stringWithFormat:@"%@", pgnText];
        }
        [mArray addObject:newText];
    }
    return [mArray copy];
}

@end
