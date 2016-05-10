//
//  BBUserDefaults.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "BBUserDefaults.h"

@implementation BBUserDefaults

+(NSString *)getSaveKeyWithSimpleSaveKey:(NSString *)simpleSaveKey{
    NSString *reKey = [NSString stringWithFormat:@"BBUD_%@_%@",[self getUserID],simpleSaveKey];
    return reKey;
}

static NSString *LoginSaveKey = @"LoginSaveKey";
+(void)setIsLogin:(BOOL)isLogin{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@(isLogin) forKey:LoginSaveKey];
    [userdefaults synchronize];
}

+(BOOL)getIsLogin{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:LoginSaveKey] boolValue];
}

static NSString *FirshLuanchSaveKey = @"FirshLuanchSaveKey";
+(void)setIsNotFirshLuanch:(BOOL)isfirst{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@(isfirst) forKey:FirshLuanchSaveKey];
    [userdefaults synchronize];
}
+(BOOL)getIsNotFirshLuanch{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:FirshLuanchSaveKey] boolValue];
}

//注销登录
+(void)resetLoginStatus{
    [self setUserDictionary:nil];
    [self setUserID:@""];
    [self setUserHeadImage:nil];
    [self setUserPhone:nil];
    [self setUserPassword:nil];
    [self setIsLogin:NO];
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
}

static NSString *UserDicSaveKey = @"UserDicSaveKey";
+(void)setUserDictionary:(NSDictionary *)userDic
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!userDic) {
        [userdefaults removeObjectForKey:UserDicSaveKey];
    }else{
        NSString *jsonStr = [NSString jsonStringWithDictionary:userDic];
        [userdefaults setObject:jsonStr forKey:UserDicSaveKey];
    }
    [userdefaults synchronize];
}

+(NSDictionary *)getUserDic
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *jsonStr = [userdefaults objectForKey:UserDicSaveKey];
    NSDictionary *userDic = [jsonStr objectFromJSONString];
    if (!userDic) {
        return nil;
    }
    return userDic;
}

