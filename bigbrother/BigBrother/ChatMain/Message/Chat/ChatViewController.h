//
//  ChatViewController.h
//  BookClub
//
//  Created by 李祖建 on 16/2/26.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController

//@property (strong, nonatomic) NSDictionary *groupDic;//群信息
@property (strong, nonatomic) NSDictionary *chatDic;//消息发送者用户信息
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
/**
 *  群名片
 */
@property (strong, nonatomic) NSString *groupRemarks;

//@property (strong, nonatomic, readonly) NSString *chatter;//接收者
//@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源

@end
