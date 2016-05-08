//
//  WantHouseProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HouseProduct.h"

@interface WantHouseProduct : HouseProduct

@property (nonatomic,assign) int price;

@property (nonatomic,assign) int area;

@property (nonatomic,assign) int expectedTypeId;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *expectedTypeValue;

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;

@end
