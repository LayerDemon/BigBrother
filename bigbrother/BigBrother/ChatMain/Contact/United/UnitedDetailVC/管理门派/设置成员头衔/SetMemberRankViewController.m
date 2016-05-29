//
//  SetMemberRankViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SetMemberRankViewController.h"

#import "SetRankNameViewController.h"
#import "SetLowerRankViewController.h"

@interface SetMemberRankViewController ()


- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation SetMemberRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"设置成员头衔";
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark -- initialize
- (void)initializeDataSource
{

}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
        //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    
    //设置等级头衔
    UIButton * setRankNameButton = [self createButtonWithTitle:@"设置等级头衔"];
    setRankNameButton.frame = FLEXIBLE_FRAME(0, 0, 320, 40);
    [setRankNameButton addTarget:self action:@selector(setRankNameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //授予下级头衔
    UIButton * setMemberRankButton = [self createButtonWithTitle:@"授予下级头衔"];
    setMemberRankButton.frame = FLEXIBLE_FRAME(0, 40, 320, 40);
    [setMemberRankButton addTarget:self action:@selector(setMemberRankButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -- button pressed
- (void)setRankNameButtonPressed:(UIButton *)sender
{
    SetRankNameViewController * setRankNameVC = [[SetRankNameViewController alloc] init];
    setRankNameVC.unitedDetailDic = _unitedDetailDic;
    [self.navigationController pushViewController:setRankNameVC animated:YES];
}

- (void)setMemberRankButtonPressed:(UIButton *)sender
{
    SetLowerRankViewController * setLowerRankVC = [[SetLowerRankViewController alloc] init];
    setLowerRankVC.unitedDetailDic = _unitedDetailDic;
    setLowerRankVC.memberArray = _unitedDetailDic[@"members"];
    [self.navigationController pushViewController:setLowerRankVC animated:YES];
}

#pragma mrak -- my methods
- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [self createLabelWithText:title font:FLEXIBLE_NUM(13) subView:button];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 100, 40);
    [self.view addSubview:button];
    
    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(295, 15, 10, 10)];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.image = [UIImage imageNamed:@"icon_more"];
    [button addSubview:rightImageView];
    
    UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:button];
    lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    
    return button;
}



#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    label.font = [UIFont systemFontOfSize:font];
    [subView addSubview:label];
    return label;
}

#pragma mark -- create button 
- (UIButton *)createButtonWithTitle:(NSString *)title font:(CGFloat)font subView:(UIView *)subView
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [subView addSubview:button];
    return button;
}

#pragma mark -- create view
- (UIView *)createViewWithBackColor:(UIColor *)color subView:(UIView *)subView
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = color;
    [subView addSubview:view];
    return view;
}


@end
