//
//  SetSpeakViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/20.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SetSpeakViewController.h"

@interface SetSpeakViewController ()

@property (strong, nonatomic) UISwitch      * mainSwitch;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation SetSpeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"设置门派内禁言";
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
    
    //topLabel
    UILabel * topLabel = [self createLabelWithText:@"进入门派名片，可对单个成员设置禁言" font:FLEXIBLE_NUM(11) subView:self.view];
    topLabel.textColor = [UIColor grayColor];
    topLabel.frame = FLEXIBLE_FRAME(15, 10, 280, 30);
    
    
    //optionView
    UIView * optionView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    optionView.frame = FLEXIBLE_FRAME(0, 50, 320, 40);
    
    UILabel * titleLabel = [self createLabelWithText:@"全员禁言" font:FLEXIBLE_NUM(13) subView:optionView];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 100, 40);
    
    _mainSwitch = ({
        UISwitch * mySwitch = [[UISwitch alloc] initWithFrame:FLEXIBLE_FRAME(270, 10, 30, 20)];
        mySwitch.center = CGPointMake(FLEXIBLE_NUM(285), FLEXIBLE_NUM(20));
        [optionView addSubview:mySwitch];
        mySwitch;
    });
    
    //bottomLabel
    UILabel * bottomLabel = [self createLabelWithText:@"全员禁言启动后，只允许群主和管理员发言" font:FLEXIBLE_NUM(11) subView:self.view];
    bottomLabel.frame = FLEXIBLE_FRAME(15, 90, 300, 40);
    bottomLabel.textColor = [UIColor grayColor];
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
