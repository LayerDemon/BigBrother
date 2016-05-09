//
//  ChatViewController.m
//  BookClub
//
//  Created by 李祖建 on 15/12/11.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "ChatViewController.h"
//#import "GMessageModel.h"
//#import "GCellFrameModel.h"
#import "ChatMessageModel.h"
#import "ChatFrameModel.h"

//#import "GroupChatViewCell.h"
#import "ChatViewCell.h"
//#import "GroupDetailViewController.h"
//#import "FriendDetailViewController.h"
//#import "PersonalViewController.h"
#import "ChatToolBarView.h"

//#import "EditMapViewController.h"

#define kToolBarH 48
#define kTextFieldH 30
#define KPageCount 10

#define MESSAGE_REPEAT @"重发该消息？"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PreviewImageViewControllerDelegate,ChatToolBarViewDelegate,EMChatManagerDelegate,ChatViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ChatToolBarView *toolBar;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (strong, nonatomic) NSDictionary *userDic;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) dispatch_queue_t messageQueue;
@property (strong, nonatomic) NSDictionary *keyInfo;

@property (strong, nonatomic) NSNumber *reportTypeId;
@property (strong, nonatomic) NSString *topicReportTypeEnum;
@property (strong, nonatomic) NSString *coseContent;
@property (strong, nonatomic) UIImage *coseImage;
@property (strong, nonatomic) ChatViewCell *longGestureCell;

@property (strong, nonatomic) EMMessage *repeatMessage;

@end

