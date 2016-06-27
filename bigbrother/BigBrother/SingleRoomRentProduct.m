//
//  SingleRoomRentProduct.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SingleRoomRentProduct.h"

@implementation SingleRoomRentProduct

-(instancetype)init{
    self = [super init];
    if (self) {
        self.baseType = BaseProductTypeHouse;
        self.houseType = HouseProductDanjianZuNin;
    }
    return self;
}

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic{
    SingleRoomRentProduct *product = [[SingleRoomRentProduct alloc] init];
    return [product updateWithNetworkDictionary:netDic];
}

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic{
    
    
    self.createTime = [XYTools getStringFromDic:netDic withKey:@"createdTime"];
    
    self.creator = [XYTools getLongFromDic:netDic withKey:@"creator"];
    
    self.districtID = [XYTools getIntFromDic:netDic withKey:@"districtId"];
    
    self._id = [XYTools getLongFromDic:netDic withKey:@"id"];
    
    self.districtFullName = [XYTools getStringFromDic:netDic withKey:@"districtFullName"];
    
    self.introduction = [XYTools getStringFromDic:netDic withKey:@"introduction"];
    
    self.nickname = [XYTools getStringFromDic:netDic withKey:@"nickname"];
    
    self.phoneNumber = [XYTools getStringFromDic:netDic withKey:@"phoneNumber"];
    
    self.title = [XYTools getStringFromDic:netDic withKey:@"title"];
    
    self.images = [XYTools getArrayFromDic:netDic withKey:@"images"];
    self.keywords = [XYTools getArrayFromDic:netDic withKey:@"keywords"];
    
    //todo 没有返回供需的信息 单间租赁 暂时只提供provide类型
    self.isSupply = YES;
    
    self.price = [XYTools getIntFromDic:netDic withKey:@"price"];
    
    self.area = [XYTools getIntFromDic:netDic withKey:@"area"];
    
    self.floor = [XYTools getIntFromDic:netDic withKey:@"floor"];
    
    self.totalFloor = [XYTools getIntFromDic:netDic withKey:@"totalFloor"];
    
    self.communityName = [XYTools getStringFromDic:netDic withKey:@"communityName"];
    
    self.communityAddress = [XYTools getStringFromDic:netDic withKey:@"communityAddress"];
    
    self.imNumber = [XYTools getStringFromDic:netDic withKey:@"im_number"];
    
    if (self.nickname && self.imNumber) {
        self.creatorUserDic = @{@"id":@(self.creator),@"nickname":self.nickname,@"imNumber":self.imNumber};
    }
    
    return self;
}

@end
