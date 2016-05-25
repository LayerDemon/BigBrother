//
//  EditUnitedMemberRankViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/26.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "EditUnitedMemberRankViewController.h"
#import "UnitedInfoModel.h"

@interface EditUnitedMemberRankViewController ()

@property (strong, nonatomic) UnitedInfoModel   * unitedInfoModel;
@property (strong, nonatomic) UITextField       * textField;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation EditUnitedMemberRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"changeTitleData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"changeTitleData"]) {
        UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _unitedInfoModel.changeTitleData;
        if ([dataDic[@"code"] integerValue] == 0) {
            alertController.message = @"修改成员专属头衔成功～";
            [self presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"修改成员专属头衔失败～";
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
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"changeTitleData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    //保存
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIView * backView = [[UIView alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 320, 45)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    _textField = ({
        UITextField * textField = [[UITextField alloc] initWithFrame:FLEXIBLE_FRAME(15, 0, 290, 45)];
        textField.textColor = [UIColor grayColor];
        textField.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(13)];
        textField.placeholder = @"输入名称";
        [backView addSubview:backView];
        textField;
    });
}

#pragma mark -- button pressed
- (void)rightButtonPressed:(UIButton *)sender
{
    if (_textField.text.length == 0) {
         UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"输入的名称不能为空～" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    [_unitedInfoModel setNiuBiNickNameWithOperator:dataDic[@"id"] userId:_userDic[@"id"] groupId:_unitedDic[@"id"] title:_textField.text];
}

@end
