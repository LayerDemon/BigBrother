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
    ChatMessageModel *messageModel = [[self alloc] init];
    messageModel.message = message;
    messageModel.isMediaPlaying = NO;
    if (message.chatType == EMChatTypeGroupChat) {
        [messageModel groupMessageModelWithMessage:message];
    }else{
        [messageModel friendMessageModelWithMessage:message];
    }
    
    return messageModel;
}

- (void)friendMessageModelWithMessage:(EMMessage *)message
{
//    ChatMessageModel *messageModel = [[self alloc] init];
//    self.message = message;
//    self.isMediaPlaying = NO;
    
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

    NSString *uid = [BBUserDefaults getUserID];
    
    EMMessageBody *firstMessageBody = message.body;
    EMTextMessageBody *messageBody = (EMTextMessageBody *)firstMessageBody;
    NSString *textMessage = @"";
    if (firstMessageBody.type == EMMessageBodyTypeText) {
        textMessage = messageBody.text;
    }
    
    if ([uid integerValue] == [userFromPojo[@"uid"] integerValue]) {
        self.userDic = userFromPojo;
        self.otherDic = userToPojo;
//        messageModel.text = textMessage;
        self.isFromOther = NO;
    }else{
        self.userDic = userToPojo;
        self.otherDic = userFromPojo;
//        messageModel.text = textMessage;
        //[EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:textMessage];
        self.isFromOther = YES;
    }
    
    self.time = [NSDate formattedTimeFromTimeInterval:(NSTimeInterval)message.timestamp];
    
    [self contentWithMessage:message];
    
//    [messageModel accessoryWithMessage:message];
    
//    return messageModel;
}

- (void)groupMessageModelWithMessage:(EMMessage *)message
{
    NSMutableDictionary *userPojo = [NSMutableDictionary dictionaryWithDictionary:message.ext[@"userPojo"]];
    if (!userPojo[@"uid"]) {
        [userPojo setObject:@([userPojo[@"id"] integerValue]) forKey:@"uid"];
        [userPojo setObject:@([userPojo[@"id"] integerValue]) forKey:@"id"];
    }
    if (!userPojo[@"id"]) {
        [userPojo setObject:@([userPojo[@"uid"] integerValue]) forKey:@"id"];
        [userPojo setObject:@([userPojo[@"uid"] integerValue]) forKey:@"uid"];
    }

    self.userDic = [BBUserDefaults getUserDic];
    self.otherDic = userPojo;

    if ([message.from isEqualToString:self.userDic[@"imNumber"]]) {
        self.isFromOther = NO;
    }else{
        self.isFromOther = YES;
    }
    
    self.time = [NSDate formattedTimeFromTimeInterval:(NSTimeInterval)message.timestamp];
    
    [self contentWithMessage:message];
}


- (void)contentWithMessage:(EMMessage *)message
{
    EMMessageBody *tempMessageBody = message.body;
    self.messageBody = tempMessageBody;
    self.messageBodyType = tempMessageBody.type;
    
    
    if (self.messageBodyType == EMMessageBodyTypeText) {
        self.text = ((EMTextMessageBody *)tempMessageBody).text;
    }
    else if (self.messageBodyType == EMMessageBodyTypeVoice) {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)tempMessageBody;
//        self.voiceMessageBody = voiceBody;
        self.mediaDuration = voiceBody.duration;
        self.isMediaPlayed = NO;
        if (message.ext) {
            self.isMediaPlayed = [[message.ext objectForKey:@"isPlayed"] boolValue];
        }
        // 音频路径
        self.fileLocalPath = voiceBody.localPath;
        self.fileURLPath = voiceBody.remotePath;
    }

    
    NSDictionary *ext = message.ext;
    NSInteger resultValue = [ext[@"resultValue"] integerValue];
    if (resultValue > 0) {
        if (resultValue > 3) {
            self.messageBodyType = EMMessageBodyTypeText;
            self.text = @"[不支持的消息类型]";
        }
        else{
            self.messageBodyType = EMMessageBodyTypeCustom;
            self.messageExt = message.ext;
        }
    }
    
    
    if (self.messageBodyType != EMMessageBodyTypeText &&
        self.messageBodyType != EMMessageBodyTypeVoice &&
        self.messageBodyType != EMMessageBodyTypeCustom) {
        self.messageBodyType = EMMessageBodyTypeText;
        self.text = @"[不支持的消息类型]";
    }
}


////根据消息获取附件
//- (void)accessoryWithMessage:(EMMessage *)message
//{
//    //根据消息体类型，赋值~
//    EMMessageBody *tempMessageBody = message.body;
//    if (tempMessageBody.type == EMMessageBodyTypeText) {
//        tempMessageBody = message.body;
//    }
//
//    //示例代码
//    self.messageBodyType = tempMessageBody.type;
//    
//    
//    
//    switch (self.messageBodyType) {
//        case EMMessageBodyTypeText:
//            break;
//        case EMMessageBodyTypeVoice:
//        {// 图片：获取缩略图~
//            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)tempMessageBody;
//            self.voiceMessageBody = voiceBody;
//            self.mediaDuration = voiceBody.duration;
//            self.isMediaPlayed = NO;
//            if (message.ext) {
//                self.isMediaPlayed = [[message.ext objectForKey:@"isPlayed"] boolValue];
//            }
//            // 音频路径
//            self.fileLocalPath = voiceBody.localPath;
//            self.fileURLPath = voiceBody.remotePath;
//        }
//            break;
//        default:
//        {//如果以上都不是~
//            self.messageBodyType = EMMessageBodyTypeText;
//            self.text = @"[不支持的消息类型]";
//        }
//            break;
//    }
//}



@end

