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
#import "FriendDetailViewController.h"

#define SECTION_TAG 2300
@interface ContactView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView               * tableView;
@property (strong, nonatomic) ContactModel              * contactMoel;
@property (strong, nonatomic) NSArray                   * allFriendsArray;
@property (strong, nonatomic) NSMutableArray            * dataArray;
@property (strong, nonatomic) NSMutableArray            * selectedArray;

@property (strong, nonatomic) UITextField               * groupNameTextField;
@property (strong, nonatomic) UITextField               * editGroupNameTextField;

@property (strong, nonatomic) UISearchDisplayController * searchDisplayController;

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
    [_contactMoel removeObserver:self forKeyPath:@"addNewGroupsData"];
    [_contactMoel removeObserver:self forKeyPath:@"deleteGroupsData"];
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
    
    if ([keyPath isEqualToString:@"addNewGroupsData"]) {
        UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _contactMoel.addNewGroupsData;
        if ([dataDic[@"code"] integerValue] == 0) {
             NSDictionary * dataDic = [BBUserDefaults getUserDic];
            [_contactMoel getAllFriendWithUserId:dataDic[@"id"]];
            
            alertController.message = @"添加分组成功～";
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"添加分组失败，请稍后重试～";
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:sureAction];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
        }
    }
    
    //删除分组
    if ([keyPath isEqualToString:@"deleteGroupsData"]) {
        UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _contactMoel.deleteGroupsData;
        if ([dataDic[@"code"] integerValue] == 0) {
            NSDictionary * dataDic = [BBUserDefaults getUserDic];
            [_contactMoel getAllFriendWithUserId:dataDic[@"id"]];
            
            alertController.message = @"删除分组成功～";
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"删除分组失败，请稍后重试～";
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:sureAction];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
        }
    }
    
    //修改分组
    if ([keyPath isEqualToString:@"editGroupData"]) {
        UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _contactMoel.editGroupData;
        if ([dataDic[@"code"] integerValue] == 0) {
            NSDictionary * dataDic = [BBUserDefaults getUserDic];
            [_contactMoel getAllFriendWithUserId:dataDic[@"id"]];
            
            alertController.message = @"修改分组成功～";
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"修改分组失败，请稍后重试～";
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:sureAction];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

#pragma mark -- alterController dismiss
- (void)alertControllerDismissWithAlertController:(UIAlertController *)alertController
{
    [alertController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
   NSDictionary * dataDic = [BBUserDefaults getUserDic];
    NSLog(@"dataDic -- %@",dataDic);
    _contactMoel = ({
        ContactModel * model = [[ContactModel alloc] init];
        [model addObserver:self forKeyPath:@"allFriendsData" options:NSKeyValueObservingOptionNew context:nil];
        [model addObserver:self forKeyPath:@"addNewGroupsData" options:NSKeyValueObservingOptionNew context:nil];
        [model addObserver:self forKeyPath:@"deleteGroupsData" options:NSKeyValueObservingOptionNew context:nil];
        [model addObserver:self forKeyPath:@"editGroupData" options:NSKeyValueObservingOptionNew context:nil];
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
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FLEXIBLE_NUM(110), MAINSCRREN_W, MAINSCRREN_H-64-48 - FLEXIBLE_NUM(110)) style:UITableViewStylePlain];
        _tableView.rowHeight = FLEXIBLE_NUM(47);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        
        UIView * footerView = [[UIView alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 320, 50)];
        footerView.backgroundColor = [UIColor clearColor];
        
        //添加分组
        UIButton * addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addGroupButton.backgroundColor = [UIColor whiteColor];
        addGroupButton.frame = FLEXIBLE_FRAME(0, 10, 320, 40);
        [addGroupButton addTarget:self action:@selector(addGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:addGroupButton];
        
        UILabel * titleLabel = [self createLabelWithText:@"添加分组" font:FLEXIBLE_NUM(13) subView:addGroupButton];
        titleLabel.frame = FLEXIBLE_FRAME(40, 0, 100, 40);
        
        UILabel * addLabel = [self createLabelWithText:@"＋" font:FLEXIBLE_NUM(20) subView:addGroupButton];
        addLabel.frame = FLEXIBLE_FRAME(0, 0, 40, 40);
        addLabel.textAlignment = NSTextAlignmentCenter;
        addLabel.textColor = [UIColor lightGrayColor];
        
        _tableView.tableFooterView = footerView;
    }
    [_tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:identify];
    
    //搜索按钮
    UIButton * searchBut = [self createButtonWithTitle:@"  搜索" font:FLEXIBLE_NUM(13) subView:topView];
    searchBut.frame = FLEXIBLE_FRAME(30, 10, 260, 30);
    searchBut.backgroundColor = RGBACOLOR(241, 241, 241, 1);
    searchBut.layer.cornerRadius = FLEXIBLE_NUM(15);
    searchBut.clipsToBounds = YES;
    [searchBut setImage:[UIImage imageNamed:@"icon_sous"] forState:UIControlStateNormal];
    [searchBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:FLEXIBLE_FRAME(0, 8, 320, 34)];
//    searchBar.placeholder = @"搜索";
//    searchBar.backgroundColor = [UIColor whiteColor];
//    searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    [topView addSubview:searchBar];
//    
//    for (UIView *subview in searchBar.subviews) {
//        for(UIView* grandSonView in subview.subviews){
//            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                grandSonView.alpha = 0.0f;
//            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
//                NSLog(@"Keep textfiedld bkg color");
//            }else{
//                grandSonView.alpha = 0.0f;
//            }
//        }//for cacheViews
//    }//subviews
//    
//    // 添加 searchbar 到 headerview
//    self.tableView.tableHeaderView = topView;
//    
//    // 用 searchbar 初始化 SearchDisplayController
//    // 并把 searchDisplayController 和当前 controller 关联起来
//    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self.viewController];
//    
//    // searchResultsDataSource 就是 UITableViewDataSource
//    _searchDisplayController.searchResultsDataSource = self;
//    // searchResultsDelegate 就是 UITableViewDelegate
//    _searchDisplayController.searchResultsDelegate = self;
//    _searchDisplayController.searchResultsTableView.rowHeight = FLEXIBLE_NUM(50);
//    [_searchDisplayController.searchResultsTableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:identify];
//    
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

#pragma mark -- 长按手势
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];

    NSInteger index = gesture.view.tag - SECTION_TAG;
    
    NSLog(@"wocaonimaIndex  -- %ld",index);
    
    
    NSString * messageString = [NSString stringWithFormat:@"请选择你对分类“%@”的操作",_dataArray[index][@"name"]];
     UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"分类管理" message:messageString preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"修改该分类" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSString * titleString= [NSString stringWithFormat:@"修改分类“%@”",_dataArray[index][@"name"]];
         UIAlertController  * editAlterController = [UIAlertController alertControllerWithTitle:titleString message:@"请输入新的分类名" preferredStyle:UIAlertControllerStyleAlert];
         [editAlterController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
             _editGroupNameTextField = textField;
         }];
        UIAlertAction * sureAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_contactMoel editGroupWithFriendsGroupId:_dataArray[index][@"id"] userId:dataDic[@"id"] name:_editGroupNameTextField.text orderBy:[_dataArray[index][@"orderBy"] integerValue]];
        }];
        UIAlertAction *  cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [editAlterController addAction:sureAction2];
        [editAlterController addAction:cancelAction2];
        [self.viewController presentViewController:editAlterController animated:YES completion:nil];
    }];
    [alertController addAction:sureAction];
    UIAlertAction * delAction = [UIAlertAction actionWithTitle:@"删除该分类" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController  * editAlterController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该分类下还有好友，移除好友后才能删除分类～" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
        }];
        UIAlertAction *  cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [editAlterController addAction:sureAction2];
        [editAlterController addAction:cancelAction2];
        if ([_dataArray[index][@"friends"] count] > 0) {
            [self.viewController presentViewController:editAlterController animated:YES completion:nil];
            return ;
        }
        
        [_contactMoel deleteGroupWithFriendsGroupId:_dataArray[index][@"id"] userId:dataDic[@"id"]];
    }];
    [alertController addAction:delAction];
    UIAlertAction *  cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
    
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
    
    cell.dataDic = dataDic;
    
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
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [headerButton addGestureRecognizer:longPressGesture];

    
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

