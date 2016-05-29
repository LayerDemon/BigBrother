//
//  SetManagerViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/19.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SetManagerViewController.h"
#import "UnitedTableViewCell.h"
#import "AddUnitedManagerViewController.h"

@interface SetManagerViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView               * tableView;
@property (strong, nonatomic) NSMutableArray            * dataArray;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation SetManagerViewController
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
        self.navigationItem.title = @"设置管理员";
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _dataArray = [[NSMutableArray alloc] init];
    NSArray * memberArray = _unitedDetailDic[@"members"];
    for (int i = 0; i < [memberArray count]; i ++) {
        if ([memberArray[i][@"role"] isEqualToString:@"ADMIN"]) {
            [_dataArray addObject:memberArray[i]];
        }
    }
    
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
        //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;

    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(45);
//        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });
    [_tableView registerClass:[UnitedTableViewCell class] forCellReuseIdentifier:identify];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    NSDictionary * dataDic = _dataArray[indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    cell.groupNameLabel.text = dataDic[@"nameInGroup"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLEXIBLE_NUM(45);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * backView = [[UIView alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 320, 45)];
    
    UIButton * addManagerButton = [self createButtonWithTitle:@"添加管理员"];
    addManagerButton.frame = FLEXIBLE_FRAME(0, 5, 320, 40);
    [addManagerButton addTarget:self action:@selector(addManagerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:addManagerButton];
    return backView;
}

- (void)addManagerButtonPressed:(UIButton *)sender
{
    AddUnitedManagerViewController * addVC = [[AddUnitedManagerViewController alloc] init];
    NSMutableArray * resultArray = [NSMutableArray array];
    for (int i = 0; i < [_unitedDetailDic[@"members"] count]; i ++) {
        if ([_unitedDetailDic[@"members"][i][@"role"] isEqualToString:@"USER"]) {
            [resultArray addObject:_unitedDetailDic[@"members"][i]];
        }
    }
    addVC.memberArray = resultArray;
    addVC.unitedDic = _unitedDetailDic;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mrak -- my methods
- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [self createLabelWithText:title font:FLEXIBLE_NUM(13) subView:button];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 100, 40);
    
    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(295, 15, 10, 10)];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.image = [UIImage imageNamed:@"icon_more"];
    [button addSubview:rightImageView];
    
    UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:button];
    lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    
    return button;
}


#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    label.font = [UIFont systemFontOfSize:font];
    [subView addSubview:label];
    return label;
}

#pragma mark -- create button 
- (UIButton *)createButtonWithTitle:(NSString *)title font:(CGFloat)font subView:(UIView *)subView
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [subView addSubview:button];
    return button;
}

#pragma mark -- create view
- (UIView *)createViewWithBackColor:(UIColor *)color subView:(UIView *)subView
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = color;
    [subView addSubview:view];
    return view;
}

@end
