//
//  NewFriendsViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/10.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "NewFriendsViewController.h"

#import "NewFriendsTableViewCell.h"
#import "ContactModel.h"
#import "NewFriendModel.h"

#import "FriendDetailViewController.h"

#define HandleType_GROUP_APPLY @"GROUP_APPLY"
#define HandleType_GROUP_INVITE @"GROUP_INVITE"
#define HandleType_FRIEND_APPLY @"FRIEND_APPLY"


@interface NewFriendsViewController () <UITableViewDelegate,UITableViewDataSource,NewFriendsTableViewCellDelegate>

@property (strong, nonatomic) UITableView   * tableView;


@property (strong, nonatomic) NSArray       * dataArray;
@property (strong, nonatomic) NSDictionary *userDic;
@property (strong, nonatomic) ContactModel  * contactModel;
@property (strong, nonatomic) NewFriendModel *newFriendModel;
@property (strong, nonatomic) NSString *requestType;
@property (strong, nonatomic) NSDictionary *requestDic;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation NewFriendsViewController

static NSString * identify = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"新朋友";
        self.userDic = [BBUserDefaults getUserDic];
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
    [_contactModel removeObserver:self forKeyPath:@"friendsRequestData"];
    [_newFriendModel removeObserver:self forKeyPath:@"agreeData"];
    [_newFriendModel removeObserver:self forKeyPath:@"refuseData"];
}

#pragma mrak -- observe
- (NewFriendModel *)newFriendModel
{
    if (!_newFriendModel) {
        _newFriendModel = [[NewFriendModel alloc]init];
        [_newFriendModel addObserver:self forKeyPath:@"agreeData" options:NSKeyValueObservingOptionNew context:nil];
        [_newFriendModel addObserver:self forKeyPath:@"refuseData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _newFriendModel;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"friendsRequestData"]) {
        _dataArray = _contactModel.friendsRequestData[@"data"];
        [_tableView reloadData];
    }
    if ([keyPath isEqualToString:@"agreeData"]) {
        [self agreeDataParse];
    }
    if ([keyPath isEqualToString:@"refuseData"]) {
        [self refuseDataParse];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
     NSDictionary * dataDic = [BBUserDefaults getUserDic];
    _contactModel = ({
        ContactModel * model = [[ContactModel alloc] init];
        [model addObserver:self forKeyPath:@"friendsRequestData" options:NSKeyValueObservingOptionNew context:nil];
        [model checkAllFriendsRequestListWithUserId:dataDic[@"id"] limit:@"50"];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = BG_COLOR;
    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight = FLEXIBLE_NUM(50);
        [self.view addSubview:tableView];
        tableView;
    });
    
    [_tableView registerClass:[NewFriendsTableViewCell class] forCellReuseIdentifier:identify];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[NewFriendsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell loadWithDataDic:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //跳转到用户详情
    NewFriendsTableViewCell *cell = (NewFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    FriendDetailViewController *friendDetailVC = [[FriendDetailViewController alloc]init];
//    NSDictionary *applyUserDic = @{@"id":cell.dataDic[@"userId"],@"avatar":cell.dataDic[@"avatar"],@"nickname":cell.dataDic[@"nickname"]};
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:cell.dataDic];
    [tempDic setObject:cell.dataDic[@"userId"] forKey:@"id"];
    friendDetailVC.currentUserDic = tempDic;
    [self.navigationController pushViewController:friendDetailVC animated:YES];
}

#pragma mark - NewFriendsTableViewCellDelegate
- (void)newFriendsCell:(NewFriendsTableViewCell *)cell clickedAgreeBtn:(UIButton *)sender
{
    [sender startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.requestDic = cell.dataDic;
    
    self.requestType = self.requestDic[@"requestType"];
    if ([self.requestType isEqualToString:HandleType_FRIEND_APPLY]) {
        [self.newFriendModel postFriendHandleDataWithUserId:self.userDic[@"id"] requestId:self.requestDic[@"id"] action:HandleAction_ACCEPT];
    }
    else if ([self.requestType isEqualToString:HandleType_GROUP_APPLY]){
        [self.newFriendModel postGroupHandleDataWithAdminId:self.userDic[@"id"] userId:self.requestDic[@"userId"] groupId:self.requestDic[@"targetId"] action:HandleAction_ACCEPT];
    }
}

- (void)newFriendsCell:(NewFriendsTableViewCell *)cell clickedRefuseBtn:(UIButton *)sender
{
    [sender startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.requestDic = cell.dataDic;
    self.requestType = self.requestDic[@"requestType"];
    if ([self.requestType isEqualToString:HandleType_FRIEND_APPLY]) {
        [self.newFriendModel postFriendHandleDataWithUserId:self.userDic[@"id"] requestId:self.requestDic[@"id"] action:HandleAction_REJECT];
    }
    else if ([self.requestType isEqualToString:HandleType_GROUP_APPLY]){
        [self.newFriendModel postGroupHandleDataWithAdminId:self.userDic[@"id"] userId:self.requestDic[@"userId"] groupId:self.requestDic[@"targetId"] action:HandleAction_REJECT];
    }
    
}

#pragma mark - 数据处理
- (void)agreeDataParse
{
    [UIButton stopAllButtonAnimationWithErrorMessage:nil];
    [self.contactModel checkAllFriendsRequestListWithUserId:self.userDic[@"id"] limit:@"50"];
    [self.tableView reloadData];
    if ([self.requestType isEqualToString:HandleType_FRIEND_APPLY]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMainDataSource" object:nil];
    }
}

- (void)refuseDataParse
{
    [UIButton stopAllButtonAnimationWithErrorMessage:nil];
    [self.contactModel checkAllFriendsRequestListWithUserId:self.userDic[@"id"] limit:@"50"];
    [self.tableView reloadData];
    if ([self.requestType isEqualToString:HandleType_FRIEND_APPLY]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMainDataSource" object:nil];
    }
}


@end
