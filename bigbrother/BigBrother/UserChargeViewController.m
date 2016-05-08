//
//  UserChargeViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/2.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UserChargeViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface UserChargeViewController () <UITextFieldDelegate>

@end

@implementation UserChargeViewController{
    UILabel *needPayMoneyLabel;
    
    UILabel *remainPointsLabel;
    UITextField *entryChargePointTextField;
    UILabel *choosePointsLabel;
    
    int chargeNumerpoints;
    
    NSMutableArray *chargedButtonArray;
    
    UIImageView *wechatPaySelectImageView;
    UIImageView *aliPaySelectImageView;
    
    UILabel *wechatPayNoteLabel;
    UILabel *aliPayNoteLabel;
    
    int paymentType;
    
    UIButton *comfirmButton;
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
    
    UIView *needPayView = [[UIView alloc] init];
    needPayView.frame = (CGRect){0,HEIGHT(self.view)-50,WIDTH(self.view),50};
    needPayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:needPayView];
    
    UILabel *needPayNoteLabel =[[UILabel alloc] init];
    needPayNoteLabel.frame = (CGRect){15,0,90,50};
    needPayNoteLabel.text = @"需支付金额：";
    needPayNoteLabel.textColor = RGBColor(50, 50, 50);
    needPayNoteLabel.font = Font(15);
    needPayNoteLabel.textAlignment = NSTextAlignmentLeft;
    [needPayView addSubview:needPayNoteLabel];
    
    needPayMoneyLabel = [[UILabel alloc] init];
    needPayMoneyLabel.frame = (CGRect){105,0,WIDTH(needPayView)-75-15,50};
    needPayMoneyLabel.text = @"¥ 0.00";
    needPayMoneyLabel.textColor = BB_BlueColor;
    needPayMoneyLabel.font = Font(15);
    needPayMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [needPayView addSubview:needPayMoneyLabel];
    
    comfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    comfirmButton.frame = (CGRect){WIDTH(needPayView)-140,0,140,HEIGHT(needPayView)};
    [comfirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfirmButton.backgroundColor = BB_BlueColor;
    comfirmButton.titleLabel.font = Font(16);
    [comfirmButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [needPayView addSubview:comfirmButton];
    
    UIView *view1 = [[UIView alloc] init];
    view1.frame = (CGRect){0,0,WIDTH(contentView),50};
    view1.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:view1];
    
    UILabel *remainPointsNoteLabel = [[UILabel alloc] init];
    remainPointsNoteLabel.frame = (CGRect){15,15,110,25};
    remainPointsNoteLabel.text = @"账户剩余点数：";
    remainPointsNoteLabel.textColor = RGBColor(50, 50, 50);
    remainPointsNoteLabel.font = Font(14);
    remainPointsNoteLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:remainPointsNoteLabel];
    
    remainPointsLabel = [[UILabel alloc] init];
    remainPointsLabel.frame = (CGRect){115,15,110,25};
    remainPointsLabel.text = [NSString stringWithFormat:@"%d点",[BBUserDefaults getUserBalance]];
    remainPointsLabel.textColor = BB_BlueColor;
    remainPointsLabel.textAlignment = NSTextAlignmentLeft;
    remainPointsLabel.font = Font(14);
    [view1 addSubview:remainPointsLabel];
    
    UIView *chargeDetailView = [[UIView alloc] init];
    chargeDetailView.frame = (CGRect){0,BOTTOM(view1)+10,WIDTH(contentView),185};
    chargeDetailView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:chargeDetailView];
    
    UILabel *chargePointsNoteLabel = [[UILabel alloc] init];
    chargePointsNoteLabel.frame = (CGRect){15,10,90,15};
    chargePointsNoteLabel.text = @"选择充值金额";
    chargePointsNoteLabel.textColor = RGBColor(50, 50, 50);
    chargePointsNoteLabel.font = Font(14);
    chargePointsNoteLabel.textAlignment = NSTextAlignmentLeft;
    [chargeDetailView addSubview:chargePointsNoteLabel];
    
    UILabel *chargePointsNote2Label = [[UILabel alloc] init];
    chargePointsNote2Label.frame = (CGRect){105,14,150,10};
    chargePointsNote2Label.text = @"人民币1元=100点数";
    chargePointsNote2Label.textColor = BB_BlueColor;
    chargePointsNote2Label.font = Font(11);
    chargePointsNote2Label.textAlignment = NSTextAlignmentLeft;
    [chargeDetailView addSubview:chargePointsNote2Label];
    
    float buttonWidth = (WIDTH(chargeDetailView)-15*2-10*3)/4;
    NSArray *tagsArray = @[@(300),@(500),@(1000),@(2000),@(3000),@(5000),@(10000),@(20000)];
    
    chargedButtonArray = [NSMutableArray array];
    for (int i = 0; i < tagsArray.count; i++) {
        int xof = i%4;
        int yof = i/4;
        UIButton *chargeButton = [[UIButton alloc] init];
        chargeButton.frame  =(CGRect){15+(buttonWidth+10)*xof,35+(30+10)*yof,buttonWidth,30};
        [chargeButton setTitle:[NSString stringWithFormat:@"%d",[tagsArray[i] intValue]] forState:UIControlStateNormal];
        [chargeButton setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
        chargeButton.tag = [tagsArray[i] intValue];
        chargeButton.titleLabel.font = Font(15);
        chargeButton.layer.borderColor = RGBAColor(100, 100, 100 ,0.3).CGColor;
        chargeButton.layer.borderWidth = 1.f;
        chargeButton.layer.cornerRadius = 3.f;
        chargeButton.layer.masksToBounds = YES;
        [chargeDetailView addSubview:chargeButton];
        [chargeButton addTarget:self action:@selector(chargeButtonNumberClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [chargedButtonArray addObject:chargeButton];
    }
    
    entryChargePointTextField = [[UITextField alloc] init];
    entryChargePointTextField.frame = (CGRect){15,120,WIDTH(chargeDetailView)-15*2,30};
    entryChargePointTextField.layer.cornerRadius = 2.f;
    entryChargePointTextField.layer.masksToBounds = YES;
    entryChargePointTextField.layer.borderWidth = 1.f;
    entryChargePointTextField.layer.borderColor = RGBAColor(100, 100, 100 ,0.3).CGColor;
    entryChargePointTextField.textColor = RGBColor(100, 100, 100);
    entryChargePointTextField.font = Font(14);
    entryChargePointTextField.minimumFontSize = 10;
    entryChargePointTextField.adjustsFontSizeToFitWidth = YES;
    entryChargePointTextField.returnKeyType = UIReturnKeyDone;
    entryChargePointTextField.keyboardType = UIKeyboardTypePhonePad;
    entryChargePointTextField.placeholder = @"手动输入其它点数";
    [entryChargePointTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [entryChargePointTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [entryChargePointTextField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(entryChargePointTextField)}]];
    [entryChargePointTextField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(entryChargePointTextField)}]];
    entryChargePointTextField.leftViewMode = UITextFieldViewModeAlways;
    entryChargePointTextField.rightViewMode = UITextFieldViewModeAlways;
    [chargeDetailView addSubview:entryChargePointTextField];
    
    UILabel *choosePointNoteLabel =[[UILabel alloc] init];
    choosePointNoteLabel.frame = (CGRect){15,160,60,15};
    choosePointNoteLabel.text = @"已选择：";
    choosePointNoteLabel.textColor = RGBColor(50, 50, 50);
    choosePointNoteLabel.font = Font(15);
    choosePointNoteLabel.textAlignment = NSTextAlignmentLeft;
    [chargeDetailView addSubview:choosePointNoteLabel];
    
    choosePointsLabel = [[UILabel alloc] init];
    choosePointsLabel.frame = (CGRect){75,160,WIDTH(chargeDetailView)-75-15,15};
    choosePointsLabel.text = @"0点";
    choosePointsLabel.textColor = BB_BlueColor;
    choosePointsLabel.font = Font(15);
    choosePointsLabel.textAlignment = NSTextAlignmentLeft;
    [chargeDetailView addSubview:choosePointsLabel];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        UITextField *tf = [note object];
        if (tf == entryChargePointTextField) {
            for (UIButton *bbbtntn in chargedButtonArray) {
                [bbbtntn setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
                bbbtntn.titleLabel.font = Font(15);
                bbbtntn.layer.borderColor = RGBAColor(100, 100, 100,0.3).CGColor;
            }
            NSString *string = entryChargePointTextField.text;
            if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                chargeNumerpoints = 0;
            }else{
                int stringInt = [string intValue];
                if (stringInt < 0  || stringInt > 10000000) {
                    [BYToastView showToastWithMessage:@"输入的数字过大"];
                    chargeNumerpoints = 10000000;
                    return;
                }else{
                    chargeNumerpoints = stringInt;
                }
            }
            choosePointsLabel.text = [NSString stringWithFormat:@"%d点",chargeNumerpoints];
            needPayMoneyLabel.text = [NSString stringWithFormat:@"¥ %.02f",chargeNumerpoints/100.f];
        }
    }];
    
    UIView *paymentView = [[UIView alloc] init];
    paymentView.frame = (CGRect){0,BOTTOM(chargeDetailView)+10,WIDTH(contentView),120};
    paymentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:paymentView];
    
    UILabel *paymentTypeNoteLabel = [[UILabel alloc] init];
    paymentTypeNoteLabel.frame = (CGRect){15,0,WIDTH(paymentView)-15*2,40};
    paymentTypeNoteLabel.text = @"选择支付方式";
    paymentTypeNoteLabel.textColor = RGBColor(50, 50, 50);
    paymentTypeNoteLabel.font = Font(14);
    paymentTypeNoteLabel.textAlignment = NSTextAlignmentLeft;
    [paymentView addSubview:paymentTypeNoteLabel];
    
    UIView *sepLine1 = [[UIView alloc] init];
    sepLine1.frame = (CGRect){0,BOTTOM(paymentTypeNoteLabel)-0.5,WIDTH(paymentView),0.5};
    sepLine1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [paymentView addSubview:sepLine1];
    
    UIView *wechatPayView = [[UIView alloc] init];
    wechatPayView.frame = (CGRect){0,40,WIDTH(paymentView),40};
    [paymentView addSubview:wechatPayView];
    
    wechatPayView.userInteractionEnabled = YES;
    [wechatPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatPayViewClick)]];
    
    wechatPaySelectImageView = [[UIImageView alloc] init];
    wechatPaySelectImageView.frame = (CGRect){15,(40-20)/2,21,21};
    wechatPaySelectImageView.image = [UIImage imageNamed:@"icon_option"];
    [wechatPayView addSubview:wechatPaySelectImageView];
    
    wechatPayNoteLabel = [[UILabel alloc] init];
    wechatPayNoteLabel.frame = (CGRect){50,0,WIDTH(paymentView)-15*2,40};
    wechatPayNoteLabel.text = @"微信支付";
    wechatPayNoteLabel.textColor = RGBColor(50, 50, 50);
    wechatPayNoteLabel.font = Font(14);
    wechatPayNoteLabel.textAlignment = NSTextAlignmentLeft;
    [wechatPayView addSubview:wechatPayNoteLabel];
    
    
    
    UIView *aliPayView = [[UIView alloc] init];
    aliPayView.frame = (CGRect){0,80,WIDTH(paymentView),40};
    [paymentView addSubview:aliPayView];
    
    aliPayView.userInteractionEnabled = YES;
    [aliPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliPayViewClick)]];
    
    aliPaySelectImageView = [[UIImageView alloc] init];
    aliPaySelectImageView.frame = (CGRect){15,(40-20)/2,21,21};
    aliPaySelectImageView.image = [UIImage imageNamed:@"icon_option"];
    [aliPayView addSubview:aliPaySelectImageView];
    
    aliPayNoteLabel = [[UILabel alloc] init];
    aliPayNoteLabel.frame = (CGRect){50,0,WIDTH(paymentView)-15*2,40};
    aliPayNoteLabel.text = @"支付宝支付";
    aliPayNoteLabel.textColor = RGBColor(50, 50, 50);
    aliPayNoteLabel.font = Font(14);
    aliPayNoteLabel.textAlignment = NSTextAlignmentLeft;
    [aliPayView addSubview:aliPayNoteLabel];
    
    paymentType = 0;
    
    UIView *sepLine2 = [[UIView alloc] init];
    sepLine2.frame = (CGRect){0,80-0.5,WIDTH(paymentView),0.5};
    sepLine2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [paymentView addSubview:sepLine2];
}

