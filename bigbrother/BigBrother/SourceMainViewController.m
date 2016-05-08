//
//  SourceMainViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SourceMainViewController.h"
#import "LoginViewController.h"
#import "CityChooseViewController.h"
#import "CarEnterViewController.h"
#import "HouseEnterViewController.h"
#import "FactoryEnterViewController.h"

#import "CarPostDetailViewController.h"
#import "HousePostDetailViewController.h"
#import "FactoryPostDetailViewController.h"

#import "CarProductTableViewCell.h"
#import "HouseProductTableViewCell.h"
#import "FactoryProductTableViewCell.h"

#import "CarProduct.h"
#import "HelpDriveProduct.h"
#import "RentCarProduct.h"
#import "CarPoolProduct.h"

#import "HouseProduct.h"
#import "SingleRoomRentProduct.h"
#import "WholeHouseRentProduct.h"
#import "WholeHouseSellProduct.h"
#import "WantHouseProduct.h"
#import "FactoryHouseProduct.h"

#import "FactoryProduct.h"


@interface SourceMainViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation SourceMainViewController{
    UIScrollView *contentView;
    
    UIView *recommandContentView;
    UITableView *recommandTableView;
    
    NSMutableArray *recommandProductionDaraArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)};
    contentView.contentSize = (CGSize){WIDTH(contentView),10000};
    contentView.backgroundColor = BB_WhiteColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    [self initTopCarouselView];
    
    [self initFunctionAreaView];
    
    [self initWithRecommandView];
}

#pragma mark - 轮播区域
static float topCarouselContentViewHeight = 140;
-(void)initTopCarouselView{
    UIView *topCarouselContentView = [[UIView alloc] init];
    topCarouselContentView.frame = (CGRect){0,0,WIDTH(contentView),topCarouselContentViewHeight};
    topCarouselContentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:topCarouselContentView];
    
    UIView *baseLineSepView = [[UIView alloc] init];
    baseLineSepView.frame = (CGRect){0,HEIGHT(topCarouselContentView)-0.5,WIDTH(topCarouselContentView),0.5};
    baseLineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [topCarouselContentView addSubview:baseLineSepView];
}

