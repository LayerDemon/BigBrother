//
//  ViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ViewController.h"
#import "SourceMainViewController.h"
#import "ChatMainViewController.h"
#import "UserMainViewController.h"
#import "EMCDDeviceManager.h"

@interface ViewController () <UITabBarControllerDelegate,EMClientDelegate,EMChatManagerDelegate,EMGroupManagerDelegate,EMContactManagerDelegate>

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

static const CGFloat kDefaultPlaySoundInterval = 3.0;//提示音间隔时间
static NSString *kMessageType = @"MessageType";//
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@implementation ViewController

- (void)dealloc
{
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SourceMainViewController *sourceMainVC = [SourceMainViewController new];
    
    ChatMainViewController *chatMainVC = [ChatMainViewController new];
//    UINavigationController *chatMainNC = [[UINavigationController alloc]initWithRootViewController:chatMainVC];
    
    UserMainViewController *userMainVC = [UserMainViewController new];
    
    NSDictionary *normalTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Tabbar_NormalColor};
    NSDictionary *selectedTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Tabbar_SelectedColor};
    
    sourceMainVC.tabBarItem.title=@"分类";
    sourceMainVC.tabBarItem.image=[UIImage imageNamed:@"foot_icon01"];
    sourceMainVC.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_icon01_on"];
    [sourceMainVC.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [sourceMainVC.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    chatMainVC.tabBarItem.title=@"聊天";
    chatMainVC.tabBarItem.image=[UIImage imageNamed:@"foot_icon02"];
    chatMainVC.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_icon02_on"];
    [chatMainVC.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [chatMainVC.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    userMainVC.tabBarItem.title=@"我";
    userMainVC.tabBarItem.image=[UIImage imageNamed:@"foot_icon03"];
    userMainVC.tabBarItem.selectedImage=[UIImage imageNamed:@"foot_icon03_on"];
    [userMainVC.tabBarItem setTitleTextAttributes:normalTitleTextAttributes forState:UIControlStateNormal];
    [userMainVC.tabBarItem setTitleTextAttributes:selectedTitleTextAttributes forState:UIControlStateSelected];
    
    self.viewControllers = @[sourceMainVC,chatMainVC,userMainVC];
    self.tabBar.tintColor= BB_Tabbar_SelectedColor;
    self.delegate = self;
    self.tabBar.selectedImageTintColor = BB_Tabbar_SelectedColor;
    
    
    //注册环信
    [self registerNotifications];
    //登录环信
    [self loginEaseMob];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.viewControllers.count != 0) {
        [self.selectedViewController viewWillAppear:animated];
    }
    //注册环信
    [self registerNotifications];
    //统计未读消息数
    [self setupUnreadMessageCount];
    
    //    [self judgeToShowWeclome];
}

#pragma mark - 自定义方法
- (void)loginEaseMob
{
//    登录环信
    NSDictionary *userDic = [BBUserDefaults getUserDic];
    EMError *error = [[EMClient sharedClient] loginWithUsername:userDic[@"imNumber"] password:[BBUserDefaults getUserPassword]];
    if (error) {
        [BYToastView showToastWithMessage:@"聊天服务器连接失败~"];
    }else{
        [BYToastView showToastWithMessage:@"聊天服务器连接成功~"];
    }
}

-(void)setupUnreadMessageCount
{
    //当前登陆用户的会话对象列表
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

//判断是否有推送
- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}


#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

#pragma mark - EMChatManagerDelegate
//会话列表发生变化~
- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    //统计未读消息数
    [self setupUnreadMessageCount];
    //刷新message页面
//    [self.messageVC refreshDataSource];
}

//收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        [self didReceiveMessage:message];
    }
}

-(void)didReceiveMessage:(EMMessage *)message
{
    //统计未读消息数
    [self setupUnreadMessageCount];
    
    BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self needShowNotification:message.conversationId] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        //        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        //        if (!isAppActivity) {
        //            [self showNotificationWithMessage:message];
        //        }else {
        //            [self playSoundAndVibration];
        //        }
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}



- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = @"";//[[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.chatType == EMChatTypeGroupChat) {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationId]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                    break;
                }
            }
        }
        notification.alertBody = [NSString stringWithFormat:@"%@:%@",title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    //#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@",notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
//    [self setupUnreadMessageCount];
}

#pragma mark - EMGroupManagerDelegate

- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason
{
    //移除会话~
    [[EMClient sharedClient].chatManager deleteConversation:aGroup.groupId deleteMessages:YES];
    
//    //显示消息
//    NSArray *groupArray = [NSArray arrayWithUserDefaultsKey:@"groupData"];
//    if (groupArray) {
//        if (reason == eGroupLeaveReason_Destroyed) {
//            for (NSDictionary *groupDic in groupArray) {
//                if ([groupDic[@"groupIM"] isEqualToString:group.groupId]) {
//                    [AppDelegate showHintLabelWithMessage:[NSString stringWithFormat:@"[群]%@ 已解散",groupDic[@"name"]]];
//                    break;
//                }
//            }
//        }
//    }
//    //移除缓存(刷新群列表)
//    [self.friendsVC refreshGroupListData:nil];
}

#pragma mark - EMClientDelegate
- (void)didLoginFromOtherDevice
{
    __weak ViewController *weakSelf = self;
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"ok", @"OK"),ACTIONSTYLE_NORMAL];
    [weakSelf showAlertViewWithTitle:TITLE_ALERT message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") buttonTitles:@[buttonTitle]];
}


#pragma mark - 系统弹框处理
- (void)clickedAlertButtonWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    if ([message isEqualToString:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places")]) {
        [BBUserDefaults resetLoginStatus];
    }
}



@end
