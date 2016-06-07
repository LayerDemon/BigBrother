//
//  CashCowDetailViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CashCowDetailViewController.h"
#import "CashCowTableViewCell.h"
#import "MoneyTreeModel.h"
#import "UserTreeHistoryViewController.h"

@interface CashCowDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       * tableView;
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UILabel *topTitleLabel;
@property (strong, nonatomic) UILabel *cashDetailLabel;
@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) MoneyTreeModel *model;
@property (strong, nonatomic) NSMutableArray *listArray;
//@property (assign, nonatomic) NSInteger currentPage;
//@property (assign, nonatomic) NSInteger pageCount;

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
    [_model removeObserver:self forKeyPath:@"pickListData"];
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    [self setIndicatorTitle:@"摇钱树详情"];
    self.listArray = [NSMutableArray array];
    [self startTitleIndicator];
    [self.model postPickListDataWithMoneyTreeId:self.moneyTreeDic[@"id"]];
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
    self.topImageView = topImageView;
    
    //title
    UILabel * topTitleLabel = [self createLabelWithText:@"魔法师下的摇钱树" font:FLEXIBLE_NUM(15) subView:self.view];
    topTitleLabel.frame = FLEXIBLE_FRAME(10, 80, 300, 30);
    topTitleLabel.textColor = [UIColor blackColor];
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.topTitleLabel = topTitleLabel;
    
    //cash detail
    UILabel * cashDetail = [self createLabelWithText:@"恭喜发财，红包给你" font:FLEXIBLE_NUM(12) subView:self.view];
    cashDetail.frame = FLEXIBLE_FRAME(10, 110, 300, 30);
    cashDetail.textColor = [UIColor grayColor];
    cashDetail.textAlignment = NSTextAlignmentCenter;
    self.cashDetailLabel = cashDetail;
    
    //countLabel
    UILabel * countLabel = [self createLabelWithText:@"5次机会，4分钟被抢光" font:FLEXIBLE_NUM(13) subView:self.view];
    countLabel.frame = FLEXIBLE_FRAME(10, 140, 200, 30);
    countLabel.textColor = [UIColor grayColor];
    self.countLabel = countLabel;
    
        
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
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefreshData)];
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];

    UIButton * bottomButton = [self createButtonWithTitle:@"查看我的收获／付出记录" font:FLEXIBLE_NUM(13) subView:self.view];
    [bottomButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    bottomButton.frame = CGRectMake(0, MAINSCRREN_H - FLEXIBLE_NUM(50)-64, MAINSCRREN_W, FLEXIBLE_NUM(50));
    bottomButton.userInteractionEnabled = YES;
    [bottomButton addTarget:self action:@selector(bottomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    NSString *urlStr = [NSString isBlankStringWithString:self.createUserDic[@"avatar"]] ? @"" : self.createUserDic[@"avatar"];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:PLACEHOLDERIMAGE_USER completed:nil];
    self.topTitleLabel.text = self.createUserDic[@"nickname"];
    self.cashDetailLabel.text = self.moneyTreeDic[@"message"];
    self.countLabel.text = [NSString stringWithFormat:@"%@次机会，%@分钟被抢光",self.moneyTreeDic[@"goldCoinCount"],@"*"];
}

#pragma mark - getter
- (MoneyTreeModel *)model
{
    if (!_model) {
        _model = [[MoneyTreeModel alloc]init];
        [_model addObserver:self forKeyPath:@"pickListData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pickListData"]) {
        [self pickListDataParse];
    }
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"Cell";
    CashCowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CashCowTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    
    [cell reloadWithDataDic:self.listArray[indexPath.row]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


#pragma mark -- button pressed
- (void)bottomButtonPressed:(UIButton *)sender
{
    UserTreeHistoryViewController *userTreeHistoryVC = [[UserTreeHistoryViewController alloc]init];
    userTreeHistoryVC.moneyTreeDic = self.moneyTreeDic;
    [self.navigationController pushViewController:userTreeHistoryVC animated:YES];
}

#pragma mark - 自定义方法
- (void)downRefreshData
{
    [self.tableView.mj_footer resetNoMoreData];
    [self.model postPickListDataWithMoneyTreeId:self.moneyTreeDic[@"id"]];
}

//- (void)upRefreshData
//{
//    self.currentPage++;
//    [self.model postPickListDataWithMoneyTreeId:self.moneyTreeDic[@"id"]];
//}


//摘取列表
- (void)pickListDataParse
{
    [self stopTitleIndicator];
    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
//    self.listArray = [NSMutableArray arrayWithArray:self.model.pickListData[@""]];
    self.listArray = [NSMutableArray arrayWithArray:self.model.pickListData[@"pageResult"][@"content"]];
    [self.tableView reloadData];
    
    
    if ([self.moneyTreeDic[@"leftCoinCount"] integerValue] > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%@次机会，还剩%@次机会",self.moneyTreeDic[@"goldCoinCount"],self.moneyTreeDic[@"leftCoinCount"]];
    }else{
        NSDictionary *tempDic = [self.listArray firstObject];
        NSString *createTimeStr = self.moneyTreeDic[@"createdTime"];
        NSString *endTimeStr = tempDic[@"createdTime"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *createdTime = [format dateFromString:createTimeStr];
        NSDate *endTime = [format dateFromString:endTimeStr];
        NSTimeInterval time=[endTime timeIntervalSinceDate:createdTime];
        
        int days = ((int)time)/(3600*24);
        
        int hours = ((int)time)%(3600*24)/3600;
        
        int minutes = ((int)time)%(3600*24)%3600/60;
        
        int seconds = ((int)time)%(3600*24)%3600%60;
        
        NSString *daysStr = days > 0 ? [NSString stringWithFormat:@"%@天",@(days)] : @"";
        NSString *hoursStr = hours > 0 ? [NSString stringWithFormat:@"%@时",@(hours)] : @"";
        NSString *minutesStr = minutes > 0 ? [NSString stringWithFormat:@"%@分",@(minutes)] : @"";
        NSString *secondsStr = seconds > 0 ? [NSString stringWithFormat:@"%@秒",@(seconds)] : @"";
        
        NSString *dateContent = [[NSString alloc] initWithFormat:@"%@%@%@%@",daysStr,hoursStr,minutesStr,secondsStr];
        
        self.countLabel.text = [NSString stringWithFormat:@"%@次机会，%@被抢光",self.moneyTreeDic[@"goldCoinCount"],dateContent];
    }
    
    
//    if ([self.model.pickListData[@"pageSize"] integerValue] == PAGESIZE_NORMAL) {
//        self.currentPage = [self.model.pickListData[@"page"] integerValue];
//        self.pageCount = [self.model.pickListData[@"totalPages"] integerValue];
//    }
//    
//    if (self.currentPage == 1) {
//        self.listArray = [NSMutableArray arrayWithArray:self.model.pickListData[@"content"]];
//    }else{
//        [self.listArray addObjectsFromArray:self.model.pickListData[@"content"]];
//    }
//    if (self.pageCount <= self.currentPage) {
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    }
    
}

@end
