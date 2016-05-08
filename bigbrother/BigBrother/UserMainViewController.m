//
//  UserMainViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UserMainViewController.h"
#import "LoginViewController.h"

#import "UserProfileViewController.h"
#import "MyAssetsViewController.h"
#import "MyPostListViewController.h"
#import "MyAuthViewController.h"
#import "AuthcationViewController.h"
#import "MyMessageViewController.h"
#import "SettingViewController.h"

#define unsignButtonTextColor RGBColor(14, 112, 195)
#define signedButtonTextColor RGBColor(220, 220, 220)
@interface UserMainViewController ()

@end

@implementation UserMainViewController{
    UIScrollView *contentView;
    
    float viewHeightOffset;
    float everyButtonViewHeight;
    
    UIImageView *headImageView;
    UILabel *userBalanceLabel;
    UILabel *nickNameLabel;
    UILabel *userPhoneLabel;
    
    //签到相关
    UILabel *dailySignStatuLabel;
    UILabel *dailySignNoteLabel;
    UIButton *dailySignButton;
    BOOL hasSigned;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)};
    contentView.contentSize = (CGSize){WIDTH(contentView),10000};
    contentView.backgroundColor = BB_WhiteColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    everyButtonViewHeight = 45.f;
    
    [self initContentView];
    
    if ([BBUserDefaults getIsLogin]) {
        [self getRatherSigned];
    }else{
        [self changeViewBySigned:NO];
    }
    
    //    [self resetToUnLoginStatus];
}

-(void)resetToUnLoginStatus{
    [BBUserDefaults resetLoginStatus];
    [self changeViewBySigned:NO];
    
    nickNameLabel.text = @"登录/注册";
    userPhoneLabel.text = @"";
    userBalanceLabel.text = @"";
    headImageView.hidden = NO;
    headImageView.image = [UIImage new];
}

-(void)getUserInfo{
    if (![BBUserDefaults getIsLogin]) {
        return;
    }
    NSString *phoneNum = [BBUserDefaults getUserPhone];
    if (!phoneNum) {
        NSLog(@"错误 ,手机号码不能为空");
        return;
    }
    [BBUrlConnection getUserInfoWithPhone:phoneNum complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            return;
        }
        if ([resultDic[@"code"] intValue] != 0) {
            return;
        }
        NSArray *dataArray = resultDic[@"data"];
        if (!dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            return;
        }
        if (dataArray.count <= 0) {
            return;
        }
        NSDictionary *userInfo = dataArray[0];
        
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
        
        NSString *phoneNumString = userInfo[@"phoneNumber"];
        if (phoneNumString && [phoneNumString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserPhone:phoneNumString];
        }
        
        NSString *imageUrlString = userInfo[@"avatar"];
        if (imageUrlString && [imageUrlString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserHeadImageUrl:imageUrlString];
            headImageView.hidden = NO;
            [headImageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:headImageView.image];
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
                int balance = [balanceNum intValue];
                [BBUserDefaults setUserBalance:balance];
                userBalanceLabel.text = [NSString stringWithFormat:@"%@点",balanceNum];
                userBalanceLabel.hidden = NO;
            }
        }else{
            userBalanceLabel.text = @"0点";
            userBalanceLabel.hidden = NO;
        }
        
        NSString *lastLoginTime = userInfo[@"lastLoginTime"];
        if (lastLoginTime && [lastLoginTime isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserLastLoginTime:lastLoginTime];
            [self getRatherSigned];
        }
        
        NSString *authType = userInfo[@"authType"];
        if (authType && [authType isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserAuthType:authType];
        }
        
        NSString *authStatus = userInfo[@"authStatus"];
        if (authStatus && [authStatus isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserAuthStatusString:authStatus];
        }
        
        if (phoneNumString) {
            userPhoneLabel.text = phoneNumString;
        }
        
        if (nicknameString) {
            nickNameLabel.text = nicknameString;
        }else{
            nickNameLabel.text = phoneNumString;
        }
    }];
}

