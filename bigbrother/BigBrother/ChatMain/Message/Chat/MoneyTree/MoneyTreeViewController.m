//
//  MoneyTreeViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/18.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MoneyTreeViewController.h"
#import "MoneyTreeModel.h"

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
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

@property (strong, nonatomic) MoneyTreeModel *model;
@property (strong, nonatomic) UIButton *lastBtn;
@property (strong, nonatomic) NSDictionary *userDic;



- (IBAction)chooseBtnPressed:(UIButton *)sender;
- (IBAction)backBtnPressed:(UIButton *)sender;
- (IBAction)sendBtnPressed:(UIButton *)sender;


@end

@implementation MoneyTreeViewController

- (void)dealloc
{
    [_model removeObserver:self forKeyPath:@"createData"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fd_prefersNavigationBarHidden = YES;
        self.userDic = [BBUserDefaults getUserDic];
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
    NSString *userMoneyStr = [NSString stringWithFormat:@"共 %@ 点",@([BBUserDefaults getUserBalance])];
    NSMutableAttributedString *userMoneyAttriStr = [[NSMutableAttributedString alloc] initWithString:userMoneyStr];
    [userMoneyAttriStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor]
                              range:[userMoneyStr rangeOfString:[NSString stringWithFormat:@"%@",@([BBUserDefaults getUserBalance])]]];
    
    self.userMoneyLabel.attributedText = userMoneyAttriStr;
    
}
#pragma mark - 各种Getter
- (MoneyTreeModel *)model
{
    if (!_model) {
        _model = [[MoneyTreeModel alloc]init];
        [_model addObserver:self forKeyPath:@"createData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"createData"]) {
        [self createDataParse];
    }
}

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
    if (!self.groupDic) {
        [BYToastView showToastWithMessage:@"只支持门派~"];
        return;
    }
    NSInteger totalCount = [self.totalCountFeild.text integerValue];
    if (totalCount < 1) {
        [BYToastView showToastWithMessage:@"摇钱次数必须大于1"];
        return;
    }
    if (totalCount > [BBUserDefaults getUserBalance]) {
        [BYToastView showToastWithMessage:@"余额不足~"];
        return;
    }
    NSInteger sum = [self.totalMoneyField.text integerValue];
    if (sum < 1) {
        [BYToastView showToastWithMessage:@"总金额必须大于1"];
        return;
    }
    
    
    
    //领取对象，ALL全部，MALE男，FEMALE女。
    NSArray *receiveTargetsArray = @[@"ALL",@"FEMALE",@"MALE"];
    NSInteger receiveTargetIndex = self.lastBtn.tag - BUTTON_TAG;
    NSString *receiveTarget = receiveTargetsArray[receiveTargetIndex];
    
    [sender startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.model getCreateDataWithGoldCoinCount:totalCount sum:sum receiveTarget:receiveTarget message:self.remarkField.text creator:self.userDic[@"id"] groupId:self.groupDic[@"id"]];
}

#pragma mark - 数据处理
- (void)createDataParse
{
    [self.sendBtn stopAnimationWithTitle:@"种下摇钱树"];
    NSDictionary *tempDic = [EaseSDKHelper customMessageDicWithSubMessage:@"种下了一棵[摇钱树]" customPojo:self.model.createData resultValue:@(1)];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"sendCustomMessage" object:tempDic];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
