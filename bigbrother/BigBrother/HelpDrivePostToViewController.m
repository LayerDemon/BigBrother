//
//  HelpDrivePostToViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/25.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HelpDrivePostToViewController.h"
#import "LoginViewController.h"

#import "TPKeyboardAvoidingScrollView.h"
#import "XYW8IndicatorView.h"

@interface HelpDrivePostToViewController ()

@end

@implementation HelpDrivePostToViewController{
    UIScrollView *contentView;
    
    float viewHeightOffset;
    float titleLineHeight;
    
    //发布 相关
    XYW8IndicatorView *indicatorView;
    
    //供需选择相关
    UIView *provideView;
    UIButton *provideButton,*needButton;
    BOOL isSupply;
    
    //关键字界面相关
    UIView *keyWordsView;
    NSMutableArray *keyWordsTextFiledArray;
    
    //标题界面相关
    UIView *titleView;
    UITextField *titleEditTextFiled;
    
    //租车服务车型- 提供 相关
    UIView *serviceHelpDriveTypeProvideView;
    UILabel *serviceHelpDriveTypeProvideInfoLabel;
    NSArray *selectedHelpDriveTypeProvideListArray;
    
    //    //租车服务车型- 需求 相关
    //    UIView *serviceHelpDriveTypeNeedView;
    //    UILabel *serviceHelpDriveTypeNeedInfoLabel;
    //    NSDictionary *serviceHelpDriveTypeNeedInfoDic;
    
    //租车服务车型- 提供和需求 相关
    NSArray *serviceHelpDriveTypeListDataArray;
    
    //供应区域相关
    UIView *provideAreaView;
    UILabel *provideAreaInfoLabel;
    NSDictionary *provideAreaInfoDic;
    NSArray *provideAreaListArray;
    
    //座位相关相关
    UIView *dayCountView;
    UITextField *dayCountTextField;
    
    //描述相关
    UIView *decriptionView;
    UITextView *decriptionTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    titleLineHeight = 45.f;
    
    contentView = [[TPKeyboardAvoidingScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight-45};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.backgroundColor = BB_WhiteColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postButton.frame = (CGRect){0,HEIGHT(self.view)-45,WIDTH(self.view),45};
    [self.view addSubview:postButton];
    postButton.backgroundColor = BB_BlueColor;
    [postButton setTitle:@"发布" forState:UIControlStateNormal];
    [postButton setTitleColor:BB_WhiteColor forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    isSupply = YES;
    
    viewHeightOffset = 10;
    provideView = [self setUpProvideOrNotViewWithOffset:viewHeightOffset];
    [contentView addSubview:provideView];
    
    [self reloadViews];
}

#pragma mark - 发布 网络请求
//发送按钮点击
-(void)postButtonClick{
    [self resignAllInputs];
    
    if (![BBUserDefaults getUserID]) {
        [BYToastView showToastWithMessage:@"还未登录"];
        NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Navigation_FontColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        
        [navi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
        
        navi.view.backgroundColor = BB_WhiteColor;
        navi.navigationBar.barTintColor = BB_NaviColor;
        navi.navigationBar.barStyle = UIBarStyleBlack;
        
        [self presentViewController:navi animated:YES completion:nil];
        return;
        return;
    }
    
    NSMutableArray *keywordMutableArray = [NSMutableArray array];
    for (UITextField *tf in keyWordsTextFiledArray) {
        if (tf) {
            NSString *keyWordsTmpString = tf.text;
            if (![keyWordsTmpString isEqualToString:@""]) {
                if (![XYTools checkString:keyWordsTmpString canEmpty:YES]) {
                    [BYToastView showToastWithMessage:@"关键字不能包含特殊字符"];
                    return;
                }else{
                    [keywordMutableArray addObject:@{@"name":keyWordsTmpString}];
                }
            }
        }
    }
    
    if (!selectedHelpDriveTypeProvideListArray || selectedHelpDriveTypeProvideListArray.count == 0) {
        [BYToastView showToastWithMessage:@"未选择代驾服务信息"];
        return;
    }
    
    if (!provideAreaInfoDic && provideAreaInfoDic.count ==0) {
        [BYToastView showToastWithMessage:@"未选择服务区域信息"];
        return;
    }
    long provideID = [[provideAreaInfoDic objectForKey:@"id"] longValue];
    
    NSString *titleString = titleEditTextFiled.text;
    if (![XYTools checkString:titleString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"标题不能包含特殊字符"];
        return;
    }
    
    NSString *desciptionString = decriptionTextView.text;
    if (![XYTools checkString:desciptionString canEmpty:YES]) {
        [BYToastView showToastWithMessage:@"详情描述不能包含特殊字符"];
        return;
    }
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:keywordMutableArray forKey:@"keywords"];
    [paramsDic setObject:titleString forKey:@"title"];
    [paramsDic setObject:desciptionString forKey:@"introduction"];
    [paramsDic setObject:selectedHelpDriveTypeProvideListArray forKey:@"serviceTypeList"];
    [paramsDic setObject:@(provideID) forKey:@"districtId"];
    
    if (isSupply) {
        [paramsDic setObject:ProductSupplyDemandTypeProvide forKey:@"supplyDemandType"];
    }else{
        NSString *dayCountString = dayCountTextField.text;
        if (![XYTools checkString:dayCountString canEmpty:NO]) {
            [BYToastView showToastWithMessage:@"所需天数不能为空或包含特殊字符"];
            return;
        }
        
        [paramsDic setObject:dayCountString forKey:@"dayCount"];
        [paramsDic setObject:ProductSupplyDemandTypeAsk forKey:@"supplyDemandType"];
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"";
    [indicatorView startAnimating];
    
    [self uploadBaseProductToServerWithParameters:paramsDic];
}

-(void)uploadBaseProductToServerWithParameters:(NSMutableDictionary *)params{
    if (!params) {
        [BYToastView showToastWithMessage:@"上传参数错误"];
        return;
    }
    [self uploadWithParams:params];
}

-(void)uploadWithParams:(NSMutableDictionary *)paramsDic{
    indicatorView.loadingLabel.text = @"提交至服务器";
    double uploadstart = [[NSDate date] timeIntervalSince1970];
    [BBUrlConnection uploadNewHelpDriveInfoWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        double uploadend = [[NSDate date] timeIntervalSince1970];
        float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating:YES];
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                int code = [resultDic[@"code"] intValue];
                if (code == 0) {
                    [BYToastView showToastWithMessage:@"发布成功,感谢您的支持"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [BYToastView showToastWithMessage:@"发送失败,请稍候重试"];
                }
            }
        });
    }];
}

