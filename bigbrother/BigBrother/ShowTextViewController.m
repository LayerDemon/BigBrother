//
//  ShowTextViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/4.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ShowTextViewController.h"

@interface ShowTextViewController ()

@end

@implementation ShowTextViewController{
    UITextView *showedTextView;
    
    NSString *showingText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    showedTextView = [[UITextView alloc] init];
    showedTextView.frame = (CGRect){10,BB_NarbarHeight+5,WIDTH(self.view)-10*2,HEIGHT(self.view)-5*2-BB_NarbarHeight};
    showedTextView.font = Font(15);
    showedTextView.textColor = RGBColor(50, 50, 50);
    showedTextView.backgroundColor = BB_WhiteColor;
    showedTextView.editable = NO;
    showedTextView.keyboardType = UIKeyboardTypeDefault;
    showedTextView.returnKeyType = UIReturnKeyNext;
    showedTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    showedTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    showedTextView.showsHorizontalScrollIndicator = NO;
    showedTextView.showsVerticalScrollIndicator = NO;
    showedTextView.selectable = NO;
    [self.view addSubview:showedTextView];
    
    [showedTextView resignFirstResponder];
    
    [self getText];
}

-(void)getText{
    if (self.showedControllerType == 1) {
        [self getPointsIntroduction];
    }else if (self.showedControllerType == 2) {
        [self getAboutUsIntroduction];
    }
}

-(void)getPointsIntroduction{
    showingText = @"点数\r\n点数是用户在本网站系统使用的，功能类似货币，仅限本网站系统使用。\r\n1.整个系统内的货币为“点数”。点数可以兑换人民币。1元人民币=100点，也就是1点=1分钱。 \r\n2.点数的获取： \r\n		a. 用户充值。\r\n        b. 网站建设初期系统赠送。\r\n        c. 通过提供服务获取其它用户的点数支付。\r\n3.点数的兑换：\r\n  用户积累点数达到2000点时，可以选择提现。并需要支付相应手续费。\r\n\r\n点数由以下方面提供\r\n(1)用户充值：\r\n		基本货币人民币，基本比率： 人民币1元=100点数 \r\n		基本兑换货币可以由站长委派特定的管理员设置\r\n(2)用户提供产品/服务赚取点数\r\n(3)推荐别人注册用户\r\n(4)网站建设初期系统,注册的用户在确认身份信息后，站长会发放1000点数给用户。\r\n(5)每天登录获得10点。\r\n		\r\n\r\n如下行为会消耗点数：\r\n(1)发布或者激活一条信息\r\n(2)接收匹配信息需要消费点数，\r\n(3)只有买家和卖家和第三方都接受的时候才扣除，\r\n(4)接受需求信息或者供应信息\r\n(5)用户也可以把自己的旅游游记，照片甚至自创小说等共享并设置阅读点数\r\n(6)供应信息10条以上需要花费点数向网站租用\r\n(7)信息置顶服务\r\n \r\n 具体扣除多少点数则需要由管理员来设置";
    showedTextView.text = showingText;
}

-(void)getAboutUsIntroduction{
    showingText = @"";
    [BBUrlConnection getAboutUsComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        NSDictionary *datDic = resultDic[@"data"];
        NSString *aboutUsString = datDic[@"aboutUs"];
        if (aboutUsString) {
            showingText = aboutUsString;
            showedTextView.text = showingText;
        }
    }];
}

#pragma mark - Navigation
-(void)setUpNavigation{
    if (self.showedControllerType == 1) {
        self.navigationItem.title = @"点数介绍";
    }else if (self.showedControllerType == 2) {
        self.navigationItem.title = @"关于我们";
    }
    
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end