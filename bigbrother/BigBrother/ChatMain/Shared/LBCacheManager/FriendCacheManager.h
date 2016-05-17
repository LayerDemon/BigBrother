//
//  FriendCacheManager.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completed)(id responseObject,NSError *error);

@interface FriendCacheManager : NSObject

+ (FriendCacheManager *)sharedManager;

//同步获取~
- (NSArray *)friendListCache;
//获取缓存block
- (void)friendListCacheWithCompleted:(completed)completed;

//创建缓存
- (BOOL)createFriendListCacheWithFriendList:(NSArray *)friendList;

//增
- (void)insertFriendDic:(NSDictionary *)friendDic completed:(completed)completed;

//删
- (void)deleteFriendDic:(NSDictionary *)friendDic completed:(completed)completed;

//改
- (void)updateFriendDic:(NSDictionary *)friendDic completed:(completed)completed;

//查
- (void)getFriendDicWithUid:(NSNumber *)uid completed:(completed)completed;

@end