@implementation ChatViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //移除chatDelegate
    [MANAGER_CHAT removeDelegate:self];
    //判断当前会话是否为空，若符合则删除该会话
    EMMessage *message = [self.conversation latestMessage];
    if (message == nil) {
        [MANAGER_CHAT deleteConversation:self.conversation.conversationId deleteMessages:YES];
    }else{
        [self.conversation markAllMessagesAsRead];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
//        self.userDic = [NSDictionary userDic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //从后台恢复到前台监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    //应用退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    
    //定位地图通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLocationMessage:) name:@"sendLocationMessage" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGroupRemarks:) name:@"refreshGroupRemarks" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.conversation markAllMessagesAsRead];
//    [self.conversation markAllMessagesAsRead:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //2.为SDK的ChatManager的delegate
//    [self registerDelegates];
    [MANAGER_CHAT removeDelegate:self];
    [MANAGER_CHAT addDelegate:self delegateQueue:nil];
    
    if (self.conversation.type == EMConversationTypeGroupChat) {
        [self loadGroupNavBarView];
    }else{
        [self loadFriendNavBarView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除chatDelegate
//    [self unregisterDelegates];
    [MANAGER_CHAT removeDelegate:self];
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    
}

//环信注册
//-(void)registerDelegates
//{
//    [self unregisterDelegates];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.picker.delegate = self;
//    self.toolBar.delegate = self;
//}

//-(void)unregisterDelegates
//{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    self.tableView.delegate = nil;
//    self.tableView.dataSource = nil;
//    self.picker.delegate = nil;
//    self.toolBar.delegate = nil;
//}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    self.messages = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    //1.设置所有消息为已读状态
    [self.conversation markAllMessagesAsRead];
//    //2.为SDK的ChatManager的delegate
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//    [[EaseMob sharedInstance].chatManager enableDeliveryNotification];
    //3.初始化message处理线程
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    
    //4.通过会话管理者获取已收发消息
//    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:nil count:KPageCount append:NO];
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgView.image = [UIImage imageNamed:@"bmbg"];
    [self.view addSubview:bgView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    
    
//#warning willEditing判断群组~还是单聊
//    if (self.conversation.conversationType == eConversationTypeGroupChat) {
//        [self loadGroupNavBarView];
//    }else{
//        [self loadFriendNavBarView];
//    }
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

//群组导航栏~
- (void)loadGroupNavBarView
{
    if ([self.chatDic[@"name"] length]) {
        self.navigationItem.title = self.chatDic[@"name"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"书乡%@",self.chatDic[@"usernameId"]];
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0,25,20);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"iconfont_ren-2"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    [GROUPCACHE_MANAGER getGroupDicWithGroupId:self.chatDic[@"id"] completed:^(id responseObject, NSError *error) {
//        if (!error) {
//            NSDictionary *groupDic = responseObject;
//            if (groupDic[@"remarks"]) {
//                self.groupRemarks = groupDic[@"remarks"];
//            }
//        }
//    }];
}

//单聊导航栏
- (void)loadFriendNavBarView
{
    if ([self.chatDic[@"nickname"] length]) {
        self.navigationItem.title = self.chatDic[@"nickname"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"书乡%@",self.chatDic[@"usernameId"]];
    }
    
    if (self.chatDic[@"remarks"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@",self.chatDic[@"remarks"]];
    }
//    [FRIENDCACHE_MANAGER getFriendDicWithUid:self.chatDic[@"uid"] completed:^(id responseObject, NSError *error) {
//        if (!error) {
//            self.chatDic = [NSDictionary dictionaryWithDictionary:responseObject];
//            
//        }
//    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bminfoitem"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
}

//#warning 修改思路~~   看群和单，。。 判断修改不同的地方~。

#pragma mark - 各种Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,MAINSCRREN_W,MAINSCRREN_H-NAVBAR_H-TABBAR_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefreshData)];
        //        [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
        //        [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
        //        [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
        [header setTitle:@"" forState:MJRefreshStateIdle];
        [header setTitle:@"" forState:MJRefreshStatePulling];
        [header setTitle:@"" forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        self.tableView.mj_header = header;
        
        [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    }
    return _tableView;
}

- (ChatToolBarView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[ChatToolBarView alloc]init];
//        _toolBar.textField.delegate = self;
        _toolBar.delegate = self;
    }
    return _toolBar;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ChatViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        //        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        cell.delegate = self;
    }
    
    [cell refreshWithCellFrameModel:self.dataSource[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatFrameModel *cellFrameModel = self.dataSource[indexPath.row];
    return cellFrameModel.cellHeight;
}

#pragma  mark UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage *dataImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self chooseWithImage:dataImage];
        }else{
            PreviewImageViewController *photoDetailViewController = [[PreviewImageViewController alloc]init];
            photoDetailViewController.image = dataImage;
            photoDetailViewController.delegate = self;
        
            [picker pushViewController:photoDetailViewController animated:YES];
        }
        
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - PreviewImageViewControllerDelegate
- (void)clickedCancelBtn:(UIButton *)sender
{
    [self.picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)chooseWithImage:(UIImage *)image
{
    //图片压缩
    NSLog(@"dataImg:%@",NSStringFromCGSize(image.size));
    UIImage *scaleImage = image;
    CGFloat maxWidth = MAINSCRREN_W-FLEXIBLE_NUM(8)*2;
    if (image.size.width > MAINSCRREN_H*2 || image.size.height > MAINSCRREN_H*2) {
        CGFloat scale = image.size.width < image.size.height ? MAINSCRREN_H*2/image.size.width : MAINSCRREN_H*2/image.size.height;
        CGFloat width = image.size.width*scale;
        CGFloat height = image.size.height*scale;
        
        CGFloat imageScale = FLEXIBLE_NUM(127)/height;
        CGFloat imageWidth = width*imageScale;
        
        if (imageWidth > maxWidth) {
            width = maxWidth/imageScale;
        }
        scaleImage = [image imageByScalingAndCroppingForSize:CGSizeMake(width,height)];
    }
    
//#warning -- 发送图片消息
    [self sendImageMessage:scaleImage];
    [self.picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - ChatToolBarViewDelegate  聊天输入栏~~~~~~、
//点击return键
- (void)toolBarShouldReturn:(ChatToolBarView *)toolBar
{
    [self sendBtnPressed:nil];
}

//点击图片
- (void)clickedPicBtn:(UIButton *)sender
{
    NSString *buttonTitle1 = [NSString stringWithFormat:@"相机%@",ACTIONSTYLE_NORMAL];
    NSString *buttonTitle2 = [NSString stringWithFormat:@"相册%@",ACTIONSTYLE_NORMAL];
    NSString *buttonTitle3 = [NSString stringWithFormat:@"取消%@",ACTIONSTYLE_CANCEL];
    [self showActionSheetViewWithTitle:TITLE_ALERT message:nil buttonTitles:@[buttonTitle1,buttonTitle2,buttonTitle3]];
}

- (void)clickedAddrBtn:(UIButton *)sender
{
//    EditMapViewController *editVC = [[EditMapViewController alloc]init];
//    editVC.isSendMessage = YES;
//    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - GroupChatViewCellDelegate
- (void)cell:(ChatViewCell *)cell clickedIconBtn:(UIButton *)sender
{
    //    NSString *chatterName = cell.cellFrame.messageModel.message.from;
    ChatMessageModel *messageModel = cell.cellFrameModel.messageModel;
    NSDictionary *chatterDic = messageModel.isFromOther ? messageModel.otherDic : messageModel.userDic;
    
    if (![chatterDic[@"id"] isEqualToNumber:self.userDic[@"id"]]) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:chatterDic];
        if (!mDic[@"uid"]) {
            [mDic setObject:mDic[@"id"] forKey:@"uid"];
        }
//        PersonalViewController *friendDetailVC = [[PersonalViewController alloc]initWithCurrentUserDic:mDic];
//        friendDetailVC.canPush = (self.conversation.conversationType != eConversationTypeChat);
//        [self.navigationController pushViewController:friendDetailVC animated:YES];
    }
}

//#warning -------- 长按弹出举报选项弹框~
//举报相关
- (void)chatViewCell:(ChatViewCell *)cell longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender
{
    ChatMessageModel *messageModel = cell.cellFrameModel.messageModel;
    NSDictionary *chatterDic = messageModel.isFromOther ? messageModel.otherDic : messageModel.userDic;
    NSString *buttonTitle1 = [NSString stringWithFormat:@"取消%@",ACTIONSTYLE_CANCEL];
    NSString *buttonTitle2 = [NSString stringWithFormat:@"举报%@",ACTIONSTYLE_DESTRUCTIVE];
    NSString *buttonTitle3 = [NSString stringWithFormat:@"添加备忘%@",ACTIONSTYLE_NORMAL];
    NSMutableArray *buttonTitleArray = [NSMutableArray arrayWithArray:@[buttonTitle3,buttonTitle2,buttonTitle1]];
    self.longGestureCell = cell;
    if (![chatterDic[@"id"] isEqualToNumber:self.userDic[@"id"]]) {
        self.coseImage = nil;
        switch (messageModel.messageBodyType) {
            case EMMessageBodyTypeText:
                self.coseContent = messageModel.text;
                break;
            case EMMessageBodyTypeImage:
            {
                self.coseContent = @"";
                self.coseImage = [UIImage imageWithContentsOfFile:messageModel.imageMessageBody.thumbnailLocalPath];
            }
                break;
            case EMMessageBodyTypeLocation:
                self.coseContent = [NSString stringWithFormat:@"latitude:%lf,longtitude:%lf",messageModel.locationMessageBody.latitude,messageModel.locationMessageBody.longitude];
                break;
            default:
                self.coseContent = @"未知消息";
                break;
        }
        self.reportTypeId = chatterDic[@"id"];
//        self.topicReportTypeEnum = messageModel.message.chatType == EMChatTypeGroupChat ? topicReportTypeEnum_GROUP : topicReportTypeEnum_PERSONAGE;
        //弹出举报框
//        if (messageModel.message.messageType == eMessageTypeGroupChat) {
//            [buttonTitleArray removeObject:buttonTitle3];
//        }
        
    }else{
        if (messageModel.message.chatType == EMChatTypeGroupChat) {
            return;
        }
        [buttonTitleArray removeObject:buttonTitle2];
    }
    [self showActionSheetViewWithTitle:TITLE_ALERT message:nil buttonTitles:buttonTitleArray];
    
}

//重发消息
- (void)chatViewCell:(ChatViewCell *)cell clickedSendStateBtn:(UIButton *)sender
{
    self.repeatMessage = cell.cellFrameModel.messageModel.message;
    NSString *buttonTitle1 = [NSString stringWithFormat:@"取消%@",ACTIONSTYLE_CANCEL];
    NSString *buttonTitle2 = [NSString stringWithFormat:@"重发%@",ACTIONSTYLE_NORMAL];
    [self showAlertViewWithTitle:nil message:MESSAGE_REPEAT buttonTitles:@[buttonTitle1,buttonTitle2]];
}

#pragma mark - 按钮方法
- (void)endEdit
{
    self.toolBar.emojiBtn.selected = NO;
//    self.toolBar.textField.inputView = nil;
    self.toolBar.textView.inputView = nil;
    [self.view endEditing:YES];
}

- (void)rightItemPressed:(UIBarButtonItem *)sender
{
    if (self.conversation.type == EMConversationTypeGroupChat) {
        //跳转到群详情
//        GroupDetailViewController *groupDetailVC = [[GroupDetailViewController alloc]init];
//        groupDetailVC.detailData = self.chatDic;
//        //    groupDetailVC.coordinate = CLLocationCoordinate2DMake([self.userDic[@"latitude"] floatValue], [self.userDic[@"longitude"] floatValue]);
//        groupDetailVC.coordinate = LOCATION.coordinate;
//        groupDetailVC.canPush = NO;
//        [self.navigationController pushViewController:groupDetailVC animated:YES];
    }else{
        //跳转到用户详情
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:self.chatDic];
        if (!mDic[@"uid"]) {
            [mDic setObject:@([mDic[@"id"] integerValue]) forKey:@"uid"];
        }
//        PersonalViewController *friendDetailVC = [[PersonalViewController alloc]initWithCurrentUserDic:mDic];
//        friendDetailVC.canPush = NO;
//        [self.navigationController pushViewController:friendDetailVC animated:YES];
    }
}

- (void)sendBtnPressed:(UIButton *)sender
{
    //发送消息
    UITextView *textField = (UITextView *)[self.toolBar viewWithTag:TEXTFIELD_TAG+10];
    if (textField.text.length) {
        if (textField.text.length > 3000) {
            [self.view endEditing:YES];
            [AppDelegate showHintLabelWithMessage:@"发送消息内容超长，请分条发送~"];
            return;
        }
        
        [self sendTextMessage:textField.text];
    }else{
        [self showAlertControlWithMessage:@"消息不能为空"];
    }
    textField.text = @"";
}

#pragma mark - 自定义方法

//通过会话管理者获取已收发消息
- (void)loadMoreMessagesFrom:(EMMessage *)lastMessage count:(NSInteger)count append:(BOOL)append
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        /*!
         @method
         @brief 根据时间加载指定条数的消息
         @param aCount 要加载的消息条数
         @param timestamp 时间点, UTC时间, 以毫秒为单位
         @discussion
         1. 加载后的消息按照升序排列;
         2. NSDate返回的timeInterval是以毫秒为单位的, 如果使用NSDate, 比如 timeIntervalSince1970 方法，需要将 timeInterval 乘以1000
         @result 加载的消息列表
         */
//        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:count before:timestamp];
        NSArray *messages = [weakSelf.conversation loadMoreMessagesFromId:lastMessage.messageId limit:(int)count];
        //        if (messages.count < count) {
        //
        //        }
        
        if ([messages count] > 0) {
            NSInteger currentCount = 0;
            if (append)//添加
            {
                NSArray *appendArray = [weakSelf formatMessages:messages];
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                currentCount = [weakSelf.dataSource count];
                [weakSelf.dataSource insertObjects:appendArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                
            }
            else
            {
                weakSelf.messages = [messages mutableCopy];
                weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            }
            //            NSInteger currentCount = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            });
            //            //发送消息已读回执
            //            NSMutableArray *unreadMessages = [NSMutableArray array];
            //            for (NSInteger i = 0; i < [messages count]; i++)
            //            {
            //                EMMessage *message = messages[i];
            //                if ([self shouldAckMessage:message read:NO])
            //                {
            //                    [unreadMessages addObject:message];
            //                }
            //            }
            //            if ([unreadMessages count])
            //            {
            //                [self sendHasReadResponseForMessages:unreadMessages];
            //            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    });
}

//处理数据messages
- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    //    self.dataSource =[NSMutableArray array];
    //    [self.dataSource removeAllObjects];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSource];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            //            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            ChatMessageModel *messageModle = [ChatMessageModel messageModelWithMessage:message];
            ChatFrameModel *lastFrame = [tempArray lastObject];
            ChatFrameModel *cellFrame = [[ChatFrameModel alloc] init];
//            NSLog(@"%lld-%lld = %lld",messageModle.message.timestamp,lastFrame.messageModel.message.timestamp,messageModle.message.timestamp-lastFrame.messageModel.message.timestamp);
//            messageModle.showTime = ![messageModle.time isEqualToString:lastFrame.messageModel.time];
            messageModle.showTime = (messageModle.message.timestamp-lastFrame.messageModel.message.timestamp)/1000.0 > 120;
            cellFrame.messageModel = messageModle;
            [tempArray addObject:cellFrame];
            [formatArray addObject:cellFrame];
        }
    }
    
    return formatArray;
}

-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    //    NSArray *messages = [self formatMessages:@[message]];
    //    [self.dataSource addObjectsFromArray:messages];
    //    [self.chatView reloadData];
    //    [self scrollToBottom];
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessages:@[message]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
//            [self.tableView beginUpdates];
//            NSInteger row = self.dataSource.count-1 > 0 ? self.dataSource.count-1 : 0;
//            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView endUpdates];

            [weakSelf scrollToBottom];
            if (weakSelf.keyInfo) {
                [weakSelf keyAnimationWithKeyInfo:weakSelf.keyInfo];
            }
            message.isRead = YES;
        });
    });
}

