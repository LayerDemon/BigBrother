//
//  GuserDetailViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/24.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "GuserDetailViewController.h"
#import "FDHeaderView.h"
#import "FriendDetailViewCell.h"
#import "GUDFooterView.h"
#import "ChatViewController.h"

#import "UnitedInfoModel.h"
#import "FriendModel.h"

@interface GuserDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GUDFooterViewDelegate,FriendDetailViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FDHeaderView *headerView;
@property (strong, nonatomic) GUDFooterView *footerView;

@property (strong, nonatomic) FriendModel *model;
@property (strong, nonatomic) UnitedInfoModel *unitedInfoModel;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSDictionary *guserInfoDic;



@end

@implementation GuserDetailViewController

- (void)dealloc
{
//    [_model removeObserver:self forKeyPath:@"friendInfoData"];
    [_model removeObserver:self forKeyPath:@"addData"];
//    [_model removeObserver:self forKeyPath:@"deleteData"];
    [_model removeObserver:self forKeyPath:@"sectionListData"];
    
    [_unitedInfoModel removeObserver:self forKeyPath:@"guserInfoData"];
    [_unitedInfoModel removeObserver:self forKeyPath:@"setAdminData"];
    [_unitedInfoModel removeObserver:self forKeyPath:@"removeAdminData"];
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
    [self setIndicatorTitle:@"群成员资料"];
    
    if ([self.currentUserDic[@"role"] isEqualToString:@"OWNER"]) {
        self.titleArray = @[@"他的供求信息",@"账号",@"入群时间",@"职务",@"成员头衔"];
    }else{//如果查看的用户不是群主
        if ([self.userDic[@"role"] isEqualToString:@"OWNER"]) {//如果自己是群主
            self.titleArray = @[@"他的供求信息",@"账号",@"入群时间",@"职务",@"成员头衔",@"设置为管理员",@"设置禁言"];
        }
        else if ([self.userDic[@"role"] isEqualToString:@"ADMIN"]){//如果自己是管理员
            if ([self.userDic[@"id"] integerValue] == [self.currentUserDic[@"id"] integerValue] ||
                [self.currentUserDic[@"role"] isEqualToString:@"ADMIN"]) {
                self.titleArray = @[@"他的供求信息",@"账号",@"入群时间",@"职务",@"成员头衔"];
            }else{
                self.titleArray = @[@"他的供求信息",@"账号",@"入群时间",@"职务",@"成员头衔",@"设置禁言"];
            }
        }else{
            self.titleArray = @[@"他的供求信息",@"账号",@"入群时间",@"职务",@"成员头衔"];
        }
    }
    [self.unitedInfoModel postGuserInfoDataWithGroupId:self.groupDic[@"id"] userId:self.currentUserDic[@"id"]];
    [self startTitleIndicator];
    
    [self.model postSectionListDataWithUserId:self.userDic[@"id"]];//获取所有分组
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self.headerView reloadGroupWithDataDic:self.currentUserDic];
    [self.footerView reloadWithCurrentUserDic:self.currentUserDic userDic:self.userDic];
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

- (GUDFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[GUDFooterView alloc]init];
        _footerView.delegate = self;
    }
    return _footerView;
}

