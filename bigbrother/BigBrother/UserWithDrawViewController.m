//
//  UserWithDrawViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/3.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UserWithDrawViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface UserWithDrawViewController ()

@end

@implementation UserWithDrawViewController{
    BOOL canWithDraw;
    
    UILabel *accoutRemainLabel;
    
    UITextField *withDrawPointsTextField;
    UITextField *withDrawBankTextField;
    UITextField *withDrawBankNumTextField;
    UITextField *withDrawBankUserTextField;
    UITextField *withDrawUserIDTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    TPKeyboardAvoidingScrollView *contentView = [[TPKeyboardAvoidingScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight-50};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    UIView *accoutInfoView = [[UIView alloc] init];
    accoutInfoView.frame = (CGRect){0,0,WIDTH(contentView),70};
    accoutInfoView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:accoutInfoView];
    
    UILabel *accoutRemainNoteLabel = [[UILabel alloc] init];
    accoutRemainNoteLabel.frame = (CGRect){15,15,90,15};
    accoutRemainNoteLabel.text = @"账户余额为：";
    accoutRemainNoteLabel.font = Font(15);
    accoutRemainNoteLabel.textAlignment = NSTextAlignmentLeft;
    accoutRemainNoteLabel.textColor = RGBColor(50, 50, 50);
    [accoutInfoView addSubview:accoutRemainNoteLabel];
    
    accoutRemainLabel = [[UILabel alloc] init];
    accoutRemainLabel.frame = (CGRect){105,15,WIDTH(accoutInfoView)/2-95,15};
    accoutRemainLabel.text = [NSString stringWithFormat:@"%d点",self.userRemainPoints];
    accoutRemainLabel.textColor = BB_BlueColor;
    accoutRemainLabel.textAlignment = NSTextAlignmentLeft;
    accoutRemainLabel.font = Font(14);
    [accoutInfoView addSubview:accoutRemainLabel];
    
    UILabel *accoutCanWithDrawNoteLabel = [[UILabel alloc] init];
    accoutCanWithDrawNoteLabel.frame = (CGRect){WIDTH(accoutInfoView)/2+10,15,90,15};
    accoutCanWithDrawNoteLabel.text = @"折合人民币：";
    accoutCanWithDrawNoteLabel.font = Font(15);
    accoutCanWithDrawNoteLabel.textAlignment = NSTextAlignmentLeft;
    accoutCanWithDrawNoteLabel.textColor = RGBColor(50, 50, 50);
    [accoutInfoView addSubview:accoutCanWithDrawNoteLabel];
    
    UILabel *accoutCanWithDrawLabel = [[UILabel alloc] init];
    accoutCanWithDrawLabel.frame = (CGRect){WIDTH(accoutInfoView)/2+95,15,WIDTH(accoutInfoView)/2-95,15};
    accoutCanWithDrawLabel.text = [NSString stringWithFormat:@"%.02f元",self.userRemainPoints/100.f];
    accoutCanWithDrawLabel.textColor = BB_BlueColor;
    accoutCanWithDrawLabel.textAlignment = NSTextAlignmentLeft;
    accoutCanWithDrawLabel.font = Font(14);
    [accoutInfoView addSubview:accoutCanWithDrawLabel];
    
    if (self.userRemainPoints >= 2000) {
        canWithDraw = YES;
    }else{
        canWithDraw = NO;
    }
    
    UILabel *canWithDrawNoteLabel = [[UILabel alloc] init];
    canWithDrawNoteLabel.frame = (CGRect){15,40,WIDTH(accoutInfoView)-15*2,15};
    if (canWithDraw) {
        canWithDrawNoteLabel.text = @"账户余额点数超过2000点,可以选择提现";
    }else{
        canWithDrawNoteLabel.text = @"账户余额点数不足2000点,不能提现";
    }
    canWithDrawNoteLabel.font = Font(11);
    canWithDrawNoteLabel.textAlignment = NSTextAlignmentLeft;
    canWithDrawNoteLabel.textColor = RGBColor(50, 50, 50);
    [accoutInfoView addSubview:canWithDrawNoteLabel];
    
    UIView *withDrawInfoView = [[UIView alloc] init];
    withDrawInfoView.frame = (CGRect){0,BOTTOM(accoutInfoView)+10,WIDTH(contentView),340};
    withDrawInfoView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:withDrawInfoView];
    
    UILabel *withDrawInfoNoteLabel = [[UILabel alloc] initWithFrame:(CGRect){15,10,WIDTH(withDrawInfoView)-15*2,12}];
    withDrawInfoNoteLabel.text = @"请认真填写以下个人信息,确保现金安全到账";
    withDrawInfoNoteLabel.font = Font(12);
    withDrawInfoNoteLabel.textColor = [UIColor redColor];
    withDrawInfoNoteLabel.textAlignment = NSTextAlignmentLeft;
    [withDrawInfoView addSubview:withDrawInfoNoteLabel];
    
    withDrawPointsTextField = [[UITextField alloc] init];
    withDrawPointsTextField.frame = (CGRect){15,BOTTOM(withDrawInfoNoteLabel)+15,WIDTH(withDrawInfoView)-15*2,35};
    withDrawPointsTextField.layer.cornerRadius = 2.f;
    withDrawPointsTextField.layer.masksToBounds = YES;
    withDrawPointsTextField.layer.borderWidth = 0.5f;
    withDrawPointsTextField.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
    withDrawPointsTextField.textColor = RGBColor(100, 100, 100);
    withDrawPointsTextField.font = Font(14);
    withDrawPointsTextField.minimumFontSize = 10;
    withDrawPointsTextField.placeholder = @"请输入要提现的点数";
    withDrawPointsTextField.adjustsFontSizeToFitWidth = YES;
    withDrawPointsTextField.returnKeyType = UIReturnKeyDone;
    withDrawPointsTextField.keyboardType = UIKeyboardTypePhonePad;
    [withDrawPointsTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [withDrawPointsTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [withDrawPointsTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawPointsTextField)}]];
    [withDrawPointsTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawPointsTextField)}]];
    withDrawPointsTextField.leftViewMode = UITextFieldViewModeAlways;
    withDrawPointsTextField.rightViewMode = UITextFieldViewModeAlways;
    [withDrawInfoView addSubview:withDrawPointsTextField];
    
    withDrawBankTextField = [[UITextField alloc] init];
    withDrawBankTextField.frame = (CGRect){15,BOTTOM(withDrawPointsTextField)+10,WIDTH(withDrawInfoView)-15*2,35};
    withDrawBankTextField.layer.cornerRadius = 2.f;
    withDrawBankTextField.layer.masksToBounds = YES;
    withDrawBankTextField.layer.borderWidth = 0.5f;
    withDrawBankTextField.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
    withDrawBankTextField.textColor = RGBColor(100, 100, 100);
    withDrawBankTextField.font = Font(14);
    withDrawBankTextField.minimumFontSize = 10;
    withDrawBankTextField.placeholder = @"请输入银行开户行";
    withDrawBankTextField.adjustsFontSizeToFitWidth = YES;
    withDrawBankTextField.returnKeyType = UIReturnKeyDone;
    withDrawBankTextField.keyboardType = UIKeyboardTypeDefault;
    [withDrawBankTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [withDrawBankTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [withDrawBankTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawBankTextField)}]];
    [withDrawBankTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawBankTextField)}]];
    withDrawBankTextField.leftViewMode = UITextFieldViewModeAlways;
    withDrawBankTextField.rightViewMode = UITextFieldViewModeAlways;
    [withDrawInfoView addSubview:withDrawBankTextField];
    
    withDrawBankNumTextField = [[UITextField alloc] init];
    withDrawBankNumTextField.frame = (CGRect){15,BOTTOM(withDrawBankTextField)+10,WIDTH(withDrawInfoView)-15*2,35};
    withDrawBankNumTextField.layer.cornerRadius = 2.f;
    withDrawBankNumTextField.layer.masksToBounds = YES;
    withDrawBankNumTextField.layer.borderWidth = 0.5f;
    withDrawBankNumTextField.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
    withDrawBankNumTextField.textColor = RGBColor(100, 100, 100);
    withDrawBankNumTextField.font = Font(14);
    withDrawBankNumTextField.minimumFontSize = 10;
    withDrawBankNumTextField.placeholder = @"请输入银行卡账号";
    withDrawBankNumTextField.adjustsFontSizeToFitWidth = YES;
    withDrawBankNumTextField.returnKeyType = UIReturnKeyDone;
    withDrawBankNumTextField.keyboardType = UIKeyboardTypePhonePad;
    [withDrawBankNumTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [withDrawBankNumTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [withDrawBankNumTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawBankNumTextField)}]];
    [withDrawBankNumTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawBankNumTextField)}]];
    withDrawBankNumTextField.leftViewMode = UITextFieldViewModeAlways;
    withDrawBankNumTextField.rightViewMode = UITextFieldViewModeAlways;
    [withDrawInfoView addSubview:withDrawBankNumTextField];
    
    withDrawBankUserTextField = [[UITextField alloc] init];
    withDrawBankUserTextField.frame = (CGRect){15,BOTTOM(withDrawBankNumTextField)+10,WIDTH(withDrawInfoView)-15*2,35};
    withDrawBankUserTextField.layer.cornerRadius = 2.f;
    withDrawBankUserTextField.layer.masksToBounds = YES;
    withDrawBankUserTextField.layer.borderWidth = 0.5f;
    withDrawBankUserTextField.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
    withDrawBankUserTextField.textColor = RGBColor(100, 100, 100);
    withDrawBankUserTextField.font = Font(14);
    withDrawBankUserTextField.minimumFontSize = 10;
    withDrawBankUserTextField.placeholder = @"请输入持卡人姓名";
    withDrawBankUserTextField.adjustsFontSizeToFitWidth = YES;
    withDrawBankUserTextField.returnKeyType = UIReturnKeyDone;
    withDrawBankUserTextField.keyboardType = UIKeyboardTypeDefault;
    [withDrawBankUserTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [withDrawBankUserTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [withDrawBankUserTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawBankUserTextField)}]];
    [withDrawBankUserTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawBankUserTextField)}]];
    withDrawBankUserTextField.leftViewMode = UITextFieldViewModeAlways;
    withDrawBankUserTextField.rightViewMode = UITextFieldViewModeAlways;
    [withDrawInfoView addSubview:withDrawBankUserTextField];
    
    withDrawUserIDTextField = [[UITextField alloc] init];
    withDrawUserIDTextField.frame = (CGRect){15,BOTTOM(withDrawBankUserTextField)+10,WIDTH(withDrawInfoView)-15*2,35};
    withDrawUserIDTextField.layer.cornerRadius = 2.f;
    withDrawUserIDTextField.layer.masksToBounds = YES;
    withDrawUserIDTextField.layer.borderWidth = 0.5f;
    withDrawUserIDTextField.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
    withDrawUserIDTextField.textColor = RGBColor(100, 100, 100);
    withDrawUserIDTextField.font = Font(14);
    withDrawUserIDTextField.minimumFontSize = 10;
    withDrawUserIDTextField.placeholder = @"请输入身份证号码";
    withDrawUserIDTextField.adjustsFontSizeToFitWidth = YES;
    withDrawUserIDTextField.returnKeyType = UIReturnKeyDone;
    withDrawUserIDTextField.keyboardType = UIKeyboardTypePhonePad;
    [withDrawUserIDTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [withDrawUserIDTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [withDrawUserIDTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawUserIDTextField)}]];
    [withDrawUserIDTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(withDrawUserIDTextField)}]];
    withDrawUserIDTextField.leftViewMode = UITextFieldViewModeAlways;
    withDrawUserIDTextField.rightViewMode = UITextFieldViewModeAlways;
    [withDrawInfoView addSubview:withDrawUserIDTextField];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = (CGRect){15,BOTTOM(withDrawUserIDTextField)+20,WIDTH(withDrawInfoView)-15*2,40};
    [doneButton setTitle:@"提现" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.backgroundColor = BB_BlueColor;
    doneButton.layer.cornerRadius = 3.f;
    doneButton.layer.masksToBounds = YES;
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [withDrawInfoView addSubview:doneButton];
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, BOTTOM(withDrawInfoView)+1)};
    
    if (canWithDraw) {
        withDrawPointsTextField.enabled = YES;
        withDrawBankTextField.enabled = YES;
        withDrawBankNumTextField.enabled = YES;
        withDrawBankUserTextField.enabled = YES;
        withDrawUserIDTextField.enabled = YES;
        doneButton.enabled = YES;
        doneButton.alpha = 1.f;
        withDrawPointsTextField.alpha = 1.f;
        withDrawBankTextField.alpha = 1.f;
        withDrawBankNumTextField.alpha = 1.f;
        withDrawBankUserTextField.alpha = 1.f;
        withDrawUserIDTextField.alpha = 1.f;
    }else{
        withDrawPointsTextField.enabled = NO;
        withDrawBankTextField.enabled = NO;
        withDrawBankNumTextField.enabled = NO;
        withDrawBankUserTextField.enabled = NO;
        withDrawUserIDTextField.enabled = NO;
        
        withDrawPointsTextField.alpha = 0.5f;
        withDrawBankTextField.alpha = 0.5f;
        withDrawBankNumTextField.alpha = 0.5f;
        withDrawBankUserTextField.alpha = 0.5f;
        withDrawUserIDTextField.alpha = 0.5f;
        
        doneButton.enabled = NO;
        doneButton.alpha = 0.5f;
    }
}

