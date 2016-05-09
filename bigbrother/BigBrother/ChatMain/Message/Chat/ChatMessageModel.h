//
//  ChatMessageModel.h
//  BookClub
//
//  Created by 李祖建 on 16/2/29.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessageModel : NSObject

@property (nonatomic, copy) NSString *text;//文字
@property (nonatomic, copy) NSString *time;//时间
@property (assign, nonatomic) BOOL showTime;//是都显示时间
@property (nonatomic, assign) BOOL isFromOther;//类型（是别人的消息还是自己的）
@property (strong, nonatomic) NSDictionary *otherDic;//他人信息
@property (strong, nonatomic) NSDictionary *userDic;//自己的信息
@property (assign, nonatomic) EMMessageBodyType messageBodyType;
@property (strong, nonatomic) EMMessage *message;//环信消息
//@property (strong, nonatomic) UIImage *image;//图片
@property (strong, nonatomic) EMImageMessageBody *imageMessageBody;//图片消息体
@property (strong, nonatomic) EMLocationMessageBody *locationMessageBody;//位置消息体
//@property (strong, nonatomic) NSDictionary *chatterDic;//
+ (id)messageModelWithMessage:(EMMessage *)message;

@end
