//
//  ContactView.m
//  BigBrother
//
//  Created by zhangyi on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "AddUnitedMemberViewController.h"
#import "ContactTableViewCell.h"
#import "ContactModel.h"
#import "NewFriendsViewController.h"
#import "UnitedViewController.h"
#import "FriendDetailViewController.h"

#define SECTION_TAG 2300
@interface AddUnitedMemberViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (strong, nonatomic) UITableView               * tableView;
@property (strong, nonatomic) ContactModel              * contactMoel;
@property (strong, nonatomic) NSArray                   * allFriendsArray;
@property (strong, nonatomic) NSMutableArray            * dataArray;
@property (strong, nonatomic) NSMutableArray            * selectedArray;

@property (strong, nonatomic) NSMutableArray            * dataSource;
@property (strong, nonatomic) UISearchController        * searchController;
@property (strong, nonatomic) NSArray                   * filterData;


@end

@implementation AddUnitedMemberViewController
static NSString * identify = @"Cell";


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"添加成员";
    }
    return self;
}

-(void)viewDidLoad
{
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{
    [_contactMoel removeObserver:self forKeyPath:@"allFriendsData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"allFriendsData"]) {
        _allFriendsArray = _contactMoel.allFriendsData[@"data"];
        if (!_dataSource) {
            _dataSource = [[NSMutableArray alloc] init];
        }
        [_dataSource removeAllObjects];
        //筛选出全部好友
        for (int j = 0; j < _allFriendsArray.count; j ++) {
            [_dataSource addObjectsFromArray:_allFriendsArray[j][@"friends"]];
        }
        
        if (!_dataArray) {
            _dataArray = [[NSMutableArray alloc] init];
        }
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:_contactMoel.allFriendsData[@"data"]];
        
        if (!_selectedArray) {
            _selectedArray = [[NSMutableArray alloc] init];
        }
        [_selectedArray removeAllObjects];
        
        
        for (int i = 0; i < _dataArray.count; i ++) {
            NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] initWithDictionary:_dataArray[i]];
            [dataDic setObject:@[] forKey:@"friends"];
            
            [_dataArray replaceObjectAtIndex:i withObject:dataDic];
            [_selectedArray addObject:@"0"];
        }
        
        [_tableView reloadData];
    }
    
}

#pragma mark -- alterController dismiss
- (void)alertControllerDismissWithAlertController:(UIAlertController *)alertController
{
    [alertController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    NSLog(@"dataDic -- %@",dataDic);
    _contactMoel = ({
        ContactModel * model = [[ContactModel alloc] init];
        [model addObserver:self forKeyPath:@"allFriendsData" options:NSKeyValueObservingOptionNew context:nil];
        [model getAllFriendWithUserId:dataDic[@"id"]];
        model;
    });
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H-64-48) style:UITableViewStylePlain];
        _tableView.rowHeight = FLEXIBLE_NUM(47);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
    [_tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:identify];
    
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = YES;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.obscuresBackgroundDuringPresentation= NO;
    _searchController.searchBar.frame = FLEXIBLE_FRAME(0, 10, 320, 30);
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.tableView.tableHeaderView = _searchController.searchBar;
    
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

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
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
    return [_dataArray[section][@"friends"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    NSDictionary  * dataDic;
    if (_searchController.active) {
        dataDic = _filterData[indexPath.row][@"friend"];
    }else{
        dataDic = _dataArray[indexPath.section][@"friends"][indexPath.row][@"friend"];
    }
    cell.dataDic = dataDic;
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"avatar"]]] placeholderImage:PLACEHOLER_IMA];
    cell.userNameLabel.text = dataDic[@"nickname"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_searchController.active) {
        return 0;
    }
    return  FLEXIBLE_NUM(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_searchController.active) {
        UIButton * headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        headerButton.frame = FLEXIBLE_FRAME(0, 0, 320, 40);
        headerButton.tag = SECTION_TAG + section;
        headerButton.backgroundColor = [UIColor whiteColor];
        [headerButton addTarget:self action:@selector(sectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * headerTitleLabel = [self createLabelWithText:_allFriendsArray[section][@"name"] font:FLEXIBLE_NUM(13) subView:headerButton];
        headerTitleLabel.frame = FLEXIBLE_FRAME(40, 0, 150, 40);
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(15, 13, 14, 14)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([_selectedArray[section] integerValue] == 0) {
            imageView.image = [UIImage imageNamed:@"icon_jt01@3x"];
            UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:headerButton];
            lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
        }else{
            imageView.image = [UIImage imageNamed:@"icon_jt02@3x"];
        }
        [headerButton addSubview:imageView];
        return headerButton;
    }
    return nil;
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataSource.count; i ++) {
        if ([_dataSource[i][@"friend"][@"nickname"] containsString:searchString]) {
            [resultArray addObject:_dataSource[i]];
        }
    }
    _filterData = resultArray;
    //刷新表格
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到用户详情
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    FriendDetailViewController *friendDetailVC = [[FriendDetailViewController alloc]init];
    friendDetailVC.currentUserDic = cell.dataDic;
    [self.navigationController pushViewController:friendDetailVC animated:YES];
}

- (void)sectionButtonPressed:(UIButton *)sender
{
    NSInteger index = sender.tag - SECTION_TAG;
    
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] initWithDictionary:_dataArray[index]];
    if ([_selectedArray[index] integerValue] == 0) {
        [_selectedArray replaceObjectAtIndex:index withObject:@"1"];
        [dataDic setObject:_allFriendsArray[index][@"friends"] forKey:@"friends"];
    }else{
        [_selectedArray replaceObjectAtIndex:index withObject:@"0"];
        [dataDic setObject:@[] forKey:@"friends"];
    }
    [_dataArray replaceObjectAtIndex:index withObject:dataDic];
    [_tableView reloadData];
    
}

#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
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
