
//
//  GroupInviteViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "GroupInviteViewController.h"
#import "GISectionHeaderView.h"
#import "GroupInviteViewCell.h"
#import "ContactModel.h"
#import "UnitedInfoModel.h"

@interface GroupInviteViewController ()<UITableViewDelegate,UITableViewDataSource,GISectionHeaderViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) ContactModel *contactMoel;
@property (strong, nonatomic) UnitedInfoModel *unitedInfoModel;
@property (strong, nonatomic) NSDictionary *userDic;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSMutableArray *chooseArray;

@end

@implementation GroupInviteViewController

- (void)dealloc
{
    [_contactMoel removeObserver:self forKeyPath:@"allFriendsData"];
    [_unitedInfoModel removeObserver:self forKeyPath:@"inviteData"];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNavBarView];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    self.listArray = [NSMutableArray array];
    self.chooseArray = [NSMutableArray array];
    [self startTitleIndicator];
    [self.contactMoel getAllFriendWithUserId:self.userDic[@"id"]];
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self.view addSubview:self.tableView];
}

- (void)loadNavBarView
{
    NSString *titleStr = [NSString stringWithFormat:@"添加成员(%@)",@(self.chooseArray.count)];
    [self setIndicatorTitle:titleStr];
    if (self.chooseArray.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    }
}

#pragma mark - 各种Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W,MAINSCRREN_H-NAVBAR_H-TABBAR_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = FLEXIBLE_NUM(50);
        _tableView.editing = YES;
    }
    return _tableView;
}

- (ContactModel *)contactMoel
{
    if (!_contactMoel) {
        _contactMoel = [[ContactModel alloc]init];
        [_contactMoel addObserver:self forKeyPath:@"allFriendsData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _contactMoel;
}

- (UnitedInfoModel *)unitedInfoModel
{
    if (!_unitedInfoModel) {
        _unitedInfoModel = [[UnitedInfoModel alloc]init];
        [_unitedInfoModel addObserver:self forKeyPath:@"inviteData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _unitedInfoModel;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"allFriendsData"]) {
        [self allFriendsDataParse];
    }
    if ([keyPath isEqualToString:@"inviteData"]) {
        [self inviteDataParse];
    }
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *friendsDic = self.listArray[section];
    if ([friendsDic[@"stateValue"] integerValue]) {
        NSArray *friednsList = friendsDic[@"friends"];
        return friednsList.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    GroupInviteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[GroupInviteViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    
    NSDictionary *friendsDic = self.listArray[indexPath.section];
    NSArray *friednsList = friendsDic[@"friends"];
    NSDictionary *dataDic = friednsList[indexPath.row];
    
    [cell reloadWithDataDic:dataDic];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GISectionHeaderView *headerView = [[GISectionHeaderView alloc]init];
    headerView.delegate = self;
    [headerView reloadWithDataDic:self.listArray[section]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLEXIBLE_NUM(36);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInviteViewCell *cell = (GroupInviteViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.chooseArray addObject:cell.dataDic];
    [self loadNavBarView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInviteViewCell *cell = (GroupInviteViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.chooseArray removeObject:cell.dataDic];
    [self loadNavBarView];
}

#pragma mark - GISectionHeaderViewDelegate
- (void)clickedSectionHeaderView:(GISectionHeaderView *)headerView
{
    NSInteger index = [self.listArray indexOfObject:headerView.dataDic];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:headerView.dataDic];
    BOOL stateValue = !(![tempDic[@"stateValue"] integerValue]);
    if (index != NSNotFound) {
        [tempDic setObject:@(!stateValue) forKey:@"stateValue"];
    }
    [self.listArray replaceObjectAtIndex:index withObject:tempDic];

//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

#pragma mark - 按钮方法
- (void)rightItemPressed:(UIBarButtonItem *)sender
{
    if (self.chooseArray.count) {
        [self startTitleIndicator];
    }
    //发送提交链接~
    for (NSDictionary *friendDic in self.chooseArray) {
        [self.unitedInfoModel getInviteDataWithUserToInviteId:friendDic[@"id"] userId:self.userDic[@"id"] groupId:self.groupDic[@"id"]];
    }
}

#pragma mark - 自定义方法

#pragma mark - 数据处理
- (void)allFriendsDataParse
{
    [self stopTitleIndicator];
    self.listArray = [NSMutableArray arrayWithArray:self.contactMoel.allFriendsData[@"data"]];
    [self.tableView reloadData];
}

- (void)inviteDataParse
{
    for (NSInteger i = 0 ; i < self.chooseArray.count;i++) {
        [self.chooseArray removeObjectAtIndex:0];
    }
    if (!self.chooseArray.count) {
        [self loadNavBarView];
        [self stopTitleIndicator];
        [self.tableView reloadData];
        [BYToastView showToastWithMessage:@"邀请成功~"];
    }
}

@end
