//
//  ViewController.m
//  RAC
//
//  Created by 栗国聚 on 17/10/29.
//  Copyright © 2017年 July. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


//@import ReactiveCocoa;

@interface ViewController ()
//第一方法
@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)UITextField *passTextfield;

@property (nonatomic,strong)UIButton *loginBtn;


// 第二个方法

@property (nonatomic ,strong)UITextField *redText;

@property (nonatomic ,strong)UITextField *greenText;

@property (nonatomic ,strong)UITextField *blueText;

@property (nonatomic ,strong)UISlider *redProgressView;

@property (nonatomic ,strong)UISlider *greenProgressView;

@property (nonatomic ,strong)UISlider *blueProgressView;

//也是滚动条
@property (nonatomic ,strong)UIProgressView *progressView;

@property (nonatomic ,strong)UIView *changeView;

@property (weak, nonatomic) IBOutlet UITextField *testText;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

//    [self CreatReaSignalText];
    
//    [self changeColor];
//    [self blindProgress:self.redProgressView textField:self.redText];
//    [self blindProgress:self.greenProgressView textField:self.greenText];
//    [self blindProgress:self.blueProgressView textField:self.blueText];
    
    self.testBtn.userInteractionEnabled = NO;
    
    [self createbutton];
    
}



- (void)CreatReaSignalText {
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
    
    self.textField.placeholder = @"请输入帐号";
    
    
    self.passTextfield = [[UITextField alloc]initWithFrame:CGRectMake(100, 160, 200, 40)];
    
    self.passTextfield.placeholder = @"请输入密码";
    
    self.loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginBtn.frame = CGRectMake(180, 230, 80, 40);
    [self.loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
//    self.loginBtn.userInteractionEnabled = NO;
    [self.loginBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.passTextfield];
    [self.view addSubview:self.loginBtn];
    
//1. 所有的都打印
    [self.textField.rac_textSignal subscribeNext:^(id x) {
 
//        NSLog(@"1.%@",x);
    }];
// 2.打印超出3个数的值
    [[self.textField.rac_textSignal filter:^BOOL(id value) {
        NSString *str  = value;
        return str.length > 3;
    }] subscribeNext:^(id x) {
//        NSLog(@"2.%@",x);
    }];
//3.详细写法
    RACSignal *usernameSourceSignal = self.textField.rac_textSignal;
    
    RACSignal *filteredUsername = [usernameSourceSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }];
    
    [filteredUsername subscribeNext:^(id x) {
//        NSLog(@"3.%@",x);
    }];
    
//4.改变事件的结构
    
   [[[self.textField.rac_textSignal map:^id(NSString *text) {
        return @(text.length);
    }] filter:^BOOL(NSNumber *length) {
        return [length integerValue] > 4;
    }] subscribeNext:^(id x) {
        NSLog(@"4.%@",x);
    } ];

//5.改变输入框颜色 这个方法不建议使用
    
    RACSignal *validPasswordSignal = [self.textField.rac_textSignal map:^id(NSString *text) {
        if (text.length == 5) {
            return @(YES);
        }else {
            return @(NO);
        }
    }] ;
    
    [[validPasswordSignal map:^id(NSNumber *passwordVaild) {
        return [passwordVaild boolValue] ? [UIColor redColor] : [UIColor clearColor];
    }] subscribeNext:^(UIColor *color) {
        self.textField.backgroundColor = color;
    }] ;
    
// 6.改变颜色另一种方法
//    RAC(self.textField,backgroundColor) = [];
// 7.两个条件同时满足时才能点击
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.textField.rac_textSignal,self.passTextfield.rac_textSignal]]map:^id(id value) {
        NSLog(@"%@",value);
        return @(([value[0] length] > 0) && ([value[1] length] > 6 ));
    }];
    
    self.loginBtn.rac_command = [[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        NSLog(@"7.%@",input);
        return [RACSignal empty];
    }];
}

- (void)changeColor {
    
    self.redText = [[UITextField alloc]initWithFrame:CGRectMake(350, 100, 60, 25)];
    
    self.redText.borderStyle = UITextBorderStyleRoundedRect;
    self.redText.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    [self.view addSubview:self.redText];
    
    self.redProgressView = [[UISlider alloc]initWithFrame:CGRectMake(50, 100, 250, 10)];
    
    self.redProgressView.value  = 0.5;
    
    [self.view addSubview:self.redProgressView];
    
    self.greenText = [[UITextField alloc]initWithFrame:CGRectMake(350, 200, 60, 25)];
    
    self.greenText.borderStyle = UITextBorderStyleRoundedRect;
    self.greenText.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    [self.view addSubview:self.greenText];
    
    self.greenProgressView = [[UISlider alloc]initWithFrame:CGRectMake(50, 200, 250, 10)];
    
    self.greenProgressView.value = 0.5;
    
    [self.view addSubview:self.greenProgressView];
    
    self.blueText = [[UITextField alloc]initWithFrame:CGRectMake(350, 300, 60, 25)];
    
    self.blueText.borderStyle = UITextBorderStyleRoundedRect;
    self.blueText.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    [self.view addSubview:self.blueText];
    
    self.blueProgressView = [[UISlider alloc]initWithFrame:CGRectMake(50, 300, 250, 10)];
    
    self.blueProgressView.value = 0.5;
    
    [self.view addSubview:self.blueProgressView];
    
    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(50, 400, 300, 300)];
    self.changeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.changeView];
    
}


- (void)blindProgress:(UISlider *)progresss textField:(UITextField *)textField {
    
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    RACChannelTerminal *signalprogress = [progresss rac_newValueChannelWithNilValue:nil];
    [signalText subscribe:signalprogress];
    [[signalprogress map:^id(id value) {
        
         self.changeView.backgroundColor = [UIColor colorWithRed:[self.redText.text floatValue] green:[self.greenText.text floatValue] blue:[self.blueText.text floatValue] alpha:1.0];
        return [NSString stringWithFormat:@"%.02f",[value floatValue]];
    }] subscribe:signalText];
    
   
}

- (void)createbutton {
   
    RACSignal *validPasswordSignal = [self.textField.rac_textSignal map:^id(NSString *text) {
        if (text.length == 5) {
            return @(NO);
        }else {
            return @(YES);
        }
    }] ;
    
    self.loginBtn.rac_command = [[RACCommand alloc]initWithEnabled:validPasswordSignal signalBlock:^RACSignal *(id input) {
        NSLog(@"7.%@",input);
        self.loginBtn.userInteractionEnabled = YES;
        return [RACSignal empty];
    }];

    
}

@end
