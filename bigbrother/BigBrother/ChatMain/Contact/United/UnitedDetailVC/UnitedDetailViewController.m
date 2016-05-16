//
//  UnitedDetailViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedDetailViewController.h"

#import "UnitedInfoModel.h"

@interface UnitedDetailViewController ()

@property (strong, nonatomic) UnitedInfoModel       * unitedInfoModel;
@property (strong, nonatomic) NSDictionary          * unitedDetailDic;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"unitedDetailData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"unitedDetailData"]) {
        _unitedDetailDic = _unitedInfoModel.unitedDetailData[@"data"];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    self.navigationItem.title = _unitedDic[@"name"];
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"unitedDetailData" options:NSKeyValueObservingOptionNew context:nil];
        [model getUnitedInfoWithId:_unitedDic[@"id"] limit:@"20"];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = BG_COLOR;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    UIImageView * topBGImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"好看2.jpg"]];
    topBGImageView.frame = FLEXIBLE_FRAME(0, 0, 320, 100);
    [self.view addSubview:topBGImageView];
    
    UIImageView * unitedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"好看2.jpg"]];
    unitedImageView.frame = FLEXIBLE_FRAME(130, 10, 60, 60);
    [self.view addSubview:unitedImageView];
    
    //门派活动
    UIButton * unitedActivityBut = [self createButtonWithTitle:@"门派活动"];
    unitedActivityBut.frame = FLEXIBLE_FRAME(0, 100, 320, 40);
    
}

- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [self createLabelWithText:title font:FLEXIBLE_NUM(13) subView:button];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 100, 40);
    
    [self.view addSubview:button];
    return button;
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
