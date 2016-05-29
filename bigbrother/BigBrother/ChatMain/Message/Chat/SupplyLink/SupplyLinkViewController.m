//
//  SupplyLinkViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/19.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SupplyLinkViewController.h"
#import "SupplyLinkViewCell.h"
#import "ChatModel.h"

@interface SupplyLinkViewController ()<UITableViewDataSource,UITableViewDelegate,SupplyLinkViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) ChatModel *model;
@property (strong, nonatomic) NSDictionary *useDic;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger pageCount;

@end

@implementation SupplyLinkViewController

- (void)dealloc
{
    [_model removeObserver:self forKeyPath:@"supplyLinkData"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.useDic = [BBUserDefaults getUserDic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNavBarView];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    self.listArray = [NSMutableArray array];
    [self startTitleIndicator];
    [self downRefreshData];
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self.view addSubview:self.tableView];
}

- (void)loadNavBarView
{
    [self setIndicatorTitle:@"供应链接"];
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - 各种Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefreshData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    }
    return _tableView;
}

- (ChatModel *)model
{
    if (!_model) {
        _model = [[ChatModel alloc]init];
        [_model addObserver:self forKeyPath:@"supplyLinkData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"supplyLinkData"]) {
        [self supplyLinkDataParse];
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
    SupplyLinkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SupplyLinkViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    
    [cell reloadWithDataDic:self.listArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Frame";
    SupplyLinkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SupplyLinkViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    [cell reloadWithDataDic:self.listArray[indexPath.row]];
    return cell.frame.size.height;
}

#pragma mark - SupplyLinkViewCellDelegate
- (void)supplyLinkViewCell:(SupplyLinkViewCell *)cell clickedSendBtn:(UIButton *)sender
{
    NSDictionary *customMessageDic = [EaseSDKHelper customMessageDicWithSubMessage:@"发送了一条[供应链接]" customPojo:cell.dataDic resultValue:@(2)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendCustomMessage" object:customMessageDic];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 按钮方法
- (void)leftItemPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义方法
- (void)downRefreshData
{
    [self.tableView.mj_footer resetNoMoreData];
    
    [self.model getSupplyLinkDataWithSupplyDemandType:@"PROVIDE" creator:self.useDic[@"id"] status:@"NOT_AUDITED" page:1 pageSize:PAGESIZE_NORMAL];
}

- (void)upRefreshData
{
    self.currentPage++;
    [self.model getSupplyLinkDataWithSupplyDemandType:@"PROVIDE" creator:self.useDic[@"id"] status:@"NOT_AUDITED" page:self.currentPage pageSize:PAGESIZE_NORMAL];
}

#pragma mark - 数据处理
- (void)supplyLinkDataParse
{
    [self stopTitleIndicator];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if ([self.model.supplyLinkData[@"pageSize"] integerValue] == PAGESIZE_NORMAL) {
        self.currentPage = [self.model.supplyLinkData[@"page"] integerValue];
        self.pageCount = [self.model.supplyLinkData[@"totalPages"] integerValue];
    }
    
    if (self.currentPage == 1) {
        self.listArray = [NSMutableArray arrayWithArray:self.model.supplyLinkData[@"content"]];
    }else{
        [self.listArray addObjectsFromArray:self.model.supplyLinkData[@"content"]];
    }
    if (self.pageCount <= self.currentPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}

@end
