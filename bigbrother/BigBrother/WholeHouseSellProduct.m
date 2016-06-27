//
//  WholeHouseSellProduct.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "WholeHouseSellProduct.h"

@implementation WholeHouseSellProduct

-(instancetype)init{
    self = [super init];
    if (self) {
        self.baseType = BaseProductTypeHouse;
        self.houseType = HouseProductFangWuXiaoShou;
    }
    return self;
}

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic{
    WholeHouseSellProduct *product = [[WholeHouseSellProduct alloc] init];
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
    
    self.isSupply = YES;
    
    self.price = [XYTools getFloatFromDic:netDic withKey:@"price"];
    
    self.area = [XYTools getIntFromDic:netDic withKey:@"area"];
    
    self.imNumber = [XYTools getStringFromDic:netDic withKey:@"im_number"];
    
    if (self.nickname && self.imNumber) {
        self.creatorUserDic = @{@"id":@(self.creator),@"nickname":self.nickname,@"imNumber":self.imNumber};
    }
    
    return self;
}

@end
