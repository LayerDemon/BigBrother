//
//  MessageViewCell.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *chatterDic;

@property (strong, nonatomic) EMConversation *conversation;

- (void)loadDataWithConversation:(EMConversation *)conversation;

@end
