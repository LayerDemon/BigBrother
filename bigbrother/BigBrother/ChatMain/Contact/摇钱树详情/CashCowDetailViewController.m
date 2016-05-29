//
//  CashCowDetailViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CashCowDetailViewController.h"
#import "CashCowTableViewCell.h"

@interface CashCowDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       * tableView;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation CashCowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{

}

#pragma mark -- initialize
- (void)initializeDataSource
{

}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    
    //topview
    //image
    UIImageView * topImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(130, 10, 60, 60)];
    topImageView.layer.cornerRadius = FLEXIBLE_NUM(30);
    topImageView.clipsToBounds = YES;
    topImageView.image = [UIImage imageNamed:@"好看2.jpg"];
    [self.view addSubview:topImageView];
    
    //title
    UILabel * topTitleLabel = [self createLabelWithText:@"魔法师下的摇钱树" font:FLEXIBLE_NUM(15) subView:self.view];
    topTitleLabel.frame = FLEXIBLE_FRAME(10, 80, 300, 30);
    topTitleLabel.textColor = [UIColor blackColor];
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    //cash detail
    UILabel * cashDetail = [self createLabelWithText:@"恭喜发财，红包给你" font:FLEXIBLE_NUM(12) subView:self.view];
    cashDetail.frame = FLEXIBLE_FRAME(10, 110, 300, 30);
    cashDetail.textColor = [UIColor grayColor];
    cashDetail.textAlignment = NSTextAlignmentCenter;
    
    //countLabel
    UILabel * countLabel = [self createLabelWithText:@"5次机会，4分钟被抢光" font:FLEXIBLE_NUM(13) subView:self.view];
    countLabel.frame = FLEXIBLE_FRAME(10, 140, 200, 30);
    countLabel.textColor = [UIColor grayColor];
    
    
        
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FLEXIBLE_NUM(170), MAINSCRREN_W, MAINSCRREN_H - FLEXIBLE_NUM(170) - 64 - FLEXIBLE_NUM(50)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(66);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });

    UIButton * bottomButton = [self createButtonWithTitle:@"查看我的收获／付出记录" font:FLEXIBLE_NUM(13) subView:self.view];
    [bottomButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    bottomButton.frame = CGRectMake(0, MAINSCRREN_H - FLEXIBLE_NUM(50)-64, MAINSCRREN_W, FLEXIBLE_NUM(50));
    [bottomButton addTarget:self action:@selector(bottomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark -- button pressed
- (void)bottomButtonPressed:(UIButton *)sender
{
    
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"Cell";
    CashCowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CashCowTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    return cell;
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
