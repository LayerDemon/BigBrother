//
//  BBUrlConnection.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "BBUrlConnection.h"
#import "AFNetworking.h"
#import "QiniuSDK.h"
#import "UIImage+Resize.h"

@implementation BBUrlConnection




#pragma mark -
#pragma mark 七牛图片上传接口
static NSString *qiniuToken;
static NSString *qiniuDomain;
+(void)getQiNiuHostAndToken{
    if (qiniuDomain && qiniuToken) {
        return;
    }
    dispatch_semaphore_t wait = dispatch_semaphore_create(0);
    
    NSURL *url = [NSURL URLWithString:@"http://121.42.161.141:8080/rent-car/api/qiniu/token"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.f];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *returnDataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (returnDataDic && [returnDataDic isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = [returnDataDic objectForKey:@"data"];
                NSString *token = dataDic[@"token"];
                NSString *urlHost = dataDic[@"domain"];
                if (urlHost && ![urlHost isEqualToString:@""]) {
                    if ([urlHost rangeOfString:@"http://"].length == 0) {
                        urlHost = [urlHost stringByReplacingOccurrencesOfString:@"https://" withString:@""];
                        urlHost = [@"http://" stringByAppendingString:urlHost];
                    }
                    qiniuDomain = urlHost;
                }
                if (token && ![token isEqualToString:@""]) {
                    qiniuToken = token;
                }
            }
        }
        dispatch_semaphore_signal(wait);
    }];
    [dataTask resume];
    dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
}

static QNUploadManager *imageUploadManager;
+(void)uploadWithImage:(UIImage *)image productType:(BaseProductType)type complete:(void(^)(NSString *imageUrl))complete{
    //    complete(@"uuuurl");
    //    return;
    if (!qiniuToken && !qiniuDomain) {
        [self getQiNiuHostAndToken];
    }
    if (!image) {
        complete(nil);
    }
    image = [image resizeImageGreaterThan:1000];
    if (!imageUploadManager) {
        imageUploadManager = [[QNUploadManager alloc] init];
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (!imageData) {
        complete(nil);
    }
    NSString *storageDir = @"base";
    if (type == BaseProductTypeHouse) {
        storageDir = @"house";
    }else if (type == BaseProductTypeFactory){
        storageDir = @"factory";
    }else if (type == BaseProductTypeCar){
        storageDir = @"car";
    }
    ShowNetworkActivityIndicator();
    [imageUploadManager putData:imageData
                            key:[NSString stringWithFormat:@"classinfo/%@/%@.jpg",storageDir,UUID()]
                          token:qiniuToken
                       complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                           HideNetworkActivityIndicator();
                           if (info.error) {
                               NSLog(@"imageupload error %@",info.error);
                               complete(nil);
                               return;
                           }
                           NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",qiniuDomain,key];
                           complete(imageUrl);
                       } option:nil];
}


