//
//  NewFriendModel.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "NewFriendModel.h"



@interface NewFriendModel ()

@property (strong, nonatomic) NSDictionary *agreeData;
@property (strong, nonatomic) NSDictionary *refuseData;

@end

@implementation NewFriendModel


/**
 *  好友请求处理
 */
- (void)postFriendHandleDataWithUserId:(NSNumber *)userId requestId:(NSNumber *)requestId action:(NSString *)action
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/requests/friends/handle",BASE_URL];
    NSDictionary *tempDic = @{@"userId":userId,@"requestId":requestId,@"action":action,@"addFriend":@"YES"};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            if ([action isEqualToString:HandleAction_ACCEPT]) {
                self.agreeData = resultDic;
            }else{
                self.refuseData = resultDic;
            }
        }
    }];
}


/**
 *  加入门派请求处理
 */
- (void)postGroupHandleDataWithAdminId:(NSNumber *)adminId userId:(NSNumber *)userId groupId:(NSNumber *)groupId action:(NSString *)action
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/requests/groups/handle",BASE_URL];
    NSDictionary *tempDic = @{@"adminId":adminId,@"userId":userId,@"groupId":groupId,@"action":action};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            if ([action isEqualToString:HandleAction_ACCEPT]) {
                self.agreeData = resultDic;
            }else{
                self.refuseData = resultDic;
            }
        }
    }];
}

@end
