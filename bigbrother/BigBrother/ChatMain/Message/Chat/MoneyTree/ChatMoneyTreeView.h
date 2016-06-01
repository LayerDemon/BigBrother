//
//  ChatMoneyTreeView.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMoneyTreeView : UIView

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSDictionary *createUserDic;
@property (assign, nonatomic) BOOL canPick;


- (void)reloadMoneyTreeWithMessageModel:(ChatMessageModel *)messageModel;

///**
// *  刷新数据源
// */
//- (void)reloadDataSource;
/**
 *  摘取摇钱树
 */
- (void)startPickMoneyTree;

@end