-(void)comfirmButtonClick{
    [entryChargePointTextField resignFirstResponder];
    if (chargeNumerpoints == 0) {
        [BYToastView showToastWithMessage:@"请选择充值金额"];
        return;
    }
    if (paymentType == 0) {
        [BYToastView showToastWithMessage:@"请选择支付方式"];
        return;
    }
    
    //paymentType = 1 微信支付  payment=2 支付宝支付
    
    //todo  现在是模拟支付阶段 直接调用api增加点数
    [BYToastView showToastWithMessage:@"模拟支付,直接增加点数"];
    //    comfirmButton.enabled = NO;
    //    comfirmButton.alpha = 0.5f;
    [BBUrlConnection increasePoint:chargeNumerpoints complete:^(NSDictionary *resultDic, NSString *errorString) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            comfirmButton.enabled = YES;
            comfirmButton.alpha = 1.f;
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
            remainPointsLabel.text = [NSString stringWithFormat:@"%d点",balance];
            [BBUserDefaults setUserBalance:balance];
            [BYToastView showToastWithMessage:@"充值成功"];
        });
    }];
    
}

-(void)chargeButtonNumberClick:(UIButton *)button{
    int tag = (int)button.tag;
    entryChargePointTextField.layer.borderColor = RGBAColor(100, 100, 100 ,0.3).CGColor;
    entryChargePointTextField.text = @"";
    for (UIButton *bbbtntn in chargedButtonArray) {
        if (button == bbbtntn) {
            [bbbtntn setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            bbbtntn.titleLabel.font = Font(15);
            bbbtntn.layer.borderColor = BB_BlueColor.CGColor;
        }else{
            [bbbtntn setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
            bbbtntn.titleLabel.font = Font(15);
            bbbtntn.layer.borderColor = RGBAColor(100, 100, 100,0.3).CGColor;
        }
    }
    choosePointsLabel.text = [NSString stringWithFormat:@"%d点",tag];
    chargeNumerpoints = tag;
    needPayMoneyLabel.text = [NSString stringWithFormat:@"¥ %.02f",chargeNumerpoints/100.f];
}

-(void)wechatPayViewClick{
    wechatPaySelectImageView.image = [UIImage imageNamed:@"icon_option_on"];
    wechatPayNoteLabel.textColor = BB_BlueColor;
    aliPaySelectImageView.image = [UIImage imageNamed:@"icon_option"];
    aliPayNoteLabel.textColor = RGBColor(50, 50, 50);
    paymentType = 1;
}

-(void)aliPayViewClick{
    wechatPaySelectImageView.image = [UIImage imageNamed:@"icon_option"];
    wechatPayNoteLabel.textColor = RGBColor(50, 50, 50);
    aliPaySelectImageView.image = [UIImage imageNamed:@"icon_option_on"];
    aliPayNoteLabel.textColor = BB_BlueColor;
    paymentType = 2;
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"充值";
    
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