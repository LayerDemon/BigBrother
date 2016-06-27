//
//  PositionChooseViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CityChooseViewController.h"

@interface CityChooseViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CityChooseViewController{
    UITableView *provinceContentTableView;
    UIScrollView *provinceCityScrollView;
    
    NSMutableArray *cityNameButtonArray;
    
    NSArray *provinceContentTableDataArray;
    
    int currentProvinceSelectedIndex;
    int currentCityID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    currentProvinceSelectedIndex = -1;
    currentCityID = [BBUserDefaults getCityID];
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    provinceContentTableView = [[UITableView alloc] initWithFrame:(CGRect){0,BB_NarbarHeight,100,HEIGHT(self.view)-BB_NarbarHeight} style:UITableViewStylePlain];
    provinceContentTableView.delegate = self;
    provinceContentTableView.dataSource = self;
    provinceContentTableView.showsHorizontalScrollIndicator = NO;
    provinceContentTableView.showsVerticalScrollIndicator = NO;
    provinceContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:provinceContentTableView];
    
    provinceCityScrollView = [[UIScrollView alloc] initWithFrame:(CGRect){WIDTH(provinceContentTableView),BB_NarbarHeight,WIDTH(self.view)-WIDTH(provinceContentTableView),HEIGHT(provinceContentTableView)}];
    provinceCityScrollView.contentSize = (CGSize){WIDTH(provinceCityScrollView),HEIGHT(provinceCityScrollView)+1};
    provinceCityScrollView.backgroundColor = BB_WhiteColor;
    provinceCityScrollView.showsHorizontalScrollIndicator = NO;
    provinceCityScrollView.showsVerticalScrollIndicator = NO;
    provinceCityScrollView.bounces = YES;
    [self.view addSubview:provinceCityScrollView];
    
    [self getAllProvinceAndCity];
}

