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
@property (strong, nonatomic, readonly) id        exitUnitedData;
@property (strong, nonatomic, readonly) id        dismissUnitedData;
@property (strong, nonatomic, readonly) id        transterUnitedData;

//获取门派资料
- (void)getUnitedInfoWithId:(NSString *)idString limit:(NSString *)limit;

//获取门派活动
- (void)getUnitedActivityWithGroupId:(NSString *)groupId page:(NSString *)page;

//创建门派活动
- (void)createUnitedActivityWithGroupId:(NSString *)groupId creator:(NSString *)creator name:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime location:(NSString *)location cost:(NSString *)cost content:(NSString *)content images:(NSArray *)images;

//退出门派
- (void)exitUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId;
//解散群
- (void)dismissUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId;
//转让群
- (void)transterUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId transferTo:(NSString *)transferTo;

@end
