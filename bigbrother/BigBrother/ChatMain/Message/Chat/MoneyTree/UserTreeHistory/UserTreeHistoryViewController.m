//
//  UserTreeHistoryViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/31.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UserTreeHistoryViewController.h"
#import "UTHTopView.h"
#import "UserTreeHistoryViewCell.h"

#import "MoneyTreeModel.h"

@interface UserTreeHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UTHTopViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UTHTopView *topView;

@property (strong, nonatomic) MoneyTreeModel *model;
@property (strong, nonatomic) NSDictionary *userDic;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger pageCount;

@end

@implementation UserTreeHistoryViewController

- (void)dealloc
{
    [_model removeObserver:self forKeyPath:@"pickHistoryData"];
}

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
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    [self setIndicatorTitle:@"付出与收获记录"];
    [self.topView topBtnPressed:self.topView.firstBtn];
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self.topView reloadWithDataDic:nil];
}
#pragma mark - 各种Getter
- (UTHTopView *)topView
{
    if (!_topView) {
        _topView = [[UTHTopView alloc]init];
        _topView.delegate = self;
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topView.frame), MAINSCRREN_W, MAINSCRREN_H-NAVBAR_H-self.topView.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = FLEXIBLE_NUM(51);
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefreshData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
        
    }
    return _tableView;
}

- (MoneyTreeModel *)model
{
    if (!_model) {
        _model = [[MoneyTreeModel alloc]init];
        [_model addObserver:self forKeyPath:@"pickHistoryData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pickHistoryData"]) {
        [self historyDataParse];
    }
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UserTreeHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UserTreeHistoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    NSDictionary *tempDic = self.listArray[indexPath.row];
    if (self.topView.lastBtn.tag-BUTTON_TAG == 0) {
        [cell reloadPickHistoryWithDataDic:tempDic];
    }else{
        [cell reloadPlanHistoryWithDataDic:tempDic];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UTHTopViewDelegate
- (void)topView:(UTHTopView *)topView clickedTopBtn:(UIButton *)sender
{
//    if (self.model.pickHistoryData) {
//        [self historyDataParse];
//        return;
//    }
//    if (sender.tag-BUTTON_TAG == 0)
//    {//收获
//        [self startTitleIndicator];
//        
//    }
//    else{//付出
//        
//    }
    [self startTitleIndicator];
    [self downRefreshData];
}

#pragma mark - 按钮方法

#pragma mark - 自定义方法
- (void)downRefreshData
{
    [self.tableView.mj_footer resetNoMoreData];
    if (self.topView.lastBtn.tag-BUTTON_TAG == 0) {
        [self.model postPickHistoryDataWithCreator:self.userDic[@"id"] page:1 pageSize:PAGESIZE_NORMAL];
    }else{
        [self.model postPlantHistoryDataWithUserId:self.userDic[@"id"] page:1 pageSize:PAGESIZE_NORMAL];
    }
}

- (void)upRefreshData
{
    self.currentPage++;
    if (self.topView.lastBtn.tag-BUTTON_TAG == 0) {
        [self.model postPickHistoryDataWithCreator:self.userDic[@"id"] page:self.currentPage pageSize:PAGESIZE_NORMAL];
    }else{
        [self.model postPlantHistoryDataWithUserId:self.userDic[@"id"] page:self.currentPage pageSize:PAGESIZE_NORMAL];
    }
}

#pragma mark - 数据处理
- (void)historyDataParse
{
    [self stopTitleIndicator];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSDictionary *histroyDic = (self.topView.lastBtn.tag-BUTTON_TAG) ? self.model.pickHistoryData : self.model.plantHistoryData;
    
    if ([histroyDic[@"pageSize"] integerValue] == PAGESIZE_NORMAL) {
        self.currentPage = [histroyDic[@"page"] integerValue];
        self.pageCount = [histroyDic[@"totalPages"] integerValue];
    }
    
    if (self.currentPage == 1) {
        self.listArray = [NSMutableArray arrayWithArray:histroyDic[@"content"]];
    }else{
        [self.listArray addObjectsFromArray:histroyDic[@"content"]];
    }
    if (self.pageCount <= self.currentPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}


@end