- (void)removeMessage:(EMMessage *)message
{
    [self.conversation deleteMessageWithId:message.messageId];
    [_messages removeObject:message];
    ChatFrameModel *removeModel;
    for (ChatFrameModel *model in self.dataSource) {
        if ([model.messageModel.message.messageId isEqualToString:message.messageId]) {
            removeModel = model;
            break;
        }
    }
    [self.dataSource removeObject:removeModel];
    [self.tableView reloadData];
    
    [self scrollToBottom];
    if (self.keyInfo) {
        [self keyAnimationWithKeyInfo:self.keyInfo];
    }
}

- (void)scrollToBottom
{
//    if (self.dataSource.count) {
////        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
////        [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        CGFloat contentOffsetY = self.tableView.contentSize.height-self.tableView.frame.size.height;
////        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x,contentOffsetY) animated:YES];
//        if (contentOffsetY > 0) {
//            [UIView animateWithDuration:0.4 animations:^{
//                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,contentOffsetY);
//            }];
//        }
//        
//    }
    CGFloat contentOffsetY = self.tableView.contentSize.height-self.tableView.frame.size.height;
    //        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x,contentOffsetY) animated:YES];
    if (contentOffsetY > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,contentOffsetY);
        }];
    }
}

- (void)downRefreshData
{    EMMessage *firstMessage = [self.messages firstObject];
    if (firstMessage)
    {
        [self loadMoreMessagesFrom:firstMessage count:KPageCount append:YES];
    }
}