-(void)getRatherSigned{
    if (![BBUserDefaults getIsLogin]) {
        return;
    }
    NSString *dateString = [BBUserDefaults getUserLastLoginTime];
    BOOL isSigned = [self judgeIfCheckSigned:dateString];
    [self changeViewBySigned:isSigned];
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

-(void)initContentView{
    viewHeightOffset = 0;
    UIView *userProfileView = [self setUpUserProfileViewWithOffset:viewHeightOffset];
    [contentView addSubview:userProfileView];
    
    viewHeightOffset += HEIGHT(userProfileView);
    viewHeightOffset += 5;
    
    UIView *dailySignView = [self setUpDailySignViewWithOffset:viewHeightOffset];
    [contentView addSubview:dailySignView];
    
    viewHeightOffset += HEIGHT(dailySignView);
    viewHeightOffset += 5;
    
    UIView *view1 = [self setUpMyAssetsInfoWithOffset:viewHeightOffset];
    [contentView addSubview:view1];
    
    viewHeightOffset += HEIGHT(view1);
    viewHeightOffset += 5;
    
    UIView *view2 = [self setUpMyProvideInfoWithOffset:viewHeightOffset];
    [contentView addSubview:view2];
    
    viewHeightOffset += HEIGHT(view2);
    viewHeightOffset += 5;
    
    UIView *view3 = [self setUpMyAskInfoWithOffset:viewHeightOffset];
    [contentView addSubview:view3];
    
    viewHeightOffset += HEIGHT(view3);
    viewHeightOffset += 5;
    
    UIView *view4 = [self setUpMyAuthenticationInfoWithOffset:viewHeightOffset];
    [contentView addSubview:view4];
    
    viewHeightOffset += HEIGHT(view4);
    viewHeightOffset += 5;
    
    UIView *view5 = [self setUpMyInfomationWithOffset:viewHeightOffset];
    [contentView addSubview:view5];
    
    viewHeightOffset += HEIGHT(view5);
    viewHeightOffset += 5;
    
    UIView *view6 = [self setUpSettingWithOffset:viewHeightOffset];
    [contentView addSubview:view6];
    
    viewHeightOffset += HEIGHT(view6);
    viewHeightOffset += 10;
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(viewHeightOffset, HEIGHT(contentView)+1)};
}

