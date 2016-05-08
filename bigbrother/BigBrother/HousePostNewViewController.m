//
//  HousePostNewViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HousePostNewViewController.h"

#import "SingleRoomRentPostToViewController.h"
#import "WholeHouseRentPostToViewController.h"
#import "WholeHouseWantRentPostToViewController.h"
#import "WholeHouseSellPostToViewController.h"
#import "WholeHouseWantBuyPostToViewController.h"
#import "HouseFactoryProvideRentPostToViewController.h"
#import "HouseFactoryWantRentPostToViewController.h"
#import "HouseFactoryWantBuyPostToViewController.h"
#import "HouseFactoryWantSellPostToViewController.h"

@interface HousePostNewViewController ()

@end

@implementation HousePostNewViewController{
    NSArray *lineTitleNameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIScrollView *contentView;
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.backgroundColor = BB_WhiteColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    lineTitleNameArray = @[@{@"title":@"单间租赁",
                             },
                           @{@"title":@"整套租赁",
                             },
                           @{@"title":@"房屋求租",
                             },
                           @{@"title":@"房屋销售",
                             },
                           @{@"title":@"房屋求购",
                             },
                           @{@"title":@"厂房租赁",
                             },
                           @{@"title":@"厂房求租",
                             },
                           @{@"title":@"厂房销售",
                             },
                           @{@"title":@"厂房求购",
                             },
                           @{@"title":@"商铺、写字楼租赁",
                             },
                           @{@"title":@"商铺、写字楼求租",
                             },
                           @{@"title":@"商铺、写字楼出售",
                             },
                           @{@"title":@"商铺、写字楼求购",
                             },
                           ];
    
    float upPadding = 10;
    float everyButtonHeight = 45;
    for (int i = 0; i < lineTitleNameArray.count; i++) {
        NSDictionary *dic = lineTitleNameArray[i];
        NSString *titleString = dic[@"title"];
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.frame = (CGRect){0,upPadding+everyButtonHeight * i,WIDTH(contentView),everyButtonHeight};
        button.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:button];
        
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = Font(15);
        titleLabel.text = titleString;
        titleLabel.textColor = RGBColor(50, 50, 50);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.frame = (CGRect){10,0,WIDTH(button)-10-10-20,45};
        [button addSubview:titleLabel];
        
        UIImageView *moreImageView = [[UIImageView alloc] init];
        moreImageView.image = [UIImage imageNamed:@"icon_more"];
        moreImageView.frame = (CGRect){WIDTH(button)-10-7,(HEIGHT(button)-11)/2,7,11};
        [button addSubview:moreImageView];
        
        UIView *lineBottomSepLineView = [[UIView alloc] init];
        lineBottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        lineBottomSepLineView.frame = (CGRect){0,HEIGHT(button)-0.5,WIDTH(button),0.5};
        [button addSubview:lineBottomSepLineView];
        
        if (i == 0) {
            UIView *lineTopSepLineView = [[UIView alloc] init];
            lineTopSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
            lineTopSepLineView.frame = (CGRect){0,0,WIDTH(button),0.5};
            [button addSubview:lineTopSepLineView];
        }
        contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, BOTTOM(button)+10)};
    }
}

-(void)titleButtonClick:(UIButton *)button{
    int tag = (int)button.tag;
    if (tag >= lineTitleNameArray.count) {
        return;
    }
    NSString *forwardString = lineTitleNameArray[tag][@"title"];
    if ([forwardString isEqualToString:@"单间租赁"]) {
        SingleRoomRentPostToViewController *srrptVC = [[SingleRoomRentPostToViewController alloc] init];
        [self.navigationController pushViewController:srrptVC animated:YES];
    }else if ([forwardString isEqualToString:@"整套租赁"]) {
        [self.navigationController pushViewController:[WholeHouseRentPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"房屋求租"]) {
        [self.navigationController pushViewController:[WholeHouseWantRentPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"房屋销售"]) {
        [self.navigationController pushViewController:[WholeHouseSellPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"房屋求购"]) {
        [self.navigationController pushViewController:[WholeHouseWantBuyPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"厂房租赁"]) {
        [self.navigationController pushViewController:[HouseFactoryProvideRentPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"厂房求租"]) {
        [self.navigationController pushViewController:[HouseFactoryWantRentPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"厂房销售"]) {
        [self.navigationController pushViewController:[HouseFactoryWantSellPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"厂房求购"]) {
        [self.navigationController pushViewController:[HouseFactoryWantBuyPostToViewController new] animated:YES];
    }else if ([forwardString isEqualToString:@"商铺、写字楼租赁"]) {
        [BYToastView showToastWithMessage:@"敬请期待"];
    }else if ([forwardString isEqualToString:@"商铺、写字楼求租"]) {
        [BYToastView showToastWithMessage:@"敬请期待"];
    }else if ([forwardString isEqualToString:@"商铺、写字楼出售"]) {
        [BYToastView showToastWithMessage:@"敬请期待"];
    }else if ([forwardString isEqualToString:@"商铺、写字楼求购"]) {
        [BYToastView showToastWithMessage:@"敬请期待"];
    }else{
        [BYToastView showToastWithMessage:@"敬请期待"];
    }
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.navigationItem.title = @"房屋租赁销售";
    
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