#pragma mark - 刷新界面
-(void)reloadViews{
    if (isSupply) {
        viewHeightOffset = 10 + HEIGHT(provideView);
        
        viewHeightOffset += 10;
        
        [keyWordsView removeFromSuperview];
        if (keyWordsView) {
            CGRect newRect = keyWordsView.frame;
            newRect.origin.y = viewHeightOffset;
            keyWordsView.frame = newRect;
        }else{
            keyWordsView = [self setUpKeyWordsViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:keyWordsView];
        
        viewHeightOffset += HEIGHT(keyWordsView);
        
        viewHeightOffset += 10;
        
        [titleView removeFromSuperview];
        if (titleView) {
            CGRect newRect = titleView.frame;
            newRect.origin.y = viewHeightOffset;
            titleView.frame = newRect;
        }else{
            titleView = [self setUpTitleViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:titleView];
        
        viewHeightOffset += HEIGHT(titleView);
        
        viewHeightOffset += 10;
        
        [serviceHelpDriveTypeProvideView removeFromSuperview];
        if (serviceHelpDriveTypeProvideView) {
            CGRect newRect = serviceHelpDriveTypeProvideView.frame;
            newRect.origin.y = viewHeightOffset;
            serviceHelpDriveTypeProvideView.frame = newRect;
        }else{
            serviceHelpDriveTypeProvideView = [self setUpServiceHelpDriveTypeProvideViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:serviceHelpDriveTypeProvideView];
        
        viewHeightOffset += HEIGHT(serviceHelpDriveTypeProvideView);
        
        viewHeightOffset += 10;
        
        //        [serviceHelpDriveTypeNeedView removeFromSuperview];
        //        if (serviceHelpDriveTypeNeedView) {
        //            CGRect newRect = serviceHelpDriveTypeNeedView.frame;
        //            newRect.origin.y = viewHeightOffset;
        //            serviceHelpDriveTypeNeedView.frame = newRect;
        //        }else{
        //            serviceHelpDriveTypeNeedView = [self setUpServiceHelpDriveTypeNeedViewWithOffset:viewHeightOffset];
        //        }
        //        [contentView addSubview:serviceHelpDriveTypeNeedView];
        //        
        //        viewHeightOffset += HEIGHT(serviceHelpDriveTypeNeedView);
        //        
        //        viewHeightOffset += 10;
        
        [provideAreaView removeFromSuperview];
        if (provideAreaView) {
            CGRect newRect = provideAreaView.frame;
            newRect.origin.y = viewHeightOffset;
            provideAreaView.frame = newRect;
        }else{
            provideAreaView = [self setUpProvideAreaViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:provideAreaView];
        
        viewHeightOffset += HEIGHT(provideAreaView);
        
        viewHeightOffset += 10;
        
        [dayCountView removeFromSuperview];
        
        [decriptionView removeFromSuperview];
        if (decriptionView) {
            CGRect newRect = decriptionView.frame;
            newRect.origin.y = viewHeightOffset;
            decriptionView.frame = newRect;
        }else{
            decriptionView = [self setUpDesciptionViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:decriptionView];
        
        viewHeightOffset += HEIGHT(decriptionView);
        
    }else{
        viewHeightOffset = 10 + HEIGHT(provideView);
        
        viewHeightOffset += 10;
        
        [keyWordsView removeFromSuperview];
        if (keyWordsView) {
            CGRect newRect = keyWordsView.frame;
            newRect.origin.y = viewHeightOffset;
            keyWordsView.frame = newRect;
        }else{
            keyWordsView = [self setUpKeyWordsViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:keyWordsView];
        
        viewHeightOffset += HEIGHT(keyWordsView);
        
        viewHeightOffset += 10;
        
        [titleView removeFromSuperview];
        if (titleView) {
            CGRect newRect = titleView.frame;
            newRect.origin.y = viewHeightOffset;
            titleView.frame = newRect;
        }else{
            titleView = [self setUpTitleViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:titleView];
        
        viewHeightOffset += HEIGHT(titleView);
        
        viewHeightOffset += 10;
        
        [serviceHelpDriveTypeProvideView removeFromSuperview];
        if (serviceHelpDriveTypeProvideView) {
            CGRect newRect = serviceHelpDriveTypeProvideView.frame;
            newRect.origin.y = viewHeightOffset;
            serviceHelpDriveTypeProvideView.frame = newRect;
        }else{
            serviceHelpDriveTypeProvideView = [self setUpServiceHelpDriveTypeProvideViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:serviceHelpDriveTypeProvideView];
        
        viewHeightOffset += HEIGHT(serviceHelpDriveTypeProvideView);
        
        viewHeightOffset += 10;
        
        //        [serviceHelpDriveTypeNeedView removeFromSuperview];
        //        if (serviceHelpDriveTypeNeedView) {
        //            CGRect newRect = serviceHelpDriveTypeNeedView.frame;
        //            newRect.origin.y = viewHeightOffset;
        //            serviceHelpDriveTypeNeedView.frame = newRect;
        //        }else{
        //            serviceHelpDriveTypeNeedView = [self setUpServiceHelpDriveTypeNeedViewWithOffset:viewHeightOffset];
        //        }
        //        [contentView addSubview:serviceHelpDriveTypeNeedView];
        //        
        //        viewHeightOffset += HEIGHT(serviceHelpDriveTypeNeedView);
        //        
        //        viewHeightOffset += 10;
        
        [provideAreaView removeFromSuperview];
        if (provideAreaView) {
            CGRect newRect = provideAreaView.frame;
            newRect.origin.y = viewHeightOffset;
            provideAreaView.frame = newRect;
        }else{
            provideAreaView = [self setUpProvideAreaViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:provideAreaView];
        
        viewHeightOffset += HEIGHT(provideAreaView);
        
        viewHeightOffset += 10;
        
        [dayCountView removeFromSuperview];
        if (dayCountView) {
            CGRect newRect = dayCountView.frame;
            newRect.origin.y = viewHeightOffset;
            dayCountView.frame = newRect;
        }else{
            dayCountView = [self setUpDayCountViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:dayCountView];
        
        viewHeightOffset += HEIGHT(dayCountView);
        
        viewHeightOffset += 10;
        
        [decriptionView removeFromSuperview];
        if (decriptionView) {
            CGRect newRect = decriptionView.frame;
            newRect.origin.y = viewHeightOffset;
            decriptionView.frame = newRect;
        }else{
            decriptionView = [self setUpDesciptionViewWithOffset:viewHeightOffset];
        }
        [contentView addSubview:decriptionView];
        
        viewHeightOffset += HEIGHT(decriptionView);
        
    }
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(viewHeightOffset+10, HEIGHT(contentView)+1)};
}


#pragma mark - 供需选择 view 及相关事件
-(UIView *)setUpProvideOrNotViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"选择供需";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    float buttonWidth = (WIDTH(view)-20-WIDTH(noteLabel)-10)/2.f;
    
    provideButton = [[UIButton alloc] init];
    provideButton.frame = (CGRect){RIGHT(noteLabel)+10,0,buttonWidth,HEIGHT(view)};
    [provideButton setTitle:@"  提供" forState:UIControlStateNormal];
    [provideButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [provideButton setTitleColor:BB_BlueColor forState:UIControlStateSelected];
    [provideButton setImage:[UIImage imageNamed:@"icon_option"] forState:UIControlStateNormal];
    [provideButton setImage:[UIImage imageNamed:@"icon_option_on"] forState:UIControlStateSelected];
    provideButton.titleLabel.font = Font(14);
    provideButton.showsTouchWhenHighlighted = YES;
    [view addSubview:provideButton];
    
    [provideButton addTarget:self action:@selector(provideButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    needButton = [[UIButton alloc] init];
    needButton.frame = (CGRect){RIGHT(noteLabel)+10+buttonWidth,0,buttonWidth,HEIGHT(view)};
    [needButton setTitle:@"  需求" forState:UIControlStateNormal];
    [needButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [needButton setTitleColor:BB_BlueColor forState:UIControlStateSelected];
    [needButton setImage:[UIImage imageNamed:@"icon_option"] forState:UIControlStateNormal];
    [needButton setImage:[UIImage imageNamed:@"icon_option_on"] forState:UIControlStateSelected];
    needButton.titleLabel.font = Font(14);
    needButton.showsTouchWhenHighlighted = YES;
    [view addSubview:needButton];
    
    [needButton addTarget:self action:@selector(needButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (isSupply) {
        [provideButton setSelected:YES];
        [needButton setSelected:NO];
    }else{
        [provideButton setSelected:NO];
        [needButton setSelected:YES];
    }
    return view;
}

-(void)provideButtonClick{
    if (isSupply) {
        return;
    }
    isSupply = YES;
    [needButton setSelected:NO];
    [provideButton setSelected:YES];
    [self reloadViews];
}

-(void)needButtonClick{
    if (!isSupply) {
        return;
    }
    isSupply = NO;
    [needButton setSelected:YES];
    [provideButton setSelected:NO];
    [self reloadViews];
}

#pragma mark - 关键字界面 view
-(UIView *)setUpKeyWordsViewWithOffset:(float)offset{
    UIView *viewTmp = [[UIView alloc] init];
    viewTmp.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+35*2+10};
    viewTmp.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,55,titleLineHeight};
    noteLabel.text = @"关键字";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [viewTmp addSubview:noteLabel];
    
    UILabel *noteDesribeLabel = [[UILabel alloc] init];
    noteDesribeLabel.frame = (CGRect){RIGHT(noteLabel),0,WIDTH(viewTmp)-10*2-RIGHT(noteLabel),titleLineHeight};
    noteDesribeLabel.text = @"（非必填，有助于提交成交率）";
    noteDesribeLabel.textColor = RGBColor(100, 100, 100);
    noteDesribeLabel.textAlignment = NSTextAlignmentLeft;
    noteDesribeLabel.font = Font(14);
    [viewTmp addSubview:noteDesribeLabel];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.frame = (CGRect){0,HEIGHT(noteLabel)-0.5,WIDTH(viewTmp),0.5};
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [viewTmp addSubview:lineSepView];
    
    float textFiledBetweenWidth = 15;
    float textFiledBetweenHeight = 10;
    float textFiledWidth = (WIDTH(viewTmp)-10*2-textFiledBetweenWidth*2)/3;
    
    keyWordsTextFiledArray = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        int xOff = i % 3;
        int yOff = (int)(i / 3);
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = (CGRect){
            10+(textFiledWidth+textFiledBetweenWidth)*xOff,
            HEIGHT(noteLabel) + textFiledBetweenHeight + (35+textFiledBetweenHeight)*yOff,
            textFiledWidth,
            35
        };
        textField.layer.cornerRadius = 2.f;
        textField.layer.masksToBounds = YES;
        textField.layer.borderWidth = 0.5f;
        textField.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
        textField.textColor = RGBColor(100, 100, 100);
        textField.font = Font(14);
        textField.minimumFontSize = 10;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeDefault;
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        [textField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(textField)}]];
        [textField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(textField)}]];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.rightViewMode = UITextFieldViewModeAlways;
        
        [viewTmp addSubview:textField];
        
        [keyWordsTextFiledArray addObject:textField];
    }
    
    viewTmp.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+35*2+textFiledBetweenHeight*3};
    
    return viewTmp;
}

#pragma mark - 标题 view 及相关事件
-(UIView *)setUpTitleViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,35,HEIGHT(view)};
    noteLabel.text = @"标题";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    titleEditTextFiled = [[UITextField alloc] init];
    titleEditTextFiled.frame = (CGRect){
        RIGHT(noteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(noteLabel)+10)-10,
        titleLineHeight
    };
    titleEditTextFiled.textColor = RGBColor(80, 80, 80);
    titleEditTextFiled.font = Font(15);
    titleEditTextFiled.minimumFontSize = 10;
    titleEditTextFiled.adjustsFontSizeToFitWidth = YES;
    titleEditTextFiled.returnKeyType = UIReturnKeyDone;
    titleEditTextFiled.keyboardType = UIKeyboardTypeDefault;
    [titleEditTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [titleEditTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [titleEditTextFiled setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(titleEditTextFiled)}]];
    [titleEditTextFiled setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(titleEditTextFiled)}]];
    titleEditTextFiled.leftViewMode = UITextFieldViewModeAlways;
    titleEditTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:titleEditTextFiled];
    
    return view;
}

#pragma mark - 服务车型 -提供 view 及相关事件
-(UIView *)setUpServiceHelpDriveTypeProvideViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *serviceCarTypeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceCarTypeProvideTap)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:serviceCarTypeTap];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,75,HEIGHT(view)};
    noteLabel.text = @"服务车型";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    serviceHelpDriveTypeProvideInfoLabel = [[UILabel alloc] init];
    serviceHelpDriveTypeProvideInfoLabel.frame = (CGRect){RIGHT(noteLabel)+10,0,WIDTH(view)-RIGHT(noteLabel)-10-10,HEIGHT(view)};
    serviceHelpDriveTypeProvideInfoLabel.text = @"";
    serviceHelpDriveTypeProvideInfoLabel.textColor = RGBColor(50, 50, 50);
    serviceHelpDriveTypeProvideInfoLabel.textAlignment = NSTextAlignmentRight;
    serviceHelpDriveTypeProvideInfoLabel.font = Font(14);
    [view addSubview:serviceHelpDriveTypeProvideInfoLabel];
    
    [self getAllHelpDriveGategroyList];
    return view;
}

