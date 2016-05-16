//
//  UnitedInfoModel.h
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitedInfoModel : NSObject

@property (strong, nonatomic, readonly) id        unitedDetailData;

//获取门派资料
- (void)getUnitedInfoWithId:(NSString *)idString limit:(NSString *)limit;

@end
