//
//  UnitedActivityDetailViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/24.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedActivityDetailViewController.h"
#import "UnitedInfoModel.h"
#import "CreateUnitedActivityViewController.h"

@interface UnitedActivityDetailViewController ()

@property (strong, nonatomic) UnitedInfoModel * unitedInfomodel;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"活动";
    }
    return self;
}

- (void)dealloc
{
    [_unitedInfomodel removeObserver:self forKeyPath:@"signUpActivityData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"signUpActivityData"]) {
           UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _unitedInfomodel.signUpActivityData;
        if ([dataDic[@"code"] integerValue] == 0) {
            alertController.message = @"群活动报名成功～";
            [self presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"群活动报名失败～";
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
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfomodel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"signUpActivityData" options:NSKeyValueObservingOptionNew context:nil];
        [model checkUnitedActivityDetailInfoWithId:_activityDic[@"id"]];
        model;
    });
    
    //创建活动
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"创建活动" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    //topView
    UIView * topView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    topView.frame = FLEXIBLE_FRAME(0, 0, 320, 70);
    
    UILabel * activityNameLabel = [self createLabelWithText:_activityDic[@"name"] font:FLEXIBLE_NUM(14) subView:topView];
    activityNameLabel.textColor = [UIColor blackColor];
    activityNameLabel.frame = FLEXIBLE_FRAME(20, 5, 280, 30);
    activityNameLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user01"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = FLEXIBLE_FRAME(78, 45, 10, 10);
    [topView addSubview:imageView];
    
    UILabel * joinNumLabel = [self createLabelWithText:[NSString stringWithFormat:@"%@人已报名",_activityDic[@"applicantCount"]] font:FLEXIBLE_NUM(10) subView:topView];
    joinNumLabel.frame = FLEXIBLE_FRAME(90, 40, 100, 20);
    joinNumLabel.textColor = [UIColor grayColor];
    
    UILabel * dateLabel = [self createLabelWithText:[NSString stringWithFormat:@"%@发布",[_activityDic[@"createdTime"] substringToIndex:10]] font:FLEXIBLE_NUM(10) subView:topView];
    dateLabel.frame = FLEXIBLE_FRAME(180, 40, 100, 20);
    dateLabel.textColor = [UIColor grayColor];
    
    //midView
    NSArray * imageNameArray = [NSArray arrayWithObjects:@"icon_wz",@"icon_time",@"icon_qian", nil];
    NSString * beginTimeString = [_activityDic[@"startTime"] substringToIndex:[_activityDic[@"startTime"] length]-2];
    NSString * endTimeString = [_activityDic[@"endTime"] substringToIndex:[_activityDic[@"endTime"] length]-2];
    NSString * timeString = [NSString stringWithFormat:@"%@ － %@",beginTimeString,endTimeString];
    NSString * costString = [NSString stringWithFormat:@"参加费用：%@元／人",_activityDic[@"cost"]];
    
    NSArray * contentArray = @[_activityDic[@"location"],timeString,costString];
    
    for (int i = 0; i < 3; i ++) {
        UIView * backView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
        backView.frame = FLEXIBLE_FRAME(0, 80 + 40 * i, 320, 40);
        
        UIImageView * markImage = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(10, 12, 16, 16)];
        markImage.image = [UIImage imageNamed:imageNameArray[i]];
        markImage.contentMode = UIViewContentModeScaleAspectFit;
        [backView addSubview:markImage];
        
        UILabel * contentLabel = [self createLabelWithText:contentArray[i] font:FLEXIBLE_NUM(13) subView:backView];
        contentLabel.frame = FLEXIBLE_FRAME(36, 0, 270, 40);
        
        UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:backView];
        lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    }
    
    //发起人
    UIView * peopleView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    peopleView.frame = FLEXIBLE_FRAME(0, 205, 320, 100);
    
    UILabel * peopleLabel = [self createLabelWithText:@"发起人：" font:FLEXIBLE_NUM(13) subView:peopleView];
    peopleLabel.frame = FLEXIBLE_FRAME(10, 0, 200, 40);
    
    UIView * peoplelineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:peopleView];
    peoplelineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    
    //加为好友
    UIButton * addFriendButton = [self createButtonWithTitle:@"加为好友" font:FLEXIBLE_NUM(10) subView:peopleView];
    [addFriendButton setTitleColor:BB_NaviColor forState:UIControlStateNormal];
    addFriendButton.frame = FLEXIBLE_FRAME(260, 8, 50, 24);
    addFriendButton.layer.cornerRadius = FLEXIBLE_NUM(12);
    addFriendButton.layer.borderColor = BB_NaviColor.CGColor;
    addFriendButton.layer.borderWidth = FLEXIBLE_NUM(1);
    
    //活动介绍<#w#>
    UILabel * infoTitleLabel = [self createLabelWithText:@"活动介绍：" font:FLEXIBLE_NUM(13) subView:peopleView];
    infoTitleLabel.frame = FLEXIBLE_FRAME(10, 40, 100, 40);
    
    UILabel * infoContentLabel = [self createLabelWithText:[NSString stringWithFormat:@"    %@",_activityDic[@"content"]] font:FLEXIBLE_NUM(11) subView:peopleView];
    infoContentLabel.frame = FLEXIBLE_FRAME(10, 80, 300, 0);
    infoContentLabel.numberOfLines = 0;
    [infoContentLabel sizeToFit];
    
    peopleView.frame = FLEXIBLE_FRAME(0, 205, 320, 100 + CGRectGetMaxY(infoContentLabel.bounds));
    
    
    //报名
    UIView * bottomView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    bottomView.frame = CGRectMake(0, MAINSCRREN_H - FLEXIBLE_NUM(50) - 64, MAINSCRREN_W, FLEXIBLE_NUM(50));
    
    UIView * bottomLineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:bottomView];
    bottomLineView.frame = FLEXIBLE_FRAME(0, 0, 320, 1);
    
    UIButton * bottomButton = [self createButtonWithTitle:@"报名" font:0 subView:bottomView];
    bottomButton.frame = FLEXIBLE_FRAME(15, 5, 290, 40);
    bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(14)];
    bottomButton.backgroundColor = BB_NaviColor;
    [bottomView addSubview:bottomButton];
    [bottomButton addTarget:self action:@selector(signUpActivityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- button pressed
- (void)addFriendButtonPressed:(UIButton *)sender
{
    
}

//报名
- (void)signUpActivityButtonPressed:(UIButton *)sender
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    [_unitedInfomodel signUpUnitedActivityWithActivityId:_activityDic[@"id"] userId:dataDic[@"id"]];
}

- (void)rightButtonPressed:(UIBarButtonItem *)sender
{
    CreateUnitedActivityViewController * createActivityVC = [[CreateUnitedActivityViewController alloc] init];
    createActivityVC.unitedDic = _unitedDic;
    [self.navigationController pushViewController:createActivityVC animated:YES];
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
