//
//  FriendCacheManager.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FriendCacheManager.h"

typedef NS_ENUM(NSInteger, FriendCacheErrorCode) {
    FriendCacheErrorCode_UrlFailed = 0,//获取网络列表缓存失败
    FriendCacheErrorCode_CreateFailed,//建表失败
    FriendCacheErrorCode_NotFount//没有找到
};

@implementation FriendCacheManager

+ (FriendCacheManager *)sharedManager
{
    static FriendCacheManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        //        sharedAccountManagerInstance.supportKeys = @[@"friendList"];
    });
    
    return sharedAccountManagerInstance;
}


- (NSArray *)friendListCache
{
    if ([CACHE_MANAGER isTableOKWithDbname:DBNAME tableName:TABLENAME_FRIENDLIST]) {
        NSArray *friendList = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_FRIENDLIST column_list:nil condition_map:nil];
        return friendList;
    }
    return [NSArray array];
}

- (void)friendListCacheWithCompleted:(completed)completed
{
    if ([CACHE_MANAGER isTableOKWithDbname:DBNAME tableName:TABLENAME_FRIENDLIST]) {
        NSArray *friendList = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_FRIENDLIST column_list:nil condition_map:nil];
        completed(friendList,nil);
    }else{
        [self getfriendListWithCompleted:^(id responseObject, NSError *error) {
            completed(responseObject,error);
        }];
    }
}

//获取好友列表从网络
- (void)getfriendListWithCompleted:(completed)completed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/im/friends",BASE_URL];
    __weak FriendCacheManager *weakSelf = self;
    [NetworkingManager postWithURL:urlStr params:@{@"userId":[BBUserDefaults getUserID]} successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSDictionary * dataDic = responseObj;
        NSLog(@"dataDic -- %@",dataDic);
        
        NSArray *dataArray = dataDic[@"data"];
        NSMutableArray *friendList = [NSMutableArray array];
        for (NSDictionary *sectionDic in dataArray) {
            NSString *friendsGroupName = sectionDic[@"name"];//分组名称
            NSString *friendsGroupId = [NSString stringWithFormat:@"%@",sectionDic[@"id"]];
            NSArray *friendArray = sectionDic[@"friends"];
            for (NSDictionary *rowDic in friendArray) {
                if (rowDic) {
                    NSMutableDictionary *friendDic = [NSMutableDictionary dictionaryWithDictionary:rowDic[@"friend"]];
                    [friendDic setObject:friendsGroupName forKey:@"friendsGroupName"];
                    [friendDic setObject:friendsGroupId forKey:@"friendsGroupId"];
                    [friendList addObject:friendDic];
                }
            }
            
        }
        BOOL createResult = [weakSelf createFriendListCacheWithFriendList:friendList];
        if (createResult) {
            completed(friendList,nil);
        }else{
            completed(friendList,[NSError errorWithDomain:@"" code:FriendCacheErrorCode_CreateFailed userInfo:@{@"data":@"从服务器获取失败"}]);
        }
        
        
        
    } failAction:^(NSError *error, id responseObj) {
        completed(nil,[NSError errorWithDomain:@"" code:FriendCacheErrorCode_UrlFailed userInfo:@{@"data":@"从服务器获取失败"}]);
    }];
    
//    NSString *urlStr = [NSString stringWithFormat:@"/cobber/search"];
//    NSDictionary *params = @{@"uid":[BBUserDefaults getUserID],@"pageIndex":@(1),@"pageSize":@(SXNOTFOUND),@"token":[NSString tokenString]};
//    __weak FriendCacheManager *weakSelf = self;
//    [NetworkingManager getWithURL:urlStr params:params successAction:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        id object = [string objectFromJSONString];
//        
//        NSArray *friendList = object[@"domains"];
//        
//        [weakSelf createFriendListCacheWithFriendList:friendList];
//        completed(friendList,nil);
//        
//    } failAction:^(AFHTTPRequestOperation *operation, NSError *error) {
//        completed(nil,error);
//    }];
}

