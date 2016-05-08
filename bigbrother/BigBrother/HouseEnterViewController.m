//
//  HouseEnterViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HouseEnterViewController.h"
#import "HousePostNewViewController.h"

#import "HouseSquareViewController.h"

@interface HouseEnterViewController ()

@end

@implementation HouseEnterViewController{
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
                           @{@"title":@"厂房销售",
                             },
                           @{@"title":@"商铺、写字楼租赁",
                             },
                           @{@"title":@"商铺、写字楼销售",
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
    NSString *forwardString = lineTitleNameArray[tag][@"title"];;
    
    HouseProductType type = HouseProductNone;
    if ([forwardString isEqualToString:@"单间租赁"]) {
        type = HouseProductDanjianZuNin;
    }else if ([forwardString isEqualToString:@"整套租赁"]) {
        type = HouseProductZhengTaoZuNin;
    }else if ([forwardString isEqualToString:@"厂房租赁"]) {
        type = HouseProductChangFangZuNin;
    }else if ([forwardString isEqualToString:@"房屋求租"]) {
        type = HouseProductFangWuQiuZu;
    }else if ([forwardString isEqualToString:@"房屋求购"]) {
        type = HouseProductFangWuQiuGou;
    }else if ([forwardString isEqualToString:@"房屋销售"]) {
        type = HouseProductFangWuXiaoShou;
    }else if ([forwardString isEqualToString:@"厂房销售"]) {
        type = HouseProductChangFangXiaoShou;
    }else if ([forwardString isEqualToString:@"商铺、写字楼租赁"]) {
        type = HouseProductShangPuZuNin;
        [BYToastView showToastWithMessage:@"敬请期待"];
        return;
    }else if ([forwardString isEqualToString:@"商铺、写字楼销售"]) {
        type = HouseProductShangPuXiaoShou;
        [BYToastView showToastWithMessage:@"敬请期待"];
        return;
    }
    if (type == CarProductNone) {
        return;
    }
    
    HouseSquareViewController *hsVC = [[HouseSquareViewController alloc] init];
    hsVC.houseType = type;
    [self.navigationController pushViewController:hsVC animated:YES];
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.navigationItem.title = @"房屋租赁销售";
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIImage *imageArrow = [UIImage imageNamed:@"icon_fb"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setImage:imageArrow forState:UIControlStateNormal];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(16);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rightButtonTitle = @" 发布";
    [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,60,20};
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    HousePostNewViewController *hpnVC = [[HousePostNewViewController alloc] init];
    [self.navigationController pushViewController:hpnVC animated:YES];
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
