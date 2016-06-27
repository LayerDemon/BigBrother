//
//  WantHouseProduct.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "WantHouseProduct.h"

@implementation WantHouseProduct

-(instancetype)init{
    self = [super init];
    if (self) {
        self.baseType = BaseProductTypeHouse;
        self.houseType = HouseProductNone;
    }
    return self;
}

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic{
    WantHouseProduct *product = [[WantHouseProduct alloc] init];
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
    
    self.isSupply = NO;
    
    self.price = [XYTools getIntFromDic:netDic withKey:@"price"];
    
    self.area = [XYTools getIntFromDic:netDic withKey:@"area"];
    
    NSString *postType = [XYTools getStringFromDic:netDic withKey:@"postType"];
    
    if ([postType isEqualToString:HouseProductHouseRoomType_QiuZu]) {
        self.houseType = HouseProductFangWuQiuZu;
    }else if ([postType isEqualToString:HouseProductHouseRoomType_QiuGou]){
        self.houseType = HouseProductFangWuQiuGou;
    }
    
    self.address = [XYTools getStringFromDic:netDic withKey:@"address"];
    
    self.expectedTypeId = [XYTools getIntFromDic:netDic withKey:@"expectedTypeId"];
    
    self.expectedTypeValue = [XYTools getStringFromDic:netDic withKey:@"expectedTypeValue"];
    
    self.imNumber = [XYTools getStringFromDic:netDic withKey:@"im_number"];
    
    if (self.nickname && self.imNumber) {
        self.creatorUserDic = @{@"id":@(self.creator),@"nickname":self.nickname,@"imNumber":self.imNumber};
    }
    
    return self;
}


@end
