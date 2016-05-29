//
//  UnitedMemberViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "AddUnitedManagerViewController.h"
#import "GroupInviteViewCell.h"
#import "UnitedInfoModel.h"
#import "UnitedViewController.h"

@interface AddUnitedManagerViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (strong, nonatomic) UITableView       * tableView;
@property (strong, nonatomic) NSArray           * dataArray;
@property (strong, nonatomic) NSMutableArray    * selectedArray;

@property (strong, nonatomic) UISearchController                * searchController;
@property (strong, nonatomic) NSArray                           * filterData;

@property (strong, nonatomic) UnitedInfoModel   * unitedInfoModel;
@property (strong, nonatomic) UILabel           * stateLabel;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation AddUnitedManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"添加管理员";
    }
    return self;
}

- (void)dealloc
{
    [_unitedInfoModel removeObserver:self forKeyPath:@"addAdminData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"addAdminData"]) {
           UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _unitedInfoModel.addAdminData;
        if ([dataDic[@"code"] integerValue] == 0) {
            alertController.message = @"门派管理员设置成功～";
            [self presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"门派管理员设置失败～";
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
    _selectedArray = [NSMutableArray array];
    
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"addAdminData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
    
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(47);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });
    _tableView.editing = YES;
    
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

    //添加
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark -- button pressed
- (void)rightButtonPressed:(UIButton *)sender
{

    if (_selectedArray.count == 0) {
         UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你还未选中任何成员～" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSMutableString * resultString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < _selectedArray.count; i ++) {
        if (i == 0) {
            [resultString appendString:[NSString stringWithFormat:@"%@",_selectedArray[i][@"id"]]];
        }else{
            [resultString appendString:[NSString stringWithFormat:@",%@",_selectedArray[i][@"id"]]];
        }
    }
    
     NSDictionary * dataDic = [BBUserDefaults getUserDic];
    
    [_unitedInfoModel addUnitedAdminsWithOwnerId:dataDic[@"id"] userIds:resultString groupId:_unitedDic[@"id"]];
}

#pragma mark -- <<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchController.active) {
        return _filterData.count;
    }
    return _memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    GroupInviteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[GroupInviteViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSDictionary * dataDic;
    if (_searchController.active) {
        dataDic = _filterData[indexPath.row];
    }else{
        dataDic = _memberArray[indexPath.row];
    }
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
    cell.nameLabel.text = dataDic[@"nameInGroup"];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchController.active) {
        
    }else{
        [_selectedArray addObject:_memberArray[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchController.active) {
        
    }else{
        [_selectedArray removeObject:_memberArray[indexPath.row]];
    }
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _memberArray.count; i ++) {
        if ([_memberArray[i][@"nameInGroup"] containsString:searchString]) {
            [resultArray addObject:_memberArray[i]];
        }
    }
    _filterData = resultArray;
    //刷新表格
    [self.tableView reloadData];
}


@end
