//
//  ForgetPasswordViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/28.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#import "TPKeyboardAvoidingScrollView.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController{
    
    UITextField *userLoginNameTextField;
    UITextField *codeTextField;
    UITextField *passwordTextField;
    UITextField *passwordRepeatTextField;
    
    
    UIButton *sendCodeButton;
    
    NSString *globalCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    TPKeyboardAvoidingScrollView *contentView = [[TPKeyboardAvoidingScrollView alloc] init];
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
    loginNoteLabel.text = @"新用户注册赠送点数";
    loginNoteLabel.textColor = RGBColor(251, 0, 6);
    loginNoteLabel.textAlignment = NSTextAlignmentCenter;
    loginNoteLabel.font = Font(13);
    [contentView addSubview:loginNoteLabel];
    
    float loginTextFieldOffset = BOTTOM(loginNoteLabel)+5;
    
    userLoginNameTextField = [[UITextField alloc] init];
    userLoginNameTextField.backgroundColor = [UIColor whiteColor];
    userLoginNameTextField.frame = (CGRect){15,loginTextFieldOffset,(WIDTH(contentView)-15*2),45};
    userLoginNameTextField.textColor = RGBColor(100, 100, 100);
    userLoginNameTextField.font = Font(15);
    userLoginNameTextField.returnKeyType = UIReturnKeyDone;
    userLoginNameTextField.placeholder = @"邮箱";
    userLoginNameTextField.keyboardType = UIKeyboardTypePhonePad;
    [userLoginNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [userLoginNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    userLoginNameTextField.layer.cornerRadius = 2.f;
    userLoginNameTextField.layer.masksToBounds = YES;
    [contentView addSubview:userLoginNameTextField];
    if ([BBUserDefaults getUserPhone]) {
        userLoginNameTextField.text = [BBUserDefaults getUserPhone];
    }
    
    UIImage *userLoginLeftImage = [UIImage imageNamed:@"login_loginname"];
    
    UIView *userLoginLeftView = [[UIView alloc] init];
    userLoginLeftView.backgroundColor = userLoginNameTextField.backgroundColor;
    userLoginLeftView.frame = (CGRect){0,0,20+10*2,HEIGHT(userLoginNameTextField)};
    UIImageView *userLoginLeftImageView = [[UIImageView alloc] initWithImage:userLoginLeftImage];
    userLoginLeftImageView.frame = (CGRect){10,(HEIGHT(userLoginLeftView)-userLoginLeftImage.size.height)/2,userLoginLeftImage.size.width,userLoginLeftImage.size.height};
    [userLoginLeftView addSubview:userLoginLeftImageView];
    userLoginNameTextField.leftView = userLoginLeftView;
    userLoginNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    codeTextField = [[UITextField alloc] init];
    codeTextField.backgroundColor = [UIColor whiteColor];
    codeTextField.frame = (CGRect){15,BOTTOM(userLoginNameTextField)+10,(WIDTH(contentView)-15*2)-120-10,40};
    codeTextField.textColor = RGBColor(100, 100, 100);
    codeTextField.font = Font(15);
    codeTextField.returnKeyType = UIReturnKeyDone;
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.placeholder = @"验证码";
    [codeTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [codeTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    codeTextField.layer.cornerRadius = 2.f;
    codeTextField.layer.masksToBounds = YES;
    [contentView addSubview:codeTextField];
    
    sendCodeButton = [[UIButton alloc] init];
    sendCodeButton.frame = (CGRect){WIDTH(contentView)-15-120,BOTTOM(userLoginNameTextField)+10,120,40};
    [sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
    sendCodeButton.titleLabel.font = Font(16);
    sendCodeButton.layer.borderWidth = 1.f;
    sendCodeButton.layer.cornerRadius = 3.f;
    sendCodeButton.layer.masksToBounds = YES;
    [contentView addSubview:sendCodeButton];
    
    [sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *codeLeftView = [[UIView alloc] init];
    codeLeftView.frame = (CGRect){0,0,5,HEIGHT(codeTextField)};
    codeLeftView.backgroundColor = codeTextField.backgroundColor;
    codeTextField.leftView = codeLeftView;
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    passwordTextField = [[UITextField alloc] init];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.frame = (CGRect){15,BOTTOM(codeTextField)+10,(WIDTH(contentView)-15*2),45};
    passwordTextField.textColor = RGBColor(100, 100, 100);
    passwordTextField.font = Font(15);
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
    
    passwordRepeatTextField = [[UITextField alloc] init];
    passwordRepeatTextField.backgroundColor = [UIColor whiteColor];
    passwordRepeatTextField.frame = (CGRect){15,BOTTOM(passwordTextField)+10,(WIDTH(contentView)-15*2),45};
    passwordRepeatTextField.textColor = RGBColor(100, 100, 100);
    passwordRepeatTextField.font = Font(15);
    passwordRepeatTextField.returnKeyType = UIReturnKeyDone;
    passwordRepeatTextField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordRepeatTextField.placeholder = @"重复密码";
    passwordRepeatTextField.secureTextEntry = YES;
    [passwordRepeatTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [passwordRepeatTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    passwordRepeatTextField.layer.cornerRadius = 2.f;
    passwordRepeatTextField.layer.masksToBounds = YES;
    [contentView addSubview:passwordRepeatTextField];
    
    UIView *passwordRepeatLeftView = [[UIView alloc] init];
    passwordRepeatLeftView.backgroundColor = passwordTextField.backgroundColor;
    passwordRepeatLeftView.frame = (CGRect){0,0,20+10*2,HEIGHT(passwordTextField)};
    UIImageView *passwordRepeatLeftImageView = [[UIImageView alloc] initWithImage:passwordLeftImage];
    passwordRepeatLeftImageView.frame = (CGRect){10,(HEIGHT(passwordRepeatLeftView)-passwordLeftImage.size.height)/2,passwordLeftImage.size.width,passwordLeftImage.size.height};
    [passwordRepeatLeftView addSubview:passwordRepeatLeftImageView];
    
    passwordRepeatTextField.leftView = passwordRepeatLeftView;
    passwordRepeatTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = (CGRect){15,BOTTOM(passwordRepeatTextField)+15,WIDTH(contentView)-15*2,45};
    doneButton.backgroundColor = BB_BlueColor;
    [doneButton setTitle:@"提交" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = Font(15);
    doneButton.layer.cornerRadius = 4.f;
    doneButton.layer.masksToBounds = YES;
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:doneButton];
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, BOTTOM(doneButton)+50)};
}

-(void)doneButtonClick{
    NSString *loginNameString = userLoginNameTextField.text;
    if (!loginNameString || [loginNameString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"邮箱不能为空"];
        return;
    }
    if (![XYTools checkString:loginNameString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"输入的邮箱不能包含特殊字符"];
        return;
    }
    
    NSString *codeString = codeTextField.text;
    
    if (!codeString || [codeString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"验证码不能为空"];
        return;
    }
    if (![XYTools checkString:codeString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"验证码不能包含特殊字符"];
        return;
    }
    if ([codeString isEqualToString:globalCode]) {
        [BYToastView showToastWithMessage:@"验证码不正确"];
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
    
    NSString *passwordRepeatString = passwordRepeatTextField.text;
    if (!passwordRepeatString || [passwordRepeatString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"重复密码不能为空"];
        return;
    }
    if (![XYTools checkString:passwordRepeatString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"重复密码不能包含特殊字符"];
        return;
    }
    if (![passwordRepeatString isEqualToString:passwordString]) {
        [BYToastView showToastWithMessage:@"两次输入的密码不一致"];
        return;
    }
    
    [BYToastView showToastWithMessage:@"正在提交,请稍候..."];
    [BBUrlConnection resetUserPasswordWithLoginName:loginNameString password:passwordString complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if ([resultDic[@"code"] intValue] != 0) {
            [BYToastView showToastWithMessage:@"重置密码失败,请稍候再试"];
            return;
        }
        NSDictionary *dataDic = resultDic[@"data"];
        if (!dataDic || ![dataDic isKindOfClass:[NSDictionary class]]) {
            [BYToastView showToastWithMessage:@"重置密码失败,请稍候再试"];
            return;
        }
        NSString *success = dataDic[@"success"];
        if (success) {
            [BYToastView showToastWithMessage:@"重置成功,跳转登录"];
            [BBUserDefaults resetLoginStatus];
            [BBUserDefaults setUserPhone:loginNameString];
            [BBUserDefaults setUserEmail:loginNameString];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        [BYToastView showToastWithMessage:@"重置密码失败,请稍候再试"];
        return;
    }];
}

-(void)sendCodeButtonClick{
    //网络请求
    [self resignAllInput];
    
    NSString *phoneString = userLoginNameTextField.text;
    if (!phoneString || [phoneString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"登录名不能为空"];
        return;
    }
    if (![XYTools checkString:phoneString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"输入的邮箱不能包含特殊字符"];
        return;
    }
    globalCode = nil;
    [sendCodeButton.titleLabel.text isEqualToString:@"正在发送"];
    
    
    [BBUrlConnection getUserInfoWithPhone:phoneString complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:@"验证码发送失败"];
            [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
            [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
            return;
        }
        if ([resultDic[@"code"] intValue] != 0) {
            [BYToastView showToastWithMessage:@"验证码发送失败"];
            [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
            [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
            return;
        }
        NSArray *dataArray = resultDic[@"data"];
        if (!dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"验证码发送失败,请检查邮箱是否输入正确"];
            [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
            [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
            return;
        }
        if (dataArray.count <= 0) {
            [BYToastView showToastWithMessage:@"该邮箱不存在"];
            [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
            [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
            return;
        }
        [BBUrlConnection sendCodeThroughPhone:phoneString complete:^(NSDictionary *coderesultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:@"验证码发送失败"];
                [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
                sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
                [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
                return;
            }
            if ([coderesultDic[@"code"] intValue] != 0) {
                [BYToastView showToastWithMessage:@"验证码发送失败"];
                [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
                sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
                [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
                return;
            }
            NSDictionary *dataDic = coderesultDic[@"data"];
            if (!dataDic || ![dataDic isKindOfClass:[NSDictionary class]] || dataDic.count == 0) {
                [BYToastView showToastWithMessage:@"验证码发送失败"];
                [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
                sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
                [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
                return;
            }
            NSString *code = dataDic[@"code"];
            if (!code || [code isEqualToString:@""]) {
                [BYToastView showToastWithMessage:@"验证码发送失败"];
                [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
                sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
                [sendCodeButton.titleLabel.text isEqualToString:@"重新发送"];
                return;
            }
            globalCode = code;
            [BYToastView showToastWithMessage:@"验证码发送成功"];
            [self codeButtonCountDownAnimated];
            NSLog(@"getEntryCodeComplete: %@",globalCode);
        }];
    }];
}

static NSString *preString = @"已发送";
static int countDown = 0;
-(void)codeButtonCountDownAnimated{
    sendCodeButton.enabled = NO;
    sendCodeButton.userInteractionEnabled = NO;
    if ([sendCodeButton.titleLabel.text isEqualToString:@"获取验证码"]
        ||[sendCodeButton.titleLabel.text isEqualToString:@"重新发送"]
        || [sendCodeButton.titleLabel.text isEqualToString:@"正在发送"]) {
        countDown = 61;
    }
    if (countDown != 1) {
        [sendCodeButton setTitleColor:RGBAColor(200, 200, 200, 1) forState:UIControlStateNormal];
        sendCodeButton.layer.borderColor = RGBAColor(200, 200, 200, 1).CGColor;
        [sendCodeButton setTitle:[NSString stringWithFormat:@"%@ %02d",preString,countDown-1] forState:UIControlStateNormal];
        countDown = countDown - 1;
        [self performSelector:@selector(codeButtonCountDownAnimated) withObject:nil afterDelay:1.f];
    }else{
        [sendCodeButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        [sendCodeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
        sendCodeButton.layer.borderColor = BB_BlueColor.CGColor;
        sendCodeButton.enabled = YES;
        sendCodeButton.userInteractionEnabled = YES;
    }
}

-(void)resignAllInput{
    [userLoginNameTextField resignFirstResponder];
    [codeTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [passwordRepeatTextField resignFirstResponder];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"忘记密码";
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end