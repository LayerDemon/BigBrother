//
//  HouseSquareViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HouseSquareViewController.h"
#import "UIScrollView+XYRefresh.h"

#import "HouseProductTableViewCell.h"
#import "HousePostNewViewController.h"
#import "HousePostDetailViewController.h"

#import "SingleRoomRentProduct.h"
#import "WholeHouseRentProduct.h"
#import "FactoryHouseProduct.h"
#import "WholeHouseSellProduct.h"
#import "WantHouseProduct.h"

@interface HouseSquareViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation HouseSquareViewController{
    UIView *titleFilterView;
    UIButton *titleAreaFiterButton,*titleSupplyFiterButton,*titleGategroyFiterButton;
    
    UITableView *contentTableView;
    
    NSArray *currentDataArray;
    
    NSMutableArray *totalDataArray;
    
    NSArray *districtToShowDataArray;
    
    NSArray *supplyToShowDataArray;
    
    NSArray *gategroyToShowDataArray;
    
    int currentListIndex;
    
    NSString *areaTitleStringTmp;
    NSString *supplyTitleStringTmp;
    NSString *gategroyTitleStringTmp;
    
    int currentFilterDistrictID;
    
    int currentFilterSupplyID;
    
    int currentGategroyTypeID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIView *contentView;
    contentView = [[UIView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.backgroundColor = BB_WhiteColor;
    [self.view addSubview:contentView];
    
    titleFilterView = [[UIView alloc] init];
    titleFilterView.frame = (CGRect){0,0,WIDTH(contentView),40};
    titleFilterView.backgroundColor = contentView.backgroundColor;
    [contentView addSubview:titleFilterView];
    
    [self initTitleFiterView];
    [self getAreaList];
    [self supplyTypeList];
    [self getGategroyList];
    
    contentTableView = [[UITableView alloc] initWithFrame:(CGRect){0,HEIGHT(titleFilterView),WIDTH(contentView),HEIGHT(contentView)-HEIGHT(titleFilterView)} style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.showsHorizontalScrollIndicator = NO;
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:contentTableView];
    
    weak(weakself, self);
    currentListIndex = 1;
    
    [contentTableView initDownRefresh];
    [contentTableView setDownRefreshBlock:^(id refreshView){
        [weakself getContentDataWithPageIndex:1];
    }];
    
    [contentTableView initPullUpRefresh];
    [contentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getContentDataWithPageIndex:currentListIndex + 1];
    }];
    
    [self getContentDataWithPageIndex:currentListIndex];
}

//获取区域信息
-(void)getAreaList{
    int cityID = [BBUserDefaults getCityID];
    
    [BBUrlConnection getAllDistrictWithCityID:cityID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取城市区域信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"获取城市区域信息失败,请稍后再试"];
            return;
        }
        
        NSArray *districtsArray = dataDic[@"districts"];
        if (!districtsArray || districtsArray.count == 0 || ![districtsArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取城市区域信息失败,请稍后再试"];
            return;
        }
        
        NSMutableArray *districtsTmpShowedArray = [NSMutableArray array];
        
        [districtsTmpShowedArray addObject:@{@"id":@(cityID),@"name":@"全城"}];
        
        for (NSDictionary *dic in districtsArray) {
            int districtIDTmp = [dic[@"id"] intValue];
            NSString *name1 = dic[@"name"];
            NSString *name2 = dic[@"suffix"];
            NSString *name = [name1 stringByAppendingString:name2];
            [districtsTmpShowedArray addObject:@{@"id":@(districtIDTmp),@"name":name}];
        }
        districtToShowDataArray = [NSArray arrayWithArray:districtsTmpShowedArray];
    }];
}

