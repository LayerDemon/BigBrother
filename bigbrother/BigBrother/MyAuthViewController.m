//
//  MyAuthViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/1.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MyAuthViewController.h"
#import "AuthcationViewController.h"

@interface MyAuthViewController ()

@end

@implementation MyAuthViewController{
    UIScrollView *contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    NSString *authTypeString = [BBUserDefaults getUserAuthType];
    NSString *authSatusString = [BBUserDefaults getUserAuthStatusString];
    
    if (!authTypeString || !authSatusString) {
        return;
    }
    
    [self getUserAuthInfo];
}

-(void)getUserAuthInfo{
    [BBUrlConnection getUserAuthInfoComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *dataDic = resultDic[@"data"];
        if (!dataDic || ![dataDic isKindOfClass:[NSDictionary class]]) {
            [BYToastView showToastWithMessage:@"获取认证信息失败,请稍候再试"];
            return;
        }
        [self setContentViewWithDictionary:dataDic];
    }];
}

-(void)setContentViewWithDictionary:(NSDictionary *)dictionary{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!dictionary) {
        return;
    }
    NSString *type = dictionary[@"type"];
    NSString *status = dictionary[@"status"];
    if (type && status) {
        if ([type isEqualToString:@"PERSONAL"]) {
            [self setPersonalAuthViewWithDictionary:dictionary];
        }else if ([type isEqualToString:@"COMPANY"]){
            [self setCompanyAuthViewWithDictionary:dictionary];
        }
    }
    
}

-(void)setPersonalAuthViewWithDictionary:(NSDictionary *)dictionary{
    NSString *status = dictionary[@"status"];
    if (status) {
        NSString *statusLabelString;
        if ([status isEqualToString:@"PENDING_AUDIT"]) {
            statusLabelString = @"您的资料已经提交审核,请耐心等待审核结果";
        }else if ([status isEqualToString:@"AUDIT_PASSED"]) {
            statusLabelString = @"您已通过个人认证";
        }
        NSString *createTime = dictionary[@"createdTime"];
        
        NSString *frontIDUrlString = dictionary[@"identityCardFrontUrl"];
        NSString *backIDUrlString = dictionary[@"identityCardBackUrl"];
        
        if (!statusLabelString) {
            return;
        }
        
        float IDPicWidth = (WIDTH(contentView)-15*2);
        float IDPicHeight = IDPicWidth * 54.f/86.f;
        
        UILabel *authNoteLabel = [[UILabel alloc] init];
        authNoteLabel.frame = (CGRect){15,15,WIDTH(contentView)-15*2,15};
        authNoteLabel.font = Font(15);
        authNoteLabel.text = statusLabelString;
        authNoteLabel.textColor = RGBColor(50, 50, 50);
        authNoteLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:authNoteLabel];
        
        UILabel *authTimeLabel = [[UILabel alloc] init];
        authTimeLabel.frame = (CGRect){15,40,WIDTH(contentView)-15*2,15};
        authTimeLabel.font = Font(15);
        authTimeLabel.text = [NSString stringWithFormat:@"创建时间:%@",createTime];
        authTimeLabel.textColor = RGBColor(50, 50, 50);
        authTimeLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:authTimeLabel];
        
        UIImageView *personalIDFrontImageView = [[UIImageView alloc] init];
        personalIDFrontImageView.backgroundColor = [UIColor clearColor];
        personalIDFrontImageView.frame = (CGRect){15,BOTTOM(authTimeLabel)+20,IDPicWidth,IDPicHeight};
        personalIDFrontImageView.userInteractionEnabled = NO;
        [contentView addSubview:personalIDFrontImageView];
        
        UIImageView *personalIDBackImageView = [[UIImageView alloc] init];
        personalIDBackImageView.backgroundColor = [UIColor clearColor];
        personalIDBackImageView.frame = (CGRect){15,BOTTOM(personalIDFrontImageView)+20,IDPicWidth,IDPicHeight};
        personalIDBackImageView.userInteractionEnabled = NO;
        [contentView addSubview:personalIDBackImageView];
        
        [personalIDFrontImageView setImageWithURL:[NSURL URLWithString:frontIDUrlString]];
        
        [personalIDBackImageView setImageWithURL:[NSURL URLWithString:backIDUrlString]];
        
        UIButton *reAuthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reAuthButton.frame = (CGRect){15,BOTTOM(personalIDBackImageView)+20,WIDTH(contentView)-15*2,40};
        reAuthButton.layer.cornerRadius = 2.f;
        reAuthButton.layer.masksToBounds = YES;
        [reAuthButton setTitle:@"重新提交" forState:UIControlStateNormal];
        [reAuthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        reAuthButton.backgroundColor = BB_BlueColor;
        [reAuthButton addTarget:self action:@selector(reAuthButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:reAuthButton];
    }
}

