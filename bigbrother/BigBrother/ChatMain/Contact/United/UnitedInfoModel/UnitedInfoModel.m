//
//  UnitedInfoModel.m
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedInfoModel.h"

@interface UnitedInfoModel ()

@property (strong, nonatomic) id        unitedDetailData;
@property (strong, nonatomic) id        unitedActivityData;
@property (strong, nonatomic) id        createUnitedActivityData;

@property (strong, nonatomic) id        exitUnitedData;
@property (strong, nonatomic) id        dismissUnitedData;
@property (strong, nonatomic) id        transterUnitedData;

@property (strong, nonatomic) id        addAdminData;
@property (strong, nonatomic) id        removeAdminData;
@property (strong, nonatomic) id        setSpeakData;

@property (strong, nonatomic) id        getUnitedRankData;
@property (strong, nonatomic) id        changeRankNameData;

@end

@implementation UnitedInfoModel

//获取门派资料
- (void)getUnitedInfoWithId:(NSString *)idString limit:(NSString *)limit
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:idString forKey:@"id"];
    [dataDic setObject:limit forKey:@"limit"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/detail" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"getUnitedDetailInfo -- %@",responseObj);
        self.unitedDetailData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];

}

//获取门派活动
- (void)getUnitedActivityWithGroupId:(NSString *)groupId page:(NSString *)page
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:page forKey:@"page"];
    [dataDic setObject:groupId forKey:@"groupId"];
//    [dataDic setObject:@"10" forKey:@"pageSize"];
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/activities/all" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"getActivity -- %@",responseObj);
        self.unitedActivityData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
    
}

//创建门派活动
- (void)createUnitedActivityWithGroupId:(NSString *)groupId creator:(NSString *)creator name:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime location:(NSString *)location cost:(NSString *)cost content:(NSString *)content images:(NSArray *)images
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    [dataDic setObject:creator forKey:@"creator"];
    [dataDic setObject:name forKey:@"name"];
    [dataDic setObject:startTime forKey:@"startTime"];
    [dataDic setObject:endTime forKey:@"endTime"];
    [dataDic setObject:location forKey:@"location"];
    [dataDic setObject:cost forKey:@"cost"];
    [dataDic setObject:content forKey:@"content"];
//    [dataDic setObject:images forKey:@"images"];
//    [dataDic setObject:[groupId JSONString]forKey:@"groupId"];
//    [dataDic setObject:[creator JSONString]forKey:@"creator"];
//    [dataDic setObject:[name JSONString]forKey:@"name"];
//    [dataDic setObject:[startTime JSONString] forKey:@"startTime"];
//    [dataDic setObject:[endTime JSONString]forKey:@"endTime"];
//    [dataDic setObject:[location JSONString] forKey:@"location"];
//    [dataDic setObject:[cost JSONString]forKey:@"cost"];
//    [dataDic setObject:[content JSONString] forKey:@"content"];
    [dataDic setObject:images forKey:@"images"];
    
    NSString * resultString = [NSString jsonStringWithDictionary:dataDic];
    
     NSLog(@"dataDic -- %@",dataDic);
    NSLog(@"dataString -- %@",resultString);
    NSDictionary * resultDic = @{@"json":resultString};
   
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/activities/add" params:resultDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"createUnitedActivityData -- %@",responseObj);
        self.createUnitedActivityData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//退出门派
- (void)exitUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    [dataDic setObject:userId forKey:@"userId"];
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/quit" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"exitUnitedData -- %@",responseObj);
        self.exitUnitedData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//解散群
- (void)dismissUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    [dataDic setObject:userId forKey:@"userId"];
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/dismiss" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"dismissUnitedData -- %@",responseObj);
        self.dismissUnitedData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}


//转让群
- (void)transterUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId transferTo:(NSString *)transferTo
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:transferTo forKey:@"transferTo"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/transfer" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"transterUnitedData -- %@",responseObj);
        self.transterUnitedData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}


//设置管理员
- (void)addUnitedAdminsWithOwnerId:(NSString *)ownerId userIds:(NSString *)userIds groupId:(NSString *)groupId
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    [dataDic setObject:userIds forKey:@"userIds"];
    [dataDic setObject:ownerId forKey:@"ownerId"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/admins/add" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"addAdminData -- %@",responseObj);
        self.addAdminData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//移除管理员
- (void)removeUnitedAdminsWithOwnerId:(NSString *)ownerId adminId:(NSString *)adminId groupId:(NSString *)groupId
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    [dataDic setObject:adminId forKey:@"adminId"];
    [dataDic setObject:ownerId forKey:@"ownerId"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/admins/remove" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"removeAdminData -- %@",responseObj);
        self.removeAdminData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//设置门派禁言
- (void)setUnitedSpearkWithGroupId:(NSString *)groupId userId:(NSString *)userId isBan:(NSString *)isBan
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:isBan forKey:@"isBan"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/ban" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"setSpeakData -- %@",responseObj);
        self.setSpeakData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}


//获取门派等级
- (void)getUnitedRankWithGroupId:(NSString *)groupId
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupId forKey:@"groupId"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/grades" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"getUnitedRankData -- %@",responseObj);
        self.getUnitedRankData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//修改等级名称
- (void)changeUnitedRankNameWithUserId:(NSString *)userId groupGradeId:(NSString *)groupGradeId name:(NSString *)name
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:groupGradeId forKey:@"groupGradeId"];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:name forKey:@"name"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/grades/modify" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"changeRankNameData -- %@",responseObj);
        self.changeRankNameData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}



@end
