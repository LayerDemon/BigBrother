//
//  BBUserDefaults.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBUserDefaults : NSObject

+(void)setIsLogin:(BOOL)isLogin;
+(BOOL)getIsLogin;

+(void)setIsNotFirshLuanch:(BOOL)isfirst;
+(BOOL)getIsNotFirshLuanch;

//注销登录
+(void)resetLoginStatus;

+(void)setUserDictionary:(NSDictionary *)userDic;
+(NSDictionary *)getUserDic;

+(void)setUserID:(NSString *)uid;
+(NSString *)getUserID;

+(void)setUserPhone:(NSString *)phone;
+(NSString *)getUserPhone;

+(void)setUserPassword:(NSString *)password;
+(NSString *)getUserPassword;

+(void)setUserIsSigned:(BOOL)isSigned;
+(BOOL)getUserIsSigned;

+(void)setUserUserName:(NSString *)username;
+(NSString *)getUserUserName;

+(void)setUserNickName:(NSString *)nickName;
+(NSString *)getUserNickName;

+(void)setUserSex:(NSString *)sex;
+(NSString *)getUserSex;

+(void)setUserDistrictIdString:(NSString *)districtIdString;
+(NSString *)getUserDistrictIdString;

+(void)setUserDistrictFullNameString:(NSString *)districtFullNameString;
+(NSString *)getUserDistrictFullNameString;

+(void)setUserAuthType:(NSString *)authType;
+(NSString *)getUserAuthType;

+(void)setUserAuthStatusString:(NSString *)authStatusString;
+(NSString *)getUserAuthStatusString;

+(void)setUserBalance:(int)balance;
+(int)getUserBalance;


+(void)setUserLastLoginTime:(NSString *)lastLoginTime;
+(NSString *)getUserLastLoginTime;

+(void)setUserHeadImage:(UIImage *)image;
+(UIImage *)getUserHeadImage;

+(void)setUserHeadImageUrl:(NSString *)imageurl;
+(NSString *)getUserHeadImageUrl;

+(void)setCityDictionary:(NSDictionary *)dictionary;
+(NSDictionary *)getCityDictionary;
+(int)getCityID;
+(NSString *)getCityName;

@end
