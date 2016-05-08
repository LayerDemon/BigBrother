//
//  FactorySquareViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FactorySquareViewController.h"

#import "FactoryProductTableViewCell.h"
#import "FactoryPostNewViewController.h"
#import "FactoryPostDetailViewController.h"

#import "UIScrollView+XYRefresh.h"

#import "FactoryProduct.h"

@interface FactorySquareViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation FactorySquareViewController{
    UIView *titleFilterView;
    UIButton *titleAreaFiterButton,*titleSupplyFiterButton,*titleGategroyFiterButton;
    
    UITableView *contentTableView;
    
    NSArray *currentDataArray;
    
    NSMutableArray *totalDataArray;
    
    NSArray *districtToShowDataArray;
    
    NSArray *supplyToShowDataArray;
    
    NSArray *gategroyToShowDataArray;
    
    int currentListIndex;
    
    NSString *gategroyTitleName;
    
    int currentFilterDistrictID;
    
    NSString *currentFilterSupplyInfo;
    
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
    
    NSString *enterProductName = [self.enterProductTypeInfo objectForKey:@"name"];
    int enterProductID = [[self.enterProductTypeInfo objectForKey:@"id"] intValue];
    if (enterProductName && enterProductID != 0) {
        if (enterProductID == -1) {
            enterProductName = @"所有产品";
        }
        currentGategroyTypeID = enterProductID;
        gategroyTitleName = enterProductName;
    }
    
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
    supplyToShowDataArray = @[@{@"name":@"所有",@"params":@""},
                              @{@"name":@"供应",@"params":@"PROVIDE"},
                              @{@"name":@"需求",@"params":@"ASK"}];
}

//获取类型选择列表
-(void)getGategroyList{
    if (!self.productTypeListArray || self.productTypeListArray.count == 0) {
        [self getFactoryProductTypeList];
    }else{
        gategroyToShowDataArray = self.productTypeListArray;
    }
}

-(void)getFactoryProductTypeList{
    [BBUrlConnection getFactoryProductTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取类别信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || dataArray.count == 0 || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取类别信息失败,请稍后再试"];
            return;
        }
        NSMutableArray *typeTmpShowedArray = [NSMutableArray array];
        
        [typeTmpShowedArray addObject:@{@"id":@(-1),@"name":@"所有产品"}];
        
        for (NSDictionary *dic in dataArray) {
            int gategroyIDTmp = [dic[@"id"] intValue];
            NSString *name = dic[@"name"];
            [typeTmpShowedArray addObject:@{@"id":@(gategroyIDTmp),@"name":name}];
        }
        gategroyToShowDataArray = [NSArray arrayWithArray:typeTmpShowedArray];
        self.productTypeListArray = gategroyToShowDataArray;
    }];
}

//获取列表信息接口 统一调用这个函数
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
    if (currentFilterSupplyInfo) {
        [params setObject:currentFilterSupplyInfo forKey:@"supplyDemandType"];
    }
    
    if (currentGategroyTypeID != -1 && currentGategroyTypeID != 0) {
        [params setObject:@(currentGategroyTypeID) forKey:@"typeId"];
    }
    
    [self getAllFactoryProductListWithParams:params index:index];
}

