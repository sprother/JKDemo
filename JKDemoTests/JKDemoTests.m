//
//  JKDemoTests.m
//  JKDemoTests
//
//  Created by jackyjiao on 3/22/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface JKDemoTests : XCTestCase

@end

@implementation JKDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSLog(@"testExample");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

////报错,XCTest中无法调用XCUITest
//- (void)testUIExample {
//    //启动被测App
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    [app launch];
//    
//    //点击tableView的动画cell
//    [app.tables.staticTexts[@"动画"] tap];
//    [app.navigationBars[@"动画"].buttons[@"工具"] tap];
//    [app.tables.staticTexts[@"退出登录"] tap];
//    
//    
//    app = [[XCUIApplication alloc] init];
//    //点击账号输入框
//    XCUIElement *textField = app.textFields[@"账号"];
//    [textField tap];
//    //在账号输入框输入文本
//    [textField typeText:@"123"];
//    
//    textField = app.secureTextFields[@"密码"];
//    [textField tap];
//    [textField typeText:@"asd"];
//    
//    //点击登录按钮
//    [app.buttons[@"Login"] tap];
//}

@end
