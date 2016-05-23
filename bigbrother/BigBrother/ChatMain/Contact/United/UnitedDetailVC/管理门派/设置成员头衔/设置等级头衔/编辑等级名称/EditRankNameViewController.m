//
//  EditRankNameViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "EditRankNameViewController.h"
#import "UnitedInfoModel.h"

@interface EditRankNameViewController ()

@property (strong, nonatomic) UITextField       * editRankNameTextField;
@property (strong, nonatomic) UnitedInfoModel   * unitedModel;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation EditRankNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"编辑成员头衔";
    }
    return self;
}

- (void)dealloc
{
    [_unitedModel removeObserver:self forKeyPath:@"changeRankNameData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"changeRankNameData"]) {
        UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _unitedModel.changeRankNameData;
        if ([dataDic[@"data"][@"success"] integerValue] == 1) {
            alertController.message = @"等级头衔修改成功～";
            [self presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"等级头衔修改失败～";
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"changeRankNameData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //编辑成员头衔
    _editRankNameTextField = [self createTextFieldWithTitle:@"输入名称" height:0];
    
}

#pragma mark -- button pressed
- (void)rightButtonPressed:(UIBarButtonItem *)sender
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    [_unitedModel changeUnitedRankNameWithUserId:dataDic[@"id"] groupGradeId:_editRankDic[@"id"] name:_editRankNameTextField.text];
}

#pragma mrak -- my methods
- (UITextField *)createTextFieldWithTitle:(NSString *)title height:(NSInteger)height
{
    UIView * bgView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    bgView.frame = FLEXIBLE_FRAME(0, height, 320, 40);
    
    UILabel * titleLabel = [self createLabelWithText:title font:FLEXIBLE_NUM(13) subView:bgView];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 75, 40);
    
    UITextField * textField = [[UITextField alloc] initWithFrame:FLEXIBLE_FRAME(90, 0, 220, 40)];
    textField.textColor = [UIColor grayColor];
    textField.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(12)];
    [bgView addSubview:textField];
    //    textField.backgroundColor = [UIColor yellowColor];
    UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:bgView];
    lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    
    return  textField;
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
