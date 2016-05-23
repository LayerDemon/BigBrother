//
//  NSString+Category.m
//  FB
//
//  Created by tfc on 15/8/19.
//  Copyright (c) 2015年 ----四川筷子科技有限公司----. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

@interface NSString ()


@end

@implementation NSString (Category)


+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+ (NSString *)jsonStringWithNumber:(NSNumber *)number
{
    return [NSString stringWithFormat:@"%@",number];
}

+ (NSString *)jsonStringWithDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-M-dd HH:mm:ss"];
    
    return [NSString stringWithFormat:@"%@",[format stringFromDate:date]];
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }else if ([object isKindOfClass:[NSNumber class]]){
        value = [self jsonStringWithNumber:object];
    }else if ([object isKindOfClass:[NSDate class]]){
        value = [self jsonStringWithDate:object];
        
    }
    return value;
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *)specialCharacterParse:(id)object
{
    NSString *tempStr = [NSString stringWithFormat:@"%@",object];
    NSString *utf8Str = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                      (CFStringRef)tempStr,
                                                                                      NULL,
                                                                                      CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                      kCFStringEncodingUTF8);
    return utf8Str;
}



//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    // CC_MD5( cStr, strlen(cStr), digest ); 这里的用法明显是错误的，但是不知道为什么依然可以在网络上得以流传。当srcString中包含空字符（\0）时
    CC_MD5( cStr,(int)srcString.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr,(int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//中文逗号转英文
+ (NSString *)formatEnglishCommaWithText:(NSString *)text
{
    NSMutableString *tempStr = [NSMutableString stringWithString:text];
    for (NSInteger i = 0; i < text.length ; i++ ) {
        NSRange range1 = [tempStr rangeOfString:@"，"];
        if (range1.location != NSNotFound) {
            [tempStr replaceCharactersInRange:range1 withString:@","];
            continue;
        }else{
            break;
        }
    }
    return tempStr;
}


//-------------------------------------------------
//获取设备id（服务器返回）
+ (NSString *)deviceIdString
{
    NSString *string = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"]];
    if (string) {
        return string;
    }
    return @"";
}
//数据库名
+ (NSString *)dbnameString
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSArray *versionArray = [currentVersion componentsSeparatedByString:@"."];
    NSInteger versionNumber = 0;
    for (NSInteger i = 0; i < versionArray.count; i ++) {
        versionNumber += [versionArray[i] integerValue] * pow(10, versionArray.count - i -1);
    }
    
    NSString  *dbname = [NSString stringWithFormat:@"%@_SHUXIANG.sqlite",@(versionNumber)];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastDBname"]) {
        [[NSUserDefaults standardUserDefaults] setObject:dbname forKey:@"lastDBname"];
    }
    NSString *lastDBname = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDBname"];
    if ([lastDBname integerValue] < [dbname integerValue]) {
        [CACHE_MANAGER deleteDatabseWithDbname:lastDBname];
        [[NSUserDefaults standardUserDefaults] setObject:dbname forKey:@"lastDBname"];
    }
    
    return dbname;
}

////获取tokenStr
//+ (NSString *)tokenString
//{
//    NSDictionary *loginInfo = [NSDictionary dictionaryWithUserDefaultsKey:@"loginInfo"];
//    if (loginInfo) {
//        NSString *token = loginInfo[@"token"];
//        return token;
//    }
//    return @"";
//}


////显示通讯录好友缓存key
//+ (NSString *)contactKeyString
//{
//    NSDictionary *userDic = [NSDictionary userDic];
//    
//    return [NSString stringWithFormat:@"contact%@",userDic[@"id"]];
//}
//
////获取imusername
//+ (NSString *)imusernameString
//{
//    NSDictionary *loginInfo = [NSDictionary dictionaryWithUserDefaultsKey:LOGININFO_KEY];
//    
//    return [NSString stringWithFormat:@"%@",loginInfo[@"imusername"]];
//}
//
////获取impassword
//+ (NSString *)impasswordString
//{
//    NSDictionary *loginInfo = [NSDictionary dictionaryWithUserDefaultsKey:LOGININFO_KEY];
//    
//    return [NSString stringWithFormat:@"%@",loginInfo[@"impassword"]];
//}


//电话号码判断
+ (NSString *)phoneNumerWithString:(NSString *)string
{
    NSRange range1 = [string rangeOfString:@"+"];
    if (range1.location != NSNotFound) {
        string = [string substringFromIndex:range1.location+3];
//        NSLog(@"++++++++|%@",string);
    }
    
    NSRange range2 = [string rangeOfString:@")"];
    if (range2.location != NSNotFound) {
        string = [string substringFromIndex:range2.location+1];
    }
    
    NSArray *array1 = [string componentsSeparatedByString:@"-"];
    string = [array1 componentsJoinedByString:@""];
    NSArray *array2 = [string componentsSeparatedByString:@" "];
    string = [array2 componentsJoinedByString:@""];
    
    return [self valiMobile:string];
}


//电话号码判断
+ (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
//        NSLog(@"非手机：%@",mobile);
        return nil;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return mobile;
        }else{
//            NSLog(@"非手机：%@",mobile);
            return nil;
        }
    }
    return nil;
}

//时间转换


//-------------------------------------------------

+ (CGSize)sizeWithString:(NSString *)string Font:(UIFont *)font maxWidth:(CGFloat)maxWidth NumberOfLines:(NSInteger)numberOfLines
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, maxWidth,0)];
    id tempObject = string;
    if (tempObject == [NSNull null] ) {
        string = @"";
    }
    
    label.text = string;
//    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = numberOfLines;
    label.font = font;
    [label sizeToFit];
    return CGSizeMake(label.frame.size.width,label.frame.size.height);
}


//判断字符串为空和只有空格
- (BOOL)isBlankString{
    
    if (self == nil) {
        return YES;
    }
    
    if (self == NULL) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isBlankStringWithString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//+ (NSString *)parameterWithcsName:(NSString *)csName webaddress:(NSString *)webaddress
//{
//    NSError *error;
//    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",csName];
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
//                                                                           options:NSRegularExpressionCaseInsensitive
//                                                                             error:&error];
//    
//    // 执行匹配的过程
//    // NSString *webaddress=@"http://wgpc.wzsafety.gov.cn/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
//    NSArray *matches = [regex matchesInString:webaddress
//                                      options:0
//                                        range:NSMakeRange(0, [webaddress length])];
//    for (NSTextCheckingResult *match in matches) {
//        
//        
//        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
//        //    NSLog(@"分组2所对应的串:%@\n",tagValue);
//        return tagValue;
//    }
//    return @"";
//}





@end
