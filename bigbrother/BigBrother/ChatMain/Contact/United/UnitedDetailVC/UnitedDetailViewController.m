//
//  UnitedDetailViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedDetailViewController.h"
#import "UnitedActivityViewController.h"
#import "ManagerUnitedViewController.h"
#import "UnitedMemberViewController.h"
#import "UnitedInfoModel.h"
#import "ExitUnitedViewController.h"

@interface UnitedDetailViewController ()

@property (strong, nonatomic) UnitedInfoModel       * unitedInfoModel;
@property (strong, nonatomic) NSDictionary          * unitedDetailDic;

@property (strong, nonatomic) NSDateFormatter       * dateFormater;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
//    [self initializeUserInterface];
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"unitedDetailData"];
    [_unitedInfoModel removeObserver:self forKeyPath:@"exitUnitedData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"unitedDetailData"]) {
        _unitedDetailDic = _unitedInfoModel.unitedDetailData[@"data"];
        [self initializeUserInterface];
    }
    
    if ([keyPath isEqualToString:@"exitUnitedData"]) {
        
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    
    _dateFormater = [[NSDateFormatter alloc] init];
    [_dateFormater setDateFormat:@"yyyy年MM月dd日"];

    self.navigationItem.title = _unitedDic[@"name"];
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"unitedDetailData" options:NSKeyValueObservingOptionNew context:nil];
        [model addObserver:self forKeyPath:@"exitUnitedData" options:NSKeyValueObservingOptionNew context:nil];
        [model getUnitedInfoWithId:_unitedDic[@"id"] limit:@"10000"];
        model;
    });
}

