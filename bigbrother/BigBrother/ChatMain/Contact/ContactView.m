//
//  ContactView.m
//  BigBrother
//
//  Created by zhangyi on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ContactView.h"
#import "ContactTableViewCell.h"
#import "ContactModel.h"
#import "NewFriendsViewController.h"
#import "UnitedViewController.h"

#define SECTION_TAG 2300
@interface ContactView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       * tableView;
@property (strong, nonatomic) ContactModel      * contactMoel;
@property (strong, nonatomic) NSArray           * allFriendsArray;
@property (strong, nonatomic) NSMutableArray    * dataArray;
@property (strong, nonatomic) NSMutableArray    * selectedArray;


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

- (void)dealloc
{
    [_contactMoel removeObserver:self forKeyPath:@"allFriendsData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"allFriendsData"]) {
        _allFriendsArray = _contactMoel.allFriendsData[@"data"];
        if (!_dataArray) {
            _dataArray = [[NSMutableArray alloc] init];
        }
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:_contactMoel.allFriendsData[@"data"]];
        
        //
        if (!_selectedArray) {
            _selectedArray = [[NSMutableArray alloc] init];
        }
        [_selectedArray removeAllObjects];
        
        
        for (int i = 0; i < _dataArray.count; i ++) {
            NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] initWithDictionary:_dataArray[i]];
            [dataDic setObject:@[] forKey:@"friends"];
            
            [_dataArray replaceObjectAtIndex:i withObject:dataDic];
            [_selectedArray addObject:@"0"];
        }
        
        [_tableView reloadData];
    }
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
   NSDictionary * dataDic = [BBUserDefaults getUserDic];
    NSLog(@"dataDic -- %@",dataDic);
    _contactMoel = ({
        ContactModel * model = [[ContactModel alloc] init];
        [model addObserver:self forKeyPath:@"allFriendsData" options:NSKeyValueObservingOptionNew context:nil];
        [model getAllFriendWithUserId:dataDic[@"id"]];
        model;
    });
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    self.backgroundColor = THEMECOLOR_BACK;
    
    UIView * topView = [self createViewWithBackColor:[UIColor whiteColor] subView:self];
    topView.frame = FLEXIBLE_FRAME(0, 0, 320, 105);
    
    //搜索按钮
    UIButton * searchBut = [self createButtonWithTitle:@"  搜索" font:FLEXIBLE_NUM(13) subView:topView];
    searchBut.frame = FLEXIBLE_FRAME(30, 10, 260, 30);
    searchBut.backgroundColor = RGBACOLOR(241, 241, 241, 1);
    searchBut.layer.cornerRadius = FLEXIBLE_NUM(15);
    searchBut.clipsToBounds = YES;
    [searchBut setImage:[UIImage imageNamed:@"icon_sous"] forState:UIControlStateNormal];
    [searchBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    NSArray * titleArray = [NSArray arrayWithObjects:@"新朋友",@"门派", nil];
    for (int i = 0; i < 2; i ++) {
        UIButton * topButton = [self createButtonWithTitle:nil font:0 subView:topView];
        topButton.frame = FLEXIBLE_FRAME(80 + 120 * i, 50, 40, 50);
        if (i == 0) {
            [topButton addTarget:self action:@selector(newFriendsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [topButton addTarget:self action:@selector(unitsedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(5, 0, 30, 30)];
        imageView.image = [UIImage imageNamed:titleArray[i]];
        [topButton addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel * titleLabel = [self createLabelWithText:titleArray[i] font:FLEXIBLE_NUM(12) subView:topButton];
        titleLabel.frame = FLEXIBLE_FRAME(0, 30, 40, 20);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
    }
    
    [self addSubview:self.tableView];
}
#pragma mark - 各种Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FLEXIBLE_NUM(110), MAINSCRREN_W, MAINSCRREN_H-FLEXIBLE_NUM(110)-64-48) style:UITableViewStylePlain];
        _tableView.rowHeight = FLEXIBLE_NUM(47);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    [_tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:identify];
    return _tableView;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section][@"friends"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    NSDictionary  * dataDic = _dataArray[indexPath.section][@"friends"][indexPath.row][@"friend"];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"avatar"]]] placeholderImage:PLACEHOLER_IMA];
    cell.userNameLabel.text = dataDic[@"nickname"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  FLEXIBLE_NUM(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.frame = FLEXIBLE_FRAME(0, 0, 320, 40);
    headerButton.tag = SECTION_TAG + section;
    headerButton.backgroundColor = [UIColor whiteColor];
    [headerButton addTarget:self action:@selector(sectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * headerTitleLabel = [self createLabelWithText:_allFriendsArray[section][@"name"] font:FLEXIBLE_NUM(13) subView:headerButton];
    headerTitleLabel.frame = FLEXIBLE_FRAME(40, 0, 150, 40);
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(15, 13, 14, 14)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([_selectedArray[section] integerValue] == 0) {
         imageView.image = [UIImage imageNamed:@"icon_jt01@3x"];
        UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:headerButton];
        lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    }else{
        imageView.image = [UIImage imageNamed:@"icon_jt02@3x"];
    }
    [headerButton addSubview:imageView];
    
    return headerButton;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到用户详情
}

#pragma mark - 按钮方法
- (void)newFriendsButtonPressed:(UIButton *)sender
{
    NewFriendsViewController * newFriendsVC = [[NewFriendsViewController alloc] init];
    [self.viewController.navigationController pushViewController:newFriendsVC animated:YES];
}

- (void)unitsedButtonPressed:(UIButton *)sender
{
    UnitedViewController * unitedVC = [[UnitedViewController alloc] init];
    [self.viewController.navigationController pushViewController:unitedVC animated:YES];
}


- (void)sectionButtonPressed:(UIButton *)sender
{
    NSInteger index = sender.tag - SECTION_TAG;
    
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] initWithDictionary:_dataArray[index]];
    if ([_selectedArray[index] integerValue] == 0) {
        [_selectedArray replaceObjectAtIndex:index withObject:@"1"];
        [dataDic setObject:_allFriendsArray[index][@"friends"] forKey:@"friends"];
    }else{
        [_selectedArray replaceObjectAtIndex:index withObject:@"0"];
        [dataDic setObject:@[] forKey:@"friends"];
    }
    [_dataArray replaceObjectAtIndex:index withObject:dataDic];
    [_tableView reloadData];
    
}

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
