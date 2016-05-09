//
//  ChatMainViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChatMainViewController.h"
#import "MessageView.h"
#import "ContactView.h"

@interface ChatMainViewController ()

@property (strong, nonatomic) UISegmentedControl    *segmentedControl;
@property (strong, nonatomic) MessageView           *messageView;//消息界面
@property (strong, nonatomic) ContactView           *contactView;       //聊天界面

@end

@implementation ChatMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeDataSource];
    [self initializeUserInterface];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.navigationItem setTitleView:nil];
    
    //移除环信代理
    [self.messageView unregisterNotifications];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.titleView = self.segmentedControl;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //设置环信代理
    [self.messageView registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    [self indexDidChangeForSegmentedControl:self.segmentedControl];
}
#pragma mark - 各种Getter
- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
//        [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
//        [self.tabBarController.navigationItem setRightBarButtonItem:nil];
        NSArray *segmentedArray = [NSArray arrayWithObjects:@"消息",@"联系人",nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        segmentedControl.frame = CGRectMake(0.0, 0.0, WIDTH(self.view)/2.5, 30.0);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor whiteColor];
        [segmentedControl addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)
                   forControlEvents:UIControlEventValueChanged];
        _segmentedControl = segmentedControl;
    }
    return _segmentedControl;
}

- (MessageView *)messageView
{
    if (!_messageView) {
        _messageView = [[MessageView alloc]init];
    }
    return _messageView;
}

- (ContactView *)contactView
{
    if (!_contactView) {
        _contactView = [[ContactView alloc] init];
    }
    return _contactView;
}

#pragma mark - 按钮方法
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)SegC{
    if (SegC.selectedSegmentIndex == 0){
        NSLog(@"message");
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.view addSubview:self.messageView];
    }else{
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.view addSubview:self.contactView];
        NSLog(@"address");
        
    }
}


#pragma mark - 自定义方法



//{
//    UITableView *tableV;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    UIView *topFixView = [[UIView alloc] init];
//    topFixView.frame = CGRectZero;
//    [self.view addSubview:topFixView];
//    
//    tableV = [[UITableView alloc] initWithFrame:(CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight} style:UITableViewStylePlain];
//    tableV.delegate = self;
//    tableV.dataSource = self;
//    tableV.showsHorizontalScrollIndicator = NO;
//    tableV.showsVerticalScrollIndicator = NO;
//    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:tableV];
//    /*
//    [tableV initDownRefresh];
//    [tableV setDownRefreshBlock:^(id refreshView){
//        [weakself getContentDataWithPageIndex:1];
//    }];
//    
//    [tableV initPullUpRefresh];
//    [tableV setPullUpRefreshBlock:^(id refreshView){
//        [weakself getContentDataWithPageIndex:currentListIndex + 1];
//    }];
//     */
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.tabBarController.navigationItem setTitleView:nil];
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setUpNavigation];
//}

//
//#pragma mark - UITableViewDelegate
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 6;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 65;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *LTMessageTableViewCellCellIdentifier = @"LTMessageTableViewCell";
//    LTMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTMessageTableViewCellCellIdentifier];
//    if (!cell) {
//        cell = [[LTMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTMessageTableViewCellCellIdentifier];
//    }
////        FactoryProduct *product = currentDataArray[indexPath.row];
////        cell.product = product;
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    if (tableView == contentTableView) {
////        FactoryPostDetailViewController *fpdVC = [[FactoryPostDetailViewController alloc] init];
////        FactoryProduct *product = currentDataArray[indexPath.row];
////        fpdVC.product = product;
////        [self.navigationController pushViewController:fpdVC animated:YES];
////    }
//}
@end