//获取供需列表
-(void)supplyTypeList{
    if (self.houseType == HouseProductDanjianZuNin) {
        //单间租赁
        [self getHouseAreaTypeList];
    }else if (self.houseType == HouseProductZhengTaoZuNin ||
              self.houseType == HouseProductFangWuQiuZu){
        //整套租赁
        //房屋求租
        [self getRoomTypeList];
    }else if (self.houseType == HouseProductChangFangZuNin ||
              self.houseType == HouseProductChangFangQiuZu ||
              self.houseType == HouseProductChangFangXiaoShou ||
              self.houseType == HouseProductChangFangQiuGou ){
        //厂房租赁
        //厂房求租
        //厂房销售
        //厂房求购
        supplyToShowDataArray = @[@{@"name":@"所有",@"id":@(-1)},
                                  @{@"name":@"出租",@"id":@(1)},
                                  @{@"name":@"求租",@"id":@(2)},
                                  @{@"name":@"出售",@"id":@(3)},
                                  @{@"name":@"求购",@"id":@(4)},
                                  ];
        
        if (self.houseType == HouseProductChangFangZuNin) {
            currentFilterSupplyID = 1;
        }else if (self.houseType == HouseProductChangFangQiuZu){
            currentFilterSupplyID = 2;
        }else if (self.houseType == HouseProductChangFangXiaoShou){
            currentFilterSupplyID = 3;
        }else if (self.houseType == HouseProductChangFangQiuGou){
            currentFilterSupplyID = 4;
        }
    }else if (self.houseType == HouseProductFangWuXiaoShou ||
              self.houseType == HouseProductFangWuQiuGou){
        //房屋销售
        //房屋求购
        [self getHouseAreaTypeList];
    }else if (self.houseType == HouseProductShangPuZuNin){
        //商铺租赁
    }else if (self.houseType == HouseProductShangPuXiaoShou){
        //商铺销售
    }
}

-(void)getHouseAreaTypeList{
    [BBUrlConnection getHouseAreaTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取面积信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取面积信息失败,请稍后再试"];
            return;
        }
        
        supplyToShowDataArray = [NSArray arrayWithArray:dataArray];
    }];
}

-(void)getRoomTypeList{
    [BBUrlConnection getRoomTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取厅室信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取厅室信息失败,请稍后再试"];
            return;
        }
        
        NSMutableArray *supplyTmpShowedArray = [NSMutableArray array];
        [supplyTmpShowedArray addObject:@{@"id":@(-1),@"name":@"不限"}];
        
        for (NSDictionary *dic in dataArray) {
            int gategroyIDTmp = [dic[@"id"] intValue];
            NSString *name = dic[@"name"];
            [supplyTmpShowedArray addObject:@{@"id":@(gategroyIDTmp),@"name":name}];
        }
        supplyToShowDataArray = [NSArray arrayWithArray:supplyTmpShowedArray];
    }];
}

//获取类型选择列表
-(void)getGategroyList{
    if (self.houseType == HouseProductDanjianZuNin) {
        //单间租赁
        [self getHouseRentPriceTypeList];
    }else if (self.houseType == HouseProductZhengTaoZuNin ||
              self.houseType == HouseProductFangWuQiuZu){
        //整套租赁
        //房屋求租
        [self getHouseRentPriceTypeList];
    }else if (self.houseType == HouseProductChangFangZuNin ||
              self.houseType == HouseProductChangFangQiuZu ||
              self.houseType == HouseProductChangFangXiaoShou ||
              self.houseType == HouseProductChangFangQiuGou ){
        //厂房租赁
        //厂房求租
        //厂房销售
        //厂房求购
        [self getFactoryAreaList];
    }else if (self.houseType == HouseProductFangWuXiaoShou ||
              self.houseType == HouseProductFangWuQiuGou){
        //房屋销售
        //房屋求购
        [self getHouseSellPriceList];
    }else if (self.houseType == HouseProductShangPuZuNin){
        //商铺租赁
    }else if (self.houseType == HouseProductShangPuXiaoShou){
        //商铺销售
    }
}

