//
//  UnitedActivityViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedActivityViewController.h"
#import "UnitedActivityTableViewCell.h"
#import "UnitedInfoModel.h"
#import "CreateUnitedActivityViewController.h"
#import "UnitedActivityDetailViewController.h"

@interface UnitedActivityViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UnitedInfoModel       * unitedInfoModel;
@property (strong, nonatomic) NSMutableArray        * dataArray;
@property (strong, nonatomic) UITableView           * tableView;

@property (strong, nonatomic) UILabel               * stateLabel;
@property (assign, nonatomic) NSInteger             currentPage;
@property (assign, nonatomic) NSInteger             mark;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedActivityViewController

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
        self.navigationItem.title = @"活动";
    }
    return self;
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"unitedActivityData"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_unitedInfoModel getUnitedActivityWithGroupId:_unitedDic[@"id"] page:@"1"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"unitedActivityData"]) {
        NSArray * dataArray = _unitedInfoModel.unitedActivityData[@"data"];
        if (!_dataArray) {
            _dataArray = [[NSMutableArray alloc] init];
        }
        if (_mark == 0) {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:dataArray];
            _currentPage = 2;
            [_tableView.mj_header endRefreshing];
            
            if (dataArray.count == 10) {
                [_tableView.mj_footer resetNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [_dataArray addObjectsFromArray:dataArray];
            if (dataArray.count == 10) {
                [_tableView.mj_footer endRefreshing];
                _currentPage ++;
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (_dataArray.count == 0) {
            _stateLabel.hidden = NO;
        }else{
            _stateLabel.hidden = YES;
        }
        [_tableView reloadData];
    }

}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"unitedActivityData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
        
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(115);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });
    [_tableView registerClass:[UnitedActivityTableViewCell class] forCellReuseIdentifier:identify];

    __weak typeof(self) weakSelf = self;
    
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.unitedInfoModel getUnitedActivityWithGroupId:_unitedDic[@"id"] page:@"1"];
        weakSelf.mark = 0;
    }];
    
    //上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.mark = 1;
        [weakSelf.unitedInfoModel getUnitedActivityWithGroupId:_unitedDic[@"id"] page:[NSString stringWithFormat:@"%ld",(long)_currentPage]];
    }];
    
    _stateLabel = ({
        UILabel * label = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 200, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = FLEXIBLE_CENTER(160, 250);
        label.textColor = [UIColor grayColor];
        label.hidden = YES;
        label.text = @"还没有门派活动哦～";
        label.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(15)];
        [self.view addSubview:label];
        label;
    });

    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"创建活动" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark -- button pressed
- (void)rightButtonPressed:(UIButton *)sender
{
    CreateUnitedActivityViewController * createActivityVC = [[CreateUnitedActivityViewController alloc] init];
    createActivityVC.unitedDic = _unitedDic;
    [self.navigationController pushViewController:createActivityVC animated:YES];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * dataDic = _dataArray[indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"images"][0][@"url"]] placeholderImage:PLACEHOLER_IMA];
    cell.unitedNameLabel.text = dataDic[@"name"];
    cell.locationLabel.text = dataDic[@"location"];
    NSString * beginTimeString = [dataDic[@"startTime"] substringToIndex:[dataDic[@"startTime"] length]-2];
    NSString * endTimeString = [dataDic[@"endTime"] substringToIndex:[dataDic[@"endTime"] length]-2];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ － %@",beginTimeString,endTimeString];
    cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人已报名",dataDic[@"applicantCount"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedActivityDetailViewController * vc = [[UnitedActivityDetailViewController alloc] init];
    vc.activityDic = _dataArray[indexPath.row];
    vc.unitedDic = _unitedDic;
    [self.navigationController pushViewController:vc animated:YES];
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
