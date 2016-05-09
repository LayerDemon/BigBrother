//
//  MessageViewCell.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MessageViewCell.h"

@interface MessageViewCell ()


@property (assign, nonatomic) NSInteger count;

@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;


@end

@implementation MessageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MessageViewCell" owner:self
                                            options:nil] lastObject];
        self.numLabel.layer.cornerRadius = FLEXIBLE_NUM(7);
        self.numLabel.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - 加载数据
#warning --- tempConversation
- (void)testLoadDataWithConversation:(EMConversation *)conversation
{
    
    self.conversation = [MANAGER_CHAT getConversation:@"1000" type:EMConversationTypeChat createIfNotExist:YES];
    [self loadDataWithConversation:conversation];
    self.count = 100;
    self.nameLabel.text = @"测试昵称";
    self.messageLabel.text = @"测试信息~";
    self.timeLabel.text = @"00:00";
}

- (void)loadDataWithConversation:(EMConversation *)conversation
{
    self.conversation = conversation;
    
    self.messageLabel.text = [self subTitleMessageByConversation:conversation];
    self.timeLabel.text = [self lastMessageTimeByConversation:conversation];
    self.count = [self unreadMessageCountByConversation:conversation];
    //群组消息
    if (conversation.type == EMConversationTypeGroupChat) {
        EMMessage *lastMessage = [conversation latestMessage];
        NSMutableDictionary *groupPojo = [NSMutableDictionary dictionaryWithDictionary:lastMessage.ext[@"groupPojo"]];
        [groupPojo setObject:@([groupPojo[@"id"] integerValue]) forKey:@"id"];
        [self refreshGroupChatWithChatterDic:groupPojo];
    }
    //好友消息
    else{
        EMMessage *lastMessage = [conversation latestMessage];
        NSMutableDictionary *chatterDic = [NSMutableDictionary dictionaryWithDictionary:lastMessage.ext[@"userFromPojo"]];
        if (!chatterDic[@"uid"]) {
            [chatterDic setObject:@([chatterDic[@"id"] integerValue]) forKey:@"uid"];
            [chatterDic setObject:@([chatterDic[@"id"] integerValue]) forKey:@"id"];
        }
        if (!chatterDic[@"id"]) {
            [chatterDic setObject:@([chatterDic[@"uid"] integerValue]) forKey:@"id"];
            [chatterDic setObject:@([chatterDic[@"uid"] integerValue]) forKey:@"uid"];
        }
        
        //            NSDictionary *chatterDic = lastMessage.ext[@"userFromPojo"];
        NSString *uid = [BBUserDefaults getUserID];
        if ([chatterDic[@"uid"] integerValue] == [uid integerValue]) {
            chatterDic = [NSMutableDictionary dictionaryWithDictionary:lastMessage.ext[@"userToPojo"]];
            if (!chatterDic[@"uid"]) {
                [chatterDic setObject:@([chatterDic[@"id"] integerValue]) forKey:@"uid"];
                [chatterDic setObject:@([chatterDic[@"id"] integerValue]) forKey:@"id"];
            }
            if (!chatterDic[@"id"]) {
                [chatterDic setObject:@([chatterDic[@"uid"] integerValue]) forKey:@"id"];
                [chatterDic setObject:@([chatterDic[@"uid"] integerValue]) forKey:@"uid"];
            }
        }
        
        [self refreshFriendChatWithChatterDic:chatterDic];
    }
}

//刷新好友消息列
- (void)refreshFriendChatWithChatterDic:(NSDictionary *)chatterDic
{
    self.chatterDic = chatterDic;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:chatterDic[@"avatar"]] placeholderImage:PLACEHOLDERIMAGE_USER];
    if (chatterDic[@"nickname"]) {
        self.nameLabel.text = chatterDic[@"nickname"];
    }else{
        self.nameLabel.text = chatterDic[@"usernameId"];
    }
//    [FRIENDCACHE_MANAGER getFriendDicWithUid:chatterDic[@"uid"] completed:^(id responseObject, NSError *error) {
//        if (!error) {
//            self.chatterDic = [NSDictionary dictionaryWithDictionary:responseObject];
//            if (self.chatterDic[@"remarks"]) {
//                self.nameLabel.text = [NSString stringWithFormat:@"%@",self.chatterDic[@"remarks"]];
//            }
//        }
//    }];
}

//刷新群组消息列
- (void)refreshGroupChatWithChatterDic:(NSDictionary *)chatterDic
{
    self.chatterDic = chatterDic;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:chatterDic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"bfsystemhead"]];
    self.nameLabel.text = chatterDic[@"name"];
    if (self.chatterDic) {
//        [self isJoinGroup];
    }
}

#pragma mark - setter
- (void)setCount:(NSInteger)count
{
    _count = count;
    if (!count) {
        self.numLabel.hidden = YES;
    }
    
    
    NSString *title = [NSString stringWithFormat:@"%ld",(long)count];
    if (count > 99) {
        title = [NSString stringWithFormat:@"99+"];
    }
    
    CGSize size = [NSString sizeWithString:title Font:[UIFont systemFontOfSize:FLEXIBLE_NUM(12)] maxWidth:MAINSCRREN_W NumberOfLines:0];
    CGSize zeroSize = [NSString sizeWithString:@"1" Font:[UIFont systemFontOfSize:FLEXIBLE_NUM(12)] maxWidth:MAINSCRREN_W NumberOfLines:0];
    CGFloat offset = size.width - zeroSize.width;
    self.numLabel.text = title;
    
    self.numLabel.frame = CGRectMake(self.numLabel.frame.origin.x-offset,
                                     self.numLabel.frame.origin.y,
                                     self.numLabel.frame.size.width+offset,
                                     self.numLabel.frame.size.height);
}


#pragma mark - 自定义方法

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    return  ret;
}
// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
//        id<EMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
                if (conversation.type == EMConversationTypeGroupChat) {
                    NSDictionary *lastUserDic = lastMessage.ext[@"userPojo"];
                    NSString *uid = [BBUserDefaults getUserID];
                    if ([lastUserDic[@"id"] integerValue] != [uid integerValue]) {
                        ret = [NSString stringWithFormat:@"%@：%@",lastUserDic[@"nickname"],didReceiveText];
                    }
                }
            
            } break;
            case EMMessageBodyTypeVoice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
                
            } break;
        }
    }
    
    return ret;
}

@end
