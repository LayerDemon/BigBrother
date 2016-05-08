//
//  SettingViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/1.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SettingViewController.h"

#import "ShowTextViewController.h"
#import "SuggestionPostViewController.h"

@interface SettingViewController () <UIAlertViewDelegate>

@end

@implementation SettingViewController{
    UIButton *logOutButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    float everyButtonViewHeight = 45;
    
    float offset = 10;
    
    UIImage *moreImage = [UIImage imageNamed:@"icon_more"];
    
    UIView *pointsIntroView = [[UIView alloc] init];
    pointsIntroView.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    pointsIntroView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:pointsIntroView];
    
    pointsIntroView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pointsIntroViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pointsIntroViewTapTriger)];
    [pointsIntroView addGestureRecognizer:pointsIntroViewTap];
    
    UILabel *pointsIntrolabel = [[UILabel alloc] init];
    pointsIntrolabel.frame = (CGRect){15,0,170,HEIGHT(pointsIntroView)};
    pointsIntrolabel.text = @"点数介绍";
    pointsIntrolabel.textColor = RGBColor(50, 50, 50);
    pointsIntrolabel.textAlignment = NSTextAlignmentLeft;
    pointsIntrolabel.font = Font(14);
    [pointsIntroView addSubview:pointsIntrolabel];
    
    UIImageView *pointsIntroMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    pointsIntroMoreImage.frame = (CGRect){WIDTH(pointsIntroView)-10-moreImage.size.width,(HEIGHT(pointsIntroView)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [pointsIntroView addSubview:pointsIntroMoreImage];
    
    UIView *lineViewSep1 = [[UIView alloc] initWithFrame:(CGRect){0,HEIGHT(pointsIntroView)-0.5,WIDTH(pointsIntroView),0.5}];
    lineViewSep1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [pointsIntroView addSubview:lineViewSep1];
    
    offset += HEIGHT(pointsIntroView);
    
    UIView *aboutUsView = [[UIView alloc] init];
    aboutUsView.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    aboutUsView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:aboutUsView];
    
    aboutUsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *aboutUsViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutUsViewTapTriger)];
    [aboutUsView addGestureRecognizer:aboutUsViewTap];
    
    UILabel *aboutUslabel = [[UILabel alloc] init];
    aboutUslabel.frame = (CGRect){15,0,170,HEIGHT(aboutUsView)};
    aboutUslabel.text = @"关于我们";
    aboutUslabel.textColor = RGBColor(50, 50, 50);
    aboutUslabel.textAlignment = NSTextAlignmentLeft;
    aboutUslabel.font = Font(14);
    [aboutUsView addSubview:aboutUslabel];
    
    UIImageView *aboutUsMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    aboutUsMoreImage.frame = (CGRect){WIDTH(aboutUsView)-10-moreImage.size.width,(HEIGHT(aboutUsView)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [aboutUsView addSubview:aboutUsMoreImage];
    
    UIView *lineViewSep2 = [[UIView alloc] initWithFrame:(CGRect){0,HEIGHT(aboutUsView)-0.5,WIDTH(aboutUsView),0.5}];
    lineViewSep2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [aboutUsView addSubview:lineViewSep2];
    
    offset += HEIGHT(aboutUsView);
    
    UIView *suggestionPostView = [[UIView alloc] init];
    suggestionPostView.frame = (CGRect){0,offset,WIDTH(contentView),everyButtonViewHeight};
    suggestionPostView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:suggestionPostView];
    
    suggestionPostView.userInteractionEnabled = YES;
    UITapGestureRecognizer *suggestionPostViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suggestionPostViewTapTriger)];
    [suggestionPostView addGestureRecognizer:suggestionPostViewTap];
    
    UILabel *suggestionPostlabel = [[UILabel alloc] init];
    suggestionPostlabel.frame = (CGRect){15,0,170,HEIGHT(suggestionPostView)};
    suggestionPostlabel.text = @"意见反馈";
    suggestionPostlabel.textColor = RGBColor(50, 50, 50);
    suggestionPostlabel.textAlignment = NSTextAlignmentLeft;
    suggestionPostlabel.font = Font(14);
    [suggestionPostView addSubview:suggestionPostlabel];
    
    UIImageView *suggestionPostMoreImage = [[UIImageView alloc] initWithImage:moreImage];
    suggestionPostMoreImage.frame = (CGRect){WIDTH(suggestionPostView)-10-moreImage.size.width,(HEIGHT(suggestionPostView)-moreImage.size.height)/2,moreImage.size.width,moreImage.size.height};
    [suggestionPostView addSubview:suggestionPostMoreImage];
    
    UIView *lineViewSep3 = [[UIView alloc] initWithFrame:(CGRect){0,HEIGHT(suggestionPostView)-0.5,WIDTH(suggestionPostView),0.5}];
    lineViewSep3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [suggestionPostView addSubview:lineViewSep3];
    
    offset += HEIGHT(suggestionPostView);
    
    offset += 10;
    
    if ([BBUserDefaults getIsLogin]) {
        logOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        logOutButton.frame = (CGRect){15,offset,WIDTH(contentView)-15*2,40};
        logOutButton.layer.cornerRadius = 2.f;
        logOutButton.layer.masksToBounds = YES;
        [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logOutButton.backgroundColor = BB_BlueColor;
        [logOutButton addTarget:self action:@selector(logOutClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:logOutButton];
    }
}

-(void)pointsIntroViewTapTriger{
    ShowTextViewController *stVC= [[ShowTextViewController alloc] init];
    stVC.showedControllerType = 1;
    [self.navigationController pushViewController:stVC animated:YES];
}

-(void)aboutUsViewTapTriger{
    ShowTextViewController *stVC= [[ShowTextViewController alloc] init];
    stVC.showedControllerType = 2;
    [self.navigationController pushViewController:stVC animated:YES];
}

-(void)suggestionPostViewTapTriger{
    [self.navigationController pushViewController:[SuggestionPostViewController new] animated:YES];
}

-(void)logOutClick{
    [[[UIAlertView alloc] initWithTitle:@"提示信息" message:@"确定注销登录吗?" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"注销", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [BBUserDefaults resetLoginStatus];
        logOutButton.hidden = YES;
    }
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"设置";
    
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