#pragma mark - 通知方法
/**
 *  键盘发生改变执行
 */
- (void)keyboardWillChange:(NSNotification *)note
{
    //    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    self.keyInfo = userInfo;
    [self keyAnimationWithKeyInfo:self.keyInfo];
}

- (void)keyAnimationWithKeyInfo:(NSDictionary *)keyInfo
{
    NSDictionary *userInfo = keyInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat toolMoveY = keyFrame.origin.y - self.toolBar.frame.size.height-NAVBAR_H;
    CGFloat tableMoveY = 0;
    if (keyFrame.origin.y < self.tableView.contentSize.height+NAVBAR_H) {
        if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
            tableMoveY = toolMoveY - self.tableView.frame.size.height;
        }else{
            tableMoveY = toolMoveY - self.tableView.contentSize.height;
        }
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self.toolBar setOriginY:toolMoveY];
        [self.tableView setOriginY:tableMoveY];
    }];
}

//从后台恢复到前台监听
- (void)didBecomeActive
{
    [self reloadData];
}

- (void)reloadData{
    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.tableView reloadData];
}
//刷新单条消息~（用于带附件的消息）
- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.conversationId isEqualToString:message.conversationId])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[ChatFrameModel class]]) {
                    ChatFrameModel *frameModel = (ChatFrameModel *)object;
                    if ([message.messageId isEqualToString:frameModel.messageModel.message.messageId]) {
                        
                        ChatMessageModel *messageModle = [ChatMessageModel messageModelWithMessage:message];
                        NSInteger lastIndex = i-1;
                        if (i == 0) {
                            lastIndex = 0;
                        }
                        ChatFrameModel *lastFrame = [weakSelf.dataSource objectAtIndex:lastIndex];
                        ChatFrameModel *cellFrame = [[ChatFrameModel alloc] init];
                        messageModle.showTime = ![messageModle.time isEqualToString:lastFrame.messageModel.time];
                        cellFrame.messageModel = messageModle;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellFrame];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
//                            [weakSelf scrollToBottom];
                        });
                        break;
                    }
                }
            }
        }
    });
}