#pragma mark - 头像视图
-(UIView *)setUpUserProfileViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),80};
    view.backgroundColor = [UIColor whiteColor];
    
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *userProfileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileTapTrigger)];
    [view addGestureRecognizer:userProfileTap];
    
    headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = 4.f;
    headImageView.layer.masksToBounds = YES;
    headImageView.frame = (CGRect){10,10,HEIGHT(view)-10*2,HEIGHT(view)-10*2};
    [view addSubview:headImageView];
    
    nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.frame = (CGRect){HEIGHT(view),15,WIDTH(view)-HEIGHT(view)-10,20};
    nickNameLabel.textColor = RGBColor(50, 50, 50);
    nickNameLabel.numberOfLines = 1;
    nickNameLabel.font = Font(16);
    nickNameLabel.textAlignment = NSTextAlignmentLeft;
    nickNameLabel.text = @"";
    [view addSubview:nickNameLabel];
    
    userPhoneLabel = [[UILabel alloc] init];
    userPhoneLabel.frame = (CGRect){HEIGHT(view),45,WIDTH(view)-HEIGHT(view)-20,20};
    userPhoneLabel.textColor = RGBColor(50, 50, 50);
    userPhoneLabel.numberOfLines = 1;
    userPhoneLabel.font = Font(16);
    userPhoneLabel.textAlignment = NSTextAlignmentLeft;
    userPhoneLabel.text = @"";
    [view addSubview:userPhoneLabel];
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    UIImageView *rightMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    rightMoreImage.frame = (CGRect){WIDTH(view)-10-moreImage.size.width,(HEIGHT(view)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [view addSubview:rightMoreImage];
    
    nickNameLabel.text = @"";
    userPhoneLabel.text = @"";
    if ([BBUserDefaults getIsLogin]) {
        NSString *userPhone = [BBUserDefaults getUserPhone];
        if (userPhone) {
            userPhoneLabel.text = userPhone;
        }
        NSString *nickName = [BBUserDefaults getUserNickName];
        if (nickName) {
            nickNameLabel.text = nickName;
        }else{
            nickNameLabel.text = userPhone;
        }
    }else{
        nickNameLabel.text = @"登录/注册";
        userPhoneLabel.text = @"";
    }
    
    return view;
}

-(void)userProfileTapTrigger{
    if (![BBUserDefaults getIsLogin]) {
        [self jumpToLogin];
        return;
    }
    [self.navigationController pushViewController:[UserProfileViewController new] animated:YES];
}

#pragma mark - 签到视图
-(UIView *)setUpDailySignViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    dailySignStatuLabel = [[UILabel alloc] init];
    dailySignStatuLabel.frame = (CGRect){10,0,90,HEIGHT(view)};
    dailySignStatuLabel.textColor = RGBColor(50, 50, 50);
    dailySignStatuLabel.numberOfLines = 1;
    dailySignStatuLabel.font = Font(15);
    dailySignStatuLabel.textAlignment = NSTextAlignmentLeft;
    dailySignStatuLabel.text = @"今日还未签到";
    [view addSubview:dailySignStatuLabel];
    
    dailySignNoteLabel = [[UILabel alloc] init];
    dailySignNoteLabel.frame = (CGRect){RIGHT(dailySignStatuLabel)+10,0,150,HEIGHT(view)};
    dailySignNoteLabel.textColor = RGBColor(150, 150, 150);
    dailySignNoteLabel.numberOfLines = 1;
    dailySignNoteLabel.font = Font(12);
    dailySignNoteLabel.textAlignment = NSTextAlignmentLeft;
    dailySignNoteLabel.text = @"每日签到获得10个点数";
    [view addSubview:dailySignNoteLabel];
    
    dailySignButton = [UIButton new];
    dailySignButton.frame = (CGRect){WIDTH(view)-15-50,8,50,HEIGHT(view)-8*2};
    [dailySignButton setTitle:@"签到" forState:UIControlStateNormal];
    [dailySignButton setTitleColor:unsignButtonTextColor forState:UIControlStateNormal];
    [dailySignButton setTitleColor:signedButtonTextColor forState:UIControlStateSelected];
    dailySignButton.layer.cornerRadius = 4.f;
    dailySignButton.layer.borderColor = unsignButtonTextColor.CGColor;
    dailySignButton.layer.borderWidth = 1;
    dailySignButton.titleLabel.font = Font(14);
    [view addSubview:dailySignButton];
    
    [dailySignButton addTarget:self action:@selector(dailySignButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    hasSigned = NO;
    if ([BBUserDefaults getIsLogin]) {
        NSString *lastLoginTime = [BBUserDefaults getUserLastLoginTime];
        if (lastLoginTime) {
            hasSigned = [self judgeIfCheckSigned:lastLoginTime];
        }
    }
    
    [self changeViewBySigned:hasSigned];
    
    //    if (hasSigned) {
    //        dailySignStatuLabel.text = @"今日已签到";
    //        dailySignNoteLabel.hidden = YES;
    //        [dailySignButton setTitle:@"已签" forState:UIControlStateNormal];
    //        dailySignButton.userInteractionEnabled = NO;
    //        [dailySignButton setTitleColor:signedButtonTextColor forState:UIControlStateNormal];
    //        dailySignButton.layer.borderColor = signedButtonTextColor.CGColor;
    //    }else{
    //        dailySignStatuLabel.text = @"今日还未签到";
    //        dailySignNoteLabel.hidden = NO;
    //        dailySignButton.userInteractionEnabled = YES;
    //        [dailySignButton setTitle:@"签到" forState:UIControlStateNormal];
    //        [dailySignButton setTitleColor:unsignButtonTextColor forState:UIControlStateNormal];
    //        [dailySignButton setTitleColor:signedButtonTextColor forState:UIControlStateSelected];
    //        dailySignButton.layer.borderColor = unsignButtonTextColor.CGColor;
    //    }
    
    return view;
}

-(void)dailySignButtonClick{
    if (![BBUserDefaults getIsLogin]) {
        [self jumpToLogin];
        return;
    }
    dailySignButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25f animations:^{
        [dailySignButton setSelected:YES];
        dailySignButton.alpha = 0.9;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            [dailySignButton setSelected:NO];
            dailySignButton.alpha = 1;
        } completion:^(BOOL finished) {
            dailySignButton.userInteractionEnabled = YES;
        }];
    }];
    NSString *loginNameString = [BBUserDefaults getUserPhone];
    if (!loginNameString || [loginNameString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"签到失败,请重新登录"];
        [self resetToUnLoginStatus];
        return;
    }
    
    NSString *passwordString = [BBUserDefaults getUserPassword];
    if (!passwordString || [passwordString isEqualToString:@""]) {
        [BYToastView showToastWithMessage:@"签到失败,请重新登录"];
        [self resetToUnLoginStatus];
        return;
    }
    [BYToastView showToastWithMessage:@"签到中.."];
    [BBUrlConnection loginUserWithLoginName:loginNameString password:passwordString complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            [self resetToUnLoginStatus];
            return;
        }
        if ([resultDic[@"code"] intValue] != 0) {
            [BYToastView showToastWithMessage:@"签到失败,请重新登录"];
            [self resetToUnLoginStatus];
            return;
        }
        NSDictionary *dataDic = resultDic[@"data"];
        if (!dataDic || ![dataDic isKindOfClass:[NSDictionary class]]) {
            [BYToastView showToastWithMessage:@"签到失败,请重新登录"];
            [self resetToUnLoginStatus];
            return;
        }
        NSString *idString = dataDic[@"id"];
        if (idString) {
            if ([idString isKindOfClass:[NSNumber class]]) {
                idString = [NSString stringWithFormat:@"%ld",(long)[idString longLongValue]];
            }
            [BYToastView showToastWithMessage:@"签到成功"];
            
            [BBUserDefaults resetLoginStatus];
            
            [BBUserDefaults setUserID:idString];
            [BBUserDefaults setIsLogin:YES];
            
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
            [self getUserInfo];
            [self changeViewBySigned:YES];
            return;
        }
        [BYToastView showToastWithMessage:@"签到失败,请重新登录"];
        [self resetToUnLoginStatus];
        return;
    }];
}