-(void)serviceCarTypeProvideTap{
    [self resignAllInputs];
    if (!serviceHelpDriveTypeListDataArray || serviceHelpDriveTypeListDataArray.count == 0) {
        [BYToastView showToastWithMessage:@"数据不存在,请稍候再试"];
        [self getAllHelpDriveGategroyList];
        return;
    }
    [PopUpSelectedView showFilterMutitypeChooseViewWithArray:serviceHelpDriveTypeListDataArray withTitle:@"服务车型" normalTextColor:RGBColor(100, 100, 100) selectedTextColor:BB_BlueColor doneButtonBlock:^(NSArray *selectedIndexArray) {
        [self serviceCarTypeSelectFinish:selectedIndexArray];
    }];
}

-(void)serviceCarTypeSelectFinish:(NSArray *)array{
    NSLog(@"array %@",array);
    if (!serviceHelpDriveTypeListDataArray || serviceHelpDriveTypeListDataArray.count == 0) {
        return;
    }
    
    int orderBy = 1;
    NSMutableArray *labelShowedStringArray = [NSMutableArray array];
    
    NSMutableArray *selectedHelpDriveTypeListArrayTmp = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        BOOL select = [array[i] boolValue];
        if (select) {
            NSDictionary *dic = serviceHelpDriveTypeListDataArray[i];
            NSString *name = dic[@"name"];
            if (!name) {
                name = @"";
            }
            long cartypeID = [XYTools getLongFromDic:dic withKey:@"id"];
            [labelShowedStringArray addObject:name];
            
            [selectedHelpDriveTypeListArrayTmp addObject:@{@"id":@(cartypeID),@"name":name,@"orderBy":@(orderBy)}];
            orderBy += 1;
        }
    }
    
    selectedHelpDriveTypeProvideListArray = [NSArray arrayWithArray:selectedHelpDriveTypeListArrayTmp];
    
    NSString *labelShowString = [labelShowedStringArray componentsJoinedByString:@"、 "];
    serviceHelpDriveTypeProvideInfoLabel.text = labelShowString;
}

