//
//  MoneyTreeModel.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyTreeModel : NSObject

@property (strong, nonatomic, readonly) NSDictionary *createData;
@property (strong, nonatomic, readonly) NSDictionary *moneyTreeData;
@property (strong, nonatomic, readonly) NSDictionary *pickData;
@property (strong, nonatomic, readonly) NSDictionary *pickListData;
@property (strong, nonatomic, readonly) NSDictionary *userInfoData;

@property (strong, nonatomic, readonly) NSDictionary *pickHistoryData;//领取记录
@property (strong, nonatomic, readonly) NSDictionary *plantHistoryData;//付出记录

/**
 *  创建摇钱树
 */
- (void)postCreateDataWithGoldCoinCount:(NSInteger)goldCoinCount sum:(NSInteger)sum receiveTarget:(NSString *)receiveTarget message:(NSString *)message creator:(NSNumber *)creator groupId:(NSNumber *)groupId;

/**
 *  获取摇钱树
 */
- (void)postMoneyTreeDataWithMoneyTreeId:(NSNumber *)treeId;

/**
 *  领取摇钱树
 */
- (void)postPickDataWithMoneyTreeId:(NSNumber *)moneyTreeId operator:(NSNumber *)operatorId;

/**
 *  获取摇钱树的领取列表
 */
- (void)postPickListDataWithMoneyTreeId:(NSNumber *)moneyTreeId;

/**
 *  获取个人的领取记录
 */
- (void)postPickHistoryDataWithCreator:(NSNumber *)creator page:(NSInteger)page pageSize:(NSInteger)pageSize;



/**
 *  获取用户付出记录（）
 */
- (void)postPlantHistoryDataWithUserId:(NSNumber *)userId page:(NSInteger)page pageSize:(NSInteger)pageSize;






/**
 *  用户信息
 */
- (void)postUserInfoDataWithUid:(NSNumber *)uid;
@end
