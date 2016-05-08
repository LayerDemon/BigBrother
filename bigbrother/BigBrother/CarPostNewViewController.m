//
//  CarPostNewViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CarPostNewViewController.h"

#import "RentCarPostToViewController.h"
#import "CarPoolPostToViewController.h"
#import "HelpDrivePostToViewController.h"

@interface CarPostNewViewController ()

@end

@implementation CarPostNewViewController{
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
    
    lineTitleNameArray = @[@{@"title":@"租车服务",
                             },
                           @{@"title":@"拼车服务",
                             },
                           @{@"title":@"代驾服务",
                             },
                           @{@"title":@"旅行保险",
                             }];
    
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
        contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, BOTTOM(button)+5)};
    }
}

-(void)titleButtonClick:(UIButton *)button{
    int tag = (int)button.tag;
    if (tag >= lineTitleNameArray.count) {
        return;
    }
    NSString *forwardString = lineTitleNameArray[tag][@"title"];;
    if ([forwardString rangeOfString:@"租车"].length != 0) {
        RentCarPostToViewController *rcpVC = [[RentCarPostToViewController alloc] init];
        [self.navigationController pushViewController:rcpVC animated:YES];
    }else if ([forwardString rangeOfString:@"拼车"].length != 0){
        CarPoolPostToViewController *cpptVC = [[CarPoolPostToViewController alloc] init];
        [self.navigationController pushViewController:cpptVC animated:YES];
    }else if ([forwardString rangeOfString:@"代驾"].length != 0){
        HelpDrivePostToViewController *hpptVC = [[HelpDrivePostToViewController alloc] init];
        [self.navigationController pushViewController:hpptVC animated:YES];
    }else if ([forwardString rangeOfString:@"保险"].length != 0){
        [BYToastView showToastWithMessage:@"敬请期待"];
    }else{
        [BYToastView showToastWithMessage:@"敬请期待"];
    }
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.navigationItem.title = @"用车服务-发布";
    
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
