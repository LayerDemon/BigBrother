//
//  ExitUnitedViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/18.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ExitUnitedViewController.h"
#import "UnitedInfoModel.h"

@interface ExitUnitedViewController ()

@property (strong, nonatomic) UnitedInfoModel       * unitedInfoModel;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation ExitUnitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"退出该门派";
    }
    return self;
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"dismissUnitedData"];
    [_unitedInfoModel removeObserver:self forKeyPath:@"transterUnitedData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dismissUnitedData"]) {
        
    }
    
    if ([keyPath isEqualToString:@"transterUnitedData"]) {
        
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"dismissUnitedData" options:NSKeyValueObservingOptionNew context:nil];
        [model addObserver:self forKeyPath:@"transterUnitedData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    
    //门派成员
    UIButton * unitedMemberBut = [self createButtonWithTitle:@"你将与他们失去联系"];
    unitedMemberBut.frame = FLEXIBLE_FRAME(0, 10, 320, 40);
    [unitedMemberBut addTarget:self action:@selector(unitedMemberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * unitedMemberBGView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    unitedMemberBGView.frame = FLEXIBLE_FRAME(0, 50, 320, 55);
    
    NSArray * memberArray = _unitedDetailDic[@"members"];
    for (int i = 0; i < memberArray.count; i ++) {
        UIImageView * memberImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(15 + 50 * i, 5, 40, 40)];
        memberImageView.layer.cornerRadius = FLEXIBLE_NUM(20);
        memberImageView.clipsToBounds = YES;
        [unitedMemberBGView addSubview:memberImageView];
        [memberImageView sd_setImageWithURL:[NSURL URLWithString:memberArray[i][@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    }
 
    //描述label
    UILabel * introLabel = [self createLabelWithText:@"你是群主，请选择转让或解散门派，建议转让" font:FLEXIBLE_NUM(10) subView:self.view];
    introLabel.textColor = [UIColor grayColor];
    introLabel.textAlignment = NSTextAlignmentCenter;
    introLabel.frame = FLEXIBLE_FRAME(0, 105, 320, 30);
    introLabel.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(10)];
    
    //转让
    UIButton * buttonOne = [self createButtonWithTitle:@"转让" font:FLEXIBLE_NUM(13) subView:self.view];
    buttonOne.backgroundColor = RGBACOLOR(1, 132, 207, 1);
    buttonOne.frame = FLEXIBLE_FRAME(20, 140, 280, 35);
    buttonOne.titleLabel.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(13)];
    [buttonOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //解散
    UIButton * buttonTwo = [self createButtonWithTitle:@"解散" font:FLEXIBLE_NUM(13) subView:self.view];
    buttonTwo.backgroundColor = [UIColor redColor];
    buttonTwo.frame = FLEXIBLE_FRAME(20, 190, 280, 35);
    buttonTwo.titleLabel.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(13)];
    [buttonTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

#pragma mark -- button pressed
- (void)unitedMemberButtonPressed:(UIButton *)sender
{
    
}

//转让
- (void)buttonOneButtonPressed:(UIButton *)sender
{
    UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定立即解散该群？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        _unitedInfoModel dismissUnitedWithGroupId:_unitedDetailDic[@"id"] userId:<#(NSString *)#>
    }];
    UIAlertAction *  cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//解散
- (void)buttonTwoButtonPressed:(UIButton *)sender
{
     UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定立即解散该群？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        _unitedInfoModel dismissUnitedWithGroupId:_unitedDetailDic[@"id"] userId:<#(NSString *)#>
    }];
    UIAlertAction *  cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mrak -- my methods
- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [self createLabelWithText:title font:FLEXIBLE_NUM(13) subView:button];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 200, 40);
    
    [self.view addSubview:button];
    
    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(295, 15, 10, 10)];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.image = [UIImage imageNamed:@"icon_more"];
    if ([title isEqualToString:@"门派介绍"]) {
        return button;
    }
    [button addSubview:rightImageView];
    
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
