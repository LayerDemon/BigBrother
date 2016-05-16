//
//  NetworkingManager.h
//  Class1Demo
//
//  Created by DreamHack on 15-5-18.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//
#import "AFNetworking.h"
typedef void(^SuccessBlock)(NSURLSessionDataTask * operation, id responseObj);

typedef void(^FailBlock)(NSError * error, id responseObj);

#import <Foundation/Foundation.h>

@interface NetworkingManager : NSObject

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure;


+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure;

+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure;


+ (void)post2WithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure;

+ (void)get2WithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure;

@end
