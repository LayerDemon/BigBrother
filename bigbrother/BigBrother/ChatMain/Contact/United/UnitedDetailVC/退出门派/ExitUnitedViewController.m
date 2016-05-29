//
//  ExitUnitedViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/18.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ExitUnitedViewController.h"
#import "UnitedInfoModel.h"
#import "UnitedViewController.h"
#import "MakeOverViewController.h"

#import "UnitedMemberViewController.h"

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
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dismissUnitedData"]) {
        UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _unitedInfoModel.dismissUnitedData;
        if ([dataDic[@"data"][@"success"] integerValue] == 1) {
            alertController.message = @"门派解散成功～";
            [self presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"门派解散失败，请稍后重试～";
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark -- alterController dismiss
- (void)alertControllerDismissWithAlertController:(UIAlertController *)alertController
{
    [alertController dismissViewControllerAnimated:YES completion:nil];
    for (int i = 0; i < self.navigationController.viewControllers.count; i ++) {
        if ([self.navigationController.viewControllers[i] isKindOfClass:[UnitedViewController class]]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
        }
    }
    
}



#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"dismissUnitedData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
        //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    //门派成员
    UIButton * unitedMemberBut = [self createButtonWithTitle:@"你将与他们失去联系"];
    unitedMemberBut.frame = FLEXIBLE_FRAME(0, 10, 320, 40);
    [unitedMemberBut addTarget:self action:@selector(unitedMemberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * unitedMemberBGView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    unitedMemberBGView.frame = FLEXIBLE_FRAME(0, 50, 320, 55);
    
    NSArray * memberArray = _unitedDetailDic[@"members"];
//    NSMutableArray * userArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i ; <#increment#>) {
//        <#statements#>
//    }
    
    UILabel * totalLabel = [self createLabelWithText:[NSString stringWithFormat:@"%ld人",[_unitedDetailDic[@"members"] count]] font:FLEXIBLE_NUM(12) subView:unitedMemberBut];
    totalLabel.frame = FLEXIBLE_FRAME(240, 0, 50, 40);
    totalLabel.textAlignment = NSTextAlignmentRight;
    
    for (int i = 0; i < memberArray.count; i ++) {
        if (15 + 50 * i + 50 > 310) {
            continue;
        }
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
    [buttonOne addTarget:self action:@selector(buttonOneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //解散
    UIButton * buttonTwo = [self createButtonWithTitle:@"解散" font:FLEXIBLE_NUM(13) subView:self.view];
    buttonTwo.backgroundColor = [UIColor redColor];
    buttonTwo.frame = FLEXIBLE_FRAME(20, 190, 280, 35);
    buttonTwo.titleLabel.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(13)];
    [buttonTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonTwo addTarget:self action:@selector(buttonTwoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -- button pressed
- (void)unitedMemberButtonPressed:(UIButton *)sender
{
    UnitedMemberViewController * unitedMemberVC = [[UnitedMemberViewController alloc] init];
    unitedMemberVC.memberArray = _unitedDetailDic[@"members"];
    unitedMemberVC.groupDic = _unitedDetailDic;
    unitedMemberVC.userDic = self.userDic;
    [self.navigationController pushViewController:unitedMemberVC animated:YES];
}

//转让
- (void)buttonOneButtonPressed:(UIButton *)sender
{

    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_unitedDetailDic[@"members"] count]; i ++) {
        if (![_unitedDetailDic[@"members"][i][@"role"] isEqualToString:@"OWNER"]) {
            [dataArray addObject:_unitedDetailDic[@"members"][i]];
        }
    }
    
    MakeOverViewController * makeOverVC = [[MakeOverViewController alloc] init];
    makeOverVC.memberArray = dataArray;
    makeOverVC.unitedDetailDic = _unitedDetailDic;
    [self.navigationController pushViewController:makeOverVC animated:YES];
}

//解散
- (void)buttonTwoButtonPressed:(UIButton *)sender
{
     NSDictionary * dataDic = [BBUserDefaults getUserDic];
     UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定立即解散该群？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_unitedInfoModel dismissUnitedWithGroupId:_unitedDetailDic[@"id"] userId:dataDic[@"id"]];
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
