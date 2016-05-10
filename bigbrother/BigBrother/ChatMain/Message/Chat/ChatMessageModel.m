//
//  ChatMessageModel.m
//  BookClub
//
//  Created by 李祖建 on 16/2/29.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "ChatMessageModel.h"

@implementation ChatMessageModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showTime = NO;
    }
    return self;
}

+ (id)messageModelWithMessage:(EMMessage *)message
{
    if (message.chatType == EMChatTypeGroupChat) {
        return [self groupMessageModelWithMessage:message];
    }
    
    return [self friendMessageModelWithMessage:message];
}

+ (id)friendMessageModelWithMessage:(EMMessage *)message
{
    ChatMessageModel *messageModel = [[self alloc] init];
    messageModel.message = message;
    
    NSMutableDictionary *userFromPojo = [NSMutableDictionary dictionaryWithDictionary:message.ext[@"userFromPojo"]];
    if (!userFromPojo[@"uid"]) {
        [userFromPojo setObject:@([userFromPojo[@"id"] integerValue]) forKey:@"uid"];
        [userFromPojo setObject:@([userFromPojo[@"id"] integerValue]) forKey:@"id"];
    }
    if (!userFromPojo[@"id"]) {
        [userFromPojo setObject:@([userFromPojo[@"uid"] integerValue]) forKey:@"id"];
        [userFromPojo setObject:@([userFromPojo[@"uid"] integerValue]) forKey:@"uid"];
    }
    
    NSMutableDictionary *userToPojo = [NSMutableDictionary dictionaryWithDictionary:message.ext[@"userToPojo"]];
    if (!userToPojo[@"uid"]) {
        [userToPojo setObject:@([userToPojo[@"id"] integerValue]) forKey:@"uid"];
        [userToPojo setObject:@([userToPojo[@"id"] integerValue]) forKey:@"id"];
    }
    if (!userToPojo[@"id"]) {
        [userToPojo setObject:@([userToPojo[@"uid"] integerValue]) forKey:@"id"];
        [userToPojo setObject:@([userToPojo[@"uid"] integerValue]) forKey:@"uid"];
    }
//    NSDictionary *userDic = [NSDictionary userDic];
    NSString *uid = [BBUserDefaults getUserID];
    
    EMMessageBody *firstMessageBody = message.body;
    EMTextMessageBody *messageBody = (EMTextMessageBody *)firstMessageBody;
    NSString *textMessage = @"";
    if (firstMessageBody.type == EMMessageBodyTypeText) {
        textMessage = messageBody.text;
    }
    
    if ([uid integerValue] == [userFromPojo[@"uid"] integerValue]) {
        messageModel.userDic = userFromPojo;
        messageModel.otherDic = userToPojo;
        messageModel.text = textMessage;
        messageModel.isFromOther = NO;
    }else{
        messageModel.userDic = userToPojo;
        messageModel.otherDic = userFromPojo;
        messageModel.text = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:textMessage];
        messageModel.isFromOther = YES;
    }
    
    messageModel.time = [NSDate formattedTimeFromTimeInterval:(NSTimeInterval)message.timestamp];
    
    
    [messageModel accessoryWithMessage:message];
    
    return messageModel;
}

+ (id)groupMessageModelWithMessage:(EMMessage *)message
{
    ChatMessageModel *messageModel = [[self alloc] init];
    messageModel.message = message;
    
    messageModel.userDic = @{};
    
    NSMutableDictionary *userPojo = [NSMutableDictionary dictionaryWithDictionary:message.ext[@"userPojo"]];
    if (!userPojo[@"uid"]) {
        [userPojo setObject:@([userPojo[@"id"] integerValue]) forKey:@"uid"];
        [userPojo setObject:@([userPojo[@"id"] integerValue]) forKey:@"id"];
    }
    if (!userPojo[@"id"]) {
        [userPojo setObject:@([userPojo[@"uid"] integerValue]) forKey:@"id"];
        [userPojo setObject:@([userPojo[@"uid"] integerValue]) forKey:@"uid"];
    }

    messageModel.otherDic = userPojo;
    
    
    EMMessageBody *firstMessageBody = message.body;
    EMTextMessageBody *messageBody = (EMTextMessageBody *)firstMessageBody;
    NSString *textMessage = @"";
    if (firstMessageBody.type == EMMessageBodyTypeText) {
        textMessage = messageBody.text;
    }

    if ([message.from isEqualToString:messageModel.userDic[@"imusername"]]) {
        messageModel.isFromOther = NO;
        messageModel.text = textMessage;
    }else{
        messageModel.isFromOther = YES;
        messageModel.text = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:textMessage];
    }
    
    messageModel.time = [NSDate formattedTimeFromTimeInterval:(NSTimeInterval)message.timestamp];
    
    
    [messageModel accessoryWithMessage:message];
    
    return messageModel;
}



//根据消息获取附件
- (void)accessoryWithMessage:(EMMessage *)message
{
    //根据消息体类型，赋值~
    EMMessageBody *tempMessageBody = message.body;
    if (tempMessageBody.type == EMMessageBodyTypeText) {
        tempMessageBody = message.body;
    }

    //示例代码
    self.messageBodyType = tempMessageBody.type;
    
    
    
    switch (self.messageBodyType) {
        case EMMessageBodyTypeText:
            break;
        case EMMessageBodyTypeImage:
        {// 图片：获取缩略图~
            self.imageMessageBody = (EMImageMessageBody *)tempMessageBody;
        }
            break;
        case EMMessageBodyTypeLocation:
        {// 获取地图~
            self.locationMessageBody = (EMLocationMessageBody *)tempMessageBody;
        }
            break;
            
        default:
        {//如果以上都不是~
            self.messageBodyType = EMMessageBodyTypeText;
            self.text = @"[不支持的消息类型]";
        }
            break;
    }
}



@end

