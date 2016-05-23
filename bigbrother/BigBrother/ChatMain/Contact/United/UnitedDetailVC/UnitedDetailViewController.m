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

@property (strong, nonatomic) UIButton *joinBtn;

@property (strong, nonatomic) UnitedInfoModel       * unitedInfoModel;
@property (strong, nonatomic) NSDictionary          * unitedDetailDic;
@property (strong, nonatomic) NSDateFormatter       * dateFormater;
@property (assign, nonatomic) BOOL isJoinGroup;
@property (strong, nonatomic) NSDictionary *userDic;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDic = [BBUserDefaults getUserDic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
//    [self initializeUserInterface];
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"unitedDetailData"];
    [_unitedInfoModel removeObserver:self forKeyPath:@"exitUnitedData"];
    [_unitedInfoModel removeObserver:self forKeyPath:@"joinData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"unitedDetailData"]) {
        _unitedDetailDic = _unitedInfoModel.unitedDetailData[@"data"];
        [GROUPCACHE_MANAGER getGroupDicWithGroupId:_unitedDetailDic[@"id"] completed:^(id responseObject, NSError *error) {
            if (!error) {
                self.isJoinGroup = YES;
            }
            [self initializeUserInterface];
        }];
        
    }
    
    if ([keyPath isEqualToString:@"exitUnitedData"]) {
        
    }
    
    if ([keyPath isEqualToString:@"joinData"]) {
        [self joinDataParse];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    self.isJoinGroup = NO;
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
        [model addObserver:self forKeyPath:@"joinData" options:NSKeyValueObservingOptionNew context:nil];
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
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.userInteractionEnabled = NO;
    //添加到要有毛玻璃特效的控件中
    effectView.frame = topBGImageView.bounds;
    effectView.alpha = 0.9;
    [topBGImageView addSubview:effectView];
    
    UIImageView * unitedImageView = [[UIImageView alloc] initWithFrame: FLEXIBLE_FRAME(130, 10, 60, 60)];
    unitedImageView.clipsToBounds = YES;
    [self.view addSubview:unitedImageView];
    [unitedImageView sd_setImageWithURL:[NSURL URLWithString:_unitedDetailDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    
    UILabel * unitedNumLabel = [self createLabelWithText:_unitedDetailDic[@"groupNumber"] font:FLEXIBLE_NUM(12) subView:topBGImageView];
    unitedNumLabel.frame = FLEXIBLE_FRAME(50, 70, 220, 30);
    unitedNumLabel.textColor = [UIColor whiteColor];
    unitedNumLabel.textAlignment = NSTextAlignmentCenter;
    
    //门派活动
    UIButton * unitedActivityBut = [self createButtonWithTitle:@"门派活动"];
    unitedActivityBut.frame = FLEXIBLE_FRAME(0, 100, 320, 40);
    [unitedActivityBut addTarget:self action:@selector(unitedActivityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //门派成员
    UIButton * unitedMemberBut = [self createButtonWithTitle:@"门派成员"];
    unitedMemberBut.frame = FLEXIBLE_FRAME(0, 150, 320, 40);
    [unitedMemberBut addTarget:self action:@selector(unitedMemberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //成员数量
    UILabel * memberNumLabel = [self createLabelWithText:[NSString stringWithFormat:@"%ld人",[_unitedDetailDic[@"members"] count]] font:FLEXIBLE_NUM(13) subView:unitedMemberBut];
    memberNumLabel.frame = FLEXIBLE_FRAME(260, 0, 30, 40);
    memberNumLabel.textAlignment = NSTextAlignmentRight;
    
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
    
    //整理门派成员模块到一个视图，方便移动
    UIView *unitedMemberSuperView = [[UIView alloc]initWithFrame:CGRectMake(0,FLEXIBLE_NUM(150),MAINSCRREN_W,unitedMemberBut.frame.size.height+unitedMemberBGView.frame.size.height)];
    unitedMemberSuperView.backgroundColor = [UIColor whiteColor];
    [unitedMemberBut setOriginY:0];
    [unitedMemberSuperView addSubview:unitedMemberBut];
    [unitedMemberBGView setOriginY:CGRectGetMaxY(unitedMemberBut.frame)];
    [unitedMemberSuperView addSubview:unitedMemberBGView];
    [self.view addSubview:unitedMemberSuperView];
    
    NSInteger max_Y = 255;
    if (_pushMark == 0) {
        //管理门派
        UIButton * managerUnitedButton = [self createButtonWithTitle:@"管理门派"];
        managerUnitedButton.frame = FLEXIBLE_FRAME(0, max_Y, 320, 40);
        [managerUnitedButton addTarget:self action:@selector(managerUnitedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        max_Y += 50;
    }
    
    //门派介绍
    UIButton * unitedIntrButton = [self createButtonWithTitle:@"门派介绍"];
    unitedIntrButton.frame = FLEXIBLE_FRAME(0, max_Y, 320, 40);
    
    UIView * unitedIntrView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    unitedIntrView.frame = FLEXIBLE_FRAME(0, max_Y + 40, 320, 30);
    
    NSDate * createUnitedDate = [NSDate dateWithTimeIntervalSince1970:[_unitedDetailDic[@"createdTime"] doubleValue]/1000];
    
    UILabel * unitedIntrLabel = [self createLabelWithText:[NSString stringWithFormat:@"本群创建于%@",[_dateFormater stringFromDate:createUnitedDate]] font:FLEXIBLE_NUM(12) subView:unitedIntrView];
    unitedIntrLabel.textColor = [UIColor grayColor];
    unitedIntrLabel.frame = FLEXIBLE_FRAME(15, 0, 290, 25);
    unitedIntrLabel.numberOfLines = 0;
    [unitedIntrLabel sizeToFit];
    unitedIntrView.frame = CGRectMake(0, FLEXIBLE_NUM(345), MAINSCRREN_W, CGRectGetMaxY(unitedIntrLabel.frame) + 10);
    
    //整理门派介绍到一个界面
    UIView *unitedIntrSuperView = [[UIView alloc]initWithFrame:CGRectMake(0, FLEXIBLE_NUM(max_Y),MAINSCRREN_W,unitedIntrButton.frame.size.height+unitedIntrView.frame.size.height)];
    unitedIntrSuperView.backgroundColor = [UIColor whiteColor];
    [unitedIntrButton setOriginY:0];
    [unitedIntrSuperView addSubview:unitedIntrButton];
    [unitedIntrView setOriginY:CGRectGetMaxY(unitedIntrButton.frame)];
    [unitedIntrSuperView addSubview:unitedIntrView];
    [self.view addSubview:unitedIntrSuperView];
    
    //退出门派
    UIButton * exitUnitedButton = [self createButtonWithTitle:@"退出门派"];
    exitUnitedButton.frame = CGRectMake(0, CGRectGetMaxY(unitedIntrSuperView.frame) + 10, MAINSCRREN_W, FLEXIBLE_NUM(40));
    [exitUnitedButton addTarget:self action:@selector(exitUnitedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!self.isJoinGroup) {
        [unitedMemberSuperView setOriginY:CGRectGetMaxY(unitedActivityBut.frame)+FLEXIBLE_NUM(10)];
        [unitedIntrSuperView setOriginY:CGRectGetMaxY(unitedMemberSuperView.frame)+FLEXIBLE_NUM(10)];
        exitUnitedButton.hidden = YES;
        addMemberButton.hidden = YES;
        [self.view addSubview:self.joinBtn];
    }
}

#pragma mark -- getter
- (UIButton *)joinBtn
{
    if (!_joinBtn) {
        UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        joinBtn.frame = CGRectMake(0,0,MAINSCRREN_W-FLEXIBLE_NUM(40),FLEXIBLE_NUM(35));
        [joinBtn setTitle:@"申请加群" forState:UIControlStateNormal];
        [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [joinBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [joinBtn addTarget:self action:@selector(joinBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        joinBtn.backgroundColor = BB_BlueColor;
        joinBtn.center = CGPointMake(MAINSCRREN_W/2, MAINSCRREN_H-NAVBAR_H-FLEXIBLE_NUM(28)-joinBtn.frame.size.height/2);
        joinBtn.layer.cornerRadius = FLEXIBLE_NUM(4);
        joinBtn.layer.masksToBounds = YES;
        _joinBtn = joinBtn;
    }
    return _joinBtn;
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
    managerUnitedVC.unitedDetailDic = _unitedDetailDic;
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
        if ([dataDic[@"id"] integerValue] == [membersArray[i][@"id"] integerValue]) {
            if ([membersArray[i][@"role"] isEqualToString:@"OWNER"]) {  //群主
                ExitUnitedViewController * exitUnitedVC = [[ExitUnitedViewController alloc] init];
                exitUnitedVC.unitedDetailDic = _unitedDetailDic;
                [self.navigationController pushViewController:exitUnitedVC animated:YES];
            }else{                                                      //普通成员
                NSString * messageString = [NSString stringWithFormat:@"你将退出门派 %@(%@)吗？",_unitedDetailDic[@"name"],_unitedDetailDic[@"groupNumber"]];
                 UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [_unitedInfoModel exitUnitedWithGroupId:_unitedDetailDic[@"id"] userId:dataDic[@"id"]];
                }];
                UIAlertAction *  cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:sureAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}

//申请加群
- (void)joinBtnPressed:(UIButton *)sender
{
    [sender startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.unitedInfoModel postJoinDataWithGroupId:_unitedDetailDic[@"id"] userId:self.userDic[@"id"] message:@"让我加入吧~"];
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


#pragma mark - 数据处理
- (void)joinDataParse
{
    [self.joinBtn stopAnimationWithTitle:@"已发送申请"];
    self.joinBtn.backgroundColor = [UIColor whiteColor];
    self.joinBtn.layer.borderColor = _999999.CGColor;
    [self.joinBtn setTitleColor:_999999 forState:UIControlStateNormal];
    self.joinBtn.userInteractionEnabled = NO;
}


@end