-(void)getHouseRentPriceTypeList{
    [BBUrlConnection getHouseRentPriceTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取价格类别信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || dataArray.count == 0 || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取价格类别信息失败,请稍后再试"];
            return;
        }
        NSMutableArray *gategroyTmpShowedArray = [NSMutableArray array];
        
        [gategroyTmpShowedArray addObject:@{@"id":@(-1),@"name":@"不限"}];
        
        for (NSDictionary *dic in dataArray) {
            int gategroyIDTmp = [dic[@"id"] intValue];
            NSString *name = dic[@"name"];
            [gategroyTmpShowedArray addObject:@{@"id":@(gategroyIDTmp),@"name":name}];
        }
        gategroyToShowDataArray = [NSArray arrayWithArray:gategroyTmpShowedArray];
    }];
}

-(void)getFactoryAreaList{
    [BBUrlConnection getFactoryAreaTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取厂房面积信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取厂房信息失败,请稍后再试"];
            return;
        }
        
        gategroyToShowDataArray = [NSArray arrayWithArray:dataArray];
    }];
}

-(void)getHouseSellPriceList{
    [BBUrlConnection getFactoryAreaTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取价格信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取价格信息失败,请稍后再试"];
            return;
        }
        
        gategroyToShowDataArray = [NSArray arrayWithArray:dataArray];
    }];
}

#pragma mark - 获取列表信息接口 统一调用这个函数
-(void)getContentDataWithPageIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    //todo 添加城市id 进入查询状态 打开下面注释即可
    //    int cityID = [BBUserDefaults getCityID];
    //    if (cityID != 0) {
    //        [params setObject:@(cityID) forKey:@"districtId"];
    //    }
    
    if (currentFilterDistrictID != 0) {
        [params setObject:@(currentFilterDistrictID) forKey:@"districtId"];
    }
    
    if (self.houseType == HouseProductDanjianZuNin) {
        //单间租赁
        [self getAllSingleRoomRentListWithPrams:params index:index];
    }else if (self.houseType == HouseProductZhengTaoZuNin){
        //整套租赁
        [self getAllWholeHouseRentListWithPrams:params index:index];
    }else if (self.houseType == HouseProductFangWuXiaoShou){
        //房屋销售
        [self getAllWholeHouseSellListWithPrams:params index:index];
    }else if (self.houseType == HouseProductChangFangZuNin){
        //厂房租赁
        [self getAllFactoryInfoListWithPrams:params index:index];
    }else if (self.houseType == HouseProductChangFangQiuZu){
        //厂房求租
        [self getAllFactoryInfoListWithPrams:params index:index];
    }else if (self.houseType == HouseProductChangFangXiaoShou){
        //厂房销售
        [self getAllFactoryInfoListWithPrams:params index:index];
    }else if (self.houseType == HouseProductChangFangQiuGou){
        //厂房求购
        [self getAllFactoryInfoListWithPrams:params index:index];
    }else if (self.houseType == HouseProductFangWuQiuZu){
        //房屋求租
        [self getAllWholeHouseWantRentListWithPrams:params index:index];
    }else if (self.houseType == HouseProductFangWuQiuGou){
        //房屋求购
        [self getAllWholeHouseWantBuyListWithPrams:params index:index];
    }else if (self.houseType == HouseProductShangPuZuNin){
        //商铺租赁
    }else if (self.houseType == HouseProductShangPuXiaoShou){
        //商铺销售
    }
}

//获取全部的单间租赁的信息列表
-(void)getAllSingleRoomRentListWithPrams:(NSMutableDictionary *)params index:(int)index{
    if (currentFilterSupplyID != -1 && currentFilterSupplyID != 0) {
        [params setObject:@(currentFilterSupplyID) forKey:@"areaId"];
    }
    if (currentGategroyTypeID != -1 && currentGategroyTypeID != 0) {
        [params setObject:@(currentGategroyTypeID) forKey:@"priceId"];
    }
    
    [BBUrlConnection getAllSingleRoomRentListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        
        NSArray *listArray = dataDic[@"content"];
        NSMutableArray *arrayTmp = [NSMutableArray array];
        [listArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            SingleRoomRentProduct *product = [SingleRoomRentProduct productWithNetWorkDictionary:dic];
            [arrayTmp addObject:product];
        }];
        
        if (index == 1) {
            totalDataArray = [NSMutableArray array];
        }
        if (arrayTmp.count != 0) {
            [totalDataArray addObjectsFromArray:arrayTmp];
            currentListIndex = index;
        }else{
            [BYToastView showToastWithMessage:@"没有更多了"];
        }
        currentDataArray = [NSArray arrayWithArray:totalDataArray];
        [contentTableView reloadData];
    }];
}

