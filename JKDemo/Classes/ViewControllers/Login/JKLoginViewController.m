//
//  LoginViewController.m
//  TabDemo
//
//  Created by jackyjiao on 3/13/15.
//  Copyright (c) 2015 jackyjiao. All rights reserved.
//
#import "JKAppDelegate+MainUI.h"
#import "JKLoginViewController.h"

@interface JKLoginViewController ()
{
    UIButton *_btn1;
    UITextField *textfield1, *textfield2;
}
@end

@implementation JKLoginViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    UIImage *bgImage = [UIImage imageNamed:@"login_bg.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    //button
    _btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _btn1.frame = CGRectMake(10, 250, screenSize.size.width-20, 50);
    _btn1.layer.cornerRadius = 10;
    [_btn1 setBackgroundColor:[UIColor colorWithRed:10/255.0f green:172/255.0f  blue:240/255.0f alpha:1.0f]];
    [_btn1 setTitle:@"Login" forState:UIControlStateNormal];
    _btn1.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [_btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btn1];
    //
    textfield1=[[UITextField alloc]init];
    //    textfield1.frame=CGRectMake(0, 130, screenSize.size.width, 50);
    textfield1.borderStyle=UITextBorderStyleRoundedRect;
    textfield1.clearButtonMode = UITextFieldViewModeWhileEditing;//编辑时会出现个修改x(删除)
    //[textfield1 addTarget:self action:nil forControlEvents:UIControlEventEditingDidEndOnExit];
    textfield1.placeholder = @"账号";
    textfield1.keyboardType = UIKeyboardTypeNumberPad;//键盘样式，输入数字
    textfield1.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:textfield1];
    
    textfield2=[[UITextField alloc]init];
    //    textfield2.frame=CGRectMake(0, 180, screenSize.size.width, 50);
    textfield2.borderStyle=UITextBorderStyleRoundedRect;//圆角矩形输入框
    textfield2.clearButtonMode = UITextFieldViewModeAlways;//始终会出现个修改x(删除)
    [textfield2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventEditingDidEndOnExit];//回车响应函数
    textfield2.secureTextEntry = YES;//密码框，不显示明文
    textfield2.placeholder = @"密码";//默认显示的文字
    textfield2.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
    [self.view addSubview:textfield2];
    //
    textfield1.translatesAutoresizingMaskIntoConstraints = NO;
    textfield2.translatesAutoresizingMaskIntoConstraints = NO;
    _btn1.translatesAutoresizingMaskIntoConstraints = NO;
    //============textfield1
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield1
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    // 距离顶部130单位
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield1
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1
                              constant:130]];
    // 定义宽度最大为300
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield1
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:0]];
    // 定义高度最小为50
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield1
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                              constant:50]];
    //===========textfield2
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield2
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    // 距离顶部0单位
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield2
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:textfield1
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:0]];
    // 定义宽度最大为300
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield2
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:0]];
    // 定义高度最小为50
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:textfield2
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                              constant:50]];
    //===========btn1
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_btn1
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    // 距离顶部20单位
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_btn1
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:textfield2
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:20]];
    // 定义宽度最大为300
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_btn1
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:-10]];
    // 定义高度最小为50
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_btn1
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                              constant:50]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//点击空白处隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)btn1Click:sender{
    JLog(@"Login button1 clicked.");
    if ([textfield1.text isEqualToString:@"123"] &&  [textfield2.text isEqualToString:@"asd"]){
        [USER_DEFAULT setBool:YES forKey:@"hasLogin"];
        [[JKAppDelegate shareInstance] showMainViewAnimated:NO];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"账号或者密码错误！\n账号123,密码asd。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
