//
//  FactoryPostNewViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FactoryPostNewViewController.h"

#import "FactroyPostToViewController.h"

@interface FactoryPostNewViewController ()

@end

@implementation FactoryPostNewViewController{
    NSArray *lineTitleNameArray;
    
    UIScrollView *contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.backgroundColor = BB_WhiteColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    [self getFactoryProductTypeList];
}

-(void)getFactoryProductTypeList{
    [BBUrlConnection getFactoryProductTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取类别信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || dataArray.count == 0 || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取类别信息失败,请稍后再试"];
            return;
        }
        NSMutableArray *typeTmpShowedArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArray) {
            int gategroyIDTmp = [dic[@"id"] intValue];
            NSString *name = dic[@"name"];
            [typeTmpShowedArray addObject:@{@"id":@(gategroyIDTmp),@"name":name}];
        }
        lineTitleNameArray = [NSArray arrayWithArray:typeTmpShowedArray];
        [self setActiveButtonWithArray:lineTitleNameArray];
    }];
}

-(void)setActiveButtonWithArray:(NSArray *)array{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float upPadding = 10;
    float everyButtonHeight = 45;
    for (int i = 0; i < lineTitleNameArray.count; i++) {
        NSDictionary *dic = lineTitleNameArray[i];
        NSString *titleString = dic[@"name"];
        
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
    if (!lineTitleNameArray || lineTitleNameArray.count == 0)  {
        return;
    }
    if (tag >= lineTitleNameArray.count) {
        return;
    }
    NSDictionary *linePostDic = lineTitleNameArray[tag];
    NSString *forwardString = linePostDic[@"name"];
    
    FactroyPostToViewController *fptVC = [[FactroyPostToViewController alloc] init];
    fptVC.postProductInfoDic = linePostDic;
    fptVC.title = [NSString stringWithFormat:@"%@-发布",forwardString];
    [self.navigationController pushViewController:fptVC animated:YES];
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.navigationItem.title = @"工业产品-发布";
    
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
