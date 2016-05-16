//
//  FriendDetailViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "FDHeaderView.h"
#import "FriendDetailViewCell.h"
#import "FDFooterView.h"

@interface FriendDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FDHeaderView *headerView;
@property (strong, nonatomic) FDFooterView *footerView;

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSDictionary *userDic;

@end

@implementation FriendDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDic = [BBUserDefaults getUserDic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ARGB_COLOR(242, 242, 242, 1);
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    [self setIndicatorTitle:@"个人资料"];
    self.titleArray = @[@"他的供求信息",@"地区",@"性别",@"个性签名"];
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self.headerView loadWithDataDic:self.currentUserDic];
    [self.footerView loadWithDataDic:self.currentUserDic];
    [self.view addSubview:self.tableView];
}
#pragma mark - 各种Getter
- (FDHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[FDHeaderView alloc]init];
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
        _tableView.backgroundColor = ARGB_COLOR(242, 242, 242, 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (FDFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[FDFooterView alloc]init];
    }
    return _footerView;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    FriendDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[FriendDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell loadWithTitle:self.titleArray[indexPath.section] DataDic:self.currentUserDic];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewCell *cell = [[FriendDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Frame"];
    [cell loadWithTitle:self.titleArray[indexPath.section] DataDic:self.currentUserDic];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, FLEXIBLE_NUM(6))];
    lineView.backgroundColor = ARGB_COLOR(242, 242, 242, 1);
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLEXIBLE_NUM(6);
}

#pragma mark - 按钮方法

#pragma mark - 自定义方法



@end
