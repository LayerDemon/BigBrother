//
//  FriendDetailViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "FDHeaderView.h"
#import "FriendDetailViewCell.h"
#import "FDFooterView.h"
#import "ChatViewController.h"

#import "FriendModel.h"


@interface FriendDetailViewController ()<UITableViewDelegate,UITableViewDataSource,FDFooterViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FDHeaderView *headerView;
@property (strong, nonatomic) FDFooterView *footerView;

@property (strong, nonatomic) FriendModel *model;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSDictionary *userDic;

@end

@implementation FriendDetailViewController

- (void)dealloc
{
    [_model removeObserver:self forKeyPath:@"friendInfoData"];
    [_model removeObserver:self forKeyPath:@"addData"];
    [_model removeObserver:self forKeyPath:@"deleteData"];
    [_model removeObserver:self forKeyPath:@"sectionListData"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDic = [BBUserDefaults getUserDic];
        self.isChatPush = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ARGB_COLOR(242, 242, 242, 1);
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    [self setIndicatorTitle:@"个人资料"];
    self.titleArray = @[@"他的供求信息",@"地区",@"性别",@"个性签名"];
    [self.model postFriendInfoDataWithUid:self.currentUserDic[@"id"]];
    [self startTitleIndicator];
    
    [self.model postSectionListDataWithUserId:self.userDic[@"id"]];//获取所有分组
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self.headerView loadWithDataDic:self.currentUserDic];
    [self.footerView loadWithDataDic:self.currentUserDic];
    [self.view addSubview:self.tableView];
}
#pragma mark - 各种Getter
- (FDHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[FDHeaderView alloc]init];
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
        _tableView.backgroundColor = ARGB_COLOR(242, 242, 242, 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (FDFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[FDFooterView alloc]init];
        _footerView.delegate = self;
    }
    return _footerView;
}

- (FriendModel *)model
{
    if (!_model) {
        _model = [[FriendModel alloc]init];
        [_model addObserver:self forKeyPath:@"friendInfoData" options:NSKeyValueObservingOptionNew context:nil];
        [_model addObserver:self forKeyPath:@"addData" options:NSKeyValueObservingOptionNew context:nil];
        [_model addObserver:self forKeyPath:@"deleteData" options:NSKeyValueObservingOptionNew context:nil];
        [_model addObserver:self forKeyPath:@"sectionListData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"friendInfoData"]) {
        [self friendInfoDataParse];
    }
    if ([keyPath isEqualToString:@"addData"]) {
        [self addDataParse];
    }
    if ([keyPath isEqualToString:@"sectionListData"]) {
//        [self sectionListDataParse];
    }
    if ([keyPath isEqualToString:@"deleteData"]) {
        [self deleteDataParse];
    }
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    FriendDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[FriendDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell loadWithTitle:self.titleArray[indexPath.section] DataDic:self.currentUserDic];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewCell *cell = [[FriendDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Frame"];
    [cell loadWithTitle:self.titleArray[indexPath.section] DataDic:self.currentUserDic];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, FLEXIBLE_NUM(5))];
    lineView.backgroundColor = ARGB_COLOR(242, 242, 242, 1);
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLEXIBLE_NUM(5);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - FDFooterViewDelegate
- (void)clickedAddFriendBtn:(UIButton *)sender
{
    //添加
    NSArray *dataArray = self.model.sectionListData[@"data"];
    if (!dataArray) {
        [BYToastView showToastWithMessage:@"正在获取分组信息，请稍后~"];
        return;
    }
    
//#warning --- 测试
    NSDictionary *testDic = [dataArray firstObject];
    [sender startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.model postAddDataWithUserId:self.userDic[@"id"] friendId:self.currentUserDic[@"id"] message:@"加一下好友呗~" friendsGroupId:testDic[@"id"]];
}

- (void)clickedDeleteFriendBtn:(UIButton *)sender
{
    //删除
    [sender startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.model postDeleteDataWithUserId:self.userDic[@"id"] friendId:self.currentUserDic[@"id"]];
}

- (void)clickedSendMessageBtn:(UIButton *)sender
{
    //发送消息
    if (!self.isChatPush) {
        //    发送消息
        ChatViewController *chatVC = [[ChatViewController alloc]init];
        EMConversation *conversation = [MANAGER_CHAT getConversation:self.currentUserDic[@"imNumber"] type:EMConversationTypeChat createIfNotExist:YES];
        chatVC.conversation = conversation;
        chatVC.chatDic = self.currentUserDic;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 按钮方法jjghgh

#pragma mark - 自定义方法

#pragma mark - 数据处理
//获取到好友信息~
- (void)friendInfoDataParse
{
    [self stopTitleIndicator];
    self.currentUserDic = self.model.friendInfoData[@"data"];
    [self.headerView loadWithDataDic:self.currentUserDic];
    [self.footerView loadWithDataDic:self.currentUserDic];
    [self.tableView reloadData];
}

//已发送添加请求
- (void)addDataParse
{
    [self.footerView.firstBtn stopAnimationWithTitle:@"已发送申请"];
    self.footerView.firstBtn.selected = YES;
    [BYToastView showToastWithMessage:@"已发送好友申请~"];
}

//删除好友结果
- (void)deleteDataParse
{
    [self.footerView.firstBtn stopAnimationWithTitle:@"添加好友"];
    [FRIENDCACHE_MANAGER deleteFriendDic:self.currentUserDic completed:^(id responseObject, NSError *error) {
        
    }];
    [BYToastView showToastWithMessage:@"已删除该好友~"];
    //刷新好友列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMainDataSource" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
