//
//  MessageView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MessageView.h"
#import "MessageViewCell.h"

@interface MessageView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MessageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H);
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
    [self addSubview:self.tableView];
}
#pragma mark - 各种Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds];
        _tableView.rowHeight = FLEXIBLE_NUM(47);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[MessageViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

#pragma mark - 按钮方法


#pragma mark - 自定义方法



@end
