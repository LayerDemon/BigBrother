//
//  MyPostInfo.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/5.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MyPostInfo.h"

@implementation MyPostInfo

+(instancetype)infoWithNetDictionary:(NSDictionary *)netDic{
    MyPostInfo *info = [[MyPostInfo alloc] init];
    return [info updateWithNetDictionary:netDic];
}

-(instancetype)updateWithNetDictionary:(NSDictionary *)netDic{
    self.postInfoID = [XYTools getIntFromDic:netDic withKey:@"id"];
    
    self.createdTime = [XYTools getStringFromDic:netDic withKey:@"createdTime"];
    
    //@"PENDING_AUDIT" "SHOWING" todo 还有一个状态未知 已经 认可 忽略 取消 删除 这三个状态我猜的
    self.status = [XYTools getStringFromDic:netDic withKey:@"status"];
    if (self.status) {
        if ([self.status isEqualToString:@"PENDING_AUDIT"]) {
            self.showingStatus = @"审核中";
        }else if ([self.status isEqualToString:@"SHOWING"]){
            self.showingStatus = @"";
        }else if ([self.status isEqualToString:@"CANCELED"]){
            self.showingStatus = @"";
        }else if ([self.status isEqualToString:@"DELETED"]){
            self.showingStatus = @"已删除";
        }else if ([self.status isEqualToString:@"ACCEPTED"]){
            self.showingStatus = @"已认可";
        }else if ([self.status isEqualToString:@"IGNORED"]){
            self.showingStatus = @"已忽略";
        }
    }
    
    self.title = [XYTools getStringFromDic:netDic withKey:@"title"];
    
    self.postType = [XYTools getStringFromDic:netDic withKey:@"postType"];
    //todo 可能需要修改添加的地方
    if (self.postType) {
        if ([self.postType isEqualToString:CarProductType_RentCar]) {
            self.showingPostType = @"租车服务";
        }else if ([self.postType isEqualToString:CarProductType_HelpDrive]){
            self.showingPostType = @"代驾服务";
        }else if ([self.postType isEqualToString:CarProductType_CarPool]){
            self.showingPostType = @"拼车服务";
        }else if ([self.postType isEqualToString:HouseProductHouseRoomType_ChuShou]){
            self.showingPostType = @"房屋出售";
        }else if ([self.postType isEqualToString:HouseProductHouseRoomType_QiuGou]){
            self.showingPostType = @"房屋求购";
        }else if ([self.postType isEqualToString:HouseProductHouseRoomType_QiuZu]){
            self.showingPostType = @"房屋求租";
        }else if ([self.postType isEqualToString:HouseProductHouseRoomType_RentHouse]){
            self.showingPostType = @"整套租赁";
        }else if ([self.postType isEqualToString:HouseProductHouseRoomType_RentRoom]){
            self.showingPostType = @"单间租赁";
        }else if ([self.postType isEqualToString:HouseProductFactoryRoomType_ChuZu]){
            self.showingPostType = @"厂房出租";
        }else if ([self.postType isEqualToString:HouseProductFactoryRoomType_QiuZu]){
            self.showingPostType = @"厂房求租";
        }else if ([self.postType isEqualToString:HouseProductFactoryRoomType_ChuShou]){
            self.showingPostType = @"厂房出售";
        }else if ([self.postType isEqualToString:HouseProductFactoryRoomType_QiuGou]){
            self.showingPostType = @"厂房求购";
        }else if ([self.postType isEqualToString:FactoryProductType_FactoryProduct]){
            self.showingPostType = @"工业产品";
        }
    }
    //    NSLog(@"%@  %@",self.postType,self.showingPostType);
    self.matchedCount = [XYTools getIntFromDic:netDic withKey:@"matchedCount"];
    
    self.onTop = [XYTools getBoolFromDic:netDic withKey:@"onTop"];
    
    return self;
}

@end
