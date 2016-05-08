//
//  MyAssetsViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/1.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MyAssetsViewController.h"

#import "UserChargeViewController.h"
#import "UserWithDrawViewController.h"
#import "MyAssetsRecordViewController.h"

@interface MyAssetsViewController ()

@end

@implementation MyAssetsViewController{
    UILabel *yueLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    UIView *view1 = [[UIView alloc] init];
    view1.frame = (CGRect){0,0,WIDTH(contentView),65};
    view1.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:view1];
    
    UILabel *yueNoteLabel = [[UILabel alloc] init];
    yueNoteLabel.frame = (CGRect){15,20,70,25};
    yueNoteLabel.text = @"当前余额：";
    yueNoteLabel.textColor = RGBColor(50, 50, 50);
    yueNoteLabel.font = Font(14);
    yueNoteLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:yueNoteLabel];
    
    yueLabel = [[UILabel alloc] init];
    yueLabel.frame = (CGRect){85,20,110,25};
    yueLabel.text = [NSString stringWithFormat:@"%d点",self.userRemainPoints];
    yueLabel.textColor = BB_BlueColor;
    yueLabel.textAlignment = NSTextAlignmentLeft;
    yueLabel.font = Font(14);
    [view1 addSubview:yueLabel];
    
    UIButton *chargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chargeButton.frame = (CGRect){WIDTH(view1)-15-50-10-50,17,50,30};
    [chargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [chargeButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    chargeButton.layer.cornerRadius = 2.f;
    chargeButton.layer.masksToBounds = YES;
    chargeButton.layer.borderWidth = 0.5;
    chargeButton.layer.borderColor = BB_BlueColor.CGColor;
    [view1 addSubview:chargeButton];
    [chargeButton addTarget:self action:@selector(chargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    outButton.frame = (CGRect){WIDTH(view1)-15-50,17,50,30};
    [outButton setTitle:@"提现" forState:UIControlStateNormal];
    [outButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    outButton.layer.cornerRadius = 2.f;
    outButton.layer.masksToBounds = YES;
    outButton.layer.borderWidth = 0.5;
    outButton.layer.borderColor = BB_BlueColor.CGColor;
    [view1 addSubview:outButton];
    [outButton addTarget:self action:@selector(outButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view2 = [[UIView alloc] init];
    view2.frame = (CGRect){0,BOTTOM(view1)+10,WIDTH(contentView),45};
    view2.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:view2];
    
    UILabel *xiaofeiNoteLabel = [[UILabel alloc] init];
    xiaofeiNoteLabel.frame = (CGRect){15,0,70,HEIGHT(view2)};
    xiaofeiNoteLabel.text = @"消费记录";
    xiaofeiNoteLabel.textColor = RGBColor(50, 50, 50);
    xiaofeiNoteLabel.font = Font(15);
    xiaofeiNoteLabel.textAlignment = NSTextAlignmentLeft;
    [view2 addSubview:xiaofeiNoteLabel];
    
    UIImageView *xiaofeiMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
    xiaofeiMoreImageView.frame = (CGRect){WIDTH(view2)-20-10,(HEIGHT(view2)-11)/2,7,11};
    [view2 addSubview:xiaofeiMoreImageView];
    
    UIView *lineSepLineView2 = [[UIView alloc] init];
    lineSepLineView2.frame = (CGRect){0,HEIGHT(view2)-0.5,WIDTH(view2),0.5};
    lineSepLineView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view2 addSubview:lineSepLineView2];
    
    
    UIView *view3 = [[UIView alloc] init];
    view3.frame = (CGRect){0,BOTTOM(view2),WIDTH(contentView),45};
    view3.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:view3];
    
    UILabel *chongzhiNoteLabel = [[UILabel alloc] init];
    chongzhiNoteLabel.frame = (CGRect){15,0,70,HEIGHT(view3)};
    chongzhiNoteLabel.text = @"充值记录";
    chongzhiNoteLabel.textColor = RGBColor(50, 50, 50);
    chongzhiNoteLabel.font = Font(15);
    chongzhiNoteLabel.textAlignment = NSTextAlignmentLeft;
    [view3 addSubview:chongzhiNoteLabel];
    
    UIImageView *chongzhiMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
    chongzhiMoreImageView.frame = (CGRect){WIDTH(view3)-20-10,(HEIGHT(view3)-11)/2,7,11};
    [view3 addSubview:chongzhiMoreImageView];
    
    view2.userInteractionEnabled = YES;
    [view2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaofeijiluTapTrigger)]];
    
    view3.userInteractionEnabled = YES;
    [view3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chongzhijiluTapTrigger)]];
}


-(void)chargeButtonClick{
    UserChargeViewController *ucVC = [[UserChargeViewController alloc] init];
    [self.navigationController pushViewController:ucVC animated:YES];
}

-(void)outButtonClick{
    UserWithDrawViewController *uwdVC = [[UserWithDrawViewController alloc] init];
    uwdVC.userRemainPoints = self.userRemainPoints;
    [self.navigationController pushViewController:uwdVC animated:YES];
}

-(void)xiaofeijiluTapTrigger{
    MyAssetsRecordViewController *marVC = [[MyAssetsRecordViewController alloc] init];
    marVC.isChargeRecord = NO;
    [self.navigationController pushViewController:marVC animated:YES];
}

-(void)chongzhijiluTapTrigger{
    MyAssetsRecordViewController *marVC = [[MyAssetsRecordViewController alloc] init];
    marVC.isChargeRecord = YES;
    [self.navigationController pushViewController:marVC animated:YES];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"我的资产";
    
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
    if (yueLabel) {
        int balance = [BBUserDefaults getUserBalance];
        self.userRemainPoints = balance;
        yueLabel.text = [NSString stringWithFormat:@"%d点",self.userRemainPoints];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end