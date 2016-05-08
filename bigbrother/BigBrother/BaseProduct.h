//
//  BaseProduct.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseProduct : NSObject

@property (nonatomic,assign) BaseProductType baseType;

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,assign) long creator;

@property (nonatomic,copy) NSString *districtFullName;

@property (nonatomic,assign) int districtID;

@property (nonatomic,assign) long _id;

@property (nonatomic,strong) NSArray *images;

@property (nonatomic,copy) NSString *introduction;

@property (nonatomic,strong) NSArray *keywords;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *phoneNumber;

@property (nonatomic,assign) BOOL isSupply;

@property (nonatomic,copy) NSString *title;

@end