-(void)getAllHelpDriveGategroyList{
    if (serviceHelpDriveTypeListDataArray && serviceHelpDriveTypeListDataArray.count != 0) {
        return;
    }
    [BBUrlConnection getAllHelpDriveTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取车辆类别信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || dataArray.count == 0 || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取车辆类别信息失败,请稍后再试"];
            return;
        }
        NSMutableArray *gategroyTmpShowedArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArray) {
            int gategroyIDTmp = [dic[@"id"] intValue];
            NSString *name = dic[@"name"];
            [gategroyTmpShowedArray addObject:@{@"id":@(gategroyIDTmp),@"name":name}];
        }
        serviceHelpDriveTypeListDataArray = [NSArray arrayWithArray:gategroyTmpShowedArray];
    }];
}

//#pragma mark - 服务车型 - 需求 view 及相关事件
//-(UIView *)setUpServiceHelpDriveTypeNeedViewWithOffset:(float)offset{
//    UIView *view = [[UIView alloc] init];
//    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
//    view.backgroundColor = [UIColor whiteColor];
//    
//    UITapGestureRecognizer *serviceCarTypeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceCarTypeNeedTap)];
//    view.userInteractionEnabled = YES;
//    [view addGestureRecognizer:serviceCarTypeTap];
//    
//    UILabel *noteLabel = [[UILabel alloc] init];
//    noteLabel.frame = (CGRect){10,0,75,HEIGHT(view)};
//    noteLabel.text = @"所需服务";
//    noteLabel.textColor = RGBColor(50, 50, 50);
//    noteLabel.textAlignment = NSTextAlignmentLeft;
//    noteLabel.font = [UIFont boldSystemFontOfSize:15];
//    [view addSubview:noteLabel];
//    
//    serviceHelpDriveTypeNeedInfoLabel = [[UILabel alloc] init];
//    serviceHelpDriveTypeNeedInfoLabel.frame = (CGRect){RIGHT(noteLabel)+10,0,WIDTH(view)-RIGHT(noteLabel)-10-10,HEIGHT(view)};
//    serviceHelpDriveTypeNeedInfoLabel.text = @"";
//    serviceHelpDriveTypeNeedInfoLabel.textColor = RGBColor(50, 50, 50);
//    serviceHelpDriveTypeNeedInfoLabel.textAlignment = NSTextAlignmentRight;
//    serviceHelpDriveTypeNeedInfoLabel.font = Font(14);
//    [view addSubview:serviceHelpDriveTypeNeedInfoLabel];
//    
//    [self getAllHelpDriveGategroyList];
//    return view;
//}
//
//-(void)serviceCarTypeNeedTap{
//    [self resignAllInputs];
//    if (!serviceHelpDriveTypeListDataArray || serviceHelpDriveTypeListDataArray.count == 0) {
//        [BYToastView showToastWithMessage:@"数据不存在,请稍候再试"];
//        [self getAllHelpDriveGategroyList];
//        return;
//    }
//    [PopUpSelectedView showFilterSingleChooseViewWithArray:serviceHelpDriveTypeListDataArray withTitle:@"选择服务" target:self labelTapAction:@selector(serviceHelpDriveNeedSelectClick:)];
//}
//
//-(void)serviceHelpDriveNeedSelectClick:(UITapGestureRecognizer *)tap{
//    if (!serviceHelpDriveTypeListDataArray || serviceHelpDriveTypeListDataArray.count == 0) {
//        return;
//    }
//    NSDictionary *dic = serviceHelpDriveTypeListDataArray[tap.view.tag];
//    serviceHelpDriveTypeNeedInfoDic = dic;
//    NSString *name = dic[@"name"];
//    serviceHelpDriveTypeNeedInfoLabel.text = name;
//    [PopUpSelectedView dismissFilterChooseView];
//}