#pragma mark - 功能区域
static float functionViewEveryButtonHeight = 80;
static float functionViewContentViewHeight = 80*3;
-(void)initFunctionAreaView{
    UIView *functionAreaContentView = [[UIView alloc] init];
    functionAreaContentView.frame = (CGRect){0,0+topCarouselContentViewHeight,WIDTH(contentView),functionViewContentViewHeight};
    functionAreaContentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:functionAreaContentView];
    
    UIButton *carServiceButton = [[UIButton alloc] init];
    carServiceButton.frame = (CGRect){0,0,WIDTH(functionAreaContentView),functionViewEveryButtonHeight};
    [carServiceButton addTarget:self action:@selector(sourceMainCarServiceClick) forControlEvents:UIControlEventTouchUpInside];
    [functionAreaContentView addSubview:carServiceButton];
    
    UIImageView *carServiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_car"]];
    carServiceImageView.frame = (CGRect){10,10,60,60};
    [carServiceButton addSubview:carServiceImageView];
    
    UILabel *carServiceTextLabel = [[UILabel alloc] init];
    carServiceTextLabel.frame = (CGRect){RIGHT(carServiceImageView)+X(carServiceImageView),20,WIDTH(carServiceButton)-(RIGHT(carServiceImageView)+X(carServiceImageView))-X(carServiceImageView),17};
    carServiceTextLabel.font = Font(17);
    carServiceTextLabel.textColor = RGBColor(50, 50, 50);
    [carServiceButton addSubview:carServiceTextLabel];
    carServiceTextLabel.text = @"用车服务";
    carServiceTextLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *carServiceDetailLabel = [[UILabel alloc] init];
    carServiceDetailLabel.frame = (CGRect){LEFT(carServiceTextLabel),BOTTOM(carServiceTextLabel)+6,WIDTH(carServiceTextLabel),15};
    carServiceDetailLabel.font = Font(15);
    carServiceDetailLabel.textColor = RGBColor(100, 100, 100);
    [carServiceButton addSubview:carServiceDetailLabel];
    carServiceDetailLabel.text = @"寻找包车服务,提供包车服务,发起拼车等";
    carServiceDetailLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView *carServiceLineSepView = [[UIView alloc] init];
    carServiceLineSepView.frame = (CGRect){0,HEIGHT(carServiceButton)-0.5,WIDTH(carServiceButton),0.5};
    carServiceLineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [carServiceButton addSubview:carServiceLineSepView];
    
    UIButton *houseServiceButton = [[UIButton alloc] init];
    houseServiceButton.frame = (CGRect){0,functionViewEveryButtonHeight,WIDTH(functionAreaContentView),functionViewEveryButtonHeight};
    [houseServiceButton addTarget:self action:@selector(sourceMainHouseServiceClick) forControlEvents:UIControlEventTouchUpInside];
    [functionAreaContentView addSubview:houseServiceButton];
    
    UIImageView *houseServiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_house"]];
    houseServiceImageView.frame = (CGRect){10,10,60,60};
    [houseServiceButton addSubview:houseServiceImageView];
    
    UILabel *houseServiceTextLabel = [[UILabel alloc] init];
    houseServiceTextLabel.frame = (CGRect){RIGHT(houseServiceImageView)+X(houseServiceImageView),20,WIDTH(houseServiceButton)-(RIGHT(houseServiceImageView)+X(houseServiceImageView))-X(houseServiceImageView),17};
    houseServiceTextLabel.font = Font(17);
    houseServiceTextLabel.textColor = RGBColor(50, 50, 50);
    [houseServiceButton addSubview:houseServiceTextLabel];
    houseServiceTextLabel.text = @"房屋租赁销售";
    houseServiceTextLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *houseServiceDetailLabel = [[UILabel alloc] init];
    houseServiceDetailLabel.frame = (CGRect){LEFT(houseServiceTextLabel),BOTTOM(houseServiceTextLabel)+6,WIDTH(houseServiceTextLabel),15};
    houseServiceDetailLabel.font = Font(15);
    houseServiceDetailLabel.textColor = RGBColor(100, 100, 100);
    [houseServiceButton addSubview:houseServiceDetailLabel];
    houseServiceDetailLabel.text = @"海量最新的出租信息,免费发布出租信息";
    houseServiceDetailLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView *houseServiceLineSepView = [[UIView alloc] init];
    houseServiceLineSepView.frame = (CGRect){0,HEIGHT(houseServiceButton)-0.5,WIDTH(houseServiceButton),0.5};
    houseServiceLineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [houseServiceButton addSubview:houseServiceLineSepView];
    
    UIButton *factoryServiceButton = [[UIButton alloc] init];
    factoryServiceButton.frame = (CGRect){0,functionViewEveryButtonHeight*2,WIDTH(functionAreaContentView),functionViewEveryButtonHeight};
    [factoryServiceButton addTarget:self action:@selector(sourceMainFactoryServiceClick) forControlEvents:UIControlEventTouchUpInside];
    [functionAreaContentView addSubview:factoryServiceButton];
    
    UIImageView *factoryServiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_factory"]];
    factoryServiceImageView.frame = (CGRect){10,10,60,60};
    [factoryServiceButton addSubview:factoryServiceImageView];
    
    UILabel *factoryServiceTextLabel = [[UILabel alloc] init];
    factoryServiceTextLabel.frame = (CGRect){RIGHT(factoryServiceImageView)+X(factoryServiceImageView),20,WIDTH(factoryServiceButton)-(RIGHT(factoryServiceImageView)+X(factoryServiceImageView))-X(factoryServiceImageView),17};
    factoryServiceTextLabel.font = Font(17);
    factoryServiceTextLabel.textColor = RGBColor(50, 50, 50);
    [factoryServiceButton addSubview:factoryServiceTextLabel];
    factoryServiceTextLabel.text = @"工业产品";
    factoryServiceTextLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *factoryServiceDetailLabel = [[UILabel alloc] init];
    factoryServiceDetailLabel.frame = (CGRect){LEFT(factoryServiceTextLabel),BOTTOM(factoryServiceTextLabel)+6,WIDTH(factoryServiceTextLabel),15};
    factoryServiceDetailLabel.font = Font(15);
    factoryServiceDetailLabel.textColor = RGBColor(100, 100, 100);
    [factoryServiceButton addSubview:factoryServiceDetailLabel];
    factoryServiceDetailLabel.text = @"海量最新工业信息,免费发布工业产品信息";
    factoryServiceDetailLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView *factoryServiceLineSepView = [[UIView alloc] init];
    factoryServiceLineSepView.frame = (CGRect){0,HEIGHT(factoryServiceButton)-0.5,WIDTH(factoryServiceButton),0.5};
    factoryServiceLineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [factoryServiceButton addSubview:factoryServiceLineSepView];
}

