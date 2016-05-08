//
//  CarPoolPostToViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/25.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CarPoolPostToViewController.h"
#import "WMCustomDatePicker.h"

#import "TPKeyboardAvoidingScrollView.h"
#import "XYW8IndicatorView.h"
#import "LoginViewController.h"

@interface CarPoolPostToViewController ()

@end

@implementation CarPoolPostToViewController{
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
    
    //拼车类型选择相关
    UIView *carPoolTypeChooseView;
    UIButton *carPoolTypeLongTripButton,*carPoolTypeSameCityButton;
    NSString *carPoolTypeString;
    
    //出发目的地点相关
    UIView *startEndPositionView;
    UITextField *startPositionTextfiled;
    UITextField *destinationTextfiled;
    
    //出发时间相关
    UIView *startTimeView;
    UILabel *startTimeLabel;
    
    //供应区域相关
    UIView *provideAreaView;
    UILabel *provideAreaInfoLabel;
    NSDictionary *provideAreaInfoDic;
    NSArray *provideAreaListArray;
    
    //座位相关相关
    UIView *personCountView;
    UILabel *seatNoteLabel;
    UITextField *personCountTextField;
    
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
    
    viewHeightOffset += HEIGHT(provideView);
    
    viewHeightOffset += 10;
    
    keyWordsView = [self setUpKeyWordsViewWithOffset:viewHeightOffset];
    [contentView addSubview:keyWordsView];
    
    viewHeightOffset += HEIGHT(keyWordsView);
    
    viewHeightOffset += 10;
    
    carPoolTypeChooseView = [self setUpCarPoolTypeChooseWithOffset:viewHeightOffset];
    [contentView addSubview:carPoolTypeChooseView];
    
    viewHeightOffset += HEIGHT(carPoolTypeChooseView);
    
    viewHeightOffset += 10;
    
    startEndPositionView = [self setUpStartEndPositionViewWithOffset:viewHeightOffset];
    [contentView addSubview:startEndPositionView];
    
    viewHeightOffset += HEIGHT(startEndPositionView);
    
    viewHeightOffset += 10;
    
    startTimeView = [self setUpStartTimeViewWithOffset:viewHeightOffset];
    [contentView addSubview:startTimeView];
    
    viewHeightOffset += HEIGHT(startTimeView);
    
    viewHeightOffset += 10;
    
    provideAreaView = [self setUpProvideAreaViewWithOffset:viewHeightOffset];
    [contentView addSubview:provideAreaView];
    
    viewHeightOffset += HEIGHT(provideAreaView);
    
    viewHeightOffset += 10;
    
    personCountView = [self setUpRentPersonCountViewWithOffset:viewHeightOffset];
    [contentView addSubview:personCountView];
    
    viewHeightOffset += HEIGHT(personCountView);
    
    viewHeightOffset += 10;
    
    decriptionView = [self setUpDesciptionViewWithOffset:viewHeightOffset];
    [contentView addSubview:decriptionView];
    
    viewHeightOffset += HEIGHT(decriptionView);
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(viewHeightOffset+10, HEIGHT(contentView)+1)};
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
    
    if (![XYTools checkString:carPoolTypeString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"请选择拼车类型"];
        return;
    }
    
    NSString *startP = startPositionTextfiled.text;
    if (![XYTools checkString:startP canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"起点不能为空或包含特殊字符"];
        return;
    }
    NSString *endP = destinationTextfiled.text;
    if (![XYTools checkString:endP canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"目的地不能为空或包含特殊字符"];
        return;
    }
    
    NSString *startTimeString = startTimeLabel.text;
    if (![XYTools checkString:startTimeString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"出发时间不能为空或包含特殊字符"];
        return;
    }
    
    if (!provideAreaInfoDic && provideAreaInfoDic.count ==0) {
        [BYToastView showToastWithMessage:@"未选择服务区域信息"];
        return;
    }
    long provideID = [[provideAreaInfoDic objectForKey:@"id"] longValue];
    
    NSString *seatNeedString = personCountTextField.text;
    if (![XYTools checkString:seatNeedString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"座位数量不能为空或包含特殊字符"];
        return;
    }
    
    NSString *desciptionString = decriptionTextView.text;
    if (![XYTools checkString:desciptionString canEmpty:YES]) {
        [BYToastView showToastWithMessage:@"详情描述不能包含特殊字符"];
        return;
    }
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:keywordMutableArray forKey:@"keywords"];
    [paramsDic setObject:carPoolTypeString forKey:@"carpoolType"];
    [paramsDic setObject:startP forKey:@"start"];
    [paramsDic setObject:endP forKey:@"destination"];
    [paramsDic setObject:startTimeString forKey:@"leaveTime"];
    [paramsDic setObject:@(provideID) forKey:@"districtId"];
    [paramsDic setObject:seatNeedString forKey:@"seatCount"];
    [paramsDic setObject:desciptionString forKey:@"introduction"];
    
    if (isSupply) {
        [paramsDic setObject:ProductSupplyDemandTypeProvide forKey:@"supplyDemandType"];
    }else{
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
    [BBUrlConnection uploadNewCarPoolInfoWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
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
        seatNoteLabel.text = @"提供座位";
    }else{
        seatNoteLabel.text = @"所需座位";
    }
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


#pragma mark - 拼车类型提供或需求 选择 view 及相关事件
-(UIView *)setUpCarPoolTypeChooseWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"拼车类型";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    float buttonWidth = (WIDTH(view)-20-WIDTH(noteLabel)-10)/2.f;
    
    carPoolTypeLongTripButton = [[UIButton alloc] init];
    carPoolTypeLongTripButton.frame = (CGRect){RIGHT(noteLabel)+10,0,buttonWidth,HEIGHT(view)};
    [carPoolTypeLongTripButton setTitle:@"  长途拼车" forState:UIControlStateNormal];
    [carPoolTypeLongTripButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [carPoolTypeLongTripButton setTitleColor:BB_BlueColor forState:UIControlStateSelected];
    [carPoolTypeLongTripButton setImage:[UIImage imageNamed:@"icon_option"] forState:UIControlStateNormal];
    [carPoolTypeLongTripButton setImage:[UIImage imageNamed:@"icon_option_on"] forState:UIControlStateSelected];
    carPoolTypeLongTripButton.titleLabel.font = Font(14);
    carPoolTypeLongTripButton.showsTouchWhenHighlighted = YES;
    [view addSubview:carPoolTypeLongTripButton];
    
    [carPoolTypeLongTripButton addTarget:self action:@selector(carPoolTypeLongTripButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    carPoolTypeSameCityButton = [[UIButton alloc] init];
    carPoolTypeSameCityButton.frame = (CGRect){RIGHT(noteLabel)+10+buttonWidth,0,buttonWidth,HEIGHT(view)};
    [carPoolTypeSameCityButton setTitle:@"  同城拼车" forState:UIControlStateNormal];
    [carPoolTypeSameCityButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [carPoolTypeSameCityButton setTitleColor:BB_BlueColor forState:UIControlStateSelected];
    [carPoolTypeSameCityButton setImage:[UIImage imageNamed:@"icon_option"] forState:UIControlStateNormal];
    [carPoolTypeSameCityButton setImage:[UIImage imageNamed:@"icon_option_on"] forState:UIControlStateSelected];
    carPoolTypeSameCityButton.titleLabel.font = Font(14);
    carPoolTypeSameCityButton.showsTouchWhenHighlighted = YES;
    [view addSubview:carPoolTypeSameCityButton];
    
    [carPoolTypeSameCityButton addTarget:self action:@selector(carPoolTypeSameCityButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([carPoolTypeString isEqualToString:@"LONG_TRIP"]) {
        [carPoolTypeLongTripButton setSelected:YES];
        [carPoolTypeSameCityButton setSelected:NO];
    }else if ([carPoolTypeString isEqualToString:@"SAME_CITY"]){
        [carPoolTypeLongTripButton setSelected:NO];
        [carPoolTypeSameCityButton setSelected:YES];
    }else{
        carPoolTypeString = @"LONG_TRIP";
        [carPoolTypeLongTripButton setSelected:YES];
        [carPoolTypeSameCityButton setSelected:NO];
    }
    return view;
}

-(void)carPoolTypeLongTripButtonClick{
    carPoolTypeString = @"LONG_TRIP";
    [carPoolTypeSameCityButton setSelected:NO];
    [carPoolTypeLongTripButton setSelected:YES];
}

-(void)carPoolTypeSameCityButtonClick{
    carPoolTypeString = @"SAME_CITY";
    [carPoolTypeSameCityButton setSelected:YES];
    [carPoolTypeLongTripButton setSelected:NO];
}

#pragma mark - 出发目的地点 view 及相关事件
-(UIView *)setUpStartEndPositionViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight*2};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,titleLineHeight};
    noteLabel.text = @"出发地点";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    
    startPositionTextfiled = [[UITextField alloc] init];
    startPositionTextfiled.frame = (CGRect){
        RIGHT(noteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(noteLabel)+10)-10,
        titleLineHeight
    };
    startPositionTextfiled.textColor = RGBColor(80, 80, 80);
    startPositionTextfiled.font = Font(15);
    startPositionTextfiled.minimumFontSize = 10;
    startPositionTextfiled.adjustsFontSizeToFitWidth = YES;
    startPositionTextfiled.returnKeyType = UIReturnKeyDone;
    startPositionTextfiled.keyboardType = UIKeyboardTypeDefault;
    [startPositionTextfiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [startPositionTextfiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [startPositionTextfiled setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(startPositionTextfiled)}]];
    [startPositionTextfiled setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(startPositionTextfiled)}]];
    startPositionTextfiled.leftViewMode = UITextFieldViewModeAlways;
    startPositionTextfiled.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:startPositionTextfiled];
    
    UIView *lineSepView = [[UIView alloc] initWithFrame:(CGRect){0,BOTTOM(startPositionTextfiled)-0.5,WIDTH(view),0.5}];
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view addSubview:lineSepView];
    
    UILabel *noteLabel2 = [[UILabel alloc] init];
    noteLabel2.frame = (CGRect){10,titleLineHeight,65,titleLineHeight};
    noteLabel2.text = @"目的地点";
    noteLabel2.textColor = RGBColor(50, 50, 50);
    noteLabel2.textAlignment = NSTextAlignmentLeft;
    noteLabel2.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel2];
    
    destinationTextfiled = [[UITextField alloc] init];
    destinationTextfiled.frame = (CGRect){
        RIGHT(noteLabel2)+10,
        titleLineHeight,
        WIDTH(view)-(RIGHT(noteLabel2)+10)-10,
        titleLineHeight
    };
    destinationTextfiled.textColor = RGBColor(80, 80, 80);
    destinationTextfiled.font = Font(15);
    destinationTextfiled.minimumFontSize = 10;
    destinationTextfiled.adjustsFontSizeToFitWidth = YES;
    destinationTextfiled.returnKeyType = UIReturnKeyDone;
    destinationTextfiled.keyboardType = UIKeyboardTypeDefault;
    [destinationTextfiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [destinationTextfiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [destinationTextfiled setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(destinationTextfiled)}]];
    [destinationTextfiled setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(destinationTextfiled)}]];
    destinationTextfiled.leftViewMode = UITextFieldViewModeAlways;
    destinationTextfiled.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:destinationTextfiled];
    
    return view;
}