#pragma mark - 供应地的 view 和相关事件
-(UIView *)setUpProvideAreaViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *provideAreaViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(provideAreaViewTap)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:provideAreaViewTap];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,75,HEIGHT(view)};
    noteLabel.text = @"供应区域";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    provideAreaInfoLabel = [[UILabel alloc] init];
    provideAreaInfoLabel.frame = (CGRect){RIGHT(noteLabel)+10,0,WIDTH(view)-RIGHT(noteLabel)-10-10,HEIGHT(view)};
    provideAreaInfoLabel.text = @"";
    provideAreaInfoLabel.textColor = RGBColor(50, 50, 50);
    provideAreaInfoLabel.textAlignment = NSTextAlignmentRight;
    provideAreaInfoLabel.font = Font(14);
    [view addSubview:provideAreaInfoLabel];
    
    [self getAreaList];
    return view;
}

-(void)provideAreaViewTap{
    [self resignAllInputs];
    if (!provideAreaListArray || provideAreaListArray.count == 0) {
        [BYToastView showToastWithMessage:@"数据不存在,请稍候再试"];
        [self getAreaList];
        return;
    }
    [PopUpSelectedView showFilterSingleChooseViewWithArray:provideAreaListArray withTitle:@"产品供应地" target:self labelTapAction:@selector(provideAreaActiveSelectClick:)];
}