-(void)sourceMainCarServiceClick{
    CarEnterViewController *ceVC = [[CarEnterViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:ceVC animated:YES];
}

-(void)sourceMainHouseServiceClick{
    HouseEnterViewController *heVC = [[HouseEnterViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:heVC animated:YES];
}

-(void)sourceMainFactoryServiceClick{
    FactoryEnterViewController *feVC = [[FactoryEnterViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:feVC animated:YES];
}

#pragma mark - 推荐区域
static float recommandContentViewOriginY;
static float recommandTitleViewHeight = 45.f;
-(void)initWithRecommandView{
    recommandContentViewOriginY = topCarouselContentViewHeight+functionViewContentViewHeight+10;
    recommandContentView = [[UIView alloc] init];
    recommandContentView.frame = (CGRect){0,recommandContentViewOriginY,WIDTH(contentView),HEIGHT(self.view)-BB_NarbarHeight-BB_TabbarHeight-recommandContentViewOriginY};
    recommandContentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:recommandContentView];
    
    UIView *recommandTitleView = [[UIView alloc] init];
    recommandTitleView.backgroundColor = recommandContentView.backgroundColor;
    recommandTitleView.frame = (CGRect){0,0,WIDTH(recommandContentView),recommandTitleViewHeight};
    [recommandContentView addSubview:recommandTitleView];
    
    UIView *tileLeftView = [[UIView alloc] initWithFrame:(CGRect){10,13.5,4,18}];
    tileLeftView.backgroundColor = BB_BlueColor;
    [recommandTitleView addSubview:tileLeftView];
    
    UILabel *recommandTitleLabel = [[UILabel alloc] init];
    recommandTitleLabel.frame = (CGRect){RIGHT(tileLeftView)+5,0,WIDTH(recommandContentView)-20,HEIGHT(recommandTitleView)};
    recommandTitleLabel.font = Font(16);
    recommandTitleLabel.textColor = RGBColor(50, 50, 50);
    recommandTitleLabel.text = @"最新供求信息";
    [recommandTitleView addSubview:recommandTitleLabel];
    
    UIView *titleSepLineView = [[UIView alloc] init];
    titleSepLineView.frame = (CGRect){0,HEIGHT(recommandTitleView)-1,WIDTH(recommandTitleView),1};
    titleSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [recommandTitleView addSubview:titleSepLineView];
    
    recommandTableView = [[UITableView alloc] initWithFrame:(CGRect){0,recommandTitleViewHeight,WIDTH(recommandContentView),HEIGHT(recommandContentView)-recommandTitleViewHeight} style:UITableViewStylePlain];
    recommandTableView.delegate = self;
    recommandTableView.dataSource = self;
    recommandTableView.showsHorizontalScrollIndicator = NO;
    recommandTableView.showsVerticalScrollIndicator = NO;
    recommandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [recommandContentView addSubview:recommandTableView];
    
    
    [self getrecommandList];
}

-(void)getrecommandList{
    [BBUrlConnection getRecommandListComplete:^(NSDictionary *resultDic, NSString *errorString) {
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
        //todo  服务器只提供了三组数据 后续会添加
        NSArray *helpDriveArray = dataDic[@"HELP_DRIVE"];
        NSArray *factoryArray = dataDic[@"PRODUCT"];
        NSArray *rentCarArray = dataDic[@"RENT_CAR"];
        
        recommandProductionDaraArray = [NSMutableArray array];
        
        for (NSDictionary *helpDriveDic in helpDriveArray) {
            HelpDriveProduct *product = [HelpDriveProduct productWithNetWorkDictionary:helpDriveDic];
            [recommandProductionDaraArray addObject:product];
        }
        
        for (NSDictionary *factoryDic in factoryArray) {
            FactoryProduct *product = [FactoryProduct productWithNetWorkDictionary:factoryDic];
            [recommandProductionDaraArray addObject:product];
        }
        
        for (NSDictionary *rentCarDic in rentCarArray) {
            RentCarProduct *product = [RentCarProduct productWithNetWorkDictionary:rentCarDic];
            [recommandProductionDaraArray addObject:product];
        }
        
        
        float tableHeightOffset = 0;
        for (BaseProduct *baseP in recommandProductionDaraArray) {
            if ([baseP isKindOfClass:[CarProduct class]]) {
                CarProduct *carP = (CarProduct *)baseP;
                if (carP.carType == CarProductPinChe) {
                    tableHeightOffset += 80;
                }else{
                    tableHeightOffset += 100;
                }
            }else if ([baseP isKindOfClass:[HouseProduct class]]){
                HouseProduct *houseP = (HouseProduct *)baseP;
                if (houseP.houseType == HouseProductDanjianZuNin) {
                    //单间租赁
                    tableHeightOffset +=  95;
                }else if (houseP.houseType == HouseProductZhengTaoZuNin){
                    //整套租赁
                    tableHeightOffset +=  95;
                }else if (houseP.houseType == HouseProductFangWuQiuZu){
                    //房屋求租
                    tableHeightOffset +=  75;
                }else if (houseP.houseType == HouseProductChangFangZuNin ||
                          houseP.houseType == HouseProductChangFangQiuZu ||
                          houseP.houseType == HouseProductChangFangXiaoShou||
                          houseP.houseType == HouseProductChangFangQiuGou){
                    //厂房租赁
                    //厂房求租
                    //厂房销售
                    //厂房求购
                    tableHeightOffset +=  75;
                }else if (houseP.houseType == HouseProductFangWuXiaoShou){
                    //房屋销售
                    tableHeightOffset +=  95;
                }else if (houseP.houseType == HouseProductFangWuQiuGou){
                    //房屋求购
                    tableHeightOffset +=  75;
                }else if (houseP.houseType == HouseProductShangPuZuNin){
                    //商铺租赁
                    //todo
                }else if (houseP.houseType == HouseProductShangPuXiaoShou){
                    //商铺销售
                    //todo
                }
                tableHeightOffset +=  95;
            }else if ([baseP isKindOfClass:[FactoryProduct class]]){
                tableHeightOffset +=  95;
            }
        }
        
        recommandContentViewOriginY = topCarouselContentViewHeight+functionViewContentViewHeight+10;
        
        recommandContentView.frame = (CGRect){0,recommandContentViewOriginY,WIDTH(contentView),tableHeightOffset+recommandTitleViewHeight};
        
        recommandTableView.frame = (CGRect){0,recommandTitleViewHeight,WIDTH(recommandTableView),tableHeightOffset};
        
        [recommandTableView reloadData];
        
        contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(self.view)-BB_NarbarHeight-BB_TabbarHeight+1, BOTTOM(recommandContentView)+BB_NarbarHeight+BB_TabbarHeight)+1};
    }];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == recommandTableView) {
        if (recommandProductionDaraArray && recommandProductionDaraArray.count != 0) {
            return recommandProductionDaraArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recommandTableView) {
        if (recommandProductionDaraArray && recommandProductionDaraArray.count != 0) {
            BaseProduct *product = recommandProductionDaraArray[indexPath.row];
            if ([product isKindOfClass:[CarProduct class]]) {
                CarProduct *carP = (CarProduct *)product;
                if (carP.carType == CarProductPinChe) {
                    return 80;
                }
                return 100;
            }else if ([product isKindOfClass:[HouseProduct class]]){
                HouseProduct *houseP = (HouseProduct *)product;
                if (houseP.houseType == HouseProductDanjianZuNin) {
                    //单间租赁
                    return 95;
                }else if (houseP.houseType == HouseProductZhengTaoZuNin){
                    //整套租赁
                    return 95;
                }else if (houseP.houseType == HouseProductFangWuQiuZu){
                    //房屋求租
                    return 75;
                }else if (houseP.houseType == HouseProductChangFangZuNin ||
                          houseP.houseType == HouseProductChangFangQiuZu ||
                          houseP.houseType == HouseProductChangFangXiaoShou||
                          houseP.houseType == HouseProductChangFangQiuGou){
                    //厂房租赁
                    //厂房求租
                    //厂房销售
                    //厂房求购
                    return 75;
                }else if (houseP.houseType == HouseProductFangWuXiaoShou){
                    //房屋销售
                    return 95;
                }else if (houseP.houseType == HouseProductFangWuQiuGou){
                    //房屋求购
                    return 75;
                }else if (houseP.houseType == HouseProductShangPuZuNin){
                    //商铺租赁
                }else if (houseP.houseType == HouseProductShangPuXiaoShou){
                    //商铺销售
                }
                return 95;
            }else if ([product isKindOfClass:[FactoryProduct class]]){
                return 95;
            }
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recommandTableView) {
        BaseProduct *product = recommandProductionDaraArray[indexPath.row];
        if ([product isKindOfClass:[CarProduct class]]) {
            CarProduct *carP = (CarProduct *)product;
            static NSString *CarProductTableViewCellIdentifier0001 = @"CarProductTableViewCellIdentifier0001";
            CarProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CarProductTableViewCellIdentifier0001];
            if (!cell) {
                cell = [[CarProductTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CarProductTableViewCellIdentifier0001];
            }
            cell.product = carP;
            return cell;
        }else if ([product isKindOfClass:[HouseProduct class]]){
            HouseProduct *houseP = (HouseProduct *)product;
            static NSString *HouseProductTableViewCellIdentifier0001 = @"HouseProductTableViewCellIdentifier0001";
            HouseProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseProductTableViewCellIdentifier0001];
            if (!cell) {
                cell = [[HouseProductTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HouseProductTableViewCellIdentifier0001];
            }
            cell.product = houseP;
            return cell;
        }else if ([product isKindOfClass:[FactoryProduct class]]){
            FactoryProduct *factoryP = (FactoryProduct *)product;
            static NSString *FactoryProductTableViewCellIdentifier0001 = @"FactoryProductTableViewCellIdentifier0001";
            FactoryProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FactoryProductTableViewCellIdentifier0001];
            if (!cell) {
                cell = [[FactoryProductTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FactoryProductTableViewCellIdentifier0001];
            }
            cell.product = factoryP;
            return cell;
        }else{
            return [UITableViewCell new];
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseProduct *product = recommandProductionDaraArray[indexPath.row];
    if ([product isKindOfClass:[CarProduct class]]) {
        CarProduct *carP = (CarProduct *)product;
        CarPostDetailViewController *cpdVC = [[CarPostDetailViewController alloc] init];
        cpdVC.carProduct = carP;
        [self.tabBarController.navigationController pushViewController:cpdVC animated:YES];
    }else if ([product isKindOfClass:[HouseProduct class]]){
        HouseProduct *houseP = (HouseProduct *)product;
        HousePostDetailViewController *hpdVC = [[HousePostDetailViewController alloc] init];
        hpdVC.product = houseP;
        [self.tabBarController.navigationController pushViewController:hpdVC animated:YES];
    }else if ([product isKindOfClass:[FactoryProduct class]]){
        FactoryProduct *factoryP = (FactoryProduct *)product;
        FactoryPostDetailViewController *fpdVC = [[FactoryPostDetailViewController alloc] init];
        fpdVC.product = factoryP;
        [self.tabBarController.navigationController pushViewController:fpdVC animated:YES];
    }else{
        return;
    }
}

-(void)setLocation{
    //获取用户当前位置
    [BBUrlConnection getUserCurrentLocationComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            return;
        }
        
        NSDictionary *cityDic = [dataDic objectForKey:@"city"];
        NSString *cityName = cityDic[@"name"];
        long cityID = [cityDic[@"id"] longValue];
        if (!cityName) {
            cityName = @"北京";
            cityID = 1;
        }
        [BBUserDefaults setCityDictionary:@{@"id":@(cityID),@"name":cityName}];
        [self setUpNavigation];
    }];
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.tabBarController.navigationItem.title = @"分类信息";
    
    UIImage *imageArrow = [UIImage imageNamed:@"navi_downarrow"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton setImage:imageArrow forState:UIControlStateNormal];
    leftButton.tintColor = [UIColor whiteColor];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = Font(15);
    [leftButton addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *leftButtonTitle;
    NSString *cityName = [BBUserDefaults getCityName];
    if (cityName) {
        leftButtonTitle = cityName;
    }else{
        [self setLocation];
        leftButtonTitle = @"定位中...";
    }
    
    CGSize btSize = [XYTools getSizeWithString:leftButtonTitle andSize:(CGSize){MAXFLOAT,15} andFont:Font(15)];
    [leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    leftButton.frame = (CGRect){0,0,btSize.width+imageArrow.size.width+10,20};
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.tabBarController.navigationItem setLeftBarButtonItem:leftBarButton];
    
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageArrow.size.width-3, 0, imageArrow.size.width+3)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, btSize.width, 0, -btSize.width)];
    
    UIImage *rightimage = [UIImage imageNamed:@"navi_rightmessage"];
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithImage:rightimage style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor whiteColor];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)leftItemClick{
    CityChooseViewController *ccVC = [[CityChooseViewController alloc] init];
    ccVC.isToSetDefaultCity = YES;
    [self.tabBarController.navigationController pushViewController:ccVC animated:YES];
}

-(void)rightItemClick{
    //todo 我的消息页面跳转
    if (![BBUserDefaults getIsLogin]) {
        //跳转登录
        NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Navigation_FontColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        
        [navi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
        
        navi.view.backgroundColor = BB_WhiteColor;
        navi.navigationBar.barTintColor = BB_NaviColor;
        navi.navigationBar.barStyle = UIBarStyleBlack;
        
        [self presentViewController:navi animated:YES completion:nil];
        return;
    }
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
