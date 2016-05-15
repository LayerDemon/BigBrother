//
//  NetworkingManager.m
//  Class1Demo
//
//  Created by DreamHack on 15-5-18.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "NetworkingManager.h"

#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@interface NetworkingManager ()

@property (strong,nonatomic)UIAlertView *alertView;

@end


@implementation NetworkingManager



+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error,task);
        }
    }];
}

//+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure
//{
//    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
//    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
//    NSString *timeString = [NSString stringWithFormat:@"%f", a];
//    
//    [dataDic setObject:timeString forKey:@"timestamp"];
//    [dataDic setObject:@"method" forKey:@"method"];
//    [dataDic setObject:@"v1" forKey:@"v"];
//    [dataDic setObject:@"ios" forKey:@"client"];
//    [dataDic setObject:@"1.0" forKey:@"app_v"];
//    [dataDic setObject:@"json" forKey:@"format"];
//    
//    [dataDic setValuesForKeysWithDictionary:params];
//    
//    NSMutableString *string = [NSMutableString string];
//    //遍历字典
//    for (NSString *key in dataDic) {
//        [string appendFormat:@"%@=%@&",key,dataDic[key]];
//    }
//
//    NSString * urlString = [NSString stringWithFormat:@"%@%@&%@",BASE_URL,url,string];
//    NSURL * myUrl = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    // 声明一个request
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:myUrl];
//    
//    // 通过request初始化operation
//    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    // 设置网络请求结束后调用的block
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        if (success) {
//            success(operation,string);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error,operation);
//        }
//        NSLog(@"%@",error);
//    }];
//    // 开始请求
//    [operation start];
//}
//
//+ (void)get2WithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure
//{
//    
//    NSMutableString *string = [NSMutableString string];
//    //遍历字典
//    for (NSString *key in params) {
//        [string appendFormat:@"%@=%@&",key,params[key]];
//    }
//    NSURL * myUrl = [NSURL URLWithString:url];
////    NSLog(@"-myurl----%@",myUrl);
//    
//    // 声明一个request
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:myUrl];
//    
//    // 通过request初始化operation
//    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    // 设置网络请求结束后调用的block
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        if (success) {
//            success(operation,string);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error,operation);
//        }
//        NSLog(@"%@",error);
//    }];
//    // 开始请求
//    [operation start];
//}
//
//
//+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure
//{
//    NSMutableString *string = [NSMutableString string];
//    //遍历字典
//    for (NSString *key in params) {
//        [string appendFormat:@"%@=%@&",key,params[key]];
//    }
//    NSLog(@"111%@",[NSString stringWithFormat:@"%@%@",BASE_URL,url]);
//    // 声明一个request
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,url]]];
//    
//    NetworkingManager * net = [[NetworkingManager alloc] init];
//    // 设置请求方式POST
//    [request setHTTPMethod:@"PUT"];
//    // 设置请求参数，通过NSData
//    [request setHTTPBody:[net HTTPBodyWithParams:params]];
//    NSString *authBase64 = [NSString stringWithFormat:@"Basic %@", [NetworkingManager base64Encode:string]];
//    [request setValue:authBase64 forHTTPHeaderField:@"Authorization"];
//    // 通过request初始化operation
//    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    // 设置网络请求结束后调用的block
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        if (success) {
//            success(operation,string);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error,operation);
//        }
//        NSLog(@"%@",error);
//    }];
//    
//    // 开始请求
//    [operation start];
//}
//
//+ (void)putFile
//{
//    // 1. url 最后一个是要上传的文件名
//    NSURL *url = [NSURL URLWithString:@"http://221.236.172.97:8080/test/userapi/account/profile"]; //abcd为文件名
//    
//    // 2. request
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"PUT";
//    //    request.HTTPMethod = @"DELETE";
//    
//    // 设置用户授权
//    // BASE64编码：一种对字符串和二进制数据进行编码的一种“最常用的网络编码方式”，此编码可以将二进制数据转换成字符串！
//    // 是很多加密算法的底层算法
//    // BASE64支持反编码，是一种双向的编码方案
//    NSString *authStr = @"admin:123";
//    NSString *authBase64 = [NSString stringWithFormat:@"Basic %@", [NetworkingManager base64Encode:authStr]];
//    [request setValue:authBase64 forHTTPHeaderField:@"Authorization"];
//    
//    // 3. URLSession
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    // 4. 由session发起任务
//    NSURL *localURL = [[NSBundle mainBundle] URLForResource:@"001.png" withExtension:nil];
//    [[session uploadTaskWithRequest:request fromFile:localURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"sesult---> %@ %@", result, [NSThread currentThread]);
//    }] resume];
//}
//
//+ (NSString *)base64Encode:(NSString *)str
//{
//    // 1. 将字符串转换成二进制数据
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    // 2. 对二进制数据进行base64编码
//    NSString *result = [data base64EncodedStringWithOptions:0];
//    
//    NSLog(@"base464--> %@", result);
//    
//    return result;
//}
//
//
//
//- (NSData *)HTTPBodyWithParams:(NSDictionary *)params
//{
//    NSMutableArray * parameters = [NSMutableArray arrayWithCapacity:0];
//    
//    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [parameters addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
//        
//    }];
//    
//    NSString * paramString = [parameters componentsJoinedByString:@"&"];
//    
//    return [paramString dataUsingEncoding:NSUTF8StringEncoding];
//    
//}
//
//
//
//
//+ (void)post2WithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure
//{
//    
//}
//
//- (void)post3WithURL:(NSString *)url params:(NSDictionary *)params successAction:(SuccessBlock)success failAction:(FailBlock)failure
//{
//    //分界线的标识符
//    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//    //根据url初始化request
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                       timeoutInterval:10];
//    //分界线 --AaB03x
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//    //要上传的图片
//    UIImage *image=[params objectForKey:@"pic"];
//    //得到图片的data
//    NSData* data = UIImagePNGRepresentation(image);
//    //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    //参数的集合的所有key的集合
//    NSArray *keys= [params allKeys];
//    
//    //遍历keys
//    for(int i=0;i<[keys count];i++)
//    {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        //如果key不是pic，说明value是字符类型，比如name：Boris
//        if(![key isEqualToString:@"pic"])
//        {
//            //添加分界线，换行
//            [body appendFormat:@"%@\r\n",MPboundary];
//            //添加字段名称，换2行
//            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//            //添加字段的值
//            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
//        }
//    }
//    
//    ////添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    //声明pic字段，文件名为boris.png
//    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
//    //声明上传文件的格式
//    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
//    
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    //将image的data加入
//    [myRequestData appendData:data];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    //设置HTTPHeader
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
//    //设置http body
//    [request setHTTPBody:myRequestData];
//    //http method
//    [request setHTTPMethod:@"POST"];
//    
//    //建立连接，设置代理
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    //设置接受response的data
//    if (conn) {
////        mResponseData = [NSMutableData data];
//    }
//}
//

@end
