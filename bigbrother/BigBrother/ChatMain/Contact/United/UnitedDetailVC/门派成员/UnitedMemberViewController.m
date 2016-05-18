//
//  UnitedMemberViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedMemberViewController.h"
#import "UnitedMember2TableViewCell.h"

@interface UnitedMemberViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       * tableView;
@property (strong, nonatomic) NSArray           * dataArray;
@property (strong, nonatomic) NSArray           * colorArray;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation UnitedMemberViewController

static NSString * identify = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"门派成员";
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _colorArray = @[ARGB_COLOR(254, 217, 110, 1),ARGB_COLOR(150, 220, 116, 1),ARGB_COLOR(202, 202, 202, 1)];
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
        
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FLEXIBLE_NUM(40), MAINSCRREN_W, MAINSCRREN_H - 64 - FLEXIBLE_NUM(40)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(47);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });
    [_tableView registerClass:[UnitedMember2TableViewCell class] forCellReuseIdentifier:identify];
}

#pragma mark -- <<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedMember2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dataDic = _memberArray[indexPath.row];
    [cell.headImageView  sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    cell.statusLabel.text = dataDic[@"gradeName"];
    if ([dataDic[@"role"] isEqualToString:@"OWNER"]) {
        cell.statusLabel.backgroundColor = _colorArray[0];
    }else if ([dataDic[@"role"] isEqualToString:@"ADMIN"]){
        cell.statusLabel.backgroundColor = _colorArray[1];
    }else{
        cell.statusLabel.backgroundColor = _colorArray[2];
    }
    cell.userNameLabel.text = dataDic[@"nameInGroup"];
    
    return cell;
}

@end
