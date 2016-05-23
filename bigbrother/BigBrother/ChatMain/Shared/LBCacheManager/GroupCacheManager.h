//
//  GroupCacheManager.h
//  BookClub
//
//  Created by 李祖建 on 16/4/13.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completed)(id responseObject,NSError *error);

@interface GroupCacheManager : NSObject

+ (GroupCacheManager *)sharedManager;

//同步获取
- (NSArray *)groupListCache;

- (void)groupListCacheWithCompleted:(completed)completed;

//当前用户拥有群列表
- (void)getGroupListWithCompleted:(completed)completed;

//创建缓存
- (BOOL)createGroupListCacheWithGroupList:(NSArray *)groupList;

//增
- (void)insertGroupDic:(NSDictionary *)groupDic completed:(completed)completed;

//删
- (void)deleteGroupDic:(NSDictionary *)groupDic completed:(completed)completed;

//改
- (void)updateGroupDic:(NSDictionary *)groupDic completed:(completed)completed;

//查
- (void)getGroupDicWithGroupId:(NSNumber *)groupId completed:(completed)completed;

@end
