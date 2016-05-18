//
//  MoneyTreeViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/18.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MoneyTreeViewController.h"

@interface MoneyTreeViewController ()

@property (strong, nonatomic) IBOutlet UITextField *totalCountFeild;
@property (strong, nonatomic) IBOutlet UILabel *totalCountLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCountRightLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalMoneyLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalMoneyRightLabel;
@property (strong, nonatomic) IBOutlet UITextField *totalMoneyField;

@property (strong, nonatomic) IBOutlet UIButton *firstBtn;

@property (strong, nonatomic) IBOutlet UILabel *remarkLeftLabel;
@property (strong, nonatomic) IBOutlet UITextField *remarkField;

@property (strong, nonatomic) IBOutlet UILabel *userMoneyLabel;

@property (strong, nonatomic) UIButton *lastBtn;


- (IBAction)chooseBtnPressed:(UIButton *)sender;
- (IBAction)backBtnPressed:(UIButton *)sender;
- (IBAction)sendBtnPressed:(UIButton *)sender;


@end

@implementation MoneyTreeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fd_prefersNavigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    self.view.frame = FLEFRAME(self.view.frame);
    FLEXIBLE_FONT(self.view);
    self.view.autoresizesSubviews = NO;
    [self.view setHeight:MAINSCRREN_H];
    
    for (NSInteger i = 0; i < 3; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:TEXTFIELD_TAG+i];
        textField.layer.cornerRadius = FLEXIBLE_NUM(3);
        textField.layer.borderColor = _999999.CGColor;
        textField.layer.borderWidth = 1;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.rightViewMode = UITextFieldViewModeAlways;
        UILabel *leftLabel = (UILabel *)[self.view viewWithTag:LABEL_TAG+i];
        if (leftLabel) {
            textField.leftView = leftLabel;
        }
        UILabel *rightLabel = (UILabel *)[self.view viewWithTag:LABEL_TAG+10+i];
        if (rightLabel) {
            textField.textAlignment = NSTextAlignmentRight;
            textField.rightView = rightLabel;
        }else{
            textField.textAlignment = NSTextAlignmentLeft;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
    
    [self chooseBtnPressed:self.firstBtn];
    
}
#pragma mark - 各种Getter


#pragma mark - 按钮方法

#pragma mark - 自定义方法



- (IBAction)chooseBtnPressed:(UIButton *)sender {
    if (self.lastBtn != sender) {
        self.lastBtn.selected = NO;
        sender.selected = YES;
        self.lastBtn = sender;
    }
}

- (IBAction)backBtnPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendBtnPressed:(UIButton *)sender {
    
}
@end
