//
//  PostMatchedViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/12.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "PostMatchedViewController.h"

#import "PostMacthTableViewCell.h"

#import "UIScrollView+XYRefresh.h"
#import "UIAlertView+Blocks.h"

#import "RentCarProduct.h"
#import "HelpDriveProduct.h"
#import "CarPoolProduct.h"

#import "SingleRoomRentProduct.h"
#import "WholeHouseRentProduct.h"
#import "WholeHouseSellProduct.h"
#import "WantHouseProduct.h"
#import "FactoryHouseProduct.h"

#import "CarPostDetailViewController.h"
#import "HousePostDetailViewController.h"
#import "FactoryPostDetailViewController.h"

@interface PostMatchedViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PostMacthTableViewCellDelegate>

@end

@implementation PostMatchedViewController{
    UIButton *neitherAcceptButton;
    UIButton *mineAcceptButton;
    UIButton *otherAcceptButton;
    
    UIView *selectedLineView;
    
    UIScrollView *contentView;
    
    UITableView *neitherAcceptContentTableView;
    UITableView *mineAcceptContentTableView;
    UITableView *otherAcceptContentTableView;
    
    NSMutableArray *neitherAcceptTableDataArray;
    NSMutableArray *mineAcceptTableDataArray;
    NSMutableArray *otherAcceptTableDataArray;
    
    int currentNeitherAcceptTableIndex;
    int currentMineAcceptTableIndex;
    int currentotherAcceptTableIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIView *selectView = [[UIView alloc] init];
    selectView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),45};
    selectView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:selectView];
    
    neitherAcceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    neitherAcceptButton.frame = (CGRect){0,0,WIDTH(selectView)/3,HEIGHT(selectView)};
    [neitherAcceptButton setTitle:@"未认可" forState:UIControlStateNormal];
    [neitherAcceptButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    neitherAcceptButton.titleLabel.font = Font(15);
    [selectView addSubview:neitherAcceptButton];
    [neitherAcceptButton addTarget:self action:@selector(neitherAcceptButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    mineAcceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mineAcceptButton.frame = (CGRect){WIDTH(selectView)/3,0,WIDTH(selectView)/3,HEIGHT(selectView)};
    [mineAcceptButton setTitle:@"我认可的" forState:UIControlStateNormal];
    [mineAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    mineAcceptButton.titleLabel.font = Font(15);
    [selectView addSubview:mineAcceptButton];
    [mineAcceptButton addTarget:self action:@selector(mineAcceptButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    otherAcceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    otherAcceptButton.frame = (CGRect){WIDTH(selectView)*2.f/3,0,WIDTH(selectView)/3,HEIGHT(selectView)};
    [otherAcceptButton setTitle:@"其他人认可" forState:UIControlStateNormal];
    [otherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    otherAcceptButton.titleLabel.font = Font(15);
    [selectView addSubview:otherAcceptButton];
    [otherAcceptButton addTarget:self action:@selector(otherAcceptButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepLineView1 = [[UIView alloc] init];
    sepLineView1.frame = (CGRect){WIDTH(selectView)/3,5,0.5,HEIGHT(selectView)-10};
    sepLineView1.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [selectView addSubview:sepLineView1];
    
    UIView *sepLineView2 = [[UIView alloc] init];
    sepLineView2.frame = (CGRect){WIDTH(selectView)*2.f/3,5,0.5,HEIGHT(selectView)-10};
    sepLineView2.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [selectView addSubview:sepLineView2];
    
    selectedLineView = [[UIView alloc] init];
    selectedLineView.frame = (CGRect){0,45-2,WIDTH(self.view)/3,2};
    selectedLineView.backgroundColor = BB_BlueColor;
    [selectView addSubview:selectedLineView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = self.view.backgroundColor;
    contentView.frame = (CGRect){0,BOTTOM(selectView),WIDTH(self.view),HEIGHT(self.view)-BOTTOM(selectView)};
    contentView.delegate = self;
    contentView.tag = 88911;
    contentView.pagingEnabled = YES;
    contentView.contentSize = (CGSize){WIDTH(contentView)*3,HEIGHT(contentView)};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    neitherAcceptContentTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)} style:UITableViewStylePlain];
    neitherAcceptContentTableView.backgroundColor = contentView.backgroundColor;
    neitherAcceptContentTableView.delegate = self;
    neitherAcceptContentTableView.dataSource = self;
    neitherAcceptContentTableView.showsHorizontalScrollIndicator = NO;
    neitherAcceptContentTableView.showsVerticalScrollIndicator = NO;
    neitherAcceptContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:neitherAcceptContentTableView];
    
    mineAcceptContentTableView = [[UITableView alloc] initWithFrame:(CGRect){WIDTH(contentView),0,WIDTH(contentView),HEIGHT(contentView)} style:UITableViewStylePlain];
    mineAcceptContentTableView.backgroundColor = contentView.backgroundColor;
    mineAcceptContentTableView.delegate = self;
    mineAcceptContentTableView.dataSource = self;
    mineAcceptContentTableView.showsHorizontalScrollIndicator = NO;
    mineAcceptContentTableView.showsVerticalScrollIndicator = NO;
    mineAcceptContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:mineAcceptContentTableView];
    
    otherAcceptContentTableView = [[UITableView alloc] initWithFrame:(CGRect){WIDTH(contentView)*2,0,WIDTH(contentView),HEIGHT(contentView)} style:UITableViewStylePlain];
    otherAcceptContentTableView.backgroundColor = contentView.backgroundColor;
    otherAcceptContentTableView.delegate = self;
    otherAcceptContentTableView.dataSource = self;
    otherAcceptContentTableView.showsHorizontalScrollIndicator = NO;
    otherAcceptContentTableView.showsVerticalScrollIndicator = NO;
    otherAcceptContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:otherAcceptContentTableView];
    
    currentNeitherAcceptTableIndex = 1;
    currentMineAcceptTableIndex = 1;
    currentotherAcceptTableIndex = 1;
    
    [neitherAcceptContentTableView initDownRefresh];
    [neitherAcceptContentTableView initPullUpRefresh];
    
    [mineAcceptContentTableView initDownRefresh];
    [mineAcceptContentTableView initPullUpRefresh];
    
    [otherAcceptContentTableView initDownRefresh];
    [otherAcceptContentTableView initPullUpRefresh];
    
    weak(weakself, self);
    
    //未审核
    [neitherAcceptContentTableView setDownRefreshBlock:^(id refreshView){
        [weakself getNeightMatchDataArrayWithIndex:1];
    }];
    
    [neitherAcceptContentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getNeightMatchDataArrayWithIndex:currentNeitherAcceptTableIndex+1];
    }];
    
    //显示中
    [mineAcceptContentTableView setDownRefreshBlock:^(id refreshView){
        [weakself getMineMatchDataArrayWithIndex:1];
    }];
    
    [mineAcceptContentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getMineMatchDataArrayWithIndex:currentMineAcceptTableIndex+1];
    }];
    
    //已完成
    [otherAcceptContentTableView setDownRefreshBlock:^(id refreshView){
        [weakself getotherMatchDataArrayWithIndex:1];
    }];
    
    [otherAcceptContentTableView setPullUpRefreshBlock:^(id refreshView){
        [weakself getotherMatchDataArrayWithIndex:currentotherAcceptTableIndex+1];
    }];
    
    
    [self getPostListContent];
}