-(void)provideAreaActiveSelectClick:(UITapGestureRecognizer *)tap{
    if (!provideAreaListArray || provideAreaListArray.count == 0) {
        return;
    }
    NSDictionary *dic = provideAreaListArray[tap.view.tag];
    provideAreaInfoDic = dic;
    NSString *name = dic[@"name"];
    provideAreaInfoLabel.text = name;
    [PopUpSelectedView dismissFilterChooseView];
}

-(void)getAreaList{
    int cityID = [BBUserDefaults getCityID];
    [BBUrlConnection getAllDistrictWithCityID:cityID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取供应区域信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"获取供应区域信息失败,请稍后再试"];
            return;
        }
        
        NSArray *districtsArray = dataDic[@"districts"];
        if (!districtsArray || districtsArray.count == 0 || ![districtsArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取供应区域信息失败,请稍后再试"];
            return;
        }
        
        NSMutableArray *districtsTmpShowedArray = [NSMutableArray array];
        for (NSDictionary *dic in districtsArray) {
            int districtIDTmp = [dic[@"id"] intValue];
            NSString *name1 = dic[@"name"];
            NSString *name2 = dic[@"suffix"];
            NSString *name = [name1 stringByAppendingString:name2];
            [districtsTmpShowedArray addObject:@{@"id":@(districtIDTmp),@"name":name}];
        }
        provideAreaListArray = [NSArray arrayWithArray:districtsTmpShowedArray];
    }];
}



