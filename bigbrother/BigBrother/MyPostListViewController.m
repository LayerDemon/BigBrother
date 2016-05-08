//
//  MyPostListViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/5.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MyPostListViewController.h"
#import "PostOnTopViewController.h"

#import "MyPostsTableViewCell.h"

#import "MyPostInfo.h"
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

#import "PostMatchedViewController.h"

@interface MyPostListViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MyPostsTableViewCellDelegate>

@end

@implementation MyPostListViewController{
    UIButton *unAuthButton;
    UIButton *showingButton;
    UIButton *doneButton;
    
    UIView *selectedLineView;
    
    UIScrollView *contentView;
    
    UITableView *unAuthContentTableView;
    UITableView *showingContentTableView;
    UITableView *doneContentTableView;
    
    NSMutableArray *unAuthTableDataArray;
    NSMutableArray *showingTableDataArray;
    NSMutableArray *doneTableDataArray;
    
    int currentUnAuthTableIndex;
    int currentShowingTableIndex;
    int currentDoneTableIndex;
    
    
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
    
    unAuthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    unAuthButton.frame = (CGRect){0,0,WIDTH(selectView)/3,HEIGHT(selectView)};
    [unAuthButton setTitle:@"未审核" forState:UIControlStateNormal];
    [unAuthButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    unAuthButton.titleLabel.font = Font(15);
    [selectView addSubview:unAuthButton];
    [unAuthButton addTarget:self action:@selector(unAuthButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    showingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showingButton.frame = (CGRect){WIDTH(selectView)/3,0,WIDTH(selectView)/3,HEIGHT(selectView)};
    [showingButton setTitle:@"显示中" forState:UIControlStateNormal];
    [showingButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    showingButton.titleLabel.font = Font(15);
    [selectView addSubview:showingButton];
    [showingButton addTarget:self action:@selector(showingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = (CGRect){WIDTH(selectView)*2.f/3,0,WIDTH(selectView)/3,HEIGHT(selectView)};
    [doneButton setTitle:@"已完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    doneButton.titleLabel.font = Font(15);
    [selectView addSubview:doneButton];
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    contentView.tag = 88981;
    contentView.pagingEnabled = YES;
    contentView.contentSize = (CGSize){WIDTH(contentView)*3,HEIGHT(contentView)};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    unAuthContentTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)} style:UITableViewStylePlain];
    unAuthContentTableView.backgroundColor = contentView.backgroundColor;
    unAuthContentTableView.delegate = self;
    unAuthContentTableView.dataSource = self;
    unAuthContentTableView.showsHorizontalScrollIndicator = NO;
    unAuthContentTableView.showsVerticalScrollIndicator = NO;
    unAuthContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:unAuthContentTableView];
    
    showingContentTableView = [[UITableView alloc] initWithFrame:(CGRect){WIDTH(contentView),0,WIDTH(contentView),HEIGHT(contentView)} style:UITableViewStylePlain];
    showingContentTableView.backgroundColor = contentView.backgroundColor;
    showingContentTableView.delegate = self;
    showingContentTableView.dataSource = self;
    showingContentTableView.showsHorizontalScrollIndicator = NO;
    showingContentTableView.showsVerticalScrollIndicator = NO;
    showingContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:showingContentTableView];
    
    doneContentTableView = [[UITableView alloc] initWithFrame:(CGRect){WIDTH(contentView)*2,0,WIDTH(contentView),HEIGHT(contentView)} style:UITableViewStylePlain];
    doneContentTableView.delegate = self;
    doneContentTableView.backgroundColor = contentView.backgroundColor;
    doneContentTableView.dataSource = self;
    doneContentTableView.showsHorizontalScrollIndicator = NO;
    doneContentTableView.showsVerticalScrollIndicator = NO;
    doneContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:doneContentTableView];
    
    currentUnAuthTableIndex = 1;
    currentShowingTableIndex = 1;
    currentDoneTableIndex = 1;
    
    [unAuthContentTableView initDownRefresh];
    [unAuthContentTableView initPullUpRefresh];
    
    [showingContentTableView initDownRefresh];
    [showingContentTableView initPullUpRefresh];
    
    [doneContentTableView initDownRefresh];
    [doneContentTableView initPullUpRefresh];
    
    weak(weakself, self);
    
    //未审核
    [unAuthContentTableView setDownRefreshBlock:^(id refreshView){
        if (weakself.isProvide) {
            [weakself provideGetAllUnAuthDataArrayWithIndex:1];
        }else{
            [weakself askGetAllUnAuthDataArrayWithIndex:1];
        }
    }];
    
    [unAuthContentTableView setPullUpRefreshBlock:^(id refreshView){
        if (weakself.isProvide) {
            [weakself provideGetAllUnAuthDataArrayWithIndex:currentUnAuthTableIndex+1];
        }else{
            [weakself askGetAllUnAuthDataArrayWithIndex:currentUnAuthTableIndex+1];
        }
    }];
    
    //显示中
    [showingContentTableView setDownRefreshBlock:^(id refreshView){
        if (weakself.isProvide) {
            [weakself provideGetAllShowingDataArrayWithIndex:1];
        }else{
            [weakself askGetAllShowingDataArrayWithIndex:1];
        }
    }];
    
    [showingContentTableView setPullUpRefreshBlock:^(id refreshView){
        if (weakself.isProvide) {
            [weakself provideGetAllShowingDataArrayWithIndex:currentShowingTableIndex+1];
        }else{
            [weakself askGetAllShowingDataArrayWithIndex:currentShowingTableIndex+1];
        }
    }];
    
    //已完成
    [doneContentTableView setDownRefreshBlock:^(id refreshView){
        if (weakself.isProvide) {
            [weakself provideGetAllDoneDataArrayWithIndex:1];
        }else{
            [weakself askGetAllDoneDataArrayWithIndex:1];
        }
    }];
    
    [doneContentTableView setPullUpRefreshBlock:^(id refreshView){
        if (weakself.isProvide) {
            [weakself provideGetAllDoneDataArrayWithIndex:currentDoneTableIndex+1];
        }else{
            [weakself askGetAllDoneDataArrayWithIndex:currentDoneTableIndex+1];
        }
    }];
    
    
    [self getPostListContent];
}

-(void)unAuthButtonClick{
    [contentView setContentOffset:(CGPoint){0,0} animated:YES];
    [unAuthButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    [showingButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [doneButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
}

-(void)showingButtonClick{
    [contentView setContentOffset:(CGPoint){WIDTH(contentView),0} animated:YES];
    [unAuthButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [showingButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    [doneButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
}

-(void)doneButtonClick{
    [contentView setContentOffset:(CGPoint){WIDTH(contentView)*2,0} animated:YES];
    [unAuthButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [showingButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    [doneButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
}

#pragma mark - 请求网络数据
-(void)getPostListContent{
    if (self.isProvide) {
        [self provideGetAllDoneDataArrayWithIndex:1];
        [self provideGetAllUnAuthDataArrayWithIndex:1];
        [self provideGetAllShowingDataArrayWithIndex:1];
    }else{
        [self askGetAllDoneDataArrayWithIndex:1];
        [self askGetAllShowingDataArrayWithIndex:1];
        [self askGetAllUnAuthDataArrayWithIndex:1];
    }
}

#pragma mark - 供应相关请求网络
-(void)provideGetAllUnAuthDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"PROVIDE" forKey:@"supplyDemandType"];
    [params setObject:@"NOT_AUDITED" forKey:@"status"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getAllMyPostInfoListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [unAuthContentTableView endDownRefresh];
        [unAuthContentTableView endPullUpRefresh];
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
                postInfo.infoType = MyPostInfoTableShowTypeUnAuth;
                postInfo.isProvide = YES;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentUnAuthTableIndex = index;
            if (currentUnAuthTableIndex == 1) {
                unAuthTableDataArray = [NSMutableArray array];
            }
            [unAuthTableDataArray addObjectsFromArray:listArrayTmp];
            [unAuthContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

-(void)provideGetAllShowingDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"PROVIDE" forKey:@"supplyDemandType"];
    [params setObject:@"AUDIT_PASSED" forKey:@"status"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getAllMyPostInfoListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [showingContentTableView endDownRefresh];
        [showingContentTableView endPullUpRefresh];
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
                postInfo.infoType = MyPostInfoTableShowTypeShowing;
                postInfo.isProvide = YES;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentShowingTableIndex = index;
            if (currentShowingTableIndex == 1) {
                showingTableDataArray = [NSMutableArray array];
            }
            [showingTableDataArray addObjectsFromArray:listArrayTmp];
            [showingContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

-(void)provideGetAllDoneDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"PROVIDE" forKey:@"supplyDemandType"];
    [params setObject:@"FINISHED" forKey:@"status"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getAllMyPostInfoListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [doneContentTableView endDownRefresh];
        [doneContentTableView endPullUpRefresh];
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
                postInfo.isProvide = YES;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentDoneTableIndex = index;
            if (currentDoneTableIndex == 1) {
                doneTableDataArray = [NSMutableArray array];
            }
            [doneTableDataArray addObjectsFromArray:listArrayTmp];
            [doneContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}


#pragma mark - 需求相关请求网络
-(void)askGetAllUnAuthDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"ASK" forKey:@"supplyDemandType"];
    [params setObject:@"NOT_AUDITED" forKey:@"status"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getAllMyPostInfoListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [unAuthContentTableView endDownRefresh];
        [unAuthContentTableView endPullUpRefresh];
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
                postInfo.infoType = MyPostInfoTableShowTypeUnAuth;
                postInfo.isProvide = NO;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentUnAuthTableIndex = index;
            if (currentUnAuthTableIndex == 1) {
                unAuthTableDataArray = [NSMutableArray array];
            }
            [unAuthTableDataArray addObjectsFromArray:listArrayTmp];
            [unAuthContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

-(void)askGetAllShowingDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"ASK" forKey:@"supplyDemandType"];
    [params setObject:@"AUDIT_PASSED" forKey:@"status"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getAllMyPostInfoListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [showingContentTableView endDownRefresh];
        [showingContentTableView endPullUpRefresh];
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
                postInfo.infoType = MyPostInfoTableShowTypeShowing;
                postInfo.isProvide = NO;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentShowingTableIndex = index;
            if (currentShowingTableIndex == 1) {
                showingTableDataArray = [NSMutableArray array];
            }
            [showingTableDataArray addObjectsFromArray:listArrayTmp];
            [showingContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

-(void)askGetAllDoneDataArrayWithIndex:(int)index{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"ASK" forKey:@"supplyDemandType"];
    [params setObject:@"FINISHED" forKey:@"status"];
    [params setObject:@(index) forKey:@"page"];
    [params setObject:@"20" forKey:@"pageSize"];
    
    [BBUrlConnection getAllMyPostInfoListWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        [doneContentTableView endDownRefresh];
        [doneContentTableView endPullUpRefresh];
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
                postInfo.isProvide = NO;
                [listArrayTmp addObject:postInfo];
            }];
            
            currentDoneTableIndex = index;
            if (currentDoneTableIndex == 1) {
                doneTableDataArray = [NSMutableArray array];
            }
            [doneTableDataArray addObjectsFromArray:listArrayTmp];
            [doneContentTableView reloadData];
        }else{
            [BYToastView showToastWithMessage:@"无数据"];
        }
    }];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 88981) {
        float xOff = scrollView.contentOffset.x;
        if (xOff < 0 || xOff > scrollView.contentSize.width) {
            return;
        }
        selectedLineView.frame = (CGRect){xOff/3,45-2,WIDTH(self.view)/3,2};
        if (xOff == 0) {
            [unAuthButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            [showingButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [doneButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
        }else if (xOff == WIDTH(scrollView)){
            [unAuthButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [showingButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            [doneButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
        }else if (xOff == WIDTH(scrollView)*2){
            [unAuthButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [showingButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
            [doneButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == unAuthContentTableView) {
        if (unAuthTableDataArray) {
            return unAuthTableDataArray.count;
        }
    }else if (tableView == showingContentTableView) {
        if (showingTableDataArray) {
            return showingTableDataArray.count;
        }
    }else if (tableView == doneContentTableView) {
        if (doneTableDataArray) {
            return doneTableDataArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == unAuthContentTableView) {
        if (unAuthTableDataArray) {
            MyPostInfo *info = unAuthTableDataArray[indexPath.row];
            return [MyPostsTableViewCell staticHeightWithPostInfo:info];
        }
    }else if (tableView == showingContentTableView) {
        if (showingTableDataArray) {
            MyPostInfo *info = showingTableDataArray[indexPath.row];
            return [MyPostsTableViewCell staticHeightWithPostInfo:info];
        }
    }else if (tableView == doneContentTableView) {
        if (doneTableDataArray) {
            MyPostInfo *info = doneTableDataArray[indexPath.row];
            return [MyPostsTableViewCell staticHeightWithPostInfo:info];
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView) {
        static NSString *MyPostInfoTableViewCellCellIdentifier88981 = @"MyPostInfoTableViewCellCellIdentifier88981";
        MyPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyPostInfoTableViewCellCellIdentifier88981];
        if (!cell) {
            cell = [[MyPostsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyPostInfoTableViewCellCellIdentifier88981];
        }
        if (tableView == unAuthContentTableView) {
            if (unAuthTableDataArray) {
                MyPostInfo *info = unAuthTableDataArray[indexPath.row];
                cell.postInfo = info;
            }
        }else if (tableView == showingContentTableView) {
            if (showingTableDataArray) {
                MyPostInfo *info = showingTableDataArray[indexPath.row];
                cell.postInfo = info;
            }
        }else if (tableView == doneContentTableView) {
            if (doneTableDataArray) {
                MyPostInfo *info = doneTableDataArray[indexPath.row];
                cell.postInfo = info;
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

#pragma mark - MyPostsTableViewCellDelegate
-(void)myPostTableCell:(MyPostsTableViewCell *)cell didTapMatchView:(UIView *)matchView{
    MyPostInfo *info = cell.postInfo;
    PostMatchedViewController *pmVC = [[PostMatchedViewController alloc] init];
    pmVC.myPostInfo = info;
    [self.navigationController pushViewController:pmVC animated:YES];
}

-(void)myPostTableCell:(MyPostsTableViewCell *)cell didClickOnTopButton:(UIButton *)onTopButton{
    MyPostInfo *info = cell.postInfo;
    if (info.infoType == MyPostInfoTableShowTypeShowing) {
        if (info.onTop) {
            [BYToastView showToastWithMessage:@""];
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"该条信息已置顶,是否取消置顶?" cancelButtonItem:[RIButtonItem itemWithLabel:@"返回" action:nil] otherButtonItems:[RIButtonItem itemWithLabel:@"取消置顶" action:^{
                [BBUrlConnection updatePostInfoOnTop:NO infoID:info.postInfoID dayCount:0 complete:^(NSDictionary *resultDic, NSString *errorString) {
                    if (errorString) {
                        [BYToastView showToastWithMessage:errorString];
                        return;
                    }
                    int code = [resultDic[@"code"] intValue];
                    NSDictionary *dataDic = resultDic[@"data"];
                    if (code != 0) {
                        [BYToastView showToastWithMessage:@"取消置顶失败,请稍候再试"];
                        return;
                    }
                    if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
                        BOOL success = [dataDic[@"success"] boolValue];
                        if (success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [BYToastView showToastWithMessage:@"取消置顶成功"];
                                info.onTop = NO;
                                [unAuthContentTableView reloadData];
                                [showingContentTableView reloadData];
                                [doneContentTableView reloadData];
                            });
                            return;
                        }
                    }
                }];
            }], nil];
            [alertview show];
            return;
        }
        PostOnTopViewController *potVC = [[PostOnTopViewController alloc] init];
        potVC.postInfo = info;
        [self.navigationController pushViewController:potVC animated:YES];
    }
}

-(void)myPostTableCell:(MyPostsTableViewCell *)cell didClickEditButton:(UIButton *)editButton{
    MyPostInfo *info = cell.postInfo;
    int isGoInt = -1;
    if ([editButton.titleLabel.text isEqualToString:@"上架"]) {
        isGoInt = 1;
    }else if ([editButton.titleLabel.text isEqualToString:@"下架"]) {
        isGoInt = 0;
    }
    if (isGoInt == -1) {
        return;
    }
    [BBUrlConnection setPutOnSaleOrNot:isGoInt==0?NO:YES postInfoID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        BOOL success = [resultDic[@"data"][@"success"] boolValue];
        if (success) {
            [BYToastView showToastWithMessage:@"操作成功"];
            if (isGoInt == 0) {
                info.status = @"CANCELED";
                [unAuthContentTableView reloadData];
                [showingContentTableView reloadData];
                [doneContentTableView reloadData];
            }else{
                info.status = @"SHOWING";
                [unAuthContentTableView reloadData];
                [showingContentTableView reloadData];
                [doneContentTableView reloadData];
            }
            return;
        }
        [BYToastView showToastWithMessage:@"操作失败,请稍候再试"];
        return;
    }];
}

-(void)myPostTableCell:(MyPostsTableViewCell *)cell didClickDeleteButton:(UIButton *)deleteButton{
    MyPostInfo *info = cell.postInfo;
    if ([deleteButton.titleLabel.text isEqualToString:@"删除"]) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"确定删除该消息吗?" cancelButtonItem:[RIButtonItem itemWithLabel:@"返回" action:nil] otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            [BBUrlConnection deletePostInfoWithID:info.postInfoID complete:^(NSDictionary *resultDic, NSString *errorString) {
                if (errorString) {
                    [BYToastView showToastWithMessage:errorString];
                    return;
                }
                NSDictionary *dataDic = resultDic[@"data"];
                BOOL status = [dataDic[@"success"] boolValue];
                if (status) {
                    [BYToastView showToastWithMessage:@"删除成功"];
                    [unAuthContentTableView reloadData];
                    [showingContentTableView reloadData];
                    [doneContentTableView reloadData];
                }else{
                    [BYToastView showToastWithMessage:@"删除失败,请稍候再试"];
                }
            }];
        }], nil];
        [alertview show];
    }else if([deleteButton.titleLabel.text isEqualToString:@"已删除"]){
        [BYToastView showToastWithMessage:@"该信息已删除"];
    }else if([deleteButton.titleLabel.text isEqualToString:@"详情"]){
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
}

#pragma mark - Navigation
-(void)setUpNavigation{
    if (self.isProvide) {
        self.navigationItem.title = @"我的供应信息";
    }else{
        self.navigationItem.title = @"我的需求信息";
    }
    
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
        [unAuthContentTableView reloadData];
        [showingContentTableView reloadData];
        [doneContentTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end