-(void)reloadCityListViewWithArray:(NSArray *)array{
    [provinceCityScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIFont *nameFont = Font(14);
    float offsetOriginX = 15;
    float offsetOriginY = 15;
    float offsetBetweenWidth = 10;
    float offsetBetweenHeight = 10;
    float labelPaddingX = 10;
    float labelPaddingY = 8;
    
    float usedViewWidth = offsetOriginX - offsetBetweenWidth;
    float usedViewheight = offsetOriginY;
    
    int xOffset = 0;
    int yOffset = 0;
    
    cityNameButtonArray = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *cityDic = array[i];
        
        NSString *name = cityDic[@"name"];
        int cityIDHere = [cityDic[@"id"] intValue];
        
        CGSize nameSize = [XYTools getSizeWithString:name andSize:(CGSize){MAXFLOAT,15} andFont:nameFont];
        
        float buttonWidth = nameSize.width + labelPaddingX * 2;
        
        float buttonHeight = nameSize.height + labelPaddingY * 2;
        
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nameButton.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
        nameButton.layer.borderWidth = 0.5f;
        [nameButton setTitle:name forState:UIControlStateNormal];
        [nameButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
        [nameButton setTitleColor:BB_BlueColor forState:UIControlStateSelected];
        nameButton.backgroundColor = [UIColor whiteColor];
        nameButton.tintColor = [UIColor whiteColor];
        nameButton.tag = i;
        [nameButton addTarget:self action:@selector(cityNameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        usedViewWidth += buttonWidth + offsetBetweenWidth;
        
        if (usedViewWidth <= WIDTH(provinceCityScrollView)) {
            yOffset += 0;
            xOffset += 1;
        }else{
            yOffset += 1;
            xOffset = 0;
            usedViewheight += offsetBetweenHeight + buttonHeight;
            
            usedViewWidth = offsetOriginX-offsetBetweenWidth;
            usedViewWidth += buttonWidth+offsetBetweenWidth;
        }
        
        nameButton.frame = (CGRect){
            usedViewWidth-buttonWidth,
            usedViewheight,
            buttonWidth,
            buttonHeight
        };
        [provinceCityScrollView addSubview:nameButton];
        
        [nameButton setSelected:NO];
        
        if (cityIDHere == currentCityID) {
            [nameButton setSelected:YES];
        }
        [cityNameButtonArray addObject:nameButton];
    }
}

-(void)cityNameButtonClick:(UIButton *)button{
    if (currentProvinceSelectedIndex >= provinceContentTableDataArray.count) {
        return;
    }
    NSDictionary *provinceDic = provinceContentTableDataArray[currentProvinceSelectedIndex];
    NSArray *cityList = provinceDic[@"cityList"];
    
    int tag = (int)button.tag;
    if (tag >= cityList.count) {
        return;
    }
    NSDictionary *cityInfoDic = cityList[tag];
    
    int cityID = [cityInfoDic[@"id"] intValue];
    NSString *cityName = cityInfoDic[@"name"];
    
    if (cityID == 0 || !cityName) {
        return;
    }
    
    for (UIButton *bu in cityNameButtonArray) {
        if (bu == button) {
            [bu setSelected:YES];
        }
        [bu setSelected:NO];
    }
    currentCityID = cityID;
    if (self.isToSetDefaultCity) {
        [BBUserDefaults setCityDictionary:@{@"id":@(cityID),@"name":cityName}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSourceMainData" object:nil];
    }else{
        if (self.completeBlock) {
            self.completeBlock(currentCityID,cityName);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getAllProvinceAndCity{
    [BBUrlConnection getAllProvinceAndCityComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        if (![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"数据错误,请重试"];
            return;
        }
        provinceContentTableDataArray = dataArray;
        [provinceContentTableView reloadData];
        
        int cityID = currentCityID;
        if (cityID == 0){
            cityID = 1;
        }
        for (int i = 0; i < provinceContentTableDataArray.count; i++) {
            NSDictionary *provinceDic = provinceContentTableDataArray[i];
            
            NSArray *cityListArray = provinceDic[@"cityList"];
            for (NSDictionary *cityInfoDic in cityListArray) {
                int cityIDTmp = [cityInfoDic[@"id"] intValue];
                if (cityID == cityIDTmp) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [provinceContentTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    [self tableView:provinceContentTableView didSelectRowAtIndexPath:indexPath];
                    return;
                }
            }
        }
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == provinceContentTableView) {
        if (provinceContentTableDataArray && provinceContentTableDataArray.count != 0) {
            return provinceContentTableDataArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == provinceContentTableView) {
        if (provinceContentTableDataArray && provinceContentTableDataArray.count != 0) {
            return 45;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == provinceContentTableView) {
        static NSString *provinceContentTableViewCellIdentifier = @"provinceContentTableViewCellIdentifier";
        CityChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:provinceContentTableViewCellIdentifier];
        if (!cell) {
            cell = [[CityChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:provinceContentTableViewCellIdentifier];
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dataDic = provinceContentTableDataArray[indexPath.row];
        NSDictionary *provinceDic = dataDic[@"province"];
        NSString *name = provinceDic[@"name"];
        
        cell.textLabel.text = name;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == provinceContentTableView) {
        NSDictionary *dataDic = provinceContentTableDataArray[indexPath.row];
        NSArray *cityListArray = dataDic[@"cityList"];
        
        currentProvinceSelectedIndex = (int)indexPath.row;
        if (cityListArray) {
            [self reloadCityListViewWithArray:cityListArray];
        }
    }
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    self.navigationItem.title = @"城市选择";
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
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

@implementation CityChooseTableViewCell{
    UIView *lineSepView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imageView.image = [UIImage new];
        self.imageView.backgroundColor = BB_BlueColor;
        
        self.textLabel.font = Font(15);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        self.detailTextLabel.hidden = YES;
        
        lineSepView = [[UIView alloc] init];
        lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:lineSepView];
    }
    return self;
}

-(void)layoutSubviews{
    self.imageView.frame = (CGRect){0,0,4,45};
    
    self.textLabel.frame =  (CGRect){0,0,100,45};
    
    lineSepView.frame = (CGRect){0,45-0.5,100,0.5};
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.imageView.hidden = NO;
        
        self.textLabel.textColor = BB_BlueColor;
    }else{
        self.imageView.hidden = YES;
        
        self.textLabel.textColor = RGBColor(50, 50, 50);
    }
}

@end
