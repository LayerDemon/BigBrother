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

@interface UnitedViewController () <UITableViewDelegate,UITableViewDataSource,UnitedTableViewCellDelegate>

@property (strong, nonatomic) UISearchBar                       * searchBar;
@property (strong, nonatomic) ContactModel                      * contactModel;
@property (strong, nonatomic) UITableView                       * tableView;
@property (strong, nonatomic) NSMutableArray                    * groupArray;
@property (strong, nonatomic) NSArray                           * dataArray;


@property (strong, nonatomic) UISearchDisplayController         * searchDisplayController;
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
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
        //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H - 64) style:UITableViewStyleGrouped];
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
    
    //topView
    UIView  * topView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    topView.frame = FLEXIBLE_FRAME(0, 0, 320, 50);
//
//    //搜索按钮
//    UIButton * searchBut = [self createButtonWithTitle:@"  搜索" font:FLEXIBLE_NUM(13) subView:topView];
//    searchBut.frame = FLEXIBLE_FRAME(30, 10, 260, 30);
//    searchBut.backgroundColor = RGBACOLOR(241, 241, 241, 1);
//    searchBut.layer.cornerRadius = FLEXIBLE_NUM(15);
//    searchBut.clipsToBounds = YES;
//    [searchBut setImage:[UIImage imageNamed:@"icon_sous"] forState:UIControlStateNormal];
//    [searchBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:FLEXIBLE_FRAME(0, 8, 320, 34)];
    searchBar.placeholder = @"搜索";
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [topView addSubview:searchBar];
    
    for (UIView *subview in searchBar.subviews) {
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
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = topView;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.searchResultsTableView.rowHeight = FLEXIBLE_NUM(50);
    [_searchDisplayController.searchResultsTableView registerClass:[UnitedTableViewCell class] forCellReuseIdentifier:identify];
    
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
    if (tableView == self.tableView) {
        return _groupArray.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [_groupArray[section] count];
    }else{
        // 谓词搜索
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",_searchDisplayController.searchBar.text];
//        
//        
//        _filterData =  [[NSArray alloc] initWithArray:[_dataArray filteredArrayUsingPredicate:predicate]];
        
        NSMutableArray * resultArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < _dataArray.count; i ++) {
            if ([_dataArray[i][@"name"] containsString:_searchDisplayController.searchBar.text]) {
                [resultArray addObject:_dataArray[i]];
            }
        }
        _filterData = resultArray;
        NSLog(@"wocaonimab -- %@",_filterData);
        return _filterData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.delegate = self;
    NSDictionary * dataDic;
    if (tableView == self.tableView) {
        dataDic = _groupArray[indexPath.section][indexPath.row];
    }else{
        dataDic = _filterData[indexPath.row];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.groupNameLabel.text = dataDic[@"name"];
    cell.dataDic = dataDic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
       return FLEXIBLE_NUM(40);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
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
    if (tableView == self.tableView) {
        unitedDeailVC.unitedDic = _groupArray[indexPath.section][indexPath.row];
        unitedDeailVC.pushMark = indexPath.section;
    }else{
        unitedDeailVC.unitedDic = _filterData[indexPath.row];
        if ([_filterData[indexPath.row][@"role"] isEqualToString:@"USER"]) {
            unitedDeailVC.pushMark = 1;
        }else{
            unitedDeailVC.pushMark = 0;
        }
    }
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[BBUserDefaults getUserDic]];
    NSString *tempRole = unitedDeailVC.pushMark ? @"ADMIN" : @"USER";
    NSString *roleStr = [NSString isBlankStringWithString:unitedDeailVC.unitedDic[@"role"]] ? tempRole : unitedDeailVC.unitedDic[@"role"];
    [tempDic setObject:roleStr forKey:@"role"];
    unitedDeailVC.userDic = tempDic;
   
    [self.navigationController pushViewController:unitedDeailVC animated:YES];
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
