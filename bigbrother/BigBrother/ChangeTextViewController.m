//
//  ChangeTextViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/1.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChangeTextViewController.h"

@interface ChangeTextViewController ()

@end

@implementation ChangeTextViewController{
    UITextField *changeTextfiled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = self.view.backgroundColor;
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    
    changeTextfiled = [[UITextField alloc] init];
    changeTextfiled.frame = (CGRect){15,30,WIDTH(contentView)-15*2,40};
    changeTextfiled.layer.cornerRadius = 2.f;
    changeTextfiled.layer.masksToBounds = YES;
    changeTextfiled.layer.borderWidth = 1.f;
    changeTextfiled.layer.borderColor = RGBAColor(50, 50, 50, 0.5).CGColor;
    changeTextfiled.textColor = RGBColor(50, 50, 50);
    changeTextfiled.font = Font(16);
    changeTextfiled.minimumFontSize = 10;
    changeTextfiled.adjustsFontSizeToFitWidth = YES;
    changeTextfiled.returnKeyType = UIReturnKeyDone;
    changeTextfiled.keyboardType = UIKeyboardTypeDefault;
    [changeTextfiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [changeTextfiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [changeTextfiled setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(changeTextfiled)}]];
    [changeTextfiled setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,10,HEIGHT(changeTextfiled)}]];
    changeTextfiled.leftViewMode = UITextFieldViewModeAlways;
    changeTextfiled.rightViewMode = UITextFieldViewModeAlways;
    
    [contentView addSubview:changeTextfiled];
    
    if (self.defaultText || ![self.defaultText isEqualToString:@""]) {
        changeTextfiled.text = self.defaultText;
    }
    
    [changeTextfiled becomeFirstResponder];
}

-(void)updateToServer{
    [changeTextfiled resignFirstResponder];
    NSString *changeText = changeTextfiled.text;
    if (![XYTools checkString:changeText canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"输入不能为空或包含特殊字符"];
        return;
    }
    if (!self.updateKey) {
        [BYToastView showToastWithMessage:@"修改错误,请返回重试"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:changeText forKey:self.updateKey];
    
    [BYToastView showToastWithMessage:@"修改用户信息中..."];
    [BBUrlConnection updateUserInfoWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
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
        NSString *idstring = userInfo[@"id"];
        
        if (idstring) {
            if ([idstring isKindOfClass:[NSNumber class]]) {
                idstring = [NSString stringWithFormat:@"%ld",(long)[idstring longLongValue]];
            }
            [BBUserDefaults setUserID:idstring];
        }
        
        NSString *nicknameString = userInfo[@"nickname"];
        if (nicknameString && [nicknameString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserNickName:nicknameString];
        }
        
        NSString *phoneNumString = userInfo[@"userEmail"];
        if (phoneNumString && [phoneNumString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserPhone:phoneNumString];
        }
        
        NSString *imageUrlString = userInfo[@"avatar"];
        if (imageUrlString && [imageUrlString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserHeadImageUrl:imageUrlString];
        }
        
        NSString *sexString = userInfo[@"gender"];
        if (sexString && [sexString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserSex:sexString];
        }
        
        NSString *districtIdString = userInfo[@"districtId"];
        if (districtIdString) {
            if ([districtIdString isKindOfClass:[NSString class]]) {
                [BBUserDefaults setUserDistrictIdString:districtIdString];
            }else if([districtIdString isKindOfClass:[NSNumber class]]) {
                [BBUserDefaults setUserDistrictIdString:[NSString stringWithFormat:@"%lld",[districtIdString longLongValue]]];
            }
        }
        
        NSString *districtFullNameString = userInfo[@"districtFullName"];
        if (districtFullNameString && [districtFullNameString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserDistrictFullNameString:districtFullNameString];
        }
        
        NSNumber *balanceNum = userInfo[@"balance"];
        if (balanceNum) {
            if([balanceNum isKindOfClass:[NSNumber class]]) {
                [BBUserDefaults setUserBalance:[balanceNum intValue]];
            }
        }
        
        NSString *lastLoginTime = userInfo[@"lastLoginTime"];
        if (lastLoginTime && [lastLoginTime isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserLastLoginTime:lastLoginTime];
        }
        
        NSString *authType = userInfo[@"authType"];
        if (authType && [authType isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserAuthType:authType];
        }
        
        NSString *authStatus = userInfo[@"authStatus"];
        if (authStatus && [authStatus isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserAuthStatusString:authStatus];
        }
        [BYToastView showToastWithMessage:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    if (!self.title) {
        self.navigationItem.title = @"修改";
    }
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(16);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rightButtonTitle = @"保存";
    [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,60,20};
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [changeTextfiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    [self updateToServer];
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