static NSString *UIDSaveKey = @"UIDSaveKey";
+(void)setUserID:(NSString *)uid{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!uid) {
        [userdefaults removeObjectForKey:UIDSaveKey];
    }else{
        [userdefaults setObject:uid forKey:UIDSaveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getUserID{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userdefaults objectForKey:UIDSaveKey];
    if (!userID) {
        return nil;
    }
    return userID;
}

static NSString *UserPhoneSaveKey = @"UserPhoneSaveKey";
+(void)setUserPhone:(NSString *)phone{
    NSString *saveKey = UserPhoneSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!phone || [phone isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:phone forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserPhone{
    NSString *saveKey = UserPhoneSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserPasswordSaveKey = @"UserPasswordSaveKey";
+(void)setUserPassword:(NSString *)password{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserPasswordSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!password || [password isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:password forKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getUserPassword{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserPasswordSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserIsSignedSaveKey = @"UserIsSignedSaveKey";
+(void)setUserIsSigned:(BOOL)isSigned{
    NSString *saveKey = UserIsSignedSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@(isSigned) forKey:saveKey];
    [userdefaults synchronize];
}
+(BOOL)getUserIsSigned{
    NSString *saveKey = UserIsSignedSaveKey;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:saveKey] boolValue];
}

static NSString *UserUserNameSaveKey = @"UserUserNameSaveKey";
+(void)setUserUserName:(NSString *)username{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserUserNameSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!username || [username isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:username forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserUserName{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserUserNameSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserNickNameSaveKey = @"UserNickNameSaveKey";
+(void)setUserNickName:(NSString *)nickName{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserNickNameSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!nickName || [nickName isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:nickName forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserNickName{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserNickNameSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserSexSaveKey = @"UserSexSaveKey";
+(void)setUserSex:(NSString *)sex{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserSexSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!sex || [sex isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:sex forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserSex{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserSexSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserDistrictIdStringSaveKey = @"UserDistrictIdStringSaveKey";
+(void)setUserDistrictIdString:(NSString *)districtIdString{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserDistrictIdStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!districtIdString || [districtIdString isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:districtIdString forKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getUserDistrictIdString{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserDistrictIdStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}


static NSString *UserDistrictFullNameStringSaveKey = @"UserDistrictIdStringSaveKey";
+(void)setUserDistrictFullNameString:(NSString *)districtFullNameString{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserDistrictFullNameStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!districtFullNameString || [districtFullNameString isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:districtFullNameString forKey:saveKey];
    }
    [userdefaults synchronize];
}

+(NSString *)getUserDistrictFullNameString{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserDistrictFullNameStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserAuthTypeSaveKey = @"UserAuthTypeSaveKey";
+(void)setUserAuthType:(NSString *)authType{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserAuthTypeSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!authType || [authType isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:authType forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserAuthType{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserAuthTypeSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserAuthStatusStringSaveKey = @"UserAuthStatusStringSaveKey";
+(void)setUserAuthStatusString:(NSString *)authStatusString{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserAuthStatusStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!authStatusString || [authStatusString isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:authStatusString forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserAuthStatusString{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserAuthStatusStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserBalanceStringSaveKey = @"UserBalanceStringSaveKey";
+(void)setUserBalance:(int)balance{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserBalanceStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (balance <= 0) {
        balance = 0;
    }
    [userdefaults setObject:@(balance) forKey:saveKey];
    [userdefaults synchronize];
}
+(int)getUserBalance{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserBalanceStringSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [[userdefaults objectForKey:saveKey] intValue];
}

static NSString *UserLastLoginTimeSaveKey = @"UserLastLoginTimeSaveKey";
+(void)setUserLastLoginTime:(NSString *)lastLoginTime{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserLastLoginTimeSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (!lastLoginTime || [lastLoginTime isEqualToString:@""]) {
        [userdefaults removeObjectForKey:saveKey];
    }else{
        [userdefaults setObject:lastLoginTime forKey:saveKey];
    }
    [userdefaults synchronize];
}
+(NSString *)getUserLastLoginTime{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserLastLoginTimeSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:saveKey];
}

static NSString *UserHeadImageSaveKey = @"UserHeadImageSaveKey";
+(void)setUserHeadImage:(UIImage *)image{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (image) {
        NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
        [userdefaults setObject:imageData forKey:saveKey];
        [userdefaults synchronize];
    }else{
        [userdefaults removeObjectForKey:saveKey];
    }
}

+(UIImage *)getUserHeadImage{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageSaveKey];
    NSData *imageData;
    imageData = [[NSUserDefaults standardUserDefaults] objectForKey:saveKey];
    if(imageData){
        UIImage *yourUIImage = [NSKeyedUnarchiver unarchiveObjectWithData:imageData];
        if (yourUIImage) {
            return yourUIImage;
        }
    }
    return nil;
}

static NSString *UserHeadImageURLSaveKey = @"UserHeadImageURLSaveKey";
+(void)setUserHeadImageUrl:(NSString *)imageurl{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageURLSaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (imageurl) {
        [userdefaults setObject:imageurl forKey:saveKey];
        [userdefaults synchronize];
    }else{
        [userdefaults removeObjectForKey:saveKey];
    }
}

+(NSString *)getUserHeadImageUrl{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:UserHeadImageURLSaveKey];
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:saveKey];
    return urlString;
}

static NSString *CityDictionarySaveKey = @"CityDictionarySaveKey";
+(void)setCityDictionary:(NSDictionary *)dictionary{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:CityDictionarySaveKey];
    
    if (dictionary && dictionary.count != 0) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSDictionary dictionaryWithDictionary:dictionary]];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:saveKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+(NSDictionary *)getCityDictionary{
    NSString *saveKey = [self getSaveKeyWithSimpleSaveKey:CityDictionarySaveKey];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSData *tmp = [userdefaults objectForKey:saveKey];
    if (tmp) {
        NSDictionary *arrTmp = [NSKeyedUnarchiver unarchiveObjectWithData:tmp];
        if (arrTmp) {
            return [NSDictionary dictionaryWithDictionary:arrTmp];
        }
    }
    return nil;
}

+(int)getCityID{
    NSDictionary *dic = [self getCityDictionary];
    int _id = [dic[@"id"] intValue];
    return _id;
}

+(NSString *)getCityName{
    NSDictionary *dic = [self getCityDictionary];
    NSString *name = dic[@"name"];
    return name;
}

@end
