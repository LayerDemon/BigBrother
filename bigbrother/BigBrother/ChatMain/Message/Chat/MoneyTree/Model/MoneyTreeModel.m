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

@end

@implementation MoneyTreeModel
/**
 *  创建摇钱树
 */
- (void)getCreateDataWithGoldCoinCount:(NSInteger)goldCoinCount sum:(NSInteger)sum receiveTarget:(NSString *)receiveTarget message:(NSString *)message creator:(NSNumber *)creator groupId:(NSNumber *)groupId
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

@end
