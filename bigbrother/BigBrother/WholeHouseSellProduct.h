//
//  WholeHouseSellProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HouseProduct.h"

@interface WholeHouseSellProduct : HouseProduct

@property (nonatomic,assign) float price;

@property (nonatomic,assign) int area;

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;

@end
