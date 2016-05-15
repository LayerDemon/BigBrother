//
//  UnitedViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/10.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedViewController.h"

#import "CreateUnitedViewController.h"

@interface UnitedViewController ()

@property (strong, nonatomic) UISearchBar       * searchBar;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"门派";
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
    self.view.backgroundColor = BG_COLOR;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
        //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    
    //topView
    UIView  * topView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    topView.frame = FLEXIBLE_FRAME(0, 0, 320, 50);
    
    //我管理的门派
    UILabel * manageUnitedLabel = [self createLabelWithText:@"我管理的门派" font:FLEXIBLE_NUM(14) subView:self.view];
    manageUnitedLabel.frame = FLEXIBLE_FRAME(10, 50, 200, 40);
    
    NSArray * manageArray = [[NSArray alloc] initWithObjects:@"日月神教",@"书院",@"日月神教",@"书院", nil];
    for (int i = 0; i < manageArray.count; i ++) {
        UIButton * manageButton = [self createButtonWithTitle:@"" font:FLEXIBLE_NUM(13) subView:self.view];
        manageButton.backgroundColor = [UIColor whiteColor];
        manageButton.frame = FLEXIBLE_FRAME(0, 90 + 45 * i, 320, 45);
        if (i == 0) {
            [manageButton addTarget:self action:@selector(manageButtonOPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [manageButton addTarget:self action:@selector(manageButtonTPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel * manageLabel = [self createLabelWithText:manageArray[i] font:FLEXIBLE_NUM(14) subView:manageButton];
        manageLabel.frame = FLEXIBLE_FRAME(50, 0, 100, 45);
        
        if (i == 1) {
            UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:manageButton];
            lineView.frame = FLEXIBLE_FRAME(0, 0, 320, 1);
        }
      
    }
    //创建门派
    UIBarButtonItem * rightBut = [[UIBarButtonItem alloc] initWithTitle:@"创建门派" style:UIBarButtonItemStyleDone target:self action:@selector(createUnitedButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightBut;
    
}

#pragma mark -- button pressed
- (void)manageButtonOPressed:(UIButton *)sender
{

}

- (void)manageButtonTPressed:(UIButton *)sender
{

}

- (void)createUnitedButtonPressed:(UIButton *)sender
{
    CreateUnitedViewController * createUnitedVC = [[CreateUnitedViewController alloc] init];
    [self.navigationController pushViewController:createUnitedVC animated:YES];
}

#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
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
