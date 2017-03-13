//
//  JKDemoUITests.m
//  JKDemoUITests
//
//  Created by jackyjiao on 3/9/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <WebDriverAgentLib/FBApplication.h>

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
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    FBApplication *app;
    XCUIElement *textField;
    app = [[FBApplication alloc] initPrivateWithPath:nil bundleID:@"com.tencent.imsdk.JKDemo"];
    app.fb_shouldWaitForQuiescence = YES;
    
    [app launch];
    [app.tables.staticTexts[@"动画"] tap];
    [app.navigationBars[@"动画"].buttons[@"工具"] tap];
    
    [app.tables.staticTexts[@"退出登录"] tap];
    
    app = [[FBApplication alloc] initPrivateWithPath:nil bundleID:@"com.tencent.imsdk.JKDemo"];
    app.fb_shouldWaitForQuiescence = YES;
    textField = app.textFields[@"账号"];
    [textField tap];
    [textField typeText:@"123"];
    
    textField = app.secureTextFields[@"密码"];
    [textField tap];
    [textField typeText:@"asd"];
    
    [app.buttons[@"Login"] tap];
    [app terminate];
    
    app = [[FBApplication alloc] initPrivateWithPath:nil bundleID:@"com.tencent.mqq"];
    app.fb_shouldWaitForQuiescence = YES;
    
    [app launch];
    
    textField = app.textFields[@"QQ号, 或 手机号, 或 邮箱"];
    [textField tap];
    [textField typeText:@"123"];
    
    textField = app.secureTextFields[@"密码"];
    [textField tap];
    [textField typeText:@"asdfghjkhkj"];
    [app.buttons[@"登录按钮"] tap];
    
    [app terminate];
    
    
    
    app = [[FBApplication alloc] initPrivateWithPath:nil bundleID:@"com.netmarble.penta"];
    app.fb_shouldWaitForQuiescence = YES;
    
    [app launch];
    
    [app.buttons[@"Facebook"] tap];
    
    [app.tables.staticTexts[@"登录"] tap];
    
    app = [FBApplication fb_activeApplication];
    [app.buttons[@"确定"] tap];
    
    app = [FBApplication fb_activeApplication];
    [app.buttons[@"GameCenter"] tap];
    
}

@end