-(void)doneButtonClick{
    [self resignAllInputs];
    
    NSString *withDrawPointsString = withDrawPointsTextField.text;
    NSString *withDrawBankString = withDrawBankTextField.text;
    NSString *withDrawBankNumString = withDrawBankNumTextField.text;
    NSString *withDrawBankUserString = withDrawBankUserTextField.text;
    NSString *withDrawUserIDString = withDrawUserIDTextField.text;
    
    if (![XYTools checkString:withDrawPointsString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"提现的点数不能为空或包含特殊字符"];
        return;
    }
    
    if (![XYTools checkString:withDrawBankString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"开户银行不能为空或包含特殊字符"];
        return;
    }
    
    if (![XYTools checkString:withDrawBankNumString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"银行卡号不能为空或包含特殊字符"];
        return;
    }
    
    if (![XYTools checkString:withDrawBankUserString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"持卡人姓名不能为空或包含特殊字符"];
        return;
    }
    
    if (![XYTools checkString:withDrawUserIDString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"身份证号码不能为空或包含特殊字符"];
        return;
    }
    
    int withDrawPoints = [withDrawPointsString intValue];
    if (withDrawPoints <= 0){
        [BYToastView showToastWithMessage:@"提现的点数不能为0"];
        return;
    }
    
    if (withDrawPoints > self.userRemainPoints) {
        [BYToastView showToastWithMessage:@"提现的点数不能超过余额"];
        return;
    }
    
    //todo  现在是模拟提现阶段 直接调用api减少点数
    [BYToastView showToastWithMessage:@"模拟提现,直接减少点数"];
    [BBUrlConnection decreasePoint:withDrawPoints complete:^(NSDictionary *resultDic, NSString *errorString) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            if ([resultDic[@"code"] intValue] != 0) {
                [BYToastView showToastWithMessage:@"修改失败,请稍候重试"];
                return;
            }
            NSDictionary *userInfo = resultDic[@"data"];
            if (!userInfo || ![userInfo isKindOfClass:[NSDictionary class]]) {
                [BYToastView showToastWithMessage:@"修改失败,请稍候重试"];
                return;
            }
            int balance = [userInfo[@"balance"] intValue];
            accoutRemainLabel.text = [NSString stringWithFormat:@"%d点",balance];
            [BBUserDefaults setUserBalance:balance];
            [BYToastView showToastWithMessage:@"提现成功"];
            [self leftItemClick];
        });
    }];
}

-(void)resignAllInputs{
    [withDrawPointsTextField resignFirstResponder];
    [withDrawBankTextField resignFirstResponder];
    [withDrawBankNumTextField resignFirstResponder];
    [withDrawBankUserTextField resignFirstResponder];
    [withDrawUserIDTextField resignFirstResponder];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"提现";
    
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