//获取全部的整套出租的信息列表
-(void)getAllWholeHouseRentListWithPrams:(NSMutableDictionary *)params index:(int)index{
    if (currentFilterSupplyID != -1 && currentFilterSupplyID != 0) {
        [params setObject:@(currentFilterSupplyID) forKey:@"roomId"];
    }
    if (currentGategroyTypeID != -1 && currentGategroyTypeID != 0) {
        [params setObject:@(currentGategroyTypeID) forKey:@"priceId"];
    }
    
    [BBUrlConnection getAllWholeHouseRentListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        
        NSArray *listArray = dataDic[@"content"];
        NSMutableArray *arrayTmp = [NSMutableArray array];
        [listArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            WholeHouseRentProduct *product = [WholeHouseRentProduct productWithNetWorkDictionary:dic];
            product.isSupply = YES;
            [arrayTmp addObject:product];
        }];
        
        if (index == 1) {
            totalDataArray = [NSMutableArray array];
        }
        if (arrayTmp.count != 0) {
            [totalDataArray addObjectsFromArray:arrayTmp];
            currentListIndex = index;
        }else{
            [BYToastView showToastWithMessage:@"没有更多了"];
        }
        currentDataArray = [NSArray arrayWithArray:totalDataArray];
        [contentTableView reloadData];
    }];
}

//获取全部的 整套 出售 的信息列表
-(void)getAllWholeHouseSellListWithPrams:(NSMutableDictionary *)params index:(int)index{
    if (currentFilterSupplyID != -1 && currentFilterSupplyID != 0) {
        [params setObject:@(currentFilterSupplyID) forKey:@"areaId"];
    }
    if (currentGategroyTypeID != -1 && currentGategroyTypeID != 0) {
        [params setObject:@(currentGategroyTypeID) forKey:@"priceId"];
    }
    
    [BBUrlConnection getAllWholeHouseSellListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        
        NSArray *listArray = dataDic[@"content"];
        NSMutableArray *arrayTmp = [NSMutableArray array];
        [listArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            WholeHouseSellProduct *product = [WholeHouseSellProduct productWithNetWorkDictionary:dic];
            product.isSupply = YES;
            [arrayTmp addObject:product];
        }];
        
        if (index == 1) {
            totalDataArray = [NSMutableArray array];
        }
        if (arrayTmp.count != 0) {
            [totalDataArray addObjectsFromArray:arrayTmp];
            currentListIndex = index;
        }else{
            [BYToastView showToastWithMessage:@"没有更多了"];
        }
        currentDataArray = [NSArray arrayWithArray:totalDataArray];
        [contentTableView reloadData];
    }];
}

//获取全部的 整套 求租 的信息列表
-(void)getAllWholeHouseWantRentListWithPrams:(NSMutableDictionary *)params index:(int)index{
    if (currentFilterSupplyID != -1 && currentFilterSupplyID != 0) {
        [params setObject:@(currentFilterSupplyID) forKey:@"roomId"];
    }
    if (currentGategroyTypeID != -1 && currentGategroyTypeID != 0) {
        [params setObject:@(currentGategroyTypeID) forKey:@"priceId"];
    }
    
    [BBUrlConnection getAllWholeHouseWantRentListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        
        NSArray *listArray = dataDic[@"content"];
        NSMutableArray *arrayTmp = [NSMutableArray array];
        [listArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            WantHouseProduct *product = [WantHouseProduct productWithNetWorkDictionary:dic];
            product.houseType = HouseProductFangWuQiuZu;
            [arrayTmp addObject:product];
        }];
        
        if (index == 1) {
            totalDataArray = [NSMutableArray array];
        }
        if (arrayTmp.count != 0) {
            [totalDataArray addObjectsFromArray:arrayTmp];
            currentListIndex = index;
        }else{
            [BYToastView showToastWithMessage:@"没有更多了"];
        }
        currentDataArray = [NSArray arrayWithArray:totalDataArray];
        [contentTableView reloadData];
    }];
}

