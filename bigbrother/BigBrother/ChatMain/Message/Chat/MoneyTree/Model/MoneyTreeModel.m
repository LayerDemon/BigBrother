//
//  MoneyTreeModel.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MoneyTreeModel.h"

@interface MoneyTreeModel ()

@property (strong, nonatomic) NSDictionary *createData;
@property (strong, nonatomic) NSDictionary *moneyTreeData;
@property (strong, nonatomic) NSDictionary *pickData;
@property (strong, nonatomic) NSDictionary *pickListData;
@property (strong, nonatomic) NSDictionary *userInfoData;

@property (strong, nonatomic) NSDictionary *pickHistoryData;//领取记录
@property (strong, nonatomic) NSDictionary *plantHistoryData;//付出记录

@end

@implementation MoneyTreeModel
/**
 *  创建摇钱树
 */
- (void)postCreateDataWithGoldCoinCount:(NSInteger)goldCoinCount sum:(NSInteger)sum receiveTarget:(NSString *)receiveTarget message:(NSString *)message creator:(NSNumber *)creator groupId:(NSNumber *)groupId
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/moneytrees/add",BASE_URL];
    NSDictionary *tempDic = @{@"goldCoinCount":@(goldCoinCount),@"sum":@(sum),@"receiveTarget":receiveTarget,@"message":message,@"creator":creator,@"groupId":groupId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.createData = resultDic[@"data"];
        }
    }];
}

/**
 *  获取摇钱树
 */
- (void)postMoneyTreeDataWithMoneyTreeId:(NSNumber *)treeId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/moneytrees/get",BASE_URL];
    NSDictionary *tempDic = @{@"id":treeId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.moneyTreeData = resultDic[@"data"];
        }
    }];
}

/**
 *  领取摇钱树
 */
- (void)postPickDataWithMoneyTreeId:(NSNumber *)moneyTreeId operator:(NSNumber *)operatorId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/moneytrees/clicks/add",BASE_URL];
    NSDictionary *tempDic = @{@"moneyTreeId":moneyTreeId,@"operator":operatorId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        
        if (!errorString) {
            self.pickData = resultDic[@"data"];
        }else{
            [self postMoneyTreeDataWithMoneyTreeId:moneyTreeId];
        }
    }];
}

/**
 *  获取摇钱树的领取列表
 */
- (void)postPickListDataWithMoneyTreeId:(NSNumber *)moneyTreeId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/moneytrees/clicks/list",BASE_URL];
    NSDictionary *tempDic = @{@"moneyTreeId":moneyTreeId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        
        if (!errorString) {
            self.pickListData = resultDic[@"data"];
        }
    }];
}

/**
 *  获取个人的领取记录
 */
- (void)postPickHistoryDataWithMoneyTreeId:(NSNumber *)moneyTreeId userId:(NSNumber *)userId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/moneytrees/clicks/listForUser",BASE_URL];
    NSDictionary *tempDic = @{@"moneyTreeId":moneyTreeId,@"userId":userId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        
        if (!errorString) {
            self.pickHistoryData = resultDic[@"data"];
        }
    }];
}

/**
 *  用户信息
 */
- (void)postUserInfoDataWithUid:(NSNumber *)uid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/users/get",BASE_URL];
    NSDictionary *tempDic = @{@"id":uid};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.userInfoData = resultDic;
        }
    }];
}



@end
