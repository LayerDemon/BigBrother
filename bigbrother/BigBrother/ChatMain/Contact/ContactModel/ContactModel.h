//
//  ContactModel.h
//  BigBrother
//
//  Created by zhangyi on 16/5/9.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (strong, nonatomic, readonly) id        allFriendsData;
@property (strong, nonatomic, readonly) id        allGroupData;
@property (strong, nonatomic, readonly) id        createGroupData;

@property (strong, nonatomic, readonly) id        friendsRequestData;   //获取所有好友请求

//获取所有的好友
- (void)getAllFriendWithUserId:(NSString *)userId;
//获取我的所有门派
- (void)getAllGroupsWithUserId:(NSString *)userId;

//创建门派
- (void)createUnitedWithUserId:(NSString *)userId avatar:(NSString *)avatar name:(NSString *)name introduction:(NSString *)introduction;
//查询所有好友请求列表
- (void)checkAllFriendsRequestListWithUserId:(NSString *)userId limit:(NSString *)limit;

@end