#pragma mark - 出发时间 view 及相关事件
-(UIView *)setUpStartTimeViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *startTimeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTimeViewTapTriggle)];
    [view addGestureRecognizer:startTimeViewTap];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"出发时间";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    startTimeLabel = [[UILabel alloc] init];
    startTimeLabel.frame = (CGRect){
        RIGHT(noteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(noteLabel)+10)-10,
        titleLineHeight
    };
    startTimeLabel.textColor = RGBColor(80, 80, 80);
    startTimeLabel.font = Font(15);
    startTimeLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:startTimeLabel];
    
    return view;
}

-(void)startTimeViewTapTriggle{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIButton *wholeButton = [[UIButton alloc] init];
    wholeButton.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    wholeButton.backgroundColor = RGBAColor(0, 0, 0, 0.7);
    [keyWindow addSubview:wholeButton];
    [wholeButton addTarget:self action:@selector(wholeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    WMCustomDatePicker *picker = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, HEIGHT(wholeButton)-260, WIDTH(wholeButton),260) PickerStyle:WMDateStyle_YearMonthDayHourMinute didSelectedDateFinishBack:^(WMCustomDatePicker *picker, NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        
        year = [year stringByReplacingOccurrencesOfString:@"年" withString:@""];
        month = [month stringByReplacingOccurrencesOfString:@"月" withString:@""];
        day = [day stringByReplacingOccurrencesOfString:@"日" withString:@""];
        hour = [hour stringByReplacingOccurrencesOfString:@"时" withString:@""];
        minute = [minute stringByReplacingOccurrencesOfString:@"分" withString:@""];
        
        startTimeLabel.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    }];
    
    picker.minLimitDate = [NSDate date];
    picker.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    [wholeButton addSubview:picker];
}