- (void)applicationDidEnterBackground
{
    // 设置当前conversation的所有message为已读
    [self.conversation markAllMessagesAsRead];
}

//- (void)refreshGroupRemarks:(NSNotification *)notif
//{
//    if (notif.object) {
//        self.groupRemarks = notif.object;
//    }
//}



#pragma mark - IChatManagerDelegate
//- (void)didReceiveHasDeliveredResponse:(EMReceipt *)resp
//{
//    NSLog(@"------");
//    
//}

/*!
 @method
 @brief 发送消息后的回调
 @discussion
 @param message      已发送的消息对象
 @param error        错误信息
 @result
 */
-(void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    if (error) {
        NSLog(@"%@",error);
    }
    __weak ChatViewController *weakSelf = self;
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[ChatFrameModel class]])
         {
             ChatFrameModel *frameModel = (ChatFrameModel *)obj;
             if ([frameModel.messageModel.message.messageId isEqualToString:message.messageId])
             {
                 frameModel.messageModel.message.status = message.status;//设置该条消息状态
//                 [frameModel.messageModel.message updateMessageDeliveryStateToDB];
                 [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                 *stop = YES;
             }
         }
     }];
}

/*!
 @method
 @brief 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
 针对有附件的消息, 此时附件还未被下载.
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:,
 下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */
