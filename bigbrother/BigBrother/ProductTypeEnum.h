//
//  ProductTypeEnum.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#ifndef ProductTypeEnum_h
#define ProductTypeEnum_h

typedef NS_ENUM(NSUInteger, BaseProductType) {
    BaseProductTypeHouse    = 1 << 10,
    BaseProductTypeFactory  = 1 << 11,
    BaseProductTypeCar      = 1 << 12,
};

typedef NS_ENUM(NSUInteger, CarProductType) {
    CarProductNone          = 0, //默认
    CarProductZuChe         = 1, //租车服务
    CarProductPinChe        = 2, //拼车服务
    CarProductDaiJia        = 3, //代驾服务
    CarProductLvXingBaoXian = 4, //旅行保险
};

typedef NS_ENUM(NSUInteger, HouseProductType) {
    HouseProductNone               = 5, //默认
    HouseProductDanjianZuNin       = 6, //单间租赁
    HouseProductZhengTaoZuNin      = 7, //整套租赁
    HouseProductChangFangZuNin     = 8, //厂房租赁
    HouseProductChangFangQiuZu     = 9, //厂房求租
    HouseProductFangWuXiaoShou     = 10, //房屋销售
    HouseProductChangFangXiaoShou  = 11,//厂房销售
    HouseProductChangFangQiuGou    = 12,//厂房求购
    HouseProductFangWuQiuZu        = 13,//房屋求租
    HouseProductFangWuQiuGou       = 14,//房屋求购
    HouseProductShangPuZuNin       = 15,//商铺租赁
    HouseProductShangPuXiaoShou    = 16,//商铺销售
};

/**
 *  note 当这里的字符串修改的时候  对应的地方也必须要修改  
 
 对应的记得起来的修改的地方
 MyPostInfo.m 中对应的 中文字符的对应
 
 */
//车相关
static NSString *CarProductType_RentCar = @"RENT_CAR";
static NSString *CarProductType_HelpDrive = @"HELP_DRIVE";
static NSString *CarProductType_CarPool = @"PIN_CAR";

//房屋相关
static NSString *HouseProductHouseRoomType_RentHouse = @"RENT_HOUSE";
static NSString *HouseProductHouseRoomType_RentRoom = @"RENT_ROOM";
static NSString *HouseProductHouseRoomType_ChuShou = @"SELL_HOUSE";
static NSString *HouseProductHouseRoomType_QiuGou = @"BUY_HOUSE";
static NSString *HouseProductHouseRoomType_QiuZu = @"WANT_RENT_HOUSE";

static NSString *HouseProductFactoryRoomType_ChuZu = @"PROVIDE_FACTORY_RENT";
static NSString *HouseProductFactoryRoomType_QiuZu = @"ASK_FACTORY_RENT";
static NSString *HouseProductFactoryRoomType_ChuShou = @"PROVIDE_FACTORY_SELL";
static NSString *HouseProductFactoryRoomType_QiuGou = @"ASK_FACTORY_SELL";

//工业产品相关
static NSString *FactoryProductType_FactoryProduct = @"PRODUCT";

static NSString *ProductSupplyDemandTypeProvide = @"PROVIDE";
static NSString *ProductSupplyDemandTypeAsk = @"ASK";

#endif
