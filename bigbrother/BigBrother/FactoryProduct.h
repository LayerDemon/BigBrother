//
//  FactoryProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProduct.h"

@interface FactoryProduct : BaseProduct

@property (nonatomic,assign) long productTypeId;

@property (nonatomic,copy) NSString *productTypeValue;

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;

@end
