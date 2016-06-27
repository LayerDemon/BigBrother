//
//  BBUrlConnection.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductTypeEnum.h"

@interface BBUrlConnection : NSObject

#pragma mark -
#pragma mark 七牛图片上传接口;
+(void)getQiNiuHostAndToken;

//上传图片
+(void)uploadWithImage:(UIImage *)image productType:(BaseProductType)type complete:(void(^)(NSString *imageUrl))complete;
//POST
+(NSURLSessionDataTask *)loadPostAfNetWorkingWithUrl:(NSString *)urlString andParameters:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//GET
+(NSURLSessionDataTask *)loadGetAfNetWorkingWithUrl:(NSString *)urlString andParameters:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
#pragma mark -
#pragma mark 用户相关
//根据邮箱获取用户信息
+(void)getUserInfoWithEmail:(NSString *)email complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//根据邮箱发送验证码
+(void)sendCodeThroughEmail:(NSString *)email complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//发送邮箱
+(void)sendCodeForEmail:(NSString *)email sendContext:(NSString *)sendContext complete:(void (^)(NSDictionary *sendResultDic,NSString *errorString))complete;

//根据手机号码获取用户信息
+(void)getUserInfoWithPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//根据手机号码发送验证码
+(void)sendCodeThroughPhone:(NSString *)phone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//更新用户信息
+(void)updateUserInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//用户登录
+(void)loginUserWithLoginName:(NSString *)loginName password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//用户注册
+(void)registerUserWithLoginName:(NSString *)loginName password:(NSString *)password recommandPhone:(NSString *)recommandPhone complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//重置密码
+(void)resetUserPasswordWithLoginName:(NSString *)loginName password:(NSString *)password complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取我发布的信息  个人中心 内 供需信息展示
+(void)getAllMyPostInfoListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//信息置顶/取消置顶
+(void)updatePostInfoOnTop:(BOOL)isOnTop infoID:(int)postInfoID dayCount:(int)dayCount complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//信息上架下架
+(void)setPutOnSaleOrNot:(BOOL)gotoPut postInfoID:(int)postInfoID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//信息删除
+(void)deletePostInfoWithID:(int)postInfoID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark -
#pragma mark 信息匹配相关
//获得匹配的信息的列表
+(void)getMatchedPostListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
// 信息 认可接口
+(void)acceptInfoWithPostID:(int)postID macthPostID:(int)matchID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
// 信息 忽略接口
+(void)ignoreInfoWithPostID:(int)postID macthPostID:(int)matchID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark -
#pragma mark 点数相关
//增加点数
+(void)increasePoint:(int)point complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//扣除点数
+(void)decreasePoint:(int)point complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark -
#pragma mark 获取关于我们介绍
+(void)getAboutUsComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark -
#pragma mark 认证相关
+(void)createAuthcationWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取用户认证的信息
+(void)getUserAuthInfoComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


#pragma mark -
#pragma mark 地理接口
//获取用户当前位置
+(void)getUserCurrentLocationComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取所有的省市列表
+(void)getAllProvinceAndCityComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//根据城市ID获取区域的列表
+(void)getAllDistrictWithCityID:(int)cityID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


#pragma mark 获取首页推荐的供需要求
+(void)getRecommandListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//根据地址获取
+(void)getRecommandListWithCityId:(NSNumber *)cityId complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


#pragma mark - 车
#pragma mark 租车接口
//获取租车的车型列表
+(void)getAllRentCarTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取租车的列表信息
+(void)getAllCarRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加新的租车信息
+(void)uploadNewRentCarInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个租车信息的相关的信息
+(void)getRentCarInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark 代驾接口
//获取代驾服务列表
+(void)getAllHelpDriveTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取全部代驾列表信息
+(void)getAllHelpDriveListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加新的代驾信息
+(void)uploadNewHelpDriveInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个代驾信息的相关的信息
+(void)getDaiJiaInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark 拼车接口
//获取全部拼车列表信息
+(void)getAllPinCheListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加新的拼车信息
+(void)uploadNewCarPoolInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个拼车信息的相关的信息
+(void)getCarPoolInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


#pragma mark - 房屋
//获取厅室类型列表
+(void)getRoomTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取房间面积类型列表
+(void)getHouseAreaTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取工厂面积类型列表
+(void)getFactoryAreaTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取房屋出租租金列表
+(void)getHouseRentPriceTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取房屋出售或购买价格列表
+(void)getHouseSellPriceTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark 单间
//获取单间出租的信息列表
+(void)getAllSingleRoomRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加单间租赁的信息
+(void)uploadNewSingleRoomRentInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个单间租赁的相关的信息
+(void)getSingleRoomRentInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;


#pragma mark 整套
//获取整套租赁的信息列表
+(void)getAllWholeHouseRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加整套租赁的信息
+(void)uploadNewWholeHouseRentInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个房屋出售的相关的信息
+(void)getWholeHouseRentInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;



//获取整套房屋出售的信息列表
+(void)getAllWholeHouseSellListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加房屋出售的信息
+(void)uploadNewWholeHouseWantSellInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个房屋出售的相关的信息
+(void)getWholeHouseWantSellInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取房屋求租的信息列表
+(void)getAllWholeHouseWantRentListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加房屋求租的信息
+(void)uploadNewWholeHouseWantRentInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个房屋求租的相关的信息
+(void)getWholeHouseWantRentInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取房屋求购的信息列表
+(void)getAllWholeHouseWantBuyListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加房屋求购的信息
+(void)uploadNewWholeHouseWantBuyInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取单个房屋求购相关的信息
+(void)getWholeHouseWantBuyInfoWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
#pragma mark 厂房
//获取厂房信息列表
+(void)getAllFactoryInfoListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//添加厂房信息
+(void)uploadNewHouseFactoryInfoWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取单个厂房相关的信息
+(void)getFactoryHouseProductWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

#pragma mark - 工业产品

//获取工业产品的类型列表
+(void)getFactoryProductTypeListComplete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;
//获取工业产品 列表 产品列表信息
+(void)getAllFactoryProductListWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//添加新的工业产品
+(void)uploadNewFactoryProductWithParams:(NSMutableDictionary *)params complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;

//获取单个工业产品的信息
+(void)getFactoryProductWithID:(int)productID complete:(void (^)(NSDictionary *resultDic,NSString *errorString))complete;









@end
