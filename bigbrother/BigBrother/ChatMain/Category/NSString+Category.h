//
//  NSString+Category.h
//  FB
//
//  Created by tfc on 15/8/19.
//  Copyright (c) 2015年 ----四川筷子科技有限公司----. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithObject:(id) object;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+ (NSString *)specialCharacterParse:(id)object;

//中文逗号转英文
+ (NSString *)formatEnglishCommaWithText:(NSString *)text;

//+ (NSString *)deviceIdString;
//数据库名
+ (NSString *)dbnameString;
//+ (NSString *)tokenString;
//+ (NSString *)contactKeyString;
//+ (NSString *)imusernameString;
//+ (NSString *)impasswordString;

+ (NSString *)phoneNumerWithString:(NSString *)string;

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
+ (NSString *)md5:(NSString *)str;

+ (CGSize)sizeWithString:(NSString *)string Font:(UIFont *)font maxWidth:(CGFloat)maxWidth NumberOfLines:(NSInteger)numberOfLines;



//判断字符串为空和只有空格
- (BOOL)isBlankString;
+ (BOOL)isBlankStringWithString:(NSString *)string;
//+ (NSString *)parameterWithcsName:(NSString *)csName webaddress:(NSString *)webaddress;
@end