//获取全部的 整套 求购 的信息列表
-(void)getAllWholeHouseWantBuyListWithPrams:(NSMutableDictionary *)params index:(int)index{
    if (currentFilterSupplyID != -1 && currentFilterSupplyID != 0) {
        [params setObject:@(currentFilterSupplyID) forKey:@"roomId"];
    }
    if (currentGategroyTypeID != -1 && currentGategroyTypeID != 0) {
        [params setObject:@(currentGategroyTypeID) forKey:@"priceId"];
    }
    
    [BBUrlConnection getAllWholeHouseWantBuyListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        
        NSArray *listArray = dataDic[@"content"];
        NSMutableArray *arrayTmp = [NSMutableArray array];
        [listArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            WantHouseProduct *product = [WantHouseProduct productWithNetWorkDictionary:dic];
            product.houseType = HouseProductFangWuQiuGou;
            [arrayTmp addObject:product];
        }];
        
        if (index == 1) {
            totalDataArray = [NSMutableArray array];
        }
        if (arrayTmp.count != 0) {
            [totalDataArray addObjectsFromArray:arrayTmp];
            currentListIndex = index;
        }else{
            [BYToastView showToastWithMessage:@"没有更多了"];
        }
        currentDataArray = [NSArray arrayWithArray:totalDataArray];
        [contentTableView reloadData];
    }];
}

//获取全部厂房信息列表
-(void)getAllFactoryInfoListWithPrams:(NSMutableDictionary *)params index:(int)index{
    if (currentFilterSupplyID != -1 && currentFilterSupplyID != 0) {
        if (currentFilterSupplyID == 1) {
            [params setObject:@"PROVIDE_FACTORY_RENT" forKey:@"postType"];
        }else if (currentFilterSupplyID == 2){
            [params setObject:@"ASK_FACTORY_RENT" forKey:@"postType"];
        }else if (currentFilterSupplyID == 3){
            [params setObject:@"PROVIDE_FACTORY_SELL" forKey:@"postType"];
        }else if (currentFilterSupplyID == 4){
            [params setObject:@"ASK_FACTORY_SELL" forKey:@"postType"];
        }
    }
    if (currentGategroyTypeID != -1 && currentGategroyTypeID != 0) {
        [params setObject:@(currentGategroyTypeID) forKey:@"areaId"];
    }
    
    [BBUrlConnection getAllFactoryInfoListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [contentTableView endDownRefresh];
        [contentTableView endPullUpRefresh];
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        
        NSArray *listArray = dataDic[@"content"];
        NSMutableArray *arrayTmp = [NSMutableArray array];
        [listArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            FactoryHouseProduct *product = [FactoryHouseProduct productWithNetWorkDictionary:dic];
            [arrayTmp addObject:product];
        }];
        
        if (index == 1) {
            totalDataArray = [NSMutableArray array];
        }
        if (arrayTmp.count != 0) {
            [totalDataArray addObjectsFromArray:arrayTmp];
            currentListIndex = index;
        }else{
            [BYToastView showToastWithMessage:@"没有更多了"];
        }
        currentDataArray = [NSArray arrayWithArray:totalDataArray];
        [contentTableView reloadData];
    }];
}



