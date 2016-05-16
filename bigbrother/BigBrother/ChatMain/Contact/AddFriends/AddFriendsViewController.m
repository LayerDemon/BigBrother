//
//  AddFriendsViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/12.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AddFriendsModel.h"
#import "AddFriendTableViewCell.h"
#import "UnitedTableViewCell.h"
#define TOPBUT_TAG 5100

@interface AddFriendsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView                * sliderView;
@property (strong, nonatomic) UITextField           * searchTextField;

@property (strong, nonatomic) UITableView           * tableView;
@property (strong, nonatomic) NSArray               * dataArray;

@property (strong, nonatomic) AddFriendsModel       * addFriendsModel;
@property (assign, nonatomic) NSInteger             searchMark;         //用来标记是搜索好友，还是门派


- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"添加";
    }
    return self;
}

- (void)dealloc
{
    [_addFriendsModel removeObserver:self forKeyPath:@"searchFriendsData"];
    [_addFriendsModel removeObserver:self forKeyPath:@"searchGroupsData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"searchFriendsData"]) {
        _dataArray = _addFriendsModel.searchFriendsData[@"data"];
        [_tableView reloadData];
    }
    
    if ([keyPath isEqualToString:@"searchGroupsData"]) {
        _dataArray = _addFriendsModel.searchGroupsData[@"data"];
        [_tableView reloadData];
    }
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _addFriendsModel = ({
        AddFriendsModel * model = [[AddFriendsModel alloc] init];
        [model addObserver:self forKeyPath:@"searchFriendsData" options:NSKeyValueObservingOptionNew context:nil];
        [model addObserver:self forKeyPath:@"searchGroupsData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    //topView
    UIView * topView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    topView.frame = FLEXIBLE_FRAME(0, 0, 320, 40);
    
    NSArray * titleArray = [NSArray arrayWithObjects:@"找人",@"找门派", nil];
    for (int i = 0; i < 2; i ++) {
        UIButton * topButton = [self createButtonWithTitle:titleArray[i] font:FLEXIBLE_NUM(14) subView:topView];
        topButton.titleLabel.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(13)];
        topButton.backgroundColor = [UIColor whiteColor];
        [topButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        topButton.frame = FLEXIBLE_FRAME(160 * i, 0, 160, 40);
        topButton.tag = TOPBUT_TAG + i;
        [topButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
 
    _sliderView = ({
        UIView * view = [self createViewWithBackColor:BB_NaviColor subView:topView];
        view.frame = FLEXIBLE_FRAME(0, 37.8, 160, 2);
        view;
    });
    
    //searchView
    UIView * searchView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    searchView.frame = FLEXIBLE_FRAME(0, 48, 320, 55);
    
    UIView * searchBackView = [self createViewWithBackColor:THEMECOLOR_BACK subView:searchView];
    searchBackView.frame = FLEXIBLE_FRAME(25, 13, 220, 27);
    searchBackView.layer.cornerRadius = FLEXIBLE_NUM(13);
    
    UIImageView * searchImageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(8, 6, 14, 14)];
    searchImageView.image = [UIImage imageNamed:@"icon_sous"];
    [searchBackView addSubview:searchImageView];
    
    _searchTextField = ({
        UITextField * textField = [[UITextField alloc] initWithFrame:FLEXIBLE_FRAME(30, 0, 185, 27)];
        textField.placeholder = @"手机号/门派/昵称";
        textField.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(12)];
        textField.textColor = RGBColor(157, 157, 157);
        [searchBackView addSubview:textField];
        textField;
    });
    
    UIButton * searchButton = [self createButtonWithTitle:@"搜索" font:FLEXIBLE_NUM(13) subView:searchView];
    searchButton.frame = FLEXIBLE_FRAME(250, 14, 55, 25);
    searchButton.layer.cornerRadius = FLEXIBLE_NUM(13);
    [searchButton setTitleColor:BB_NaviColor forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.layer.borderColor = BB_NaviColor.CGColor;
    searchButton.layer.borderWidth = FLEXIBLE_NUM(0.8);
    
    //搜索结果
    UILabel * searchResultLabel = [self createLabelWithText:@"搜索结果" font:FLEXIBLE_NUM(13) subView:self.view];
    searchResultLabel.frame = FLEXIBLE_FRAME(10, 103, 100, 25);
    
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FLEXIBLE_NUM(128), MAINSCRREN_W, MAINSCRREN_H - FLEXIBLE_NUM(128)-64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = FLEXIBLE_NUM(47);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    });

}
#pragma mark -- buttonPressed
- (void)topButtonPressed:(UIButton *)sender
{
    NSInteger index = sender.tag - TOPBUT_TAG;
    _searchMark = index;
    for (int i = 0; i < 2; i ++) {
        UIButton * topButton = (UIButton *)[self.view viewWithTag:TOPBUT_TAG + i];
        [topButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]forState:UIControlStateNormal];
    }
    [sender setTitleColor:BB_NaviColor forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        _sliderView.frame = FLEXIBLE_FRAME(160 * index, 37.8, 160, 2);
    }];
    
}

- (void)searchButtonPressed:(UIButton *)sender
{
    if (_searchTextField.text.length > 0) {
        if (_searchMark == 0) {
            [_addFriendsModel searchFriendsWithTerms:_searchTextField.text];
        }else{
            [_addFriendsModel searchGroupsWithTerms:_searchTextField.text];
        }
    }
  
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchMark == 0) {
        static NSString *identify = @"Cell";
        AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[AddFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        NSDictionary  * dataDic = _dataArray[indexPath.row];
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"avatar"]]] placeholderImage:PLACEHOLER_IMA];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@(%@)",dataDic[@"nickname"],dataDic[@"phoneNumber"]];
        return cell;
    }else{
        static NSString * unitIdentfiy = @"unitIdentify";
        UnitedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:unitIdentfiy];
        if (!cell) {
            cell = [[UnitedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unitIdentfiy];
        }
        NSDictionary * dataDic = _dataArray[indexPath.row];
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLER_IMA];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.groupNameLabel.text = dataDic[@"name"];
        return cell;
    }
}

                                   
                                   
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchMark == 0) {     //好友
        
    }else{                      //门派
    
    }
    
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
