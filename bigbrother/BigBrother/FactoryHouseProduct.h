//
//  FactoryHouseProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HouseProduct.h"

@interface FactoryHouseProduct : HouseProduct

@property (nonatomic,assign) float price;

@property (nonatomic,assign) int area;

@property (nonatomic,copy) NSString *postType;

@property (nonatomic,copy) NSString *address;

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;

@end
