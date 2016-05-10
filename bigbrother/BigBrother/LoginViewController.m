//
//  LoginViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/27.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

#import "TPKeyboardAvoidingScrollView.h"


@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController{
    TPKeyboardAvoidingScrollView *contentView;
    
    UITextField *userLoginNameTextField;
    UITextField *passwordTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    contentView = [[TPKeyboardAvoidingScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    float noteLabelOffset = 5;
    if (IS4_7Inches()) {
        noteLabelOffset = 10;
    }else if (IS5_5Inches()){
        noteLabelOffset = 20;
    }
    
    
    UILabel *loginNoteLabel = [[UILabel alloc] init];
    loginNoteLabel.frame = (CGRect){0,noteLabelOffset,WIDTH(contentView),30};
    loginNoteLabel.text = @"每日登录有点数赠送哦";
    loginNoteLabel.textColor = RGBColor(251, 0, 6);
    loginNoteLabel.textAlignment = NSTextAlignmentCenter;
    loginNoteLabel.font = Font(13);
    [contentView addSubview:loginNoteLabel];
    
    float loginTextFieldOffset = BOTTOM(loginNoteLabel);
    if (IS4_7Inches()) {
        loginTextFieldOffset = BOTTOM(loginNoteLabel)+10;
    }else if (IS5_5Inches()){
        loginTextFieldOffset = BOTTOM(loginNoteLabel)+20;
    }
    
    userLoginNameTextField = [[UITextField alloc] init];
    userLoginNameTextField.backgroundColor = [UIColor whiteColor];
    userLoginNameTextField.frame = (CGRect){15,loginTextFieldOffset,(WIDTH(contentView)-15*2),45};
    userLoginNameTextField.textColor = RGBColor(100, 100, 100);
    userLoginNameTextField.font = Font(15);
    userLoginNameTextField.tag = 100;
    userLoginNameTextField.delegate = self;
    userLoginNameTextField.returnKeyType = UIReturnKeyDone;
    userLoginNameTextField.keyboardType = UIKeyboardTypePhonePad;
    userLoginNameTextField.placeholder = @"手机号码";
    [userLoginNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [userLoginNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    userLoginNameTextField.layer.cornerRadius = 2.f;
    userLoginNameTextField.layer.masksToBounds = YES;
    [contentView addSubview:userLoginNameTextField];
    
    UIImage *userLoginLeftImage = [UIImage imageNamed:@"login_loginname"];
    
    UIView *userLoginLeftView = [[UIView alloc] init];
    userLoginLeftView.backgroundColor = userLoginNameTextField.backgroundColor;
    userLoginLeftView.frame = (CGRect){0,0,20+10*2,HEIGHT(userLoginNameTextField)};
    UIImageView *userLoginLeftImageView = [[UIImageView alloc] initWithImage:userLoginLeftImage];
    userLoginLeftImageView.frame = (CGRect){10,(HEIGHT(userLoginLeftView)-userLoginLeftImage.size.height)/2,userLoginLeftImage.size.width,userLoginLeftImage.size.height};
    [userLoginLeftView addSubview:userLoginLeftImageView];
    userLoginNameTextField.leftView = userLoginLeftView;
    userLoginNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    float passwordTextFieldOffset = BOTTOM(userLoginNameTextField)+10;
    
    passwordTextField = [[UITextField alloc] init];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.frame = (CGRect){15,passwordTextFieldOffset,(WIDTH(contentView)-15*2),45};
    passwordTextField.textColor = RGBColor(100, 100, 100);
    passwordTextField.font = Font(15);
    passwordTextField.tag = 101;
    passwordTextField.delegate = self;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTextField.placeholder = @"密码";
    passwordTextField.secureTextEntry = YES;
    [passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    passwordTextField.layer.cornerRadius = 2.f;
    passwordTextField.layer.masksToBounds = YES;
    [contentView addSubview:passwordTextField];
    
    UIImage *passwordLeftImage = [UIImage imageNamed:@"login_password"];
    UIView *passwordLeftView = [[UIView alloc] init];
    passwordLeftView.backgroundColor = passwordTextField.backgroundColor;
    passwordLeftView.frame = (CGRect){0,0,20+10*2,HEIGHT(passwordTextField)};
    UIImageView *passwordLeftImageView = [[UIImageView alloc] initWithImage:passwordLeftImage];
    passwordLeftImageView.frame = (CGRect){10,(HEIGHT(passwordLeftView)-passwordLeftImage.size.height)/2,passwordLeftImage.size.width,passwordLeftImage.size.height};
    [passwordLeftView addSubview:passwordLeftImageView];
    passwordTextField.leftView = passwordLeftView;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = (CGRect){15,BOTTOM(passwordTextField)+15,WIDTH(contentView)-15*2,45};
    loginButton.backgroundColor = BB_BlueColor;
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = Font(15);
    loginButton.layer.cornerRadius = 4.f;
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:loginButton];
    
    
    UILabel *registeLabel = [[UILabel alloc] init];
    registeLabel.frame = (CGRect){15,BOTTOM(loginButton)+15,28,15};
    registeLabel.text = @"注册";
    registeLabel.textColor = BB_BlueColor;
    registeLabel.font = Font(14);
    registeLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:registeLabel];
    
    UIView *registeUnderlineView = [[UIView alloc] init];
    registeUnderlineView.frame = (CGRect){15,BOTTOM(registeLabel)+1,WIDTH(registeLabel),1};
    registeUnderlineView.backgroundColor = BB_BlueColor;
    [contentView addSubview:registeUnderlineView];
    
    registeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *registeLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registeLabelTapTrigger)];
    [registeLabel addGestureRecognizer:registeLabelTap];
    
    UILabel *forgetPasswordLabel = [[UILabel alloc] init];
    forgetPasswordLabel.frame = (CGRect){WIDTH(contentView)-15-56,BOTTOM(loginButton)+15,56,15};
    forgetPasswordLabel.text = @"忘记密码";
    forgetPasswordLabel.textColor = BB_BlueColor;
    forgetPasswordLabel.font = Font(14);
    forgetPasswordLabel.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:forgetPasswordLabel];
    
    UIView *forgetPasswordUnderlineView = [[UIView alloc] init];
    forgetPasswordUnderlineView.frame = (CGRect){WIDTH(contentView)-15-56,BOTTOM(forgetPasswordLabel)+1,WIDTH(forgetPasswordLabel),1};
    forgetPasswordUnderlineView.backgroundColor = BB_BlueColor;
    [contentView addSubview:forgetPasswordUnderlineView];
    
    forgetPasswordLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgetPasswordLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordLabelTapTrigger)];
    [forgetPasswordLabel addGestureRecognizer:forgetPasswordLabelTap];
}