#pragma mark - 列表上方的筛选界面
-(void)initTitleFiterView{
    float everyButtonWidth = (WIDTH(titleFilterView)-4*10)/3.f;
    
    titleAreaFiterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleAreaFiterButton.frame = (CGRect){10,0,everyButtonWidth,HEIGHT(titleFilterView)};
    titleAreaFiterButton.tintColor = RGBColor(50, 50, 50);
    [titleAreaFiterButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    titleAreaFiterButton.titleLabel.font = Font(14);
    titleAreaFiterButton.layer.masksToBounds = YES;
    [titleFilterView addSubview:titleAreaFiterButton];
    
    titleSupplyFiterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleSupplyFiterButton.frame = (CGRect){10*2+everyButtonWidth,0,everyButtonWidth,HEIGHT(titleFilterView)};
    titleSupplyFiterButton.tintColor = RGBColor(50, 50, 50);
    [titleSupplyFiterButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    titleSupplyFiterButton.titleLabel.font = Font(14);
    titleSupplyFiterButton.layer.masksToBounds = YES;
    [titleFilterView addSubview:titleSupplyFiterButton];
    
    titleGategroyFiterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleGategroyFiterButton.frame = (CGRect){10*3+everyButtonWidth*2,0,everyButtonWidth,HEIGHT(titleFilterView)};
    titleGategroyFiterButton.tintColor = RGBColor(50, 50, 50);
    [titleGategroyFiterButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    titleGategroyFiterButton.titleLabel.font = Font(14);
    titleGategroyFiterButton.layer.masksToBounds = YES;
    [titleFilterView addSubview:titleGategroyFiterButton];
    
    UIView *titleFiterSepLineView = [[UIView alloc] init];
    titleFiterSepLineView.frame = (CGRect){0,HEIGHT(titleFilterView)-0.5,WIDTH(titleFilterView),0.5};
    titleFiterSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [titleFilterView addSubview:titleFiterSepLineView];
    
    UIView *titleFiterSepVerView1 = [[UIView alloc] init];
    titleFiterSepVerView1.frame = (CGRect){10+5+everyButtonWidth,8,0.5,HEIGHT(titleFilterView)-8*2};
    titleFiterSepVerView1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [titleFilterView addSubview:titleFiterSepVerView1];
    
    UIView *titleFiterSepVerView2 = [[UIView alloc] init];
    titleFiterSepVerView2.frame = (CGRect){10*2+5+everyButtonWidth*2,8,0.5,HEIGHT(titleFilterView)-8*2};
    titleFiterSepVerView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [titleFilterView addSubview:titleFiterSepVerView2];
    
    
    [titleAreaFiterButton addTarget:self action:@selector(titleAreaFiterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleSupplyFiterButton addTarget:self action:@selector(titleSupplyFiterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleGategroyFiterButton addTarget:self action:@selector(titleGategroyFiterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    areaTitleStringTmp = @"地区";
    supplyTitleStringTmp = @"供需";
    gategroyTitleStringTmp = @"类别";
    
    if (self.houseType == HouseProductDanjianZuNin) {
        //单间租赁
        areaTitleStringTmp = @"地区";
        supplyTitleStringTmp = @"面积";
        gategroyTitleStringTmp = @"租金";
    }else if (self.houseType == HouseProductZhengTaoZuNin ||
              self.houseType == HouseProductFangWuQiuZu){
        //整套租赁
        //房屋求租
        areaTitleStringTmp = @"地区";
        supplyTitleStringTmp = @"厅室";
        gategroyTitleStringTmp = @"租金";
    }else if (self.houseType == HouseProductChangFangZuNin ||
              self.houseType == HouseProductChangFangQiuZu ||
              self.houseType == HouseProductChangFangXiaoShou ||
              self.houseType == HouseProductChangFangQiuGou ){
        //厂房租赁
        //厂房求租
        //厂房销售
        //厂房求购
        areaTitleStringTmp = @"地区";
        gategroyTitleStringTmp = @"价格";
        supplyTitleStringTmp = @"供需";
        if (self.houseType == HouseProductChangFangZuNin) {
            supplyTitleStringTmp = @"出租";
        }else if (self.houseType == HouseProductChangFangQiuZu){
            supplyTitleStringTmp = @"求租";
        }else if (self.houseType == HouseProductChangFangXiaoShou){
            supplyTitleStringTmp = @"出售";
        }else if (self.houseType == HouseProductChangFangQiuGou){
            supplyTitleStringTmp = @"求购";
        }
    }else if (self.houseType == HouseProductFangWuXiaoShou ||
              self.houseType == HouseProductFangWuQiuGou){
        //房屋销售
        //房屋求购
        areaTitleStringTmp = @"地区";
        supplyTitleStringTmp = @"厅室";
        gategroyTitleStringTmp = @"价格";
    }else if (self.houseType == HouseProductShangPuZuNin){
        //商铺租赁
    }else if (self.houseType == HouseProductShangPuXiaoShou){
        //商铺销售
    }
    
    [self adjustTitleFilterArrowWithString:areaTitleStringTmp inButton:titleAreaFiterButton];
    [self adjustTitleFilterArrowWithString:supplyTitleStringTmp inButton:titleSupplyFiterButton];
    [self adjustTitleFilterArrowWithString:gategroyTitleStringTmp inButton:titleGategroyFiterButton];
}

-(void)adjustTitleFilterArrowWithString:(NSString *)string inButton:(UIButton *)button{
    
    UIImage *imageArrow = [UIImage imageNamed:@"filter_downarrow"];
    [button setImage:imageArrow forState:UIControlStateNormal];
    
    NSString *leftButtonTitle = string;
    
    CGSize btSize = [XYTools getSizeWithString:leftButtonTitle andSize:(CGSize){MAXFLOAT,15} andFont:Font(15)];
    
    [button setTitle:leftButtonTitle forState:UIControlStateNormal];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageArrow.size.width-3, 0, imageArrow.size.width+3)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, btSize.width, 0, -btSize.width)];
}

-(void)titleAreaFiterButtonClick:(UIButton *)button{
    [PopUpSelectedView showFilterSingleChooseViewWithArray:districtToShowDataArray withTitle:areaTitleStringTmp target:self labelTapAction:@selector(areaFilterChooseClick:)];
}

-(void)areaFilterChooseClick:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    int tag = (int)view.tag;
    if (tag >= districtToShowDataArray.count) {
        [PopUpSelectedView dismissFilterChooseView];
        return;
    }
    NSDictionary *areaChooseDic = districtToShowDataArray[tag];
    int districtID = [areaChooseDic[@"id"] intValue];
    NSString *districtName = areaChooseDic[@"name"];
    
    [self adjustTitleFilterArrowWithString:districtName inButton:titleAreaFiterButton];
    
    if (currentFilterDistrictID == districtID) {
        [PopUpSelectedView dismissFilterChooseView];
        return;
    }
    currentFilterDistrictID = districtID;
    
    [PopUpSelectedView dismissFilterChooseView];
    [self getContentDataWithPageIndex:1];
}

-(void)titleSupplyFiterButtonClick:(UIButton *)button{
    [PopUpSelectedView showFilterSingleChooseViewWithArray:supplyToShowDataArray withTitle:supplyTitleStringTmp target:self labelTapAction:@selector(supplyFilterChooseClick:)];
}

-(void)supplyFilterChooseClick:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    int tag = (int)view.tag;
    if (tag >= supplyToShowDataArray.count) {
        [PopUpSelectedView dismissFilterChooseView];
        return;
    }
    NSDictionary *supplyChooseDic = supplyToShowDataArray[tag];
    int idTmp = [supplyChooseDic[@"id"] intValue];
    NSString *supplyName = supplyChooseDic[@"name"];
    
    [self adjustTitleFilterArrowWithString:supplyName inButton:titleSupplyFiterButton];
    
    currentFilterSupplyID = idTmp;
    
    [PopUpSelectedView dismissFilterChooseView];
    [self getContentDataWithPageIndex:1];
}

-(void)titleGategroyFiterButtonClick:(UIButton *)button{
    [PopUpSelectedView showFilterSingleChooseViewWithArray:gategroyToShowDataArray withTitle:gategroyTitleStringTmp target:self labelTapAction:@selector(gategroyFilterChooseClick:)];
}

-(void)gategroyFilterChooseClick:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    int tag = (int)view.tag;
    if (tag >= gategroyToShowDataArray.count) {
        [PopUpSelectedView dismissFilterChooseView];
        return;
    }
    NSDictionary *gategroyChooseDic = gategroyToShowDataArray[tag];
    int typeID = [gategroyChooseDic[@"id"] intValue];
    NSString *typeName = gategroyChooseDic[@"name"];
    
    [self adjustTitleFilterArrowWithString:typeName inButton:titleGategroyFiterButton];
    
    currentGategroyTypeID = typeID;
    
    [PopUpSelectedView dismissFilterChooseView];
    [self getContentDataWithPageIndex:1];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == contentTableView) {
        if (currentDataArray && currentDataArray.count != 0) {
            return currentDataArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        if (currentDataArray && currentDataArray.count != 0) {
            HouseProduct *product = currentDataArray[indexPath.row];
            if (product.houseType == HouseProductDanjianZuNin) {
                //单间租赁
                return 95;
            }else if (product.houseType == HouseProductZhengTaoZuNin){
                //整套租赁
                return 95;
            }else if (product.houseType == HouseProductFangWuQiuZu){
                //房屋求租
                return 75;
            }else if (product.houseType == HouseProductChangFangZuNin ||
                      product.houseType == HouseProductChangFangQiuZu ||
                      product.houseType == HouseProductChangFangXiaoShou||
                      product.houseType == HouseProductChangFangQiuGou){
                //厂房租赁
                //厂房求租
                //厂房销售
                //厂房求购
                return 75;
            }else if (product.houseType == HouseProductFangWuXiaoShou){
                //房屋销售
                return 95;
            }else if (product.houseType == HouseProductFangWuQiuGou){
                //房屋求购
                return 75;
            }else if (product.houseType == HouseProductShangPuZuNin){
                //商铺租赁
            }else if (product.houseType == HouseProductShangPuXiaoShou){
                //商铺销售
            }
            return 95;
            //            return 75;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        static NSString *houseProductTableViewCellCellIdentifier0201 = @"carProductTableViewCellCellIdentifier0101";
        HouseProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:houseProductTableViewCellCellIdentifier0201];
        if (!cell) {
            cell = [[HouseProductTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:houseProductTableViewCellCellIdentifier0201];
        }
        HouseProduct *product = currentDataArray[indexPath.row];
        cell.product = product;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        HouseProduct *product = currentDataArray[indexPath.row];
        HousePostDetailViewController *hpdVC = [[HousePostDetailViewController alloc] init];
        hpdVC.product = product;
        [self.navigationController pushViewController:hpdVC animated:YES];
    }
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    NSString *titleName = @"房屋租赁销售";
    if (self.houseType == HouseProductDanjianZuNin) {
        //单间租赁
        titleName = @"单间租赁";
    }else if (self.houseType == HouseProductZhengTaoZuNin){
        //整套租赁
        titleName = @"整套租赁";
    }else if (self.houseType == HouseProductChangFangZuNin){
        //厂房租赁
        titleName = @"厂房租赁";
    }else if (self.houseType == HouseProductChangFangQiuZu){
        //厂房求租
        titleName = @"厂房求租";
    }else if (self.houseType == HouseProductFangWuXiaoShou){
        //房屋销售
        titleName = @"房屋销售";
    }else if (self.houseType == HouseProductChangFangXiaoShou){
        //厂房销售
        titleName = @"厂房销售";
    }else if (self.houseType == HouseProductChangFangQiuGou){
        //厂房求购
        titleName = @"厂房求购";
    }else if (self.houseType == HouseProductFangWuQiuZu){
        //房屋求租
        titleName = @"房屋求租";
    }else if (self.houseType == HouseProductFangWuQiuGou){
        //房屋求购
        titleName = @"房屋求购";
    }else if (self.houseType == HouseProductShangPuZuNin){
        //商铺租赁
        titleName = @"商铺租赁";
    }else if (self.houseType == HouseProductShangPuXiaoShou){
        //商铺销售
        titleName = @"商铺销售";
    }
    
    self.navigationItem.title = titleName;
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIImage *imageArrow = [UIImage imageNamed:@"icon_fb"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setImage:imageArrow forState:UIControlStateNormal];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(16);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rightButtonTitle = @" 发布";
    [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,60,20};
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    HousePostNewViewController *hpnVC = [[HousePostNewViewController alloc] init];
    [self.navigationController pushViewController:hpnVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end