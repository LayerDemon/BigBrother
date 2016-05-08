//
//  PostOnTopViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/6.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "PostOnTopViewController.h"
#import "UserChargeViewController.h"

@interface PostOnTopViewController ()

@end

@implementation PostOnTopViewController{
    NSArray *tagsArray;
    NSMutableArray *onTopTimeButtonsArray;
    
    UILabel *needPayPointLabel;
    UIButton *comfirmButton;
    
    int needPaypoints,needDayCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),130};
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    NSString *postTitle = self.postInfo.title;
    
    UILabel *postTitleLabel = [[UILabel alloc] init];
    postTitleLabel.frame = (CGRect){15,0,WIDTH(contentView)-15*2,50};
    postTitleLabel.text = [NSString stringWithFormat:@"置顶信息:%@",postTitle];
    postTitleLabel.textColor = RGBColor(80, 80, 80);
    postTitleLabel.textAlignment = NSTextAlignmentLeft;
    postTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    postTitleLabel.font = Font(15);
    [contentView addSubview:postTitleLabel];
    
    UIView *titleSepLineView = [[UIView alloc] init];
    titleSepLineView.frame = (CGRect){0,BOTTOM(postTitleLabel)-0.5,WIDTH(contentView),0.5};
    titleSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [contentView addSubview:titleSepLineView];
    
    UILabel *onTopTimeNoteLabel = [[UILabel alloc] init];
    onTopTimeNoteLabel.frame = (CGRect){15,BOTTOM(titleSepLineView),150,30};
    onTopTimeNoteLabel.text = @"置顶时长";
    onTopTimeNoteLabel.textColor = RGBColor(50, 50, 50);
    onTopTimeNoteLabel.textAlignment = NSTextAlignmentLeft;
    onTopTimeNoteLabel.font = Font(15);
    [contentView addSubview:onTopTimeNoteLabel];
    
    float buttonWidth = (WIDTH(contentView)-15*2-10*3)/4;
    tagsArray = @[@{@"day":@(3),
                    @"name":@"3天",
                    @"point":@(10)
                    },
                  @{@"day":@(7),
                    @"name":@"7天",
                    @"point":@(10)
                    },
                  @{@"day":@(15),
                    @"name":@"15天",
                    @"point":@(10)
                    },
                  @{@"day":@(30),
                    @"name":@"30天",
                    @"point":@(10)
                    }
                  ];
    
    onTopTimeButtonsArray = [NSMutableArray array];
    for (int i = 0; i < tagsArray.count; i++) {
        int xof = i%4;
        UIButton *onTopTimeButton = [[UIButton alloc] init];
        onTopTimeButton.frame  =(CGRect){15+(buttonWidth+10)*xof,BOTTOM(onTopTimeNoteLabel)+10,buttonWidth,30};
        [onTopTimeButton setTitle:[NSString stringWithFormat:@"%@",tagsArray[i][@"name"]] forState:UIControlStateNormal];
        [onTopTimeButton setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
        onTopTimeButton.tag = i;
        onTopTimeButton.titleLabel.font = Font(15);
        onTopTimeButton.layer.borderColor = RGBAColor(100, 100, 100 ,0.3).CGColor;
        onTopTimeButton.layer.borderWidth = 1.f;
        onTopTimeButton.layer.cornerRadius = 3.f;
        onTopTimeButton.layer.masksToBounds = YES;
        [contentView addSubview:onTopTimeButton];
        [onTopTimeButton addTarget:self action:@selector(onTopTimeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [onTopTimeButtonsArray addObject:onTopTimeButton];
    }
    
    UIView *paymentView = [[UIView alloc] init];
    paymentView.frame = (CGRect){0,HEIGHT(self.view)-50,WIDTH(self.view),50};
    paymentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:paymentView];
    
    UILabel *needPayNoteLabel =[[UILabel alloc] init];
    needPayNoteLabel.frame = (CGRect){15,0,50,50};
    needPayNoteLabel.text = @"应付：";
    needPayNoteLabel.textColor = RGBColor(50, 50, 50);
    needPayNoteLabel.font = Font(15);
    needPayNoteLabel.textAlignment = NSTextAlignmentLeft;
    [paymentView addSubview:needPayNoteLabel];
    
    needPayPointLabel = [[UILabel alloc] init];
    needPayPointLabel.frame = (CGRect){65,0,WIDTH(paymentView)-75-15,50};
    needPayPointLabel.text = @"0点数";
    needPayPointLabel.textColor = BB_BlueColor;
    needPayPointLabel.font = Font(15);
    needPayPointLabel.textAlignment = NSTextAlignmentLeft;
    [paymentView addSubview:needPayPointLabel];
    
    comfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    comfirmButton.frame = (CGRect){WIDTH(paymentView)-140,0,140,HEIGHT(paymentView)};
    [comfirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfirmButton.backgroundColor = BB_BlueColor;
    comfirmButton.titleLabel.font = Font(16);
    [comfirmButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [paymentView addSubview:comfirmButton];
    
    [self onTopTimeButtonClick:onTopTimeButtonsArray[0]];
}

-(void)onTopTimeButtonClick:(UIButton *)button{
    int tag = (int)button.tag;
    for (UIButton *bbbtntn in onTopTimeButtonsArray) {
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
    
    NSDictionary *dic = tagsArray[tag];
    needPaypoints = [dic[@"point"] intValue];
    needDayCount = [dic[@"day"] intValue];
    needPayPointLabel.text = [NSString stringWithFormat:@"%d点数",needPaypoints];
}

-(void)comfirmButtonClick{
    [BBUrlConnection updatePostInfoOnTop:YES infoID:self.postInfo.postInfoID dayCount:needDayCount complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0) {
            NSString *message = dataDic[@"message"];
            [BYToastView showToastWithMessage:message];
            if (message) {
                [BYToastView showToastWithMessage:message];
                if ([message rangeOfString:@"余额"].length != 0 && [message rangeOfString:@"不足"].length != 0 ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"点数余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                        alertView.tag = 10101;
                        [alertView show];
                    });
                }
            }
            return;
        }
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            BOOL success = [dataDic[@"success"] boolValue];
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BYToastView showToastWithMessage:[NSString stringWithFormat:@"成功置顶%d天",needDayCount]];
                    [self.navigationController popViewControllerAnimated:YES];
                    self.postInfo.onTop = YES;
                });
                return;
            }
        }
        [BYToastView showToastWithMessage:@"置顶失败,请稍候再试"];
    }];
}

#pragma mark - UIAlertViewDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10101) {
        if (buttonIndex == 1) {
            UserChargeViewController *ucVC = [[UserChargeViewController alloc] init];
            [self.navigationController pushViewController:ucVC animated:YES];
        }
    }
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"置顶服务";
    
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
