//
//  ContactView.m
//  BigBrother
//
//  Created by zhangyi on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ContactView.h"
#import "ContactTableViewCell.h"

@interface ContactView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       * tableView;

@end

@implementation ContactView
static NSString * identify = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 64, MAINSCRREN_W, MAINSCRREN_H-64-48);
        self.backgroundColor = [UIColor whiteColor];
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}


#pragma mark - 数据初始化
- (void)initializeDataSource
{
    
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    //搜索按钮
    UIButton * searchBut = [self createButtonWithTitle:@"搜索" font:FLEXIBLE_NUM(13) subView:self];
    searchBut.frame = FLEXIBLE_FRAME(30, 10, 260, 30);
    searchBut.backgroundColor = RGBACOLOR(241, 241, 241, 1);
    searchBut.layer.cornerRadius = FLEXIBLE_NUM(15);
    searchBut.clipsToBounds = YES;
    [searchBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    [self addSubview:self.tableView];
}
#pragma mark - 各种Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FLEXIBLE_NUM(100), MAINSCRREN_W, MAINSCRREN_H-FLEXIBLE_NUM(100))];
        _tableView.rowHeight = FLEXIBLE_NUM(47);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    [_tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:identify];
    return _tableView;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    
    
    return cell;
}

#pragma mark - 按钮方法


#pragma mark - 自定义方法


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
