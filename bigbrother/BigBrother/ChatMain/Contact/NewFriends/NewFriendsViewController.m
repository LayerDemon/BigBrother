//
//  NewFriendsViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/10.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "NewFriendsViewController.h"

#import "NewFriendsTableViewCell.h"
#import "ContactModel.h"

@interface NewFriendsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView   * tableView;
@property (strong, nonatomic) NSArray       * dataArray;
@property (strong, nonatomic) ContactModel  * contactModel;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation NewFriendsViewController

static NSString * identify = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"新朋友";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{
    [_contactModel removeObserver:self forKeyPath:@"friendsRequestData"];
}

#pragma mrak -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"friendsRequestData"]) {
        _dataArray = _contactModel.friendsRequestData[@"data"];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
     NSDictionary * dataDic = [BBUserDefaults getUserDic];
    _contactModel = ({
        ContactModel * model = [[ContactModel alloc] init];
        [model addObserver:self forKeyPath:@"friendsRequestData" options:NSKeyValueObservingOptionNew context:nil];
        [model checkAllFriendsRequestListWithUserId:dataDic[@"id"] limit:@"50"];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = BG_COLOR;
    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight = FLEXIBLE_NUM(50);
        [self.view addSubview:tableView];
        tableView;
    });
    
    [_tableView registerClass:[NewFriendsTableViewCell class] forCellReuseIdentifier:identify];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}





@end
