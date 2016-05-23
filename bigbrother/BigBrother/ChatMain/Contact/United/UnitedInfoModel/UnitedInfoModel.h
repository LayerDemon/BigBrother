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

@property (strong, nonatomic, readonly) id        addAdminData;
@property (strong, nonatomic, readonly) id        removeAdminData;
@property (strong, nonatomic, readonly) id        setSpeakData;

@property (strong, nonatomic, readonly) id        getUnitedRankData;
@property (strong, nonatomic, readonly) id        changeRankNameData;
@property (strong, nonatomic, readonly) NSDictionary *joinData;

//获取门派资料
- (void)getUnitedInfoWithId:(NSString *)idString limit:(NSString *)limit;

//获取门派活动
- (void)getUnitedActivityWithGroupId:(NSString *)groupId page:(NSString *)page;

//创建门派活动
- (void)createUnitedActivityWithGroupId:(NSInteger)groupId creator:(NSInteger)creator name:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime location:(NSString *)location cost:(NSInteger)cost content:(NSString *)content images:(NSArray *)images;

//退出门派
- (void)exitUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId;
//解散群
- (void)dismissUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId;
//转让群
- (void)transterUnitedWithGroupId:(NSString *)groupId userId:(NSString *)userId transferTo:(NSString *)transferTo;

#pragma mark -- 门派处理
//设置管理员
- (void)addUnitedAdminsWithOwnerId:(NSString *)ownerId userIds:(NSString *)userIds groupId:(NSString *)groupId;
//移除管理员
- (void)removeUnitedAdminsWithOwnerId:(NSString *)ownerId adminId:(NSString *)adminId groupId:(NSString *)groupId;
//设置门派禁言
- (void)setUnitedSpearkWithGroupId:(NSString *)groupId userId:(NSString *)userId isBan:(NSString *)isBan;
//获取门派等级
- (void)getUnitedRankWithGroupId:(NSString *)groupId;
//修改等级名称
- (void)changeUnitedRankNameWithUserId:(NSString *)userId groupGradeId:(NSString *)groupGradeId name:(NSString *)name;

/**
 *  申请加入群
 */
- (void)postJoinDataWithGroupId:(NSNumber *)groupId userId:(NSNumber *)userId message:(NSString *)message;

@end
