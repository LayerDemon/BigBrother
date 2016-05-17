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
@property (strong, nonatomic, readonly) id        unitedActivityData;


//获取门派资料
- (void)getUnitedInfoWithId:(NSString *)idString limit:(NSString *)limit;

//获取门派活动
- (void)getUnitedActivityWithGroupId:(NSString *)groupId page:(NSString *)page;

//创建门派活动
- (void)createUnitedActivityWithGroupId:(NSString *)groupId creator:(NSString *)creator name:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime location:(NSString *)location cost:(NSString *)cost content:(NSString *)content images:(NSString *)images;
@end
