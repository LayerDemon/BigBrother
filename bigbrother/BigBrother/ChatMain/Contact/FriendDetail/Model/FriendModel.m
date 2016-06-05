//
//  FriendModel.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FriendModel.h"

@interface FriendModel ()

@property (strong, nonatomic) NSDictionary *friendInfoData;
@property (strong, nonatomic) NSDictionary *addData;
@property (strong, nonatomic) NSDictionary *deleteData;
@property (strong, nonatomic) NSDictionary *sectionListData;

@end

@implementation FriendModel
//根据手机号查询用户信息
- (void)postFriendInfoDataWithPhoneNumber:(NSNumber *)phoneNumber
{
    NSString *urlStr = [NSString stringWithFormat:@"/users/findByPhoneNumber"];
    NSDictionary *tempDic = @{@"phoneNumber":phoneNumber};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.friendInfoData = resultDic;
        }
    }];
}

//根据手机号查询用户信息
- (void)postFriendInfoDataWithUid:(NSNumber *)uid
{
    NSString *urlStr = [NSString stringWithFormat:@"/users/get"];
    NSDictionary *tempDic = @{@"id":uid};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.friendInfoData = resultDic;
        }
    }];
}

//添加好友
- (void)postAddDataWithUserId:(id)userId friendId:(id)friendId message:(NSString *)message friendsGroupId:(id)friendsGroupId
{
    NSString *urlStr = [NSString stringWithFormat:@"/im/requests/friends/apply"];
    NSDictionary *tempDic = @{@"userId":userId,@"friendId":friendId,@"message":message,@"friendsGroupId":friendsGroupId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.addData = resultDic[@"data"];
        }
    }];
}

//删除好友
- (void)postDeleteDataWithUserId:(id)userId friendId:(id)friendId
{
    NSString *urlStr = [NSString stringWithFormat:@"/im/friends/delete"];
    NSDictionary *tempDic = @{@"userId":userId,@"friendId":friendId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.deleteData = resultDic[@"data"];
        }
    }];
}

//获取全部分组
- (void)postSectionListDataWithUserId:(id)userId
{
    NSString *urlStr = [NSString stringWithFormat:@"/im/friends/groups"];
    NSDictionary *tempDic = @{@"userId":userId};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.sectionListData = resultDic;
        }
    }];
}





@end
