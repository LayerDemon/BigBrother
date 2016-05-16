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


@end

@implementation FriendModel
//根据手机号查询用户信息
- (void)getFriendInfoDataWithPhoneNumber:(NSNumber *)phoneNumber
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/users/findByPhoneNumber",BASE_URL];
    NSDictionary *tempDic = @{@"phoneNumber":phoneNumber};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.friendInfoData = resultDic;
        }
    }];
}

//根据手机号查询用户信息
- (void)getFriendInfoDataWithUid:(NSNumber *)uid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/users/get",BASE_URL];
    NSDictionary *tempDic = @{@"id":uid};
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    
    [BBUrlConnection loadPostAfNetWorkingWithUrl:urlStr andParameters:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (!errorString) {
            self.friendInfoData = resultDic;
        }
    }];
}

@end
