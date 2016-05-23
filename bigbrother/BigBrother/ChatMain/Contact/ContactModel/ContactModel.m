//
//  ContactModel.m
//  BigBrother
//
//  Created by zhangyi on 16/5/9.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ContactModel.h"

@interface ContactModel ()

@property (strong, nonatomic) id        allFriendsData;
@property (strong, nonatomic) id        allGroupData;
@property (strong, nonatomic) id        createGroupData;

@property (strong, nonatomic) id        friendsRequestData;

@property (strong, nonatomic) id        addNewGroupsData;
@property (strong, nonatomic) id        deleteGroupsData;
@property (strong, nonatomic) id        editGroupData;

@end

@implementation ContactModel

//获取所有的好友
- (void)getAllFriendWithUserId:(NSString *)userId
{
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/friends" params:@{@"userId":userId} successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSDictionary * dataDic = responseObj;
        NSLog(@"dataDic -- %@",dataDic);
        self.allFriendsData = responseObj;
        
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
        [FRIENDCACHE_MANAGER createFriendListCacheWithFriendList:friendList];
        
//        BOOL createResult = [FRIENDCACHE_MANAGER createFriendListCacheWithFriendList:friendList];
//        if (createResult) {
//            completed(friendList,nil);
//        }else{
//            completed(friendList,[NSError errorWithDomain:@"" code:FriendCacheErrorCode_CreateFailed userInfo:@{@"data":@"从服务器获取失败"}]);
//        }
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//获取我的所有门派
- (void)getAllGroupsWithUserId:(NSString *)userId
{
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/all" params:@{@"userId":userId} successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSDictionary * dataDic = responseObj;
        NSLog(@"dataDic -- %@",dataDic);
        self.allGroupData = responseObj;
        NSArray *groupList = self.allGroupData[@"data"];
        [GROUPCACHE_MANAGER createGroupListCacheWithGroupList:groupList];
        
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//处理好有请求
- (void)managerFriendsRequestWithUserId:(NSString *)userId requestId:(NSString *)requestId action:(NSString *)action friendsGroupId:(NSString *)friendsGroupId addFriend:(NSString *)addFriend
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:requestId forKey:@"requestId"];
    [dataDic setObject:action forKey:@"action"];
    [dataDic setObject:friendsGroupId forKey:@"friendsGroupId"];
    [dataDic setObject:addFriend forKey:@"addFriend"];

    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/requests/friends/handle" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"old data -- %@",responseObj);
        NSDictionary * dataDic = responseObj;
        NSLog(@"dataDic -- %@",dataDic);
        
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//查询所有好友请求列表
- (void)checkAllFriendsRequestListWithUserId:(NSString *)userId limit:(NSString *)limit
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:limit forKey:@"limit"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/requests/all" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"getAllRequest -- %@",responseObj);
        self.friendsRequestData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//申请添加好友
- (void)applyAddFriendsWithUserId:(NSString *)userId friendId:(NSString *)friendId message:(NSString *)message friendsGroupId:(NSString *)friendsGroupId
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:friendId forKey:@"friendId"];
    [dataDic setObject:message forKey:@"message"];
    [dataDic setObject:friendsGroupId forKey:@"friendsGroupId"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/requests/friends/apply" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"old data -- %@",responseObj);
        NSDictionary * dataDic = responseObj;
        NSLog(@"dataDic -- %@",dataDic);
        
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}


//根据聊天账号查找好友
- (void)checkFriendsWithImNumber:(NSString *)imNumber
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:imNumber forKey:@"imNumber"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/requests/friends/find" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"old data -- %@",responseObj);
        NSDictionary * dataDic = responseObj;
        NSLog(@"dataDic -- %@",dataDic);
        
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];

}

//创建门派
- (void)createUnitedWithUserId:(NSString *)userId avatar:(NSString *)avatar name:(NSString *)name introduction:(NSString *)introduction
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:avatar forKey:@"avatar"];
    [dataDic setObject:name forKey:@"name"];
    [dataDic setObject:introduction forKey:@"introduction"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/add" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"dataDic -- %@",responseObj);
        self.createGroupData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//新增分类
- (void)addNewGroupWithUserId:(NSString *)userId name:(NSString *)name orderBy:(NSInteger)orderBy
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:name forKey:@"name"];
    [dataDic setObject:@(orderBy) forKey:@"orderBy"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/friends/groups/add" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"dataDic -- %@",responseObj);
        self.addNewGroupsData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//删除分类
- (void)deleteGroupWithFriendsGroupId:(NSString *)friendsGroupId userId:(NSString *)userId
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:friendsGroupId forKey:@"friendsGroupId"];
    
    NSLog(@"wocaonima -- %@",dataDic);
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/friends/groups/delete" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"delete -- %@",responseObj);
        self.deleteGroupsData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//编辑分类
- (void)editGroupWithFriendsGroupId:(NSString *)friendsGroupId userId:(NSString *)userId name:(NSString *)name orderBy:(NSInteger)orderBy
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:friendsGroupId forKey:@"friendsGroupId"];
    [dataDic setObject:@(orderBy) forKey:@"orderBy"];
    [dataDic setObject:name forKey:@"name"];
    
    NSLog(@"wocaonima -- %@",dataDic);
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/friends/groups/modify" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"delete -- %@",responseObj);
        self.editGroupData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

@end