//获取全部的租车的信息
-(void)getAllFactoryProductListWithParams:(NSMutableDictionary *)params index:(int)index{
    [BBUrlConnection getAllFactoryProductListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
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
            FactoryProduct *product = [FactoryProduct productWithNetWorkDictionary:dic];
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
    [titleAreaFiterButton setTitle:@"区域" forState:UIControlStateNormal];
    [titleAreaFiterButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    titleAreaFiterButton.titleLabel.font = Font(14);
    titleAreaFiterButton.layer.masksToBounds = YES;
    [titleFilterView addSubview:titleAreaFiterButton];
    
    titleSupplyFiterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleSupplyFiterButton.frame = (CGRect){10*2+everyButtonWidth,0,everyButtonWidth,HEIGHT(titleFilterView)};
    titleSupplyFiterButton.tintColor = RGBColor(50, 50, 50);
    [titleSupplyFiterButton setTitle:@"供需" forState:UIControlStateNormal];
    [titleSupplyFiterButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    titleSupplyFiterButton.titleLabel.font = Font(14);
    titleSupplyFiterButton.layer.masksToBounds = YES;
    [titleFilterView addSubview:titleSupplyFiterButton];
    
    titleGategroyFiterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleGategroyFiterButton.frame = (CGRect){10*3+everyButtonWidth*2,0,everyButtonWidth,HEIGHT(titleFilterView)};
    titleGategroyFiterButton.tintColor = RGBColor(50, 50, 50);
    [titleGategroyFiterButton setTitle:@"类别" forState:UIControlStateNormal];
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
    
    [self adjustTitleFilterArrowWithString:@"区域" inButton:titleAreaFiterButton];
    [self adjustTitleFilterArrowWithString:@"供需" inButton:titleSupplyFiterButton];
    [self adjustTitleFilterArrowWithString:gategroyTitleName inButton:titleGategroyFiterButton];
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
    [PopUpSelectedView showFilterSingleChooseViewWithArray:districtToShowDataArray withTitle:@"地区" target:self labelTapAction:@selector(areaFilterChooseClick:)];
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
    [PopUpSelectedView showFilterSingleChooseViewWithArray:supplyToShowDataArray withTitle:@"供需" target:self labelTapAction:@selector(supplyFilterChooseClick:)];
}

-(void)supplyFilterChooseClick:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    int tag = (int)view.tag;
    if (tag >= supplyToShowDataArray.count) {
        [PopUpSelectedView dismissFilterChooseView];
        return;
    }
    NSDictionary *supplyChooseDic = supplyToShowDataArray[tag];
    NSString *params = supplyChooseDic[@"params"];
    NSString *supplyName = supplyChooseDic[@"name"];
    
    [self adjustTitleFilterArrowWithString:supplyName inButton:titleSupplyFiterButton];
    
    currentFilterSupplyInfo = params;
    
    [PopUpSelectedView dismissFilterChooseView];
    [self getContentDataWithPageIndex:1];
}

-(void)titleGategroyFiterButtonClick:(UIButton *)button{
    [PopUpSelectedView showFilterSingleChooseViewWithArray:gategroyToShowDataArray withTitle:@"类别" target:self labelTapAction:@selector(gategroyFilterChooseClick:)];
}

-(void)gategroyFilterChooseClick:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    int tag = (int)view.tag;
    if (tag >= gategroyToShowDataArray.count) {
        [PopUpSelectedView dismissFilterChooseView];
        return;
    }
    NSDictionary *gategroyChooseDic = gategroyToShowDataArray[tag];
    int carTypeID = [gategroyChooseDic[@"id"] intValue];
    NSString *carTypeName = gategroyChooseDic[@"name"];
    
    [self adjustTitleFilterArrowWithString:carTypeName inButton:titleGategroyFiterButton];
    
    currentGategroyTypeID = carTypeID;
    
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
            return 95;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        static NSString *factoryProductTableViewCellCellIdentifier0301 = @"carProductTableViewCellCellIdentifier0101";
        FactoryProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:factoryProductTableViewCellCellIdentifier0301];
        if (!cell) {
            cell = [[FactoryProductTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:factoryProductTableViewCellCellIdentifier0301];
        }
        FactoryProduct *product = currentDataArray[indexPath.row];
        cell.product = product;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == contentTableView) {
        FactoryPostDetailViewController *fpdVC = [[FactoryPostDetailViewController alloc] init];
        FactoryProduct *product = currentDataArray[indexPath.row];
        fpdVC.product = product;
        [self.navigationController pushViewController:fpdVC animated:YES];
    }
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    NSString *titleName = @"工业产品";
    
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
    FactoryPostNewViewController *fpnVC = [[FactoryPostNewViewController alloc] init];
    [self.navigationController pushViewController:fpnVC animated:YES];
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