////tableView footer
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return FLEXIBLE_NUM(50);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView * footerView = [[UIView alloc] initWithFrame:FLEXIBLE_FRAME(0, 0, 320, 50)];
//    footerView.backgroundColor = [UIColor clearColor];
//    
//    //添加分组
//    UIButton * addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addGroupButton.backgroundColor = [UIColor whiteColor];
//    addGroupButton.frame = FLEXIBLE_FRAME(0, 10, 320, 40);
//    [addGroupButton addTarget:self action:@selector(addGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:addGroupButton];
//    
//    UILabel * titleLabel = [self createLabelWithText:@"添加分组" font:FLEXIBLE_NUM(13) subView:addGroupButton];
//    titleLabel.frame = FLEXIBLE_FRAME(40, 0, 100, 40);
//    
//    UILabel * addLabel = [self createLabelWithText:@"＋" font:FLEXIBLE_NUM(20) subView:addGroupButton];
//    addLabel.frame = FLEXIBLE_FRAME(0, 0, 40, 40);
//    addLabel.textAlignment = NSTextAlignmentCenter;
//    addLabel.textColor = [UIColor lightGrayColor];
//    
//    return footerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到用户详情
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    FriendDetailViewController *friendDetailVC = [[FriendDetailViewController alloc]init];
    friendDetailVC.currentUserDic = cell.dataDic;
    [self.viewController.navigationController pushViewController:friendDetailVC animated:YES];
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


- (void)addGroupButtonPressed:(UIButton *)sender
{
    UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"添加分组" message:@"请输入新的分组名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _groupNameTextField = textField;
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"sure   --   %@",_groupNameTextField.text);
         UIAlertController  * alertController2 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController2 addAction:sureAction2];
     
        if (_groupNameTextField.text.length == 0) {
            alertController2.message = @"分组名称不能为空～";
            [self.viewController presentViewController:alertController2 animated:YES completion:nil];
            return;
        }
        
        for (int i = 0; i < _dataArray.count; i ++) {
            if ([_dataArray[i][@"name"] isEqualToString:_groupNameTextField.text]) {
                alertController2.message = @"该分组名已存在，请输入其他分组名称～";
                [self.viewController presentViewController:alertController2 animated:YES completion:nil];
                return;
            }
        }
        
         NSDictionary * dataDic = [BBUserDefaults getUserDic];
        [_contactMoel addNewGroupWithUserId:dataDic[@"id"] name:_groupNameTextField.text orderBy:_dataArray.count + 1];
    
    }];
    UIAlertAction *  cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
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
- (void)reloadContactDataSource
{
    [_contactMoel getAllFriendWithUserId:[BBUserDefaults getUserID]];
}

#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
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