- (FriendModel *)model
{
    if (!_model) {
        _model = [[FriendModel alloc]init];
        [_model addObserver:self forKeyPath:@"addData" options:NSKeyValueObservingOptionNew context:nil];
//        [_model addObserver:self forKeyPath:@"deleteData" options:NSKeyValueObservingOptionNew context:nil];
        [_model addObserver:self forKeyPath:@"sectionListData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _model;
}

- (UnitedInfoModel *)unitedInfoModel
{
    if (!_unitedInfoModel) {
        _unitedInfoModel = [[UnitedInfoModel alloc]init];
        [_unitedInfoModel addObserver:self forKeyPath:@"guserInfoData" options:NSKeyValueObservingOptionNew context:nil];
        [_unitedInfoModel addObserver:self forKeyPath:@"setAdminData" options:NSKeyValueObservingOptionNew context:nil];
        [_unitedInfoModel addObserver:self forKeyPath:@"removeAdminData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _unitedInfoModel;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"guserInfoData"]) {
        [self guserInfoDataParse];
    }
    if ([keyPath isEqualToString:@"addData"]) {
        [self addDataParse];
    }
    if ([keyPath isEqualToString:@"sectionListData"]) {
        //        [self sectionListDataParse];
    }
//    if ([keyPath isEqualToString:@"deleteData"]) {
//        [self deleteDataParse];
//    }
    if ([keyPath isEqualToString:@"setAdminData"]) {
        [self editAdminDataParseWithSwitchOn:YES];
    }
    if ([keyPath isEqualToString:@"removeAdminData"]) {
        [self editAdminDataParseWithSwitchOn:NO];
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
        cell.delegate = self;
    }
//    [cell loadWithTitle:self.titleArray[indexPath.section] DataDic:self.currentUserDic];
    [cell reloadGroupWithTitle:self.titleArray[indexPath.section] dataDic:self.guserInfoDic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewCell *cell = [[FriendDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Frame"];
    [cell reloadGroupWithTitle:self.titleArray[indexPath.section] dataDic:self.guserInfoDic];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, FLEXIBLE_NUM(4))];
    lineView.backgroundColor = ARGB_COLOR(242, 242, 242, 1);
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLEXIBLE_NUM(4);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - FriendDetailViewCellDelegate
- (void)friendDetailViewCell:(FriendDetailViewCell *)cell didChangedSwitchValue:(UISwitch *)switchView
{
    [self startTitleIndicator];
    if (switchView.on) {
        [self.unitedInfoModel postSetAdminDataWithOwnerId:self.userDic[@"id"] userIds:[NSString stringWithFormat:@"%@",self.currentUserDic[@"id"]] groupId:self.groupDic[@"id"]];
    }else{
        [self.unitedInfoModel postRemoveAdminDataWithOwnerId:self.userDic[@"id"] adminId:self.currentUserDic[@"id"] groupId:self.groupDic[@"id"]];
    }
}

#pragma mark - GUDFooterViewDelegate
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
//    //删除
//    [sender startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.model postDeleteDataWithUserId:self.userDic[@"id"] friendId:self.currentUserDic[@"id"]];
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



#pragma mark - 按钮方法

#pragma mark - 自定义方法

#pragma mark - 数据处理
//获取到好友信息~
- (void)guserInfoDataParse
{
    [self stopTitleIndicator];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.unitedInfoModel.guserInfoData[@"userInfo"]];
    [tempDic setObject:self.unitedInfoModel.guserInfoData[@"role"] forKey:@"role"];
    self.guserInfoDic = self.unitedInfoModel.guserInfoData;
    self.currentUserDic = tempDic;
    [self.headerView reloadGroupWithDataDic:self.currentUserDic];
    [self.footerView reloadWithCurrentUserDic:self.currentUserDic userDic:self.userDic];
    [self.tableView reloadData];
}

//已发送添加请求
- (void)addDataParse
{
    [self.footerView.addFriendBtn stopAnimationWithTitle:@"已发送申请"];
    self.footerView.addFriendBtn.selected = YES;
    [BYToastView showToastWithMessage:@"已发送好友申请~"];
}

////删除好友结果
//- (void)deleteDataParse
//{
//    [self.footerView.addFriendBtn stopAnimationWithTitle:@"添加好友"];
//    [FRIENDCACHE_MANAGER deleteFriendDic:self.currentUserDic completed:^(id responseObject, NSError *error) {
//        
//    }];
//    [BYToastView showToastWithMessage:@"已删除该好友~"];
//    //刷新好友列表
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMainDataSource" object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}

//编辑管理员结果
- (void)editAdminDataParseWithSwitchOn:(BOOL)swithOn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDataAndReloadDataNotif" object:nil];
    
    [self stopTitleIndicator];
    NSMutableDictionary *tempUserDic = [NSMutableDictionary dictionaryWithDictionary:self.currentUserDic];
    NSMutableDictionary *tempGuserInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.guserInfoDic];
    if (swithOn) {
        [BYToastView showToastWithMessage:@"设置管理员成功~"];
        [tempGuserInfoDic setObject:@"ADMIN" forKey:@"role"];
    }else{
        [BYToastView showToastWithMessage:@"移除管理员成功~"];
        [tempGuserInfoDic setObject:@"USER" forKey:@"role"];
    }
    [tempUserDic setObject:tempGuserInfoDic[@"role"] forKey:@"role"];
    self.guserInfoDic = tempGuserInfoDic;
    self.currentUserDic = tempUserDic;
    [self.headerView reloadGroupWithDataDic:self.currentUserDic];
    [self.footerView reloadWithCurrentUserDic:self.currentUserDic userDic:self.userDic];
    [self.tableView reloadData];
}

@end