#pragma mark - 所需天数 view 及相关事件
-(UIView *)setUpDayCountViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"所需天数";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    
    dayCountTextField = [[UITextField alloc] init];
    dayCountTextField.frame = (CGRect){
        RIGHT(noteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(noteLabel)+10)-10,
        titleLineHeight
    };
    dayCountTextField.textColor = RGBColor(80, 80, 80);
    dayCountTextField.font = Font(15);
    dayCountTextField.minimumFontSize = 10;
    dayCountTextField.textAlignment = NSTextAlignmentRight;
    dayCountTextField.adjustsFontSizeToFitWidth = YES;
    dayCountTextField.returnKeyType = UIReturnKeyDone;
    dayCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [dayCountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [dayCountTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [dayCountTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(dayCountTextField)}]];
    [dayCountTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(dayCountTextField)}]];
    dayCountTextField.leftViewMode = UITextFieldViewModeAlways;
    dayCountTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:dayCountTextField];
    
    return view;
}

#pragma mark - 产品描述 view 及相关事件
-(UIView *)setUpDesciptionViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+200};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,155,titleLineHeight};
    noteLabel.text = @"详情描述";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.frame = (CGRect){0,HEIGHT(noteLabel)-0.5,WIDTH(view),0.5};
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view addSubview:lineSepView];
    
    decriptionTextView = [[UITextView alloc] init];
    decriptionTextView.backgroundColor = [UIColor whiteColor];
    decriptionTextView.frame = (CGRect){10,HEIGHT(noteLabel)+10,WIDTH(view)-10,200};
    decriptionTextView.textColor = RGBColor(100, 100, 100);
    decriptionTextView.font = Font(15);
    decriptionTextView.keyboardType = UIKeyboardTypeDefault;
    decriptionTextView.returnKeyType = UIReturnKeyNext;
    decriptionTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    decriptionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [view addSubview:decriptionTextView];
    
    view.frame = (CGRect){0,offset,WIDTH(contentView),BOTTOM(decriptionTextView)+10};
    return view;
}

#pragma mark -
-(void)resignAllInputs{
    if (keyWordsTextFiledArray && keyWordsTextFiledArray.count != 0) {
        for (UITextField *tf in keyWordsTextFiledArray) {
            [tf resignFirstResponder];
        }
    }
    
    [titleEditTextFiled resignFirstResponder];
    [dayCountTextField resignFirstResponder];
    [decriptionTextView resignFirstResponder];
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.title = @"代驾服务-发布";
    
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