-(void)neitherAcceptButtonClick{
    [contentView setContentOffset:(CGPoint){0,0} animated:YES];
    [neitherAcceptButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    [mineAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [otherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
}

-(void)mineAcceptButtonClick{
    [contentView setContentOffset:(CGPoint){WIDTH(contentView),0} animated:YES];
    [neitherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [mineAcceptButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    [otherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
}

-(void)otherAcceptButtonClick{
    [contentView setContentOffset:(CGPoint){WIDTH(contentView)*2,0} animated:YES];
    [neitherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [mineAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [otherAcceptButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
}

#pragma mark - 请求网络数据
-(void)getPostListContent{
    [self getNeightMatchDataArrayWithIndex:1];
    
    [self getMineMatchDataArrayWithIndex:1];
    
    [self getotherMatchDataArrayWithIndex:1];
}

-(void)getNeightMatchDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.myPostInfo.postInfoID) forKey:@"postId"];
    //    type :	未认可：NEITHER。我认可的：SELF。对方认可的：OTHER
    [params setObject:@"NEITHER" forKey:@"type"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getMatchedPostListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [neitherAcceptContentTableView endDownRefresh];
        [neitherAcceptContentTableView endPullUpRefresh];
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
        if (listArray && [listArray isKindOfClass:[NSArray class]] && listArray.count > 0) {
            NSMutableArray *listArrayTmp = [NSMutableArray array];
            [listArray enumerateObjectsUsingBlock:^(NSDictionary *netDic, NSUInteger idx, BOOL *stop) {
                MyPostInfo *postInfo = [MyPostInfo infoWithNetDictionary:netDic];
                postInfo.infoType = MyPostInfoTableShowTypeDone;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentNeitherAcceptTableIndex = index;
            if (currentNeitherAcceptTableIndex == 1) {
                neitherAcceptTableDataArray = [NSMutableArray array];
            }
            [neitherAcceptTableDataArray addObjectsFromArray:listArrayTmp];
            [neitherAcceptContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

-(void)getMineMatchDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.myPostInfo.postInfoID) forKey:@"postId"];
    //    type :	未认可：NEITHER。我认可的：SELF。对方认可的：OTHER
    [params setObject:@"SELF" forKey:@"type"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getMatchedPostListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [mineAcceptContentTableView endDownRefresh];
        [mineAcceptContentTableView endPullUpRefresh];
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
        if (listArray && [listArray isKindOfClass:[NSArray class]] && listArray.count > 0) {
            NSMutableArray *listArrayTmp = [NSMutableArray array];
            [listArray enumerateObjectsUsingBlock:^(NSDictionary *netDic, NSUInteger idx, BOOL *stop) {
                MyPostInfo *postInfo = [MyPostInfo infoWithNetDictionary:netDic];
                postInfo.infoType = MyPostInfoTableShowTypeDone;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentMineAcceptTableIndex = index;
            if (currentMineAcceptTableIndex == 1) {
                mineAcceptTableDataArray = [NSMutableArray array];
            }
            [mineAcceptTableDataArray addObjectsFromArray:listArrayTmp];
            [mineAcceptContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

-(void)getotherMatchDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.myPostInfo.postInfoID) forKey:@"postId"];
    //    type :	未认可：NEITHER。我认可的：SELF。对方认可的：OTHER
    [params setObject:@"OTHER" forKey:@"type"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getMatchedPostListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [otherAcceptContentTableView endDownRefresh];
        [otherAcceptContentTableView endPullUpRefresh];
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
        if (listArray && [listArray isKindOfClass:[NSArray class]] && listArray.count > 0) {
            NSMutableArray *listArrayTmp = [NSMutableArray array];
            [listArray enumerateObjectsUsingBlock:^(NSDictionary *netDic, NSUInteger idx, BOOL *stop) {
                MyPostInfo *postInfo = [MyPostInfo infoWithNetDictionary:netDic];
                postInfo.infoType = MyPostInfoTableShowTypeDone;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentotherAcceptTableIndex = index;
            if (currentotherAcceptTableIndex == 1) {
                otherAcceptTableDataArray = [NSMutableArray array];
            }
            [otherAcceptTableDataArray addObjectsFromArray:listArrayTmp];
            [otherAcceptContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 88911) {
        float xOff = scrollView.contentOffset.x;
        if (xOff < 0 || xOff > scrollView.contentSize.width) {
            return;
        }
        selectedLineView.frame = (CGRect){xOff/3,45-2,WIDTH(self.view)/3,2};
        if (xOff == 0) {
            [neitherAcceptButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            [mineAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [otherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
        }else if (xOff == WIDTH(scrollView)){
            [neitherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [mineAcceptButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            [otherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
        }else if (xOff == WIDTH(scrollView)*2){
            [neitherAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [mineAcceptButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [otherAcceptButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == neitherAcceptContentTableView) {
        if (neitherAcceptTableDataArray) {
            return neitherAcceptTableDataArray.count;
        }
    }else if (tableView == mineAcceptContentTableView) {
        if (mineAcceptTableDataArray) {
            return mineAcceptTableDataArray.count;
        }
    }else if (tableView == otherAcceptContentTableView) {
        if (otherAcceptTableDataArray) {
            return otherAcceptTableDataArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView) {
        static NSString *PostMacthTableViewCellIdentifier88911 = @"PostMacthTableViewCellIdentifier88911";
        PostMacthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PostMacthTableViewCellIdentifier88911];
        if (!cell) {
            cell = [[PostMacthTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PostMacthTableViewCellIdentifier88911];
        }
        if (tableView == neitherAcceptContentTableView) {
            if (neitherAcceptTableDataArray) {
                MyPostInfo *info = neitherAcceptTableDataArray[indexPath.row];
                cell.postInfo = info;
                cell.tableType = PostMacthTableTypeNeither;
            }
        }else if (tableView == mineAcceptContentTableView) {
            if (mineAcceptTableDataArray) {
                MyPostInfo *info = mineAcceptTableDataArray[indexPath.row];
                cell.postInfo = info;
                cell.tableType = PostMacthTableTypeMine;
            }
        }else if (tableView == otherAcceptContentTableView) {
            if (otherAcceptTableDataArray) {
                MyPostInfo *info = otherAcceptTableDataArray[indexPath.row];
                cell.postInfo = info;
                cell.tableType = PostMacthTableTypeOther;
            }
        }
        cell.delegate = self;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

#pragma mark PostMacthTableViewCellDelegate
-(void)postMatchTableCell:(PostMacthTableViewCell *)cell didClickIgnoreButton:(UIButton *)ignoreButton{
    [BBUrlConnection ignoreInfoWithPostID:self.myPostInfo.postInfoID macthPostID:cell.postInfo.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        BOOL success = [resultDic[@"data"][@"success"] boolValue];
        if (success) {
            [BYToastView showToastWithMessage:@"操作忽略信息成功"];
            [self getPostListContent];
        }else{
            [BYToastView showToastWithMessage:@"操作忽略信息失败,请稍候再试"];
        }
    }];
}

-(void)postMatchTableCell:(PostMacthTableViewCell *)cell didClickAcceptButton:(UIButton *)accrptButton{
    [BBUrlConnection acceptInfoWithPostID:self.myPostInfo.postInfoID macthPostID:cell.postInfo.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        BOOL success = [resultDic[@"data"][@"success"] boolValue];
        if (success) {
            [BYToastView showToastWithMessage:@"操作认可信息成功"];
            [self getPostListContent];
        }else{
            [BYToastView showToastWithMessage:@"操作认可信息失败,请稍候再试"];
        }
    }];
}

-(void)postMatchTableCell:(PostMacthTableViewCell *)cell didClickDetailButton:(UIButton *)detailButton{
    MyPostInfo *info = cell.postInfo;
    NSString *postTypeString = info.postType;
    //todo 可能需要修改添加的地方
    if ([postTypeString isEqualToString:CarProductType_RentCar]) {
        [BBUrlConnection getRentCarInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            RentCarProduct *product = [RentCarProduct productWithNetWorkDictionary:resultDic[@"data"]];
            CarPostDetailViewController *detailVC = [[CarPostDetailViewController alloc] init];
            detailVC.carProduct = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:CarProductType_HelpDrive]){
        [BBUrlConnection getDaiJiaInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            HelpDriveProduct *product = [HelpDriveProduct productWithNetWorkDictionary:resultDic[@"data"]];
            CarPostDetailViewController *detailVC = [[CarPostDetailViewController alloc] init];
            detailVC.carProduct = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:CarProductType_CarPool]){
        [BBUrlConnection getCarPoolInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            CarPoolProduct *product = [CarPoolProduct productWithNetWorkDictionary:resultDic[@"data"]];
            CarPostDetailViewController *detailVC = [[CarPostDetailViewController alloc] init];
            detailVC.carProduct = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:HouseProductHouseRoomType_ChuShou]){
        [BBUrlConnection getWholeHouseWantSellInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            WholeHouseSellProduct *product = [WholeHouseSellProduct productWithNetWorkDictionary:resultDic[@"data"]];
            HousePostDetailViewController *detailVC = [[HousePostDetailViewController alloc] init];
            detailVC.product = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:HouseProductHouseRoomType_QiuGou]){
        //房屋求购
        [BBUrlConnection getWholeHouseWantBuyInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            WantHouseProduct *product = [WantHouseProduct productWithNetWorkDictionary:resultDic[@"data"]];
            HousePostDetailViewController *detailVC = [[HousePostDetailViewController alloc] init];
            detailVC.product = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:HouseProductHouseRoomType_QiuZu]){
        //房屋求租
        [BBUrlConnection getWholeHouseWantRentInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            WantHouseProduct *product = [WantHouseProduct productWithNetWorkDictionary:resultDic[@"data"]];
            HousePostDetailViewController *detailVC = [[HousePostDetailViewController alloc] init];
            detailVC.product = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:HouseProductHouseRoomType_RentHouse]){
        //整屋租赁
        [BBUrlConnection getWholeHouseRentInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            WholeHouseRentProduct *product = [WholeHouseRentProduct productWithNetWorkDictionary:resultDic[@"data"]];
            HousePostDetailViewController *detailVC = [[HousePostDetailViewController alloc] init];
            detailVC.product = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:HouseProductHouseRoomType_RentRoom]){
        //单间租赁
        [BBUrlConnection getSingleRoomRentInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            SingleRoomRentProduct *product = [SingleRoomRentProduct productWithNetWorkDictionary:resultDic[@"data"]];
            HousePostDetailViewController *detailVC = [[HousePostDetailViewController alloc] init];
            detailVC.product = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:HouseProductFactoryRoomType_ChuZu] ||
              [postTypeString isEqualToString:HouseProductFactoryRoomType_QiuZu] ||
              [postTypeString isEqualToString:HouseProductFactoryRoomType_ChuShou] ||
              [postTypeString isEqualToString:HouseProductFactoryRoomType_QiuGou]){
        [BBUrlConnection getFactoryHouseProductWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            FactoryHouseProduct *product = [FactoryHouseProduct productWithNetWorkDictionary:resultDic[@"data"]];
            HousePostDetailViewController *detailVC = [[HousePostDetailViewController alloc] init];
            detailVC.product = product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }else if ([postTypeString isEqualToString:FactoryProductType_FactoryProduct]){
        //获取工业产品信息详情
        [BBUrlConnection getFactoryProductWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
                return;
            }
            FactoryProduct *product = [FactoryProduct productWithNetWorkDictionary:resultDic[@"data"]];
            FactoryPostDetailViewController *detailVC = [[FactoryPostDetailViewController alloc] init];
            detailVC.product= product;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"匹配的信息";
    
    
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
    if (contentView) {
        [neitherAcceptContentTableView reloadData];
        [mineAcceptContentTableView reloadData];
        [otherAcceptContentTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end