-(void)changeViewBySigned:(BOOL)isSigned{
    if (isSigned) {
        hasSigned = YES;
        dailySignStatuLabel.text = @"今日已签到";
        dailySignNoteLabel.hidden = YES;
        [dailySignButton setTitle:@"已签" forState:UIControlStateNormal];
        dailySignButton.userInteractionEnabled = NO;
        [dailySignButton setTitleColor:signedButtonTextColor forState:UIControlStateNormal];
        dailySignButton.layer.borderColor = signedButtonTextColor.CGColor;
    }else{
        hasSigned = NO;
        dailySignNoteLabel.hidden = NO;
        dailySignButton.userInteractionEnabled = YES;
        [dailySignButton setTitle:@"签到" forState:UIControlStateNormal];
        [dailySignButton setTitleColor:unsignButtonTextColor forState:UIControlStateNormal];
        [dailySignButton setTitleColor:signedButtonTextColor forState:UIControlStateSelected];
        dailySignButton.layer.borderColor = unsignButtonTextColor.CGColor;
    }
}

#pragma mark - 资产视图
-(UIView *)setUpMyAssetsInfoWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    view.userInteractionEnabled = YES;
    view.tag = 1;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTriger:)];
    [view addGestureRecognizer:viewTap];
    
    UIImage *ima = [UIImage imageNamed:@"wo_icon01"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ima];
    imageView.frame = (CGRect){15,(HEIGHT(view)-ima.size.height)/2,ima.size.width,ima.size.height};
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){RIGHT(imageView)+15,0,170,HEIGHT(view)};
    label.text = @"我的资产";
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(14);
    [view addSubview:label];
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    UIImageView *rightMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    rightMoreImage.frame = (CGRect){WIDTH(view)-10-moreImage.size.width,(HEIGHT(view)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [view addSubview:rightMoreImage];
    
    userBalanceLabel = [[UILabel alloc] init];
    userBalanceLabel.frame = (CGRect){WIDTH(view)-10-moreImage.size.width-5-150,0,150,HEIGHT(view)};
    userBalanceLabel.textColor = RGBColor(100, 100, 100);
    userBalanceLabel.numberOfLines = 1;
    userBalanceLabel.textAlignment = NSTextAlignmentRight;
    userBalanceLabel.font = Font(15);
    userBalanceLabel.text = @"";
    [view addSubview:userBalanceLabel];
    
    if ([BBUserDefaults getIsLogin]) {
        userBalanceLabel.text = [NSString stringWithFormat:@"%d点",[BBUserDefaults getUserBalance]];
    }else{
        userBalanceLabel.text = @"0点";
    }
    
    return view;
}


#pragma mark - 我的供应信息
-(UIView *)setUpMyProvideInfoWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    view.userInteractionEnabled = YES;
    view.tag = 2;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTriger:)];
    [view addGestureRecognizer:viewTap];
    
    UIImage *ima = [UIImage imageNamed:@"wo_icon02"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ima];
    imageView.frame = (CGRect){15,(HEIGHT(view)-ima.size.height)/2,ima.size.width,ima.size.height};
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){RIGHT(imageView)+15,0,170,HEIGHT(view)};
    label.text = @"我的供应信息";
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(14);
    [view addSubview:label];
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    UIImageView *rightMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    rightMoreImage.frame = (CGRect){WIDTH(view)-10-moreImage.size.width,(HEIGHT(view)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [view addSubview:rightMoreImage];
    
    return view;
}

#pragma mark - 我打的需求信息
-(UIView *)setUpMyAskInfoWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    view.userInteractionEnabled = YES;
    view.tag = 3;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTriger:)];
    [view addGestureRecognizer:viewTap];
    
    UIImage *ima = [UIImage imageNamed:@"wo_icon03"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ima];
    imageView.frame = (CGRect){15,(HEIGHT(view)-ima.size.height)/2,ima.size.width,ima.size.height};
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){RIGHT(imageView)+15,0,170,HEIGHT(view)};
    label.text = @"我的需求信息";
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(14);
    [view addSubview:label];
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    UIImageView *rightMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    rightMoreImage.frame = (CGRect){WIDTH(view)-10-moreImage.size.width,(HEIGHT(view)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [view addSubview:rightMoreImage];
    
    return view;
}

#pragma mark - 我的认证
-(UIView *)setUpMyAuthenticationInfoWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    view.userInteractionEnabled = YES;
    view.tag = 4;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTriger:)];
    [view addGestureRecognizer:viewTap];
    
    UIImage *ima = [UIImage imageNamed:@"wo_icon04"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ima];
    imageView.frame = (CGRect){15,(HEIGHT(view)-ima.size.height)/2,ima.size.width,ima.size.height};
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){RIGHT(imageView)+15,0,170,HEIGHT(view)};
    label.text = @"我的认证";
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(14);
    [view addSubview:label];
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    UIImageView *rightMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    rightMoreImage.frame = (CGRect){WIDTH(view)-10-moreImage.size.width,(HEIGHT(view)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [view addSubview:rightMoreImage];
    
    return view;
}

#pragma mark - 我的消息
-(UIView *)setUpMyInfomationWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    view.userInteractionEnabled = YES;
    view.tag = 5;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTriger:)];
    [view addGestureRecognizer:viewTap];
    
    UIImage *ima = [UIImage imageNamed:@"wo_icon05"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ima];
    imageView.frame = (CGRect){15,(HEIGHT(view)-ima.size.height)/2,ima.size.width,ima.size.height};
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){RIGHT(imageView)+15,0,170,HEIGHT(view)};
    label.text = @"我的消息";
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(14);
    [view addSubview:label];
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    UIImageView *rightMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    rightMoreImage.frame = (CGRect){WIDTH(view)-10-moreImage.size.width,(HEIGHT(view)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [view addSubview:rightMoreImage];
    
    return view;
}

#pragma mark - 设置
-(UIView *)setUpSettingWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    view.userInteractionEnabled = YES;
    view.tag = 6;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTriger:)];
    [view addGestureRecognizer:viewTap];
    
    UIImage *ima = [UIImage imageNamed:@"wo_icon06"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ima];
    imageView.frame = (CGRect){15,(HEIGHT(view)-ima.size.height)/2,ima.size.width,ima.size.height};
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){RIGHT(imageView)+15,0,170,HEIGHT(view)};
    label.text = @"设置";
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(14);
    [view addSubview:label];
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    UIImageView *rightMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    rightMoreImage.frame = (CGRect){WIDTH(view)-10-moreImage.size.width,(HEIGHT(view)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [view addSubview:rightMoreImage];
    
    return view;
}

-(void)viewTapTriger:(UITapGestureRecognizer *)tap{
    int viewTag = (int)tap.view.tag;
    if (viewTag == 6) {
        //跳转设置界面不需要判断是否已经登录
        [self.navigationController pushViewController:[SettingViewController new] animated:YES];
        return;
    }
    if (![BBUserDefaults getIsLogin]) {
        [self jumpToLogin];
        return;
    }
    if (viewTag == 1) {
        MyAssetsViewController *maVC = [[MyAssetsViewController alloc] init];
        maVC.userRemainPoints = [BBUserDefaults getUserBalance];
        [self.navigationController pushViewController:maVC animated:YES];
    }else if (viewTag == 2){
        MyPostListViewController *mplVC = [[MyPostListViewController alloc] init];
        mplVC.isProvide = YES;
        [self.navigationController pushViewController:mplVC animated:YES];
    }else if (viewTag == 3){
        MyPostListViewController *mplVC = [[MyPostListViewController alloc] init];
        mplVC.isProvide = NO;
        [self.navigationController pushViewController:mplVC animated:YES];
    }else if (viewTag == 4){
        NSString *authStatus = [BBUserDefaults getUserAuthStatusString];
        NSString *authType = [BBUserDefaults getUserAuthType];
        if (!authStatus || !authType || [authType isEqualToString:@"UNKNOWN"]) {
            AuthcationViewController *authVC = [AuthcationViewController new];
            authVC.isFromLogin = NO;
            [self.navigationController pushViewController:authVC animated:YES];
        }else{
            [self.navigationController pushViewController:[MyAuthViewController new] animated:YES];
        }
    }else if (viewTag == 5){
        [self.navigationController pushViewController:[MyMessageViewController new] animated:YES];
    }
    return;
}

//跳转到登录
-(void)jumpToLogin{
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Navigation_FontColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    
    [navi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    navi.view.backgroundColor = BB_WhiteColor;
    navi.navigationBar.barTintColor = BB_NaviColor;
    navi.navigationBar.barStyle = UIBarStyleBlack;
    
    [self presentViewController:navi animated:YES completion:nil];
}

-(void)setUpNavigation{
    self.tabBarController.navigationItem.title = @"我";
    [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
    if (contentView) {
        if ([BBUserDefaults getIsLogin]) {
            [self getUserInfo];
        }else{
            //还原视图 还原点数  还原用户信息
            [self changeViewBySigned:NO];
            [self resetToUnLoginStatus];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
