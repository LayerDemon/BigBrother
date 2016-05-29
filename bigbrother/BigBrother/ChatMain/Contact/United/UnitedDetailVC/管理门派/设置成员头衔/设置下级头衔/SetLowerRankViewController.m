//
//  SetLowerRankViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SetLowerRankViewController.h"
#import "UnitedMember2TableViewCell.h"
#import "EditUnitedMemberRankViewController.h"
@interface SetLowerRankViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (strong, nonatomic) UITableView       * tableView;
@property (strong, nonatomic) NSMutableArray    * dataArray;
@property (strong, nonatomic) NSArray           * colorArray;

@property (strong, nonatomic) UISearchController                * searchController;
@property (strong, nonatomic) NSArray                           * filterData;

- (void)initializeDataSource;
- (void)initializeUserInterface;

@end

@implementation SetLowerRankViewController

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
        self.navigationItem.title = @"授予成员头衔";
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _colorArray = @[ARGB_COLOR(254, 217, 110, 1),ARGB_COLOR(150, 220, 116, 1),ARGB_COLOR(202, 202, 202, 1)];
    
    _dataArray = [NSMutableArray array];
    
    NSMutableArray * userArray = [NSMutableArray array];
    NSMutableArray * managerArray = [NSMutableArray array];
    for (int i = 0; i < _memberArray.count; i ++) {
        if ([_memberArray[i][@"role"] isEqualToString:@"USER"]) {
            BOOL isExit = NO;
            for (int j = 0; j < userArray.count; j ++) {
                if ([userArray[j][@"section"] isEqualToString:_memberArray[i][@"grade"]]) {
                    isExit = YES;
                    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] init];
                    NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithArray:userArray[j][@"array"]];
                    [mutableArray addObject:_memberArray[i]];
                    
                    [mutableDic setObject:_memberArray[i][@"grade"] forKey:@"grade"];
                    [mutableDic setObject:mutableArray forKey:@"array"];
                    
                    [userArray replaceObjectAtIndex:j withObject:mutableDic];
                }
            }
            if (!isExit) {
                NSMutableDictionary * newDataDic = [[NSMutableDictionary alloc] init];
                [newDataDic setObject:_memberArray[i][@"grade"] forKey:@"grade"];
                [newDataDic setObject:@[_memberArray[i]] forKey:@"array"];
                [userArray addObject:newDataDic];
            }
        }else{
            [managerArray addObject:_memberArray[i]];
        }
    }
    [_dataArray addObject:managerArray];
    [_dataArray addObjectsFromArray:userArray];
    NSLog(@"dataArray --- %@",_dataArray);
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, MAINSCRREN_W, MAINSCRREN_H - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(47);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });
    [_tableView registerClass:[UnitedMember2TableViewCell class] forCellReuseIdentifier:identify];
    
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = YES;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = FLEXIBLE_FRAME(10, 8, 300, 34);
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    for (UIView *subview in _searchController.searchBar.subviews) {
        for(UIView* grandSonView in subview.subviews){
            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                grandSonView.alpha = 0.0f;
            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
                NSLog(@"Keep textfiedld bkg color");
            }else{
                grandSonView.alpha = 0.0f;
            }
        }//for cacheViews
    }//subviews
    
}

#pragma mark -- <<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchController.active) {
        return 1;
    }
    return _dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchController.active) {
        return _filterData.count;
    }
    if(section == 0){
        return [_dataArray[section] count];
    }
    return [_dataArray[section][@"array"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedMember2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dataDic;
    if (_searchController.active) {
        dataDic = _filterData[indexPath.row];
    }else{
        if (indexPath.section == 0) {
            dataDic = _dataArray[indexPath.section][indexPath.row];
        }else{
            dataDic = _dataArray[indexPath.section][@"array"][indexPath.row];
        }
    }
    cell.dataDic = dataDic;
    [cell.headImageView  sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    cell.statusLabel.text = dataDic[@"gradeName"];
    if ([dataDic[@"role"] isEqualToString:@"OWNER"]) {
        cell.statusLabel.backgroundColor = _colorArray[0];
    }else if ([dataDic[@"role"] isEqualToString:@"ADMIN"]){
        cell.statusLabel.backgroundColor = _colorArray[1];
    }else{
        cell.statusLabel.backgroundColor = _colorArray[2];
    }
    cell.userNameLabel.text = dataDic[@"nameInGroup"];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_searchController.active) {
        return 0;
    }
    return FLEXIBLE_NUM(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_searchController.active) {
        return nil;
    }else{
        UILabel * headerTitleLabel = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 320, 20)];
        headerTitleLabel.textColor = [UIColor grayColor];
        headerTitleLabel.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(10)];
        if (section == 0) {
            headerTitleLabel.text = [NSString stringWithFormat:@"    群主、管理员(%ld人)",[_dataArray[section] count]];
        }else{
            headerTitleLabel.text = [NSString stringWithFormat:@"    %@(%ld人)",_dataArray[section][@"grade"],[_dataArray[section][@"array"] count]];
        }
        return headerTitleLabel;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditUnitedMemberRankViewController * editUnitedVC = [[EditUnitedMemberRankViewController alloc] init];
    editUnitedVC.unitedDic = _unitedDetailDic;
    if (indexPath.section == 0) {
        editUnitedVC.userDic = _dataArray[indexPath.section][indexPath.row];
    }else{
        editUnitedVC.userDic = _dataArray[indexPath.section][@"array"][indexPath.row];
    }
    [self.navigationController pushViewController:editUnitedVC animated:YES];
    
        [self.searchController dismissViewControllerAnimated:YES completion:^{
        self.searchController.searchBar.hidden = NO;
        self.searchController.searchBar.text = @"";
    }];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _memberArray.count; i ++) {
        if ([_memberArray[i][@"nameInGroup"] containsString:searchString]) {
            [resultArray addObject:_memberArray[i]];
        }
    }
    _filterData = resultArray;
    //刷新表格
    [self.tableView reloadData];
}

@end