-(void)didReceiveMessage:(EMMessage *)message
{
    
    if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
        [self addMessage:message];
        [self.conversation markMessageAsReadWithId:message.messageId];
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    if ([_conversation.conversationId isEqualToString:message.conversationId]) {
        [AppDelegate showHintLabelWithMessage:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    }
}

//附件下载完成后~
- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error
{
    if (!error) {
        [self reloadTableViewDataWithMessage:message];
    }else{
        [AppDelegate showHintLabelWithMessage:@"附件加载失败~"];
    }
}

/*!
 @method
 @brief 收到发送消错误的回调
 @param messageId           消息Id
 @param conversationChatter 会话的username/groupId
 @param error               错误信息
 */
- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error
{
    if (error && [_conversation.conversationId isEqualToString:conversationChatter]) {
        //        [self showAlertControlWithMessage:@"消息发送错误"];
        [AppDelegate showHintLabelWithMessage:@"消息发送错误~"];
    }
}

/*!
 @method
 @brief 接收到离线非透传消息的回调
 @discussion
 @param offlineMessages 接收到的离线列表
 @result
 */
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if (![offlineMessages count])
    {
        return;
    }
    [_conversation markAllMessagesAsRead];
//    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:nil count:[self.messages count] + [offlineMessages count] append:NO];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [self showAlertControlWithMessage:@"另一设备登录"];
}





#pragma mark - 发送消息~

-(void)sendTextMessage:(NSString *)textMessage
{

    EMChatType messageType = (self.conversation.type == EMConversationTypeGroupChat ? EMChatTypeGroupChat : EMChatTypeChat);
    
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:self.conversation.conversationId
                                                           messageType:messageType
                                                     requireEncryption:NO
                                                                   ext:[self messageExtWithConversation:self.conversation]];
    [self addMessage:tempMessage];
}

- (void)sendImageMessage:(UIImage *)imageMessage
{
    EMChatType messageType = (self.conversation.type == EMConversationTypeGroupChat ? EMChatTypeGroupChat : EMChatTypeChat);
    
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:imageMessage
                                                            toUsername:self.conversation.conversationId
                                                           messageType:messageType
                                                     requireEncryption:NO
                                                                   ext:[self messageExtWithConversation:self.conversation]];
    

    [self addMessage:tempMessage];
}

- (void)sendLocationMessage:(NSNotification *)notif
{
    NSDictionary *dic = notif.object;
    CGFloat latitude = [dic[@"latitude"] floatValue];
    CGFloat longitude = [dic[@"longitude"] floatValue];
    NSString *address = dic[@"description"];
    
//    self.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.chatDic[@"imusername"] conversationType:self.conversation.conversationType];
    
    EMChatType messageType = (self.conversation.type == EMConversationTypeGroupChat ? EMChatTypeGroupChat : EMChatTypeChat);
    EMMessage *tempMessage = [ChatSendHelper sendLocationLatitude:latitude
                                                        longitude:longitude
                                                          address:address
                                                       toUsername:self.conversation.conversationId
                                                      messageType:messageType
                                                requireEncryption:NO
                                                              ext:[self messageExtWithConversation:self.conversation]];
    
    [self addMessage:tempMessage];
}

