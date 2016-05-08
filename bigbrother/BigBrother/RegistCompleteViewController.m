//
//  RegistCompleteViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/28.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "RegistCompleteViewController.h"

#import "AuthcationViewController.h"

@interface RegistCompleteViewController ()

@end

@implementation RegistCompleteViewController

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
    
    UIImage *doneImage = [UIImage imageNamed:@"doneImage"];
    UIImageView *doneImageView = [[UIImageView alloc] initWithImage:doneImage];
    doneImageView.frame = (CGRect){(WIDTH(contentView)-doneImage.size.width)/2,30,doneImage.size.width,doneImage.size.height};
    [contentView addSubview:doneImageView];
    
    UILabel *doneLabel = [[UILabel alloc] init];
    doneLabel.frame = (CGRect){0,BOTTOM(doneImageView)+10,WIDTH(contentView),20};
    doneLabel.text = @"注册成功";
    doneLabel.textColor = RGBColor(50, 50, 50);
    doneLabel.font = Font(17);
    doneLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:doneLabel];
    
    UILabel *doneNoteLabel = [[UILabel alloc] init];
    doneNoteLabel.frame = (CGRect){0,BOTTOM(doneLabel)+30,WIDTH(contentView),16};
    doneNoteLabel.text = @"完善认证资料,免费发布信息";
    doneNoteLabel.textColor = RGBColor(50, 50, 50);
    doneNoteLabel.font = Font(17);
    doneNoteLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:doneNoteLabel];
    
    UIButton *goAuthcationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goAuthcationButton.frame = (CGRect){15,480-20-45-20-45,WIDTH(contentView)-15*2,45};
    goAuthcationButton.backgroundColor = BB_BlueColor;
    [goAuthcationButton setTitle:@"去完善" forState:UIControlStateNormal];
    [goAuthcationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goAuthcationButton.titleLabel.font = Font(15);
    goAuthcationButton.layer.cornerRadius = 4.f;
    goAuthcationButton.layer.masksToBounds = YES;
    [goAuthcationButton addTarget:self action:@selector(goAuthcationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:goAuthcationButton];
    
    UIButton *laterAuthcationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    laterAuthcationButton.frame = (CGRect){15,480-20-45,WIDTH(contentView)-15*2,45};
    laterAuthcationButton.backgroundColor = BB_BlueColor;
    [laterAuthcationButton setTitle:@"以后再说" forState:UIControlStateNormal];
    [laterAuthcationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    laterAuthcationButton.titleLabel.font = Font(15);
    laterAuthcationButton.layer.cornerRadius = 4.f;
    laterAuthcationButton.layer.masksToBounds = YES;
    [laterAuthcationButton addTarget:self action:@selector(laterAuthcationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:laterAuthcationButton];
    
}

-(void)goAuthcationButtonClick{
    AuthcationViewController *authVC = [AuthcationViewController new];
    authVC.isFromLogin = YES;
    [self.navigationController pushViewController:authVC animated:YES];
}

-(void)laterAuthcationButtonClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"注册";
    
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
