//
//  MessageView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MessageView.h"
#import "MessageViewCell.h"
#import "ChatViewController.h"

@interface MessageView ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,EMGroupManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *messageData;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *networkStateView;

@end

@implementation MessageView

- (void)dealloc
{
    [self  unregisterNotifications];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H);
        self.backgroundColor = [UIColor whiteColor];
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)addWithSuperView:(UIView *)superView
{
    [superView addSubview:self];
    [self registerNotifications];
    [self refreshDataSource];
}


- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self unregisterNotifications];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    self.dataSource = [NSMutableArray array];
    
    //刷新数据源
    [self refreshDataSource];
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self networkStateView];
    [self addSubview:self.tableView];
}
#pragma mark - 各种Getter
#pragma mark - 各种Getter
- (UIView *)networkStateView
{
    if (!_networkStateView) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        _networkStateView.backgroundColor = [UIColor redColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    return _networkStateView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds];
        _tableView.rowHeight = FLEXIBLE_NUM(47);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefreshData)];
    }
    return _tableView;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[MessageViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    //获取对话：
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    [cell loadDataWithConversation:conversation];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageViewCell *cell = (MessageViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    chatVC.chatDic = cell.chatterDic;
    if (cell.conversation.type == EMConversationTypeGroupChat) {
        chatVC.chatDic = TESTGROUP_DIC;
    }
    chatVC.conversation = cell.conversation;
    [self.viewController.navigationController pushViewController:chatVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

////当在Cell上滑动时会调用此函数
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//对选中的Cell根据editingStyle进行操作
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        BOOL result = [[EMClient sharedClient].chatManager deleteConversation:converation.conversationId deleteMessages:NO];
        if (result) {
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [BYToastView showToastWithMessage:@"删除失败~"];
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 按钮方法


#pragma mark - 自定义方法


- (void)downRefreshData
{
    [self refreshDataSource];
//    [self.tableView.mj_header endRefreshing];
}

//// 删除不符合的会话对象（空的）
//- (void)removeEmptyConversationsFromDB
//{
//    //#warning --  移除了admin的通知~
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    NSMutableArray *needRemoveConversations;
//    for (EMConversation *conversation in conversations) {
//        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
//            if (!needRemoveConversations) {
//                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
//            }
//            
//            [needRemoveConversations addObject:conversation];
//        }
//    }
//    
//    if (needRemoveConversations && needRemoveConversations.count > 0) {
//        [[EMClient sharedClient].chatManager deleteConversations:conversations deleteMessages:YES];
//    }
//}

//刷新数据源
-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

//获取dataSource
- (NSMutableArray *)loadDataSource
{
    //    BOOL existAdmin = NO;
    NSMutableArray *ret = nil;
    //当前登陆用户的会话对象列表
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    //按时间排序
    NSMutableArray *needRemoveConversations = [NSMutableArray array];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          
                          if (!message1) {
                              [needRemoveConversations removeObject:obj1];
                              [needRemoveConversations addObject:obj1];
                          }
                          if (!message2) {
                              [needRemoveConversations removeObject:obj2];
                              [needRemoveConversations removeObject:obj2];
                          }
                          
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    
    if (needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
        [ret removeObjectsInArray:needRemoveConversations];
    }
    
    return ret;
}

#pragma mark - EMChatManagerDelegate
/*!
 *  收到消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages
{
    [self refreshDataSource];
}

/*!
 *  收到Cmd消息
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    [self refreshDataSource];
}

@end