- (NSDictionary *)messageExtWithConversation:(EMConversation *)conversation
{
    if (self.conversation.type == EMConversationTypeGroupChat) {
//        NSDictionary *loginInfo = [NSDictionary dictionaryWithUserDefaultsKey:@"loginInfo"];
//        NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:self.userDic];
//        [userDic setObject:loginInfo[@"imusername"] forKey:@"imusername"];
//        if (!userDic[@"nickname"]) {
//            [userDic setObject:userDic[@"usernameId"] forKey:@"nickname"];
//        }
//        if (self.groupRemarks.length) {
//            [userDic setObject:self.groupRemarks forKey:@"nickname"];
//        }
        NSDictionary *ext = @{@"groupPojo":self.chatDic,@"userPojo":@{}};
        return ext;
    }
    NSDictionary *ext = @{@"userFromPojo":@{},@"userToPojo":self.chatDic};
    return ext;
}





#pragma mark - 系统弹框处理
- (void)clickedAlertButtonWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    if (!message) {
        if ([buttonTitle isEqualToString:@"相机"]) {
            [self takePhone];
        }
        if ([buttonTitle isEqualToString:@"相册"]) {
            [self localPhone];
        }
        if ([buttonTitle isEqualToString:@"举报"]) {
//            [CONTENTREPORT_MANAGER showReportAlertWithTypeId:self.reportTypeId topicReportTypeEnum:self.topicReportTypeEnum otherContent:self.coseContent coseImage:self.coseImage];
        }
//        if ([buttonTitle isEqualToString:@"添加备忘"]) {
//            //设置备忘
//            NSString *url = [NSString stringWithFormat:@"/v2/memorandum"];
////            NSDictionary * self.longGestureCell.cellFrameModel.messageModel.otherDic
//            ChatMessageModel *messageModel = self.longGestureCell.cellFrameModel.messageModel;
//            NSDictionary *otherDic = messageModel.otherDic;
//            
//            NSString *content = [NSString stringWithFormat:@"\n\n%@ %@\n%@",otherDic[@"nickname"],messageModel.time,messageModel.text];
//            if (!messageModel.isFromOther) {
//                content = [NSString stringWithFormat:@"\n\n我 %@\n%@",messageModel.time,messageModel.text];
//            }
//            
//            NSDictionary *params = @{@"uid":self.userDic[@"uid"],
//                                     @"memorandumUid":otherDic[@"uid"],
//                                     @"content":content,
//                                     @"requestMethodEnum":@"POST",
//                                     @"token":[NSString  tokenString]};
//            
//            [NetworkingManager postWithURL:url params:params successAction:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                [AppDelegate showHintLabelWithMessage:@"添加备忘成功~"];
//                
//            } failAction:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//            }];
//        }
    }
    if ([message isEqualToString:MESSAGE_REPEAT]) {
        if ([buttonTitle isEqualToString:@"重发"]) {
            [self repeatMessage:self.repeatMessage];
            
        }
    }
    
}
//打开相机
-(void)takePhone
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied)
    {
        [self showAlertControlWithMessage:MESSAGE_NOTOPENCAERA];
        return;
    }
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//        
//        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
//        
//    }
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        
        _picker.allowsEditing = NO;
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:^{
            
        }];
    }
    else{
        [AppDelegate showHintLabelWithMessage:@"据说相机无法正常使用~"];
    }
}
//打开相册
-(void)localPhone
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    [self presentViewController:_picker animated:YES completion:^{
        
    }];
}

//重发消息
- (void)repeatMessage:(EMMessage *)message
{
    [self removeMessage:message];
    [MANAGER_CHAT
     asyncSendMessage:message
     progress:nil
     completion:nil];
    
    [self addMessage:message];
}

#pragma mark - 系统弹框处理
//- (void)clickedAlertButtonWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle
//{
//    if (!message) {
//        if ([buttonTitle isEqualToString:@"举报"]) {
//            
//        }
//    }
//}

@end