- (void)initializeUserInterface
{
    UIImageView * topBGImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 320, 100)];
    topBGImageView.clipsToBounds = YES;
    [self.view addSubview:topBGImageView];
    [topBGImageView sd_setImageWithURL:[NSURL URLWithString:_unitedDetailDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    
    UIImageView * unitedImageView = [[UIImageView alloc] initWithFrame: FLEXIBLE_FRAME(130, 10, 60, 60)];
    unitedImageView.clipsToBounds = YES;
    [self.view addSubview:unitedImageView];
    [unitedImageView sd_setImageWithURL:[NSURL URLWithString:_unitedDetailDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    
    //门派活动
    UIButton * unitedActivityBut = [self createButtonWithTitle:@"门派活动"];
    unitedActivityBut.frame = FLEXIBLE_FRAME(0, 100, 320, 40);
    [unitedActivityBut addTarget:self action:@selector(unitedActivityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //门派成员
    UIButton * unitedMemberBut = [self createButtonWithTitle:@"门派成员"];
    unitedMemberBut.frame = FLEXIBLE_FRAME(0, 150, 320, 40);
    [unitedMemberBut addTarget:self action:@selector(unitedMemberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * unitedMemberBGView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    unitedMemberBGView.frame = FLEXIBLE_FRAME(0, 190, 320, 55);
    
    NSArray * memberArray = _unitedDetailDic[@"members"];
    for (int i = 0; i < memberArray.count; i ++) {
        UIImageView * memberImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(15 + 50 * i, 5, 40, 40)];
        memberImageView.layer.cornerRadius = FLEXIBLE_NUM(20);
        memberImageView.clipsToBounds = YES;
        [unitedMemberBGView addSubview:memberImageView];
        [memberImageView sd_setImageWithURL:[NSURL URLWithString:memberArray[i][@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    }
    
    //邀请成员
    UIButton * addMemberButton = [self createButtonWithTitle:nil font:0 subView:unitedMemberBGView];
    [addMemberButton addTarget:self action:@selector(addMemberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    addMemberButton.frame = FLEXIBLE_FRAME(15 + 50 * memberArray.count, 5, 40, 40);
    [addMemberButton setImage:[UIImage imageNamed:@"add_person@3x"] forState:UIControlStateNormal];
    
    //管理门派
    UIButton * managerUnitedButton = [self createButtonWithTitle:@"管理门派"];
    managerUnitedButton.frame = FLEXIBLE_FRAME(0, 255, 320, 40);
    [managerUnitedButton addTarget:self action:@selector(managerUnitedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //门派介绍
    UIButton * unitedIntrButton = [self createButtonWithTitle:@"门派介绍"];
    unitedIntrButton.frame = FLEXIBLE_FRAME(0, 305, 320, 40);
    
    UIView * unitedIntrView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    unitedIntrView.frame = FLEXIBLE_FRAME(0, 345, 320, 30);
    
    NSDate * createUnitedDate = [NSDate dateWithTimeIntervalSince1970:[_unitedDetailDic[@"createdTime"] doubleValue]/1000];
    
    UILabel * unitedIntrLabel = [self createLabelWithText:[NSString stringWithFormat:@"本群创建于%@",[_dateFormater stringFromDate:createUnitedDate]] font:FLEXIBLE_NUM(12) subView:unitedIntrView];
    unitedIntrLabel.textColor = [UIColor grayColor];
    unitedIntrLabel.frame = FLEXIBLE_FRAME(15, 0, 290, 25);
    unitedIntrLabel.numberOfLines = 0;
    [unitedIntrLabel sizeToFit];
    unitedIntrView.frame = CGRectMake(0, FLEXIBLE_NUM(345), MAINSCRREN_W, CGRectGetMaxY(unitedIntrLabel.frame) + 10);
    
    //退出门派
    UIButton * exitUnitedButton = [self createButtonWithTitle:@"退出门派"];
    exitUnitedButton.frame = CGRectMake(0, CGRectGetMaxY(unitedIntrView.frame) + 10, MAINSCRREN_W, FLEXIBLE_NUM(40));
    [exitUnitedButton addTarget:self action:@selector(exitUnitedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- button pressed
//邀请入群
- (void)addMemberButtonPressed:(UIButton *)sender
{
    
}

//门派活动
- (void)unitedActivityButtonPressed:(UIButton *)sender
{
    UnitedActivityViewController * unitedActivityVC = [[UnitedActivityViewController alloc] init];
    unitedActivityVC.unitedDic = _unitedDic;
    [self.navigationController pushViewController:unitedActivityVC animated:YES];
}
//管理门派
- (void)managerUnitedButtonPressed:(UIButton *)sender
{
    ManagerUnitedViewController * managerUnitedVC = [[ManagerUnitedViewController alloc] init];
    [self.navigationController pushViewController:managerUnitedVC animated:YES];
}

//门派成员
- (void)unitedMemberButtonPressed:(UIButton *)sender
{
    UnitedMemberViewController * unitedMemberVC = [[UnitedMemberViewController alloc] init];
    unitedMemberVC.memberArray = _unitedDetailDic[@"members"];
    [self.navigationController pushViewController:unitedMemberVC animated:YES];
}

//退出门派
- (void)exitUnitedButtonPressed:(UIButton *)sender
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    NSLog(@"dataDic -- %@",dataDic);
    
    NSArray * membersArray = _unitedDetailDic[@"members"];
    for (int i = 0; i < membersArray.count; i ++) {
        if ([_unitedDetailDic[@"id"] integerValue] == [membersArray[i][@"id"] integerValue]) {
            if ([membersArray[i][@"role"] isEqualToString:@"OWNER"]) {  //群主
                ExitUnitedViewController * exitUnitedVC = [[ExitUnitedViewController alloc] init];
                exitUnitedVC.unitedDetailDic = _unitedDetailDic;
                [self.navigationController pushViewController:exitUnitedVC animated:YES];
            }else{                                                      //普通成员
                NSString * messageString = [NSString stringWithFormat:@"你将退出门派 %@(%@)吗？",_unitedDetailDic[@"name"],_unitedDetailDic[@"groupNumber"]];
                 UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    _unitedInfoModel exitUnitedWithGroupId:_unitedDetailDic[@"id"] userId:
                }];
                UIAlertAction *  cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:sureAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
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
