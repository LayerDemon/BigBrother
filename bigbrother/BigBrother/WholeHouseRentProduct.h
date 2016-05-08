//
//  WholeHouseRentProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HouseProduct.h"

@interface WholeHouseRentProduct : HouseProduct

@property (nonatomic,assign) int price;

@property (nonatomic,assign) int area;

@property (nonatomic,assign) int floor;

@property (nonatomic,assign) int totalFloor;

@property (nonatomic,copy) NSString *communityName;

@property (nonatomic,copy) NSString *communityAddress;

@property (nonatomic,assign) long roomID;

@property (nonatomic,copy) NSString *roomValue;

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;

@end
