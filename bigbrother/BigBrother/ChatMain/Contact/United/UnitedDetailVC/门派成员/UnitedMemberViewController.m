//
//  UnitedMemberViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedMemberViewController.h"
#import "UnitedMember2TableViewCell.h"

@interface UnitedMemberViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (strong, nonatomic) UITableView       * tableView;
@property (strong, nonatomic) NSArray           * dataArray;
@property (strong, nonatomic) NSArray           * colorArray;

@property (strong, nonatomic) UISearchController                * searchController;
@property (strong, nonatomic) NSArray                           * filterData;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedMemberViewController

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
        self.navigationItem.title = @"门派成员";
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
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
        
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchController.active) {
        return _filterData.count;
    }
    return _memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedMember2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dataDic;
    if (_searchController.active) {
        dataDic = _filterData[indexPath.row];
    }else{
        dataDic = _memberArray[indexPath.row];
    }
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