-(void)setCompanyAuthViewWithDictionary:(NSDictionary *)dictionary{
    NSString *status = dictionary[@"status"];
    if (status) {
        NSString *statusLabelString;
        if ([status isEqualToString:@"PENDING_AUDIT"]) {
            statusLabelString = @"您的资料已经提交审核,请耐心等待审核结果";
        }else if ([status isEqualToString:@"AUDIT_PASSED"]) {
            statusLabelString = @"您已通过企业认证";
        }
        NSString *createTime = dictionary[@"createdTime"];
        
        NSString *businessLicenceUrlString = dictionary[@"businessLicenceUrl"];
        NSString *frontIDUrlString = dictionary[@"identityCardFrontUrl"];
        NSString *backIDUrlString = dictionary[@"identityCardBackUrl"];
        
        if (!statusLabelString) {
            return;
        }
        
        float IDPicWidth = (WIDTH(contentView)-15*2);
        float IDPicHeight = IDPicWidth * 54.f/86.f;
        
        UILabel *authNoteLabel = [[UILabel alloc] init];
        authNoteLabel.frame = (CGRect){15,15,WIDTH(contentView)-15*2,15};
        authNoteLabel.font = Font(15);
        authNoteLabel.text = statusLabelString;
        authNoteLabel.textColor = RGBColor(50, 50, 50);
        authNoteLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:authNoteLabel];
        
        UILabel *authTimeLabel = [[UILabel alloc] init];
        authTimeLabel.frame = (CGRect){15,40,WIDTH(contentView)-15*2,15};
        authTimeLabel.font = Font(15);
        authTimeLabel.text = [NSString stringWithFormat:@"创建时间:%@",createTime];
        authTimeLabel.textColor = RGBColor(50, 50, 50);
        authTimeLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:authTimeLabel];
        
        UIImageView *businessLicenceImageView = [[UIImageView alloc] init];
        businessLicenceImageView.backgroundColor = [UIColor clearColor];
        businessLicenceImageView.frame = (CGRect){15,BOTTOM(authTimeLabel)+20,IDPicWidth,IDPicHeight};
        businessLicenceImageView.userInteractionEnabled = NO;
        [contentView addSubview:businessLicenceImageView];
        
        UIImageView *companyIDFrontImageView = [[UIImageView alloc] init];
        companyIDFrontImageView.backgroundColor = [UIColor clearColor];
        companyIDFrontImageView.frame = (CGRect){15,BOTTOM(businessLicenceImageView)+20,IDPicWidth,IDPicHeight};
        companyIDFrontImageView.userInteractionEnabled = NO;
        [contentView addSubview:companyIDFrontImageView];
        
        UIImageView *companyIDBackImageView = [[UIImageView alloc] init];
        companyIDBackImageView.backgroundColor = [UIColor clearColor];
        companyIDBackImageView.frame = (CGRect){15,BOTTOM(companyIDFrontImageView)+20,IDPicWidth,IDPicHeight};
        companyIDBackImageView.userInteractionEnabled = NO;
        [contentView addSubview:companyIDBackImageView];
        
        [businessLicenceImageView setImageWithURL:[NSURL URLWithString:businessLicenceUrlString]];
        
        [companyIDFrontImageView setImageWithURL:[NSURL URLWithString:frontIDUrlString]];
        
        [companyIDBackImageView setImageWithURL:[NSURL URLWithString:backIDUrlString]];
        
        UIButton *reAuthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reAuthButton.frame = (CGRect){15,BOTTOM(companyIDBackImageView)+20,WIDTH(contentView)-15*2,40};
        reAuthButton.layer.cornerRadius = 2.f;
        reAuthButton.layer.masksToBounds = YES;
        [reAuthButton setTitle:@"重新提交" forState:UIControlStateNormal];
        [reAuthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        reAuthButton.backgroundColor = BB_BlueColor;
        [reAuthButton addTarget:self action:@selector(reAuthButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:reAuthButton];
    }
}

-(void)reAuthButtonClick{
    AuthcationViewController *authVC = [AuthcationViewController new];
    authVC.isFromLogin = NO;
    [self.navigationController pushViewController:authVC animated:YES];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"我的认证";
    
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
    if (contentView) {
        [self getUserAuthInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end