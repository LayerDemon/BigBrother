//
//  SetRankNameViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SetRankNameViewController.h"
#import "UnitedInfoModel.h"
#import "SetRankNameTableViewCell.h"
#import "EditRankNameViewController.h"
@interface SetRankNameViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UnitedInfoModel       * unitedInfoModel;
@property (strong, nonatomic) NSArray               * dataArray;
@property (strong, nonatomic) UITableView           * tableView;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation SetRankNameViewController

static NSString * identify = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"设置等级头衔";
    }
    return self;
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"getUnitedRankData"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_unitedInfoModel getUnitedRankWithGroupId:_unitedDetailDic[@"id"]];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"getUnitedRankData"]) {
        _dataArray = _unitedInfoModel.getUnitedRankData[@"data"];
        [_tableView reloadData];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"getUnitedRankData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
    
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(40);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });

    [_tableView registerClass:[SetRankNameTableViewCell class] forCellReuseIdentifier:identify];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetRankNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * dataDic = _dataArray[indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%@级",dataDic[@"grade"]];
    cell.rankNameLael.text = dataDic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditRankNameViewController * editRankVC = [[EditRankNameViewController alloc] init];
    editRankVC.editRankDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:editRankVC animated:YES];
}

@end
