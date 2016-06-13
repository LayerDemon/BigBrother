//
//  ChangeSectionViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/6/7.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChangeSectionViewController.h"
#import "ChangeSectionTableViewCell.h"
#import "FriendModel.h"

@interface ChangeSectionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView      * tableView;

@property (assign, nonatomic) NSInteger        selectMark;

@property (strong, nonatomic) FriendModel       * friendModel;

@property (assign, nonatomic) NSInteger        midMark;

- (void)initializeDataSource;
- (void)initializeUserInterface;

@end

@implementation ChangeSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{
    [_friendModel removeObserver:self forKeyPath:@"changeSectionData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"changeSectionData"]) {
         UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        if ([_friendModel.changeSectionData[@"code"] integerValue] == 0) {
            alertController.message = @"改变好友分组成功～";
            _selectMark = _midMark;
            [_tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSectionNameNotif" object:_sectionArray[_selectMark][@"name"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getAllFriendsNotif" object:nil];
        }else{
            alertController.message = @"改变好友分组失败～";
        }
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    self.navigationItem.title = @"移动分组";
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    _friendModel = ({
        FriendModel * model = [[FriendModel alloc] init];
        [model addObserver:self forKeyPath:@"changeSectionData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.rowHeight = FLEXIBLE_NUM(40);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });

    for (int i = 0; i < _sectionArray.count; i ++) {
        if ([_sectionArray[i][@"name"] isEqualToString:_sectionString]) {
            _selectMark = i;
            return;
        }
    }
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ChangeSectionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.sectionNameLabel.text = _sectionArray[indexPath.row][@"name"];
    
    if (indexPath.row == _selectMark) {
        cell.sectionMarkImageView.hidden = NO;
    }else{
        cell.sectionMarkImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    if (indexPath.row != _selectMark) {
        [_friendModel changeSectionWithUserId:dataDic[@"id"] friendId:_userDic[@"id"] friendsGroupId:_sectionArray[indexPath.row][@"id"]];
        _midMark = indexPath.row;
    }
}

//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return FLEXIBLE_NUM(80);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * backView = [[UIView alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 320, 80)];
//    
//    UIButton * addSectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addSectionButton.backgroundColor = [UIColor whiteColor];
//    addSectionButton.frame = FLEXIBLE_FRAME(0, 20, 320, 40);
//    [backView addSubview:addSectionButton];
//    
//    UILabel * buttonTitleLabel = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(10, 0, 200, 40)];
//    buttonTitleLabel.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
//    buttonTitleLabel.text = @"添加到新的分组";
//    [addSectionButton addSubview:buttonTitleLabel];
//    
//    return backView;
//}


@end
