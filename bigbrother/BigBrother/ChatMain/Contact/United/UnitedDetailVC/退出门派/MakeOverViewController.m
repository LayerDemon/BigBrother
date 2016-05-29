//
//  MakeOverViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/26.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MakeOverViewController.h"
#import "CreateUnitedViewController.h"
#import "UnitedTableViewCell.h"
#import "UnitedDetailViewController.h"
#import "ChatViewController.h"
#import "UnitedInfoModel.h"
#import "UnitedViewController.h"

@interface MakeOverViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (strong, nonatomic) UISearchBar                       * searchBar;
@property (strong, nonatomic) UITableView                       * tableView;
@property (strong, nonatomic) NSMutableArray                    * groupArray;
@property (strong, nonatomic) NSArray                           * dataArray;
@property (strong, nonatomic) UILabel                           * stateLabel;

@property (strong, nonatomic) UISearchController                * searchController;
@property (strong, nonatomic) NSArray                           * filterData;

@property (strong, nonatomic) UnitedInfoModel                   * unitedInfoModel;

- (void)initializeDataSource;
- (void)initializeUserInterface;

@end

@implementation MakeOverViewController

static NSString * identify = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"门派";
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
    [_unitedInfoModel removeObserver:self forKeyPath:@"transterUnitedData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"transterUnitedData"]) {
           UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _unitedInfoModel.transterUnitedData;
        if ([dataDic[@"code"] integerValue] == 0) {
            alertController.message = @"转让群成功～";
            [self presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"转让群失败～";
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark -- alterController dismiss
- (void)alertControllerDismissWithAlertController:(UIAlertController *)alertController
{
    [alertController dismissViewControllerAnimated:YES completion:nil];
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[UnitedViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES
             ];
        }
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"transterUnitedData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });

}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    //    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    //返回title
    UIBarButtonItem * barbutton = [[UIBarButtonItem alloc] init];
    barbutton.title = @"";
    self.navigationItem.backBarButtonItem = barbutton;
    
    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(50);
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        tableView;
    });
    [_tableView registerClass:[UnitedTableViewCell class] forCellReuseIdentifier:identify];
    
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = YES;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = FLEXIBLE_FRAME(10, 8, 300, 34);
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    for (UIView *subview in _searchController.searchBar.subviews) {
        for(UIView* grandSonView in subview.subviews){
            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                grandSonView.alpha = 0.0f;
            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
                NSLog(@"Keep textfiedld bkg color");
            }else{
                grandSonView.alpha = 0.0f;
            }
        }//for cacheViews
    }//subviews
    
    _stateLabel = ({
        UILabel * label = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 200, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.center = self.view.center;
        label.textColor = [UIColor grayColor];
        if (_memberArray.count > 0) {
            label.hidden = YES;
        }else{
            label.hidden = NO;
        }
        label.text = @"门派里目前没有普通成员哦，赶快去邀请好友加入群吧～";
        label.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
        [self.view addSubview:label];
        label;
    });

}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        
        NSLog(@"wocaonimab -- %@",_filterData);
        return _filterData.count;
    }else{
        return [_memberArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    NSDictionary * dataDic;
    if (self.searchController.active) {
        dataDic = _filterData[indexPath.row];
    }else{
        dataDic = _memberArray[indexPath.row];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.groupNameLabel.text = dataDic[@"nameInGroup"];
    
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataArray.count; i ++) {
        if ([_dataArray[i][@"nameInGroup"] containsString:searchString]) {
            [resultArray addObject:_dataArray[i]];
        }
    }
    _filterData = resultArray;
    //刷新表格
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * userdataDic;
    if (_searchController.active) {
        userdataDic = _filterData[indexPath.row];
    }else{
        userdataDic = _memberArray[indexPath.row];
    }
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    
    NSString * titleString = [NSString stringWithFormat:@"是否确定立即转让该群给%@？",userdataDic[@"nameInGroup"]];
    UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:titleString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [_unitedInfoModel transterUnitedWithGroupId:_unitedDetailDic[@"id"] userId:dataDic[@"id"] transferTo:userdataDic[@"id"]];
    }];
    UIAlertAction *  cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
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