#pragma mark -
#pragma mark 用户相关
//根据手机号码获取用户信息
+(void)getUserInfoWithPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/list";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phoneNumberList"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//更新用户信息
+(void)updateUserInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/modify";
    
    NSString *userID = [BBUserDefaults getUserID];
    [params setObject:userID forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//根据手机号码发送验证码
+(void)sendCodeThroughPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/messages";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phoneNumber"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//用户登录
+(void)loginUserWithLoginName:(NSString *)loginName password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/signin";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:loginName forKey:@"phoneNumber"];
    [params setObject:password forKey:@"password"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//用户注册
+(void)registerUserWithLoginName:(NSString *)loginName password:(NSString *)password recommandPhone:(NSString *)recommandPhone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/signup";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:loginName forKey:@"phoneNumber"];
    [params setObject:password forKey:@"password"];
    if (recommandPhone && ![recommandPhone isEqualToString:@""]) {
        [params setObject:recommandPhone forKey:@"recommender"];
    }
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//重置密码
+(void)resetUserPasswordWithLoginName:(NSString *)loginName password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/passwords";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:loginName forKey:@"phoneNumber"];
    [params setObject:password forKey:@"newPassword"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取我发布的信息  个人中心 内 供需信息展示
+(void):(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/user/personal/post";
    
    NSString *userID = [BBUserDefaults getUserID];
    [params setObject:userID forKey:@"creator"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//信息置顶/取消置顶
+(void)updatePostInfoOnTop:(BOOL)isOnTop infoID:(int)postInfoID dayCount:(int)dayCount complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/user/personal/post/top";
    
    NSString *userID = [BBUserDefaults getUserID];
    
    NSURLSession *httpSeeion = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *paramsString = [NSString stringWithFormat:@"userId=%@&postId=%d&topDayCount=%d",userID,postInfoID,dayCount];
    
    if (!isOnTop) {
        paramsString = [paramsString stringByAppendingString:@"&cancel=true"];
    }
    
    NSData *postData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                               timeoutInterval:10.0f];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody: postData];
    
    
    
    NSURLSessionDataTask *dataTask = [httpSeeion dataTaskWithRequest:urlRequest completionHandler:^(NSData *responseObject, NSURLResponse *response, NSError *error) {
        if (error){
            complete(nil,@"服务器错误");
            return;
        }
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                complete((NSDictionary *)responseObject,nil);
            }else{
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
                if (!dic) {
                    NSLog(@"返回的结果不是json :%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    complete(nil,@"服务器错误");
                }else{
                    complete(dic,nil);
                }
            }
        }else{
            NSLog(@"服务器无返回值");
            complete(nil,@"服务器错误");
        }
    }];
    [dataTask resume];
}

+(void)setPutOnSaleOrNot:(BOOL)gotoPut postInfoID:(int)postInfoID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/user/personal/post/sale";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userID = [BBUserDefaults getUserID];
    [params setObject:userID forKey:@"userId"];
    [params setObject:@(postInfoID) forKey:@"postId"];
    if (gotoPut) {
        [params setObject:@"SHOWING" forKey:@"action"];
    }else{
        [params setObject:@"CANCELED" forKey:@"action"];
    }
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


//信息删除
+(void)deletePostInfoWithID:(int)postInfoID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/user/personal/post/delete";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userID = [BBUserDefaults getUserID];
    [params setObject:userID forKey:@"userId"];
    [params setObject:@(postInfoID) forKey:@"postId"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark -
#pragma mark 信息匹配相关
//获得信息匹配的列表
+(void)getMatchedPostListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/user/personal/matched";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

// 信息 认可接口
+(void)acceptInfoWithPostID:(int)postID macthPostID:(int)matchID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/user/personal/post/match";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(postID) forKey:@"postId"];
    [params setObject:@(matchID) forKey:@"matchedId"];
    [params setObject:[BBUserDefaults getUserID] forKey:@"userId"];
    [params setObject:@"ACCEPTED" forKey:@"action"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

// 信息 忽略接口
+(void)ignoreInfoWithPostID:(int)postID macthPostID:(int)matchID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/user/personal/post/match";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(postID) forKey:@"postId"];
    [params setObject:@(matchID) forKey:@"matchedId"];
    [params setObject:[BBUserDefaults getUserID] forKey:@"userId"];
    [params setObject:@"IGNORED" forKey:@"action"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark -
#pragma mark 点数相关
//增加点数
+(void)increasePoint:(int)point complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/balance/increment";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(point) forKey:@"balance"];
    [params setObject:@([[BBUserDefaults getUserID] intValue]) forKey:@"id"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//扣除点数
+(void)decreasePoint:(int)point complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/balance/decrement";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(point) forKey:@"balance"];
    [params setObject:@([[BBUserDefaults getUserID] intValue]) forKey:@"id"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark -
#pragma mark 获取关于我们介绍
+(void)getAboutUsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/index/about";
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

#pragma mark -
#pragma mark 认证相关
+(void)createAuthcationWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/authentication/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取用户认证的信息
+(void)getUserAuthInfoComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    if (![BBUserDefaults getIsLogin]) {
        complete(nil,@"未登录");
        return;
    }
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/users/authentication/findForUser";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[BBUserDefaults getUserID] intValue]) forKey:@"creator"];
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


#pragma mark -
#pragma mark 地理接口
//获取用户当前位置
+(void)getUserCurrentLocationComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/districts/current_location";
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取所有的省市列表
+(void)getAllProvinceAndCityComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/districts/allProvinceAndCity";
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//根据城市ID获取区域的列表
+(void)getAllDistrictWithCityID:(int)cityID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/districts/allDistrict";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(cityID) forKey:@"cityId"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

#pragma mark 获取首页推荐的供需要求
+(void)getRecommandListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/index/list";
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

#pragma mark - 车
#pragma mark 租车接口
//获取租车的车型列表
+(void)getAllRentCarTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/rent/carTypeList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取租车的列表信息
+(void)getAllCarRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/rent/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加新的租车信息
+(void)uploadNewRentCarInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/rent/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}
//获取单个租车信息的相关的信息
+(void)getRentCarInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/rent/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}



#pragma mark 代驾接口
//获取代驾服务列表
+(void)getAllHelpDriveTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/helpdrive/serviceList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取全部代驾列表信息
+(void)getAllHelpDriveListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/helpdrive/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加新的代驾信息
+(void)uploadNewHelpDriveInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/helpdrive/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}
//获取单个代驾信息的相关的信息
+(void)getDaiJiaInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/helpdrive/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


#pragma mark 拼车接口
//获取全部拼车列表信息
+(void)getAllPinCheListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/pin/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加新的拼车信息
+(void)uploadNewCarPoolInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/pin/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}
//获取单个拼车信息的相关的信息
+(void)getCarPoolInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/car/pin/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


#pragma mark - 房屋
//获取厅室类型列表
+(void)getRoomTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/roomTypeList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取房间面积类型列表
+(void)getHouseAreaTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/sell/post/areaList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取工厂面积类型列表
+(void)getFactoryAreaTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/factory/areaList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取房屋出租租金列表
+(void)getHouseRentPriceTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/rentPriceList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取房屋出售或购买价格列表
+(void)getHouseSellPriceTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/sell/post/priceList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}


//获取单间租赁的信息列表
+(void)getAllSingleRoomRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/room/rent/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加单间租赁的信息
+(void)uploadNewSingleRoomRentInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/room/rent/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}
//获取单个单间租赁的相关的信息
+(void)getSingleRoomRentInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/room/rent/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取整套租赁的信息列表
+(void)getAllWholeHouseRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/rent/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加整套租赁的信息
+(void)uploadNewWholeHouseRentInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/rent/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取单个房屋出售的相关的信息
+(void)getWholeHouseRentInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/rent/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}