-(void)loginButtonClick{
    NSString *loginNameString = userLoginNameTextField.text;
    if (!loginNameString || [loginNameString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"手机号码不能为空"];
        return;
    }
    if (![XYTools checkString:loginNameString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"输入的手机号码不能包含特殊字符"];
        return;
    }
    
    NSString *passwordString = passwordTextField.text;
    if (!passwordString || [passwordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"密码不能为空"];
        return;
    }
    if (![XYTools checkString:passwordString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"密码不能包含特殊字符"];
        return;
    }
    [BYToastView showToastWithMessage:@"正在登录..."];
    [BBUrlConnection loginUserWithLoginName:loginNameString password:passwordString complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if ([resultDic[@"code"] intValue] != 0) {
            [BYToastView showToastWithMessage:@"注册登录,请稍候再试"];
            return;
        }
        NSDictionary *dataDic = resultDic[@"data"];
        if (!dataDic || ![dataDic isKindOfClass:[NSDictionary class]]) {
            [BYToastView showToastWithMessage:@"注册登录,请稍候再试"];
            return;
        }
        NSString *idString = dataDic[@"id"];
        if (idString) {
            //登录环信
            [BYToastView showToastWithMessage:@"正在连接聊天服务器~"];
            EMError *error = [[EMClient sharedClient] loginWithUsername:dataDic[@"imNumber"] password:@"123456"];
            if (error) {
                [BYToastView showToastWithMessage:@"聊天服务器连接失败~"];
            }
            
            if ([idString isKindOfClass:[NSNumber class]]) {
                idString = [NSString stringWithFormat:@"%ld",(long)[idString longLongValue]];
            }
//            [BYToastView showToastWithMessage:@"登录成功"];
            
            [BBUserDefaults resetLoginStatus];
            
            [BBUserDefaults setUserDictionary:dataDic];//存储用户信息
            [BBUserDefaults setUserID:idString];
            [BBUserDefaults setIsLogin:YES];
            [BBUserDefaults setUserPassword:passwordString];
            NSString *phoneNumber = dataDic[@"phoneNumber"];
            if (phoneNumber && [phoneNumber isKindOfClass:[NSString class]]) {
                [BBUserDefaults setUserPhone:phoneNumber];
            }
            NSString *lastLoginTime = dataDic[@"lastLoginTime"];
            if (lastLoginTime && [lastLoginTime isKindOfClass:[NSString class]]) {
                [BBUserDefaults setUserLastLoginTime:lastLoginTime];
                [BBUserDefaults setUserIsSigned:[self judgeIfCheckSigned:lastLoginTime]];
            }
            
            NSString *username = dataDic[@"username"];
            if (username && [username isKindOfClass:[NSString class]]) {
                [BBUserDefaults setUserUserName:username];
            }
            
            [self leftItemClick];
            return;
        }
        [BYToastView showToastWithMessage:@"登录失败,请稍候再试"];
        return;
    }];
}

-(long long)parseTimeStringToTimestamp:(NSString *)dateString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:dateString];
    return [date timeIntervalSince1970];
}

-(BOOL)judgeIfCheckSigned:(NSString *)lastLoginTime{
    long long lastTimeStamp = [self parseTimeStringToTimestamp:lastLoginTime];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:1*24*60*60]];
    long day=[comps day];
    long year=[comps year];
    long month=[comps month];
    NSString *tomorrowString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:01",year,month,day];
    long long tomorrowTimeStamp = [self parseTimeStringToTimestamp:tomorrowString];
    if (tomorrowTimeStamp - lastTimeStamp >= 1*24*60*60) {
        return NO;
    }else{
        return YES;
    }
}

-(void)registeLabelTapTrigger{
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}

-(void)forgetPasswordLabelTapTrigger{
    [self.navigationController pushViewController:[ForgetPasswordViewController new] animated:YES];
}

-(void)resignAllInputs{
    [userLoginNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.navigationItem.title = @"登录";
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
    if (contentView) {
        NSString *userName = [BBUserDefaults getUserPhone];
        if (userName) {
            userLoginNameTextField.text= userName;
            [passwordTextField resignFirstResponder];
        }else{
            userLoginNameTextField.text = @"";
            passwordTextField.text = @"";
            [userLoginNameTextField resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)loginEMClient
//{
//    
//}

@end
