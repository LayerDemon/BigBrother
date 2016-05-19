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

@interface UnitedActivityViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UnitedInfoModel       * unitedInfoModel;
@property (strong, nonatomic) NSArray               * dataArray;
@property (strong, nonatomic) UITableView           * tableView;

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

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"unitedActivityData"]) {
        _dataArray = _unitedInfoModel.unitedActivityData[@"data"];
        
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"unitedActivityData" options:NSKeyValueObservingOptionNew context:nil];
        [model getUnitedActivityWithGroupId:_unitedDic[@"id"] page:@"1"];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    NSDictionary * dataDic = _groupArray[indexPath.section][indexPath.row];
//    
//    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.groupNameLabel.text = dataDic[@"name"];
    
    return cell;
}


@end
