//
//  XYTools.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "XYTools.h"

@implementation XYTools

+(CGSize)getSizeWithString:(NSString *)contentString andSize:(CGSize)size andFont:(UIFont *)font{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font};
        CGSize size1 =[contentString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        return size1;
    }else{
        return [contentString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
}

+(NSString *)parseTimeWithTimeStamp:(long long)dbdateline{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dbdateline];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)parseDateNow{
    NSTimeInterval timein = [[NSDate date] timeIntervalSince1970];
    return [self parseTimeWithTimeStamp:(long long)timein];
}

+(NSString *)judgeIfToday:(NSString *)timeString{
    NSArray *timeArray = [timeString componentsSeparatedByString:@" "];
    NSString *dateTime = [timeArray firstObject];
    if ([dateTime isEqualToString:[self parseDateNow]]) {
        return @"今天";
    }else{
        return dateTime;
    }
}

+(NSString *)getStringFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    if (!key) {
        return nil;
    }
    if (!dic) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString *tmpString = [dic objectForKey:key];
    if (!tmpString) {
        return nil;
    }
    if ([tmpString isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return tmpString;
}

+(int)getFloatFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    NSString *tmp = [XYTools getStringFromDic:dic withKey:key];
    if (!tmp) {
        return 0;
    }
    return [tmp floatValue];
}

+(int)getIntFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    NSString *tmp = [XYTools getStringFromDic:dic withKey:key];
    if (!tmp) {
        return 0;
    }
    return [tmp intValue];
}

+(BOOL)getBoolFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    NSString *tmp = [XYTools getStringFromDic:dic withKey:key];
    if (!tmp) {
        return NO;
    }
    return [tmp boolValue];
}

+(long)getLongFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    NSString *tmp = [XYTools getStringFromDic:dic withKey:key];
    if (!tmp) {
        return 0;
    }
    return (long)[tmp longLongValue];
}

+(long long)getLongLongFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    NSString *tmp = [XYTools getStringFromDic:dic withKey:key];
    if (!tmp) {
        return 0;
    }
    return [tmp longLongValue];
}

+(NSArray *)getArrayFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    if (!key) {
        return nil;
    }
    if (!dic) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSArray *tmp = [dic objectForKey:key];
    if (!tmp) {
        return nil;
    }
    if ([tmp isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if (![tmp isKindOfClass:[NSArray class]] || ![tmp isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    return tmp;
}

+(NSDictionary *)getDictionaryFromDic:(NSDictionary *)dic withKey:(NSString *)key{
    if (!key) {
        return nil;
    }
    if (!dic) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *tmp = [dic objectForKey:key];
    if (!tmp) {
        return nil;
    }
    if ([tmp isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if (![tmp isKindOfClass:[NSDictionary class]] || ![tmp isKindOfClass:[NSMutableDictionary class]]) {
        return nil;
    }
    return tmp;
}

+(BOOL)checkString:(NSString *)string canEmpty:(BOOL)canEmpty{
    if (!string || ![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (canEmpty) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
    }
    NSString *tmpString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([tmpString isEqualToString:@""]) {
        return NO;
    }
    if ([string rangeOfString:@"*"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"&"].length != 0) {
        return NO;
    }
    if ([string rangeOfString:@"="].length != 0) {
        return NO;
    }
    return YES;
}




@end