//创建缓存
- (BOOL)createFriendListCacheWithFriendList:(NSArray *)friendList
{
    if ([CACHE_MANAGER isTableOKWithDbname:DBNAME tableName:TABLENAME_FRIENDLIST]) {
        [CACHE_MANAGER deleteTableWithDbname:DBNAME tableName:TABLENAME_FRIENDLIST];
    }
    
    NSDictionary *params_dic = @{@"id":@"integer",
                                 @"avatar":@"text",
                                 @"imNumber":@"text",
                                 @"createdTime":@"text",
                                 @"nickname":@"text",
                                 @"usernamme":@"text",
                                 @"phoneNumber":@"text",
                                 @"friendsGroupName":@"text",
                                 @"friendsGroupId":@"text"};
    
    
    if ([CACHE_MANAGER executeCreateWithDbname:DBNAME tablename:TABLENAME_FRIENDLIST params_dic:params_dic primary_key:@"id"]) {
        for (NSDictionary *dic in friendList) {
            
            BOOL insertResult = [CACHE_MANAGER executeInsertWithDbname:DBNAME tablename:TABLENAME_FRIENDLIST value_map:dic];
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
- (void)insertFriendDic:(NSDictionary *)friendDic completed:(completed)completed
{
    [self friendListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:responseObject];
            //查看有没有
            NSArray *resultArray = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_FRIENDLIST column_list:nil condition_map:@{@"id":friendDic[@"id"]}];
            if (resultArray.count > 0) {
                completed(tempArray,nil);
            }else{//没有才增加
                BOOL insertRsult = [CACHE_MANAGER executeInsertWithDbname:DBNAME tablename:TABLENAME_FRIENDLIST value_map:friendDic];
                if (insertRsult) {
                    [tempArray addObject:friendDic];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendsVC" object:nil];
                completed(tempArray,nil);
            }
        }else{
            completed(responseObject,error);
        }
    }];
}

//删
- (void)deleteFriendDic:(NSDictionary *)friendDic completed:(completed)completed
{
    [self friendListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            //不管有没有，直接删
            //不管成功与否，反正没有了就对了。
            [CACHE_MANAGER executeDeleteWithDbname:DBNAME tablename:TABLENAME_FRIENDLIST condition_map:@{@"id":friendDic[@"id"]}];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:responseObject];
            [tempArray removeObject:friendDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendsVC" object:nil];
            completed(tempArray,nil);
        }else{
            completed(responseObject,error);
        }
    }];
}

//改
- (void)updateFriendDic:(NSDictionary *)friendDic completed:(completed)completed
{
    [self friendListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            //不管有没有都增加
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:responseObject];
            NSArray *resultArray = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_FRIENDLIST column_list:nil condition_map:@{@"id":friendDic[@"id"]}];
            NSDictionary *lastDic = [resultArray firstObject];
            NSInteger index = [tempArray indexOfObject:lastDic];
            
            BOOL updateRsult = [CACHE_MANAGER executeUpdateWithDbname:DBNAME tablename:TABLENAME_FRIENDLIST value_map:friendDic condition_map:@{@"id":friendDic[@"id"]}];
            if (updateRsult) {
                [tempArray replaceObjectAtIndex:index withObject:friendDic];
            }
            completed(tempArray,nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendsVC" object:nil];
        }else{
            completed(responseObject,error);
        }
    }];
}

//查
- (void)getFriendDicWithUid:(id)uid completed:(completed)completed
{
    
    [self friendListCacheWithCompleted:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *resultArray = [CACHE_MANAGER executeQueryDbname:DBNAME tablename:TABLENAME_FRIENDLIST column_list:nil condition_map:@{@"id":uid}];
            if (resultArray.count > 0) {
                completed([resultArray firstObject],nil);
            }else{
                completed(nil,[NSError errorWithDomain:@"" code:FriendCacheErrorCode_NotFount userInfo:@{@"data":@"什么都没有"}]);
            }
            
        }else{
            completed(responseObject,error);
        }
    }];
}

@end
