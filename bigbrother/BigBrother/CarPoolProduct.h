//
//  CarPoolProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CarProduct.h"

@interface CarPoolProduct : CarProduct

@property (nonatomic,copy) NSString *start;

@property (nonatomic,copy) NSString *destination;

@property (nonatomic,copy) NSString *leaveTime;

@property (nonatomic,copy) NSString *carPoolType;

@property (nonatomic,assign) int seatCount;

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;

@end
