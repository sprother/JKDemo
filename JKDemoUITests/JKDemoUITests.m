//
//  JKDemoUITests.m
//  JKDemoUITests
//
//  Created by jackyjiao on 3/9/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface JKDemoUITests : XCTestCase

@end

@implementation JKDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    // [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    NSLog(@"===setUp");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    NSLog(@"===tearDown");
}

- (void)testUIExample {
    //启动被测App
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    //点击tableView的动画cell
    [app.tables.staticTexts[@"动画"] tap];
    [app.navigationBars[@"动画"].buttons[@"工具"] tap];
    [app.tables.staticTexts[@"退出登录"] tap];
    
    
    app = [[XCUIApplication alloc] init];
    //点击账号输入框
    XCUIElement *textField = app.textFields[@"账号"];
    [textField tap];
    //在账号输入框输入文本
    [textField typeText:@"123"];
    
    textField = app.secureTextFields[@"密码"];
    [textField tap];
    [textField typeText:@"asd"];
    
    //点击登录按钮
    [app.buttons[@"Login"] tap];
}

@end

