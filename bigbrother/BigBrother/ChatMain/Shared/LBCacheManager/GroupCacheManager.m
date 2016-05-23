//
//  GroupCacheManager.m
//  BookClub
//
//  Created by 李祖建 on 16/4/13.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "GroupCacheManager.h"

@implementation GroupCacheManager

+ (GroupCacheManager *)sharedManager
{
    static GroupCacheManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        //        sharedAccountManagerInstance.supportKeys = @[@"friendList"];
    });
    
    return sharedAccountManagerInstance;
}


- (NSArray *)groupListCache
{
    if ([CACHE_MANAGER isTableOKWithDbname:DBNAME tableName:TABLENAME_GROUPLIST]) {
        NSArray *groupList = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_GROUPLIST column_list:nil condition_map:nil];
        return groupList;
    }
    
    
    return [NSArray array];
}

- (void)groupListCacheWithCompleted:(completed)completed
{
    if ([CACHE_MANAGER isTableOKWithDbname:DBNAME tableName:TABLENAME_GROUPLIST]) {
        NSArray *groupList = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_GROUPLIST column_list:nil condition_map:nil];
        completed(groupList,nil);
    }else{
        [self getGroupListWithCompleted:^(id responseObject, NSError *error) {
            completed(responseObject,error);
        }];
    }
}

//当前用户拥有群列表
- (void)getGroupListWithCompleted:(completed)completed
{
    NSNumber *uid = [BBUserDefaults getUserDic][@"id"];
    
    __weak GroupCacheManager *weakSelf = self;
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/all" params:@{@"userId":uid} successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSDictionary * dataDic = responseObj;
        NSLog(@"dataDic -- %@",dataDic);
//        self.allGroupData = responseObj;
        NSArray *groupList = dataDic[@"data"];
        [weakSelf createGroupListCacheWithGroupList:dataDic[@"data"]];
        
        completed(groupList,nil);
        
    } failAction:^(NSError *error, id responseObj) {
        completed(nil,error);
    }];
}

//创建缓存
- (BOOL)createGroupListCacheWithGroupList:(NSArray *)groupList
{
    if ([CACHE_MANAGER isTableOKWithDbname:DBNAME tableName:TABLENAME_GROUPLIST]) {
        [CACHE_MANAGER deleteTableWithDbname:DBNAME tableName:TABLENAME_GROUPLIST];
    }
    
    NSDictionary *params_dic = @{@"id":@"integer",
                                 @"createdTime":@"text",
                                 @"name":@"text",
                                 @"memberCount":@"integer",
                                 @"status":@"text",
                                 @"avatar":@"text",
                                 @"groupNumber":@"text",
                                 @"capacity":@"integer",
                                 @"chatGroupId":@"text",
                                 @"role":@"text"};
    
    
    if ([CACHE_MANAGER executeCreateWithDbname:DBNAME tablename:TABLENAME_GROUPLIST params_dic:params_dic primary_key:@"id"]) {
        for (NSDictionary *dic in groupList) {
            
            BOOL insertResult = [CACHE_MANAGER executeInsertWithDbname:DBNAME tablename:TABLENAME_GROUPLIST value_map:dic];
            if (!insertResult) {
                return NO;
            }
        }
    }else{
        return NO;
    }
    return YES;
}

//增
- (void)insertGroupDic:(NSDictionary *)groupDic completed:(completed)completed
{
    [self groupListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            //不管有没有都增加
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:responseObject];
            //不管有没有都增加
            NSArray *resultArray = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_GROUPLIST column_list:nil condition_map:@{@"id":groupDic[@"id"]}];
            if (resultArray.count > 0) {
                completed(tempArray,nil);
            }else{
                BOOL insertRsult = [CACHE_MANAGER executeInsertWithDbname:DBNAME tablename:TABLENAME_GROUPLIST value_map:groupDic];
                if (insertRsult) {
                    [tempArray addObject:groupDic];
                }
                completed(tempArray,nil);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMainDataSource" object:nil];
            }
            
            
        }else{
            completed(responseObject,error);
        }
    }];
}

//删
- (void)deleteGroupDic:(NSDictionary *)groupDic completed:(completed)completed
{
    [self groupListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            //不管有没有，直接删
            //不管成功与否，反正没有了就对了。
            [CACHE_MANAGER executeDeleteWithDbname:DBNAME tablename:TABLENAME_GROUPLIST condition_map:@{@"id":groupDic[@"id"]}];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:responseObject];
            [tempArray removeObject:groupDic];
            completed(tempArray,nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMainDataSource" object:nil];
        }else{
            completed(responseObject,error);
        }
    }];
}

//改
- (void)updateGroupDic:(NSDictionary *)groupDic completed:(completed)completed
{
    [self groupListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            //不管有没有都增加
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:responseObject];
            NSArray *resultArray = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_GROUPLIST column_list:nil condition_map:@{@"id":groupDic[@"id"]}];
            NSDictionary *lastDic = [resultArray firstObject];
            NSInteger index = [tempArray indexOfObject:lastDic];
            
            BOOL updateRsult = [CACHE_MANAGER executeUpdateWithDbname:DBNAME tablename:TABLENAME_GROUPLIST value_map:groupDic condition_map:@{@"id":groupDic[@"id"]}];
            if (updateRsult) {
                [tempArray replaceObjectAtIndex:index withObject:groupDic];
            }
            completed(tempArray,nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendsVC" object:nil];
        }else{
            completed(responseObject,error);
        }
    }];
}

//查
- (void)getGroupDicWithGroupId:(NSNumber *)groupId completed:(completed)completed
{
    
    [self groupListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            
            NSArray *resultArray = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_GROUPLIST column_list:nil condition_map:@{@"id":groupId}];
            if (resultArray.count > 0) {
                completed([resultArray firstObject],nil);
            }else{
                completed(nil,[NSError errorWithDomain:@"" code:0 userInfo:@{@"data":@"什么都没有"}]);
            }
            
        }else{
            completed(responseObject,error);
        }
    }];
}

@end
