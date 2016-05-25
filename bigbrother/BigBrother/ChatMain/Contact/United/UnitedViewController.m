//
//  UnitedViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/10.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedViewController.h"
#import "CreateUnitedViewController.h"
#import "ContactModel.h"
#import "UnitedTableViewCell.h"
#import "UnitedDetailViewController.h"
#import "ChatViewController.h"

@interface UnitedViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UnitedTableViewCellDelegate>

@property (strong, nonatomic) UISearchBar                       * searchBar;
@property (strong, nonatomic) ContactModel                      * contactModel;
@property (strong, nonatomic) UITableView                       * tableView;
@property (strong, nonatomic) NSMutableArray                    * groupArray;
@property (strong, nonatomic) NSArray                           * dataArray;


@property (strong, nonatomic) UISearchController                * searchController;
@property (strong, nonatomic) NSArray                           * filterData;



- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedViewController

static NSString * identify = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"门派";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{
    [_contactModel removeObserver:self forKeyPath:@"allGroupData"];
}

- (void)viewWillAppear:(BOOL)animated
{
        NSDictionary * dataDic = [BBUserDefaults getUserDic];
        [_contactModel getAllGroupsWithUserId:dataDic[@"id"]];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"allGroupData"]) {
        NSArray * dataArray = _contactModel.allGroupData[@"data"];
        _dataArray = dataArray;
        if (!_groupArray) {
            _groupArray = [[NSMutableArray alloc] init];
        }
        [_groupArray removeAllObjects];
        NSMutableArray * managerArray = [[NSMutableArray alloc] init];
        NSMutableArray * joinArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArray.count; i ++) {
            if ([dataArray[i][@"role"] isEqualToString:@"USER"]) {
                [joinArray addObject:dataArray[i]];
            }else{
                [managerArray addObject:dataArray[i]];
            }
        }
        [_groupArray addObject:managerArray];
        [_groupArray addObject:joinArray];
        [_tableView reloadData];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _contactModel = ({
        ContactModel * model = [[ContactModel alloc] init];
        [model addObserver:self forKeyPath:@"allGroupData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
//    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
        //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(50);
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        tableView;
    });
    [_tableView registerClass:[UnitedTableViewCell class] forCellReuseIdentifier:identify];
    
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
    
    //创建门派
    UIBarButtonItem * rightBut = [[UIBarButtonItem alloc] initWithTitle:@"创建门派" style:UIBarButtonItemStyleDone target:self action:@selector(createUnitedButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightBut;
    
}

#pragma mark -- button pressed
- (void)manageButtonOPressed:(UIButton *)sender
{

}

- (void)manageButtonTPressed:(UIButton *)sender
{

}

- (void)createUnitedButtonPressed:(UIButton *)sender
{
    CreateUnitedViewController * createUnitedVC = [[CreateUnitedViewController alloc] init];
    [self.navigationController pushViewController:createUnitedVC animated:YES];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return 1;
    }else{
        return _groupArray.count;;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
       
        NSLog(@"wocaonimab -- %@",_filterData);
        return _filterData.count;
    }else{
        return [_groupArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.delegate = self;
    NSDictionary * dataDic;
    if (self.searchController.active) {
         dataDic = _filterData[indexPath.row];
    }else{
         dataDic = _groupArray[indexPath.section][indexPath.row];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.groupNameLabel.text = dataDic[@"name"];
    cell.dataDic = dataDic;
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataArray.count; i ++) {
        if ([_dataArray[i][@"name"] containsString:searchString]) {
            [resultArray addObject:_dataArray[i]];
        }
    }
    _filterData = resultArray;
    //刷新表格
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return 0;
    }else{
        return FLEXIBLE_NUM(40);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active) {
        UIView * headView = [self createViewWithBackColor:[UIColor clearColor] subView:nil];
        headView.frame = FLEXIBLE_FRAME(0, 0, 320, 40);
        
        UILabel * groupNameLabel = [self createLabelWithText:@"" font:FLEXIBLE_NUM(14) subView:headView];
        if (section == 0) {
            groupNameLabel.text = @"我管理的门派";
        }else{
            groupNameLabel.text = @"我加入的门派";
        }
        groupNameLabel.frame = FLEXIBLE_FRAME(10, 0, 200, 40);
        return headView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedDetailViewController * unitedDeailVC = [[UnitedDetailViewController alloc] init];
     if (!self.searchController.active) {
        unitedDeailVC.unitedDic = _groupArray[indexPath.section][indexPath.row];
        unitedDeailVC.pushMark = indexPath.section;
    }else{
        unitedDeailVC.unitedDic = _filterData[indexPath.row];
        if ([_filterData[indexPath.row][@"role"] isEqualToString:@"USER"]) {
            unitedDeailVC.pushMark = 1;
        }else{
            unitedDeailVC.pushMark = 0;
        }
        self.searchController.searchBar.hidden = YES;
    }

    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[BBUserDefaults getUserDic]];
    NSString *tempRole = unitedDeailVC.pushMark ? @"ADMIN" : @"USER";
    NSString *roleStr = [NSString isBlankStringWithString:unitedDeailVC.unitedDic[@"role"]] ? tempRole : unitedDeailVC.unitedDic[@"role"];
    [tempDic setObject:roleStr forKey:@"role"];
    unitedDeailVC.userDic = tempDic;
   
    [self.navigationController pushViewController:unitedDeailVC animated:YES];
    [self.searchController dismissViewControllerAnimated:YES completion:^{
         self.searchController.searchBar.hidden = NO;
         self.searchController.searchBar.text = @"";
    }];
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

#pragma mark - UnitedTableViewCellDelegate
- (void)unitedTableViewCell:(UnitedTableViewCell *)cell clickedHeadImageView:(UIImageView *)imageView
{
    //    发送消息
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    EMConversation *conversation = [MANAGER_CHAT getConversation:cell.dataDic[@"chatGroupId"] type:EMConversationTypeGroupChat createIfNotExist:YES];
    chatVC.conversation = conversation;
    chatVC.chatDic = cell.dataDic;
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
