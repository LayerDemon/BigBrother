//
//  XYTools.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYTools : NSObject

+(CGSize)getSizeWithString:(NSString *)contentString andSize:(CGSize)size andFont:(UIFont *)font;

+(NSString *)parseTimeWithTimeStamp:(long long)dbdateline;

+(NSString *)judgeIfToday:(NSString *)timeString;

+(NSString *)getStringFromDic:(NSDictionary *)dic withKey:(NSString *)key;

+(NSArray *)getArrayFromDic:(NSDictionary *)dic withKey:(NSString *)key;

+(NSDictionary *)getDictionaryFromDic:(NSDictionary *)dic withKey:(NSString *)key;

+(int)getFloatFromDic:(NSDictionary *)dic withKey:(NSString *)key;

+(int)getIntFromDic:(NSDictionary *)dic withKey:(NSString *)key;

+(BOOL)getBoolFromDic:(NSDictionary *)dic withKey:(NSString *)key;

+(long long)getLongLongFromDic:(NSDictionary *)dic withKey:(NSString *)key;

+(long)getLongFromDic:(NSDictionary *)dic withKey:(NSString *)key;


+(BOOL)checkString:(NSString *)string canEmpty:(BOOL)canEmpty;

@end