-(void)wholeButtonClick:(UIButton *)button{
    [button removeFromSuperview];
}

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


#pragma mark - 租用人数 view 及相关事件
-(UIView *)setUpRentPersonCountViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    seatNoteLabel = [[UILabel alloc] init];
    seatNoteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    if (isSupply) {
        seatNoteLabel.text = @"提供座位";
    }else{
        seatNoteLabel.text = @"所需座位";
    }
    seatNoteLabel.textColor = RGBColor(50, 50, 50);
    seatNoteLabel.textAlignment = NSTextAlignmentLeft;
    seatNoteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:seatNoteLabel];
    
    personCountTextField = [[UITextField alloc] init];
    personCountTextField.frame = (CGRect){
        RIGHT(seatNoteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(seatNoteLabel)+10)-10,
        titleLineHeight
    };
    personCountTextField.textColor = RGBColor(80, 80, 80);
    personCountTextField.font = Font(15);
    personCountTextField.minimumFontSize = 10;
    personCountTextField.textAlignment = NSTextAlignmentRight;
    personCountTextField.adjustsFontSizeToFitWidth = YES;
    personCountTextField.returnKeyType = UIReturnKeyDone;
    personCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [personCountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [personCountTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [personCountTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(personCountTextField)}]];
    [personCountTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(personCountTextField)}]];
    personCountTextField.leftViewMode = UITextFieldViewModeAlways;
    personCountTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:personCountTextField];
    
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
    for (UITextField *tf in keyWordsTextFiledArray) {
        [tf resignFirstResponder];
    }
    
    [startPositionTextfiled resignFirstResponder];
    [destinationTextfiled resignFirstResponder];
    [personCountTextField resignFirstResponder];
    [decriptionTextView resignFirstResponder];
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.title = @"拼车服务-发布";
    
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
