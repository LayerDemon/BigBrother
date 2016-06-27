//
//  FactoryHouseProduct.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FactoryHouseProduct.h"

@implementation FactoryHouseProduct

-(instancetype)init{
    self = [super init];
    if (self) {
        self.baseType = BaseProductTypeHouse;
    }
    return self;
}

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic{
    FactoryHouseProduct *product = [[FactoryHouseProduct alloc] init];
    return [product updateWithNetworkDictionary:netDic];
}

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic{
//    self.imNumber = [XYTools getStringFromDic:netDic withKey:@"im_number"];
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
    
    self.price = [XYTools getFloatFromDic:netDic withKey:@"price"];
    
    self.area = [XYTools getIntFromDic:netDic withKey:@"area"];
    
    self.postType = [XYTools getStringFromDic:netDic withKey:@"postType"];
    
    if ([self.postType isEqualToString:HouseProductFactoryRoomType_ChuZu]) {
        self.houseType = HouseProductChangFangZuNin;
        self.isSupply = YES;
    }else if ([self.postType isEqualToString:HouseProductFactoryRoomType_ChuShou]) {
        self.houseType = HouseProductChangFangXiaoShou;
        self.isSupply = YES;
    }else if ([self.postType isEqualToString:HouseProductFactoryRoomType_QiuGou]) {
        self.houseType = HouseProductChangFangQiuGou;
        self.isSupply = NO;
    }else if ([self.postType isEqualToString:HouseProductFactoryRoomType_QiuZu]) {
        self.houseType = HouseProductChangFangQiuZu;
        self.isSupply = NO;
    }else{
        self.houseType = HouseProductNone;
    }
    
    self.address = [XYTools getStringFromDic:netDic withKey:@"address"];
    
    self.imNumber = [XYTools getStringFromDic:netDic withKey:@"im_number"];
    
    if (self.nickname && self.imNumber) {
        self.creatorUserDic = @{@"id":@(self.creator),@"nickname":self.nickname,@"imNumber":self.imNumber};
    }
    
    return self;
}

@end

