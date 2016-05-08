//
//  HelpDriveProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProduct.h"
#import "CarProduct.h"

@interface HelpDriveProduct :CarProduct

@property (nonatomic,assign) int dayCount;

@property (nonatomic,strong) NSArray *serviceTypeList;

+(instancetype)productWithNetWorkDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetworkDictionary:(NSDictionary *)netDic;

@end