//获取房屋出售的信息列表
+(void)getAllWholeHouseSellListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/sell/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加房屋出售的信息
+(void)uploadNewWholeHouseWantSellInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/sell/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取单个房屋出售的相关的信息
+(void)getWholeHouseWantSellInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/sell/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


//获取房屋求租的信息列表
+(void)getAllWholeHouseWantRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/wantRent/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加房屋求租的信息
+(void)uploadNewWholeHouseWantRentInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/wantRent/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}
//获取单个房屋求租的相关的信息
+(void)getWholeHouseWantRentInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/wantRent/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取房屋求购的信息列表
+(void)getAllWholeHouseWantBuyListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/buy/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加房屋求购的信息
+(void)uploadNewWholeHouseWantBuyInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/buy/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取单个房屋求购相关的信息
+(void)getWholeHouseWantBuyInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/house/buy/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取厂房信息列表
+(void)getAllFactoryInfoListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/factory/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//添加厂房信息
+(void)uploadNewHouseFactoryInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/factory/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


//获取单个厂房相关的信息
+(void)getFactoryHouseProductWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/factory/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}




#pragma mark - 工业产品
//获取工业产品的类型列表
+(void)getFactoryProductTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/product/typeList";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:nil complete:complete];
}

//获取工业产品 列表 产品列表信息
+(void)getAllFactoryProductListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/product/post/list";
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}


//添加新的工业产品
+(void)uploadNewFactoryProductWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/product/post/create";
    
    if (!params) {
        return;
    }
    NSString *uid = [BBUserDefaults getUserID];
    if (uid) {
        [params setObject:uid forKey:@"creator"];
    }
    
    [self loadProductAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}

//获取单个工业产品的信息
+(void)getFactoryProductWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    NSString *urlString = @"http://121.42.161.141:8080/rent-car/api/product/post/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(productID) forKey:@"id"];
    
    [self loadPostAfNetWorkingWithUrl:urlString andParameters:params complete:complete];
}



+(NSURLSessionDataTask *)loadGetAfNetWorkingWithUrl:(NSString *)urlString andParameters:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    ShowNetworkActivityIndicator();
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDataTask *task = [manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        HideNetworkActivityIndicator();
        NSError *error;
        if (error) {
            complete(nil,@"服务器错误");
        }else{
            if (responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    complete((NSDictionary *)responseObject,nil);
                }else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
                    if (!dic) {
                        NSLog(@"返回的结果不是json :%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                        complete(nil,@"服务器错误");
                    }else{
                        complete(dic,nil);
                    }
                }
            }else{
                NSLog(@"服务器无返回值");
                complete(nil,@"服务器错误");
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        complete(nil,@"服务器无响应");
        NSLog(@"error %@",error);
    }];
    return task;
}

//POST
+(NSURLSessionDataTask *)loadPostAfNetWorkingWithUrl:(NSString *)urlString andParameters:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    ShowNetworkActivityIndicator();
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDataTask *task = [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        HideNetworkActivityIndicator();
        NSError *error;
        if (error) {
            complete(nil,@"服务器错误");
            [UIButton stopAllButtonAnimationWithErrorMessage:@"服务器错误"];
        }else{
            if (responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    complete((NSDictionary *)responseObject,nil);
                }else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
                    NSLog(@"error -- %@",error.localizedDescription);
                    if (!dic) {
                        NSLog(@"返回的结果不是json :%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                        complete(nil,@"服务器错误");
                        [UIButton stopAllButtonAnimationWithErrorMessage:@"服务器返回数据错误"];
                    }else{
                        complete(dic,nil);
                    }
                }
            }else{
                NSLog(@"服务器无返回值");
                complete(nil,@"服务器错误");
                [UIButton stopAllButtonAnimationWithErrorMessage:@"服务器无返回"];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error2 -- %@",error.localizedDescription);
        NSLog(@"错误描述%@",[error localizedDescription]);
        
        
        NSData *data = [[error userInfo] objectForKey:@"com.alamofire.serialization.response.error.data"];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        id object = [string objectFromJSONString];
        NSLog(@"错误信息%@",object);
        NSLog(@"-douban-%@",object[@"data"]);
        complete(nil,@"服务器无响应");
        NSString *errorMessage = object[@"data"][@"message"];
        if (!errorMessage) {
            errorMessage = @"服务器无响应";
        }
        [UIButton stopAllButtonAnimationWithErrorMessage:errorMessage];
    }];
    return task;
}

+(NSURLSessionDataTask *)loadProductAfNetWorkingWithUrl:(NSString *)urlString andParameters:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:@{@"json":jsonString}];
    return [BBUrlConnection loadPostAfNetWorkingWithUrl:urlString andParameters:p complete:complete];
}

@end
