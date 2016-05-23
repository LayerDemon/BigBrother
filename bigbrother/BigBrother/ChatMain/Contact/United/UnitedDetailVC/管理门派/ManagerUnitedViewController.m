
//
//  ManagerUnitedViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ManagerUnitedViewController.h"
#import "SetManagerViewController.h"
#import "SetSpeakViewController.h"
#import "SetMemberRankViewController.h"

@interface ManagerUnitedViewController ()


- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation ManagerUnitedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"管理门派";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
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

    
    NSInteger max_Y = 0;
    //设置管理员
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    
    for (int i = 0; i < [_unitedDetailDic[@"members"] count]; i ++) {
        if ([dataDic[@"id"] integerValue] == [_unitedDetailDic[@"members"][i][@"id"] integerValue]) {
            if ([_unitedDetailDic[@"members"][i][@"role"] isEqualToString:@"OWNER"]) {
               UIButton * setManagerButton = [self createButtonWithTitle:@"设置管理员"];
                setManagerButton.frame = FLEXIBLE_FRAME(0, 0, 320, 40);
                [setManagerButton addTarget:self action:@selector(setManagerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                max_Y += 40;
            }
        }
    }
    
    //设置门派内禁言
    UIButton * setUnitedSpeakButton = [self createButtonWithTitle:@"设置门派内禁言"];
    setUnitedSpeakButton.frame = FLEXIBLE_FRAME(0, max_Y, 320, 40);
    [setUnitedSpeakButton addTarget:self action:@selector(setSpearkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    max_Y += 40;
    
    //设置成员头衔
    UIButton * setMemberButton = [self createButtonWithTitle:@"设置成员头衔"];
    setMemberButton.frame = FLEXIBLE_FRAME(0, max_Y, 320, 40);
    [setMemberButton addTarget:self action:@selector(setMemberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -- button pressed
- (void)setManagerButtonPressed:(UIButton *)sender
{
    SetManagerViewController * setManagerVC = [[SetManagerViewController alloc] init];
    setManagerVC.unitedDetailDic = _unitedDetailDic;
    [self.navigationController pushViewController:setManagerVC animated:YES];
}

- (void)setSpearkButtonPressed:(UIButton *)sender
{
    SetSpeakViewController * setSpeakVC = [[SetSpeakViewController alloc] init];
    setSpeakVC.unitedDetailDic = _unitedDetailDic;
    [self.navigationController pushViewController:setSpeakVC animated:YES];
}

- (void)setMemberButtonPressed:(UIButton *)sender
{
    SetMemberRankViewController * setMemberVC = [[SetMemberRankViewController alloc] init];
    setMemberVC.unitedDetailDic = _unitedDetailDic;
    [self.navigationController pushViewController:setMemberVC animated:YES];
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
