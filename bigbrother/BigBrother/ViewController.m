//
//  ViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ViewController.h"
#import "SourceMainViewController.h"
#import "ChatMainViewController.h"
#import "UserMainViewController.h"


@interface ViewController () <UITabBarControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SourceMainViewController *sourceMainVC = [SourceMainViewController new];
    
    ChatMainViewController *chatMainVC = [ChatMainViewController new];
//    UINavigationController *chatMainNC = [[UINavigationController alloc]initWithRootViewController:chatMainVC];
    
    UserMainViewController *userMainVC = [UserMainViewController new];
    
    NSDictionary *normalTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Tabbar_NormalColor};
    NSDictionary *selectedTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Tabbar_SelectedColor};
    
    sourceMainVC.tabBarItem.title=@"分类";
    sourceMainVC.tabBarItem.image=[UIImage imageNamed:@"foot_icon01"];
    sourceMainVC.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_icon01_on"];
    [sourceMainVC.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [sourceMainVC.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    chatMainVC.tabBarItem.title=@"聊天";
    chatMainVC.tabBarItem.image=[UIImage imageNamed:@"foot_icon02"];
    chatMainVC.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_icon02_on"];
    [chatMainVC.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [chatMainVC.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    userMainVC.tabBarItem.title=@"我";
    userMainVC.tabBarItem.image=[UIImage imageNamed:@"foot_icon03"];
    userMainVC.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_icon03_on"];
    [userMainVC.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [userMainVC.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    self.viewControllers = @[sourceMainVC,chatMainVC,userMainVC];
    self.tabBar.tintColor= BB_Tabbar_SelectedColor;
    self.delegate = self;
    self.tabBar.selectedImageTintColor = BB_Tabbar_SelectedColor;
    
    //登录环信
    NSDictionary *userDic = [BBUserDefaults getUserDic];
    NSLog(@"wocao -- %@",userDic);
//    EMError *error = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@",userDic[@"imNumber"]] password:@"123456"];
//    if (error) {
//        [BYToastView showToastWithMessage:@"聊天服务器连接失败~"];
//    }else{
//        [BYToastView showToastWithMessage:@"聊天服务器连接成功~"];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.viewControllers.count != 0) {
        [self.selectedViewController viewWillAppear:animated];
    }
    
    
    //    [self judgeToShowWeclome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
