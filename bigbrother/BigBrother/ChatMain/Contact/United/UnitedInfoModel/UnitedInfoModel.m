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

@property (strong, nonatomic) id        exitUnitedData;
@property (strong, nonatomic) id        dismissUnitedData;
@property (strong, nonatomic) id        transterUnitedData;

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
    [dataDic setObject:[images JSONString] forKey:@"images"];
    
    NSLog(@"dataDic -- %@",dataDic);
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/activities/add" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"getActivity -- %@",responseObj);
//        self.unitedActivityData = responseObj;
        
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
        NSLog(@"getActivity -- %@",responseObj);
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
        NSLog(@"getActivity -- %@",responseObj);
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
        NSLog(@"getActivity -- %@",responseObj);
        self.transterUnitedData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

@end
