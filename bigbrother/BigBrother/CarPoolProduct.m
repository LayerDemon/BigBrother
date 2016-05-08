//
//  CarPoolProduct.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CarPoolProduct.h"

@implementation CarPoolProduct

-(instancetype)init{
    self = [super init];
    if (self) {
        self.baseType = BaseProductTypeCar;
        self.carType = CarProductPinChe;
    }
    return self;
}

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic{
    CarPoolProduct *product = [[CarPoolProduct alloc] init];
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
    
    NSString *supplyString = [XYTools getStringFromDic:netDic withKey:@"supplyDemandType"];
    self.isSupply = NO;
    if (supplyString) {
        if ([supplyString isEqualToString:@"PROVIDE"]) {
            self.isSupply = YES;
        }
    }
    
    self.carPoolType = [XYTools getStringFromDic:netDic withKey:@"carpoolType"];
    
    self.start = [XYTools getStringFromDic:netDic withKey:@"start"];
    
    self.destination = [XYTools getStringFromDic:netDic withKey:@"destination"];
    
    self.leaveTime = [XYTools getStringFromDic:netDic withKey:@"leaveTime"];
    
    self.seatCount = [XYTools getIntFromDic:netDic withKey:@"seatCount"];
    
    return self;
}


@end
