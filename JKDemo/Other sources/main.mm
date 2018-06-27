//
//  main.m
//  JKDemo
//
//  Created by jackyjiao on 12/6/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([JKAppDelegate class]));
    }
}


//#import <UIKit/UIKit.h>
//#import "JKAppDelegate.h"
//#include <string>
//#include <vector>
//
//using namespace std;
//
//#if __has_feature(cxx_noexcept)
//#define OPERATOR_NEW_THROW_SPEC
//#else
//#define OPERATOR_NEW_THROW_SPEC throw (std::bad_alloc)
//#endif
//#define OPERATOR_DELETE_THROW_SPEC _NOEXCEPT
//#define OPERATOR_NEW_NOTHROW_SPEC  _NOEXCEPT
//#define OPERATOR_DELETE_NOTHROW_SPEC  _NOEXCEPT
//
//void* operator new  ( size_t Size                        ) OPERATOR_NEW_THROW_SPEC
//{
//    void* ptr = malloc( Size );
//    printf("malloc addr = %p\n",ptr);
//    return ptr;
//    
//}
//void* operator new[]( size_t Size                        ) OPERATOR_NEW_THROW_SPEC
//{
//    void* ptr = malloc( Size );
//    printf("malloc 1 addr = %p\n",ptr);
//    return ptr;
//    
//}
//void* operator new  ( size_t Size, const std::nothrow_t& ) OPERATOR_NEW_NOTHROW_SPEC
//{
//    void* ptr = malloc( Size );
//    printf("malloc  2 addr = %p\n",ptr);
//    return ptr;
//    
//}
//void* operator new[]( size_t Size, const std::nothrow_t& ) OPERATOR_NEW_NOTHROW_SPEC
//{
//    void* ptr = malloc( Size );
//    printf("malloc 3 addr = %p\n",ptr);
//    return ptr;
//    
//}
//
//void operator delete  ( void* Ptr )                                                 OPERATOR_DELETE_THROW_SPEC
//{
//    printf("free addr = %p\n",Ptr);
//    free(Ptr);
//}
//void operator delete[]( void* Ptr )                                                 OPERATOR_DELETE_THROW_SPEC
//{
//    printf("free 1 addr = %p\n",Ptr);
//    free(Ptr);
//}
//
//void operator delete  ( void* Ptr, const std::nothrow_t& )                          OPERATOR_DELETE_NOTHROW_SPEC { free(Ptr); }
//void operator delete[]( void* Ptr, const std::nothrow_t& )                          OPERATOR_DELETE_NOTHROW_SPEC { free(Ptr); }
//void operator delete  ( void* Ptr, size_t Size )                                    OPERATOR_DELETE_THROW_SPEC   { free(Ptr); }
//void operator delete[]( void* Ptr, size_t Size )                                    OPERATOR_DELETE_THROW_SPEC   { free(Ptr); }
//void operator delete  ( void* Ptr, size_t Size, const std::nothrow_t& )             OPERATOR_DELETE_NOTHROW_SPEC { free(Ptr); }
//void operator delete[]( void* Ptr, size_t Size, const std::nothrow_t& )             OPERATOR_DELETE_NOTHROW_SPEC { free(Ptr); }
//
//
//
//void testMemory()
//{
//    string str;
//    for(int i = 0;i < 100;i++)
//    {
//        str.push_back('c');
//        str.push_back('c');
//        str.push_back('c');
//    }
//    NSLog(@"pppp str = %s,%p",str.c_str(),str.c_str());
//    return;
//}
//
//int main(int argc, char * argv[]) {
//    testMemory();
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([JKAppDelegate class]));
//    }
//}

