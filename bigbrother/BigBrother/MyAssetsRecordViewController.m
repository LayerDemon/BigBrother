//
//  MyAesstsRecordViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/3.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MyAssetsRecordViewController.h"

@interface MyAssetsRecordViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) int totalPoints;

@end

@implementation MyAssetsRecordViewController{
    UILabel *totalPointsLabel;
    
    UITableView *recordTableView;
    
    NSMutableArray *recordDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIView *totalPointsView = [[UIView alloc] init];
    totalPointsView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),40};
    [self.view addSubview:totalPointsView];
    
    totalPointsLabel = [[UILabel alloc] init];
    totalPointsLabel.frame = (CGRect){15,0,WIDTH(totalPointsView)-15*2,HEIGHT(totalPointsView)};
    totalPointsLabel.textAlignment = NSTextAlignmentRight;
    [totalPointsView addSubview:totalPointsLabel];
    totalPointsLabel.font = Font(14);
    
    [self setTotalPoints:self.totalPoints];
    
    
    recordTableView = [[UITableView alloc] initWithFrame:(CGRect){0,BOTTOM(totalPointsView),WIDTH(self.view),HEIGHT(self.view)-BOTTOM(totalPointsView)} style:UITableViewStylePlain];
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.showsHorizontalScrollIndicator = NO;
    recordTableView.showsVerticalScrollIndicator = NO;
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:recordTableView];
    
    [self getRecord];
    
}

-(void)setTotalPoints:(int)totalPoints{
    _totalPoints = totalPoints;
    if (totalPointsLabel) {
        NSMutableAttributedString *attriString;
        attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计：%d点",totalPoints]];
        
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:(id)RGBColor(50, 50, 50).CGColor
                            range:NSMakeRange(0, 3)];
        
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:(id)BB_BlueColor.CGColor
                            range:NSMakeRange(3, attriString.length-3)];
        totalPointsLabel.attributedText = attriString;
    }
}

//todo 从网络获取信息
-(void)getRecord{
    if (self.isChargeRecord) {
        [self gerChargeRecord];
    }else{
        [self gerWithDrawRecord];
    }
}

-(void)gerChargeRecord{
    recordDataArray = [NSMutableArray array];
    
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-02-21 23:11:10",
                                 @"number":@(100)}];
    [recordDataArray addObject:@{@"note":@"每日签到",
                                 @"time":@"2016-02-15 19:14:57",
                                 @"number":@(10)}];
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-02-10 18:45:12",
                                 @"number":@(1000)}];
    [recordDataArray addObject:@{@"note":@"系统赠送",
                                 @"time":@"2016-01-28 17:24:17",
                                 @"number":@(600)}];
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-01-12 16:12:18",
                                 @"number":@(100)}];
    [recordDataArray addObject:@{@"note":@"网页充值",
                                 @"time":@"2016-01-11 22:34:27",
                                 @"number":@(100)}];
    [recordDataArray addObject:@{@"note":@"手机充值",
                                 @"time":@"2016-01-11 21:16:23",
                                 @"number":@(100)}];
    [recordDataArray addObject:@{@"note":@"系统赠送",
                                 @"time":@"2016-01-06 20:41:45",
                                 @"number":@(100)}];
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-01-05 08:51:26",
                                 @"number":@(300)}];
    [recordDataArray addObject:@{@"note":@"每日签到",
                                 @"time":@"2016-01-03 09:19:16",
                                 @"number":@(10)}];
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-01-02 12:40:14",
                                 @"number":@(100)}];
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-01-01 15:20:10",
                                 @"number":@(50000)}];
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-01-01 11:35:41",
                                 @"number":@(100)}];
    
    [self setTotalPoints:52620];
    [recordTableView reloadData];
}

-(void)gerWithDrawRecord{
    recordDataArray = [NSMutableArray array];
    
    [recordDataArray addObject:@{@"note":@"置顶",
                                 @"time":@"2016-02-21 23:11:10",
                                 @"number":@(-100)}];
    [recordDataArray addObject:@{@"note":@"发布",
                                 @"time":@"2016-02-15 19:14:57",
                                 @"number":@(-10)}];
    [recordDataArray addObject:@{@"note":@"充值",
                                 @"time":@"2016-02-10 18:45:12",
                                 @"number":@(-1000)}];
    [recordDataArray addObject:@{@"note":@"信息刷新",
                                 @"time":@"2016-01-28 17:24:17",
                                 @"number":@(-600)}];
    [recordDataArray addObject:@{@"note":@"信息匹配",
                                 @"time":@"2016-01-12 16:12:18",
                                 @"number":@(-100)}];
    [recordDataArray addObject:@{@"note":@"信息刷新",
                                 @"time":@"2016-01-11 22:34:27",
                                 @"number":@(-100)}];
    [recordDataArray addObject:@{@"note":@"信息匹配",
                                 @"time":@"2016-01-11 21:16:23",
                                 @"number":@(-100)}];
    [recordDataArray addObject:@{@"note":@"信息置顶",
                                 @"time":@"2016-01-06 20:41:45",
                                 @"number":@(-100)}];
    [self setTotalPoints:2110];
    [recordTableView reloadData];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == recordTableView) {
        if (recordDataArray && recordDataArray.count != 0) {
            return recordDataArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recordTableView) {
        if (recordDataArray && recordDataArray.count != 0) {
            return 60;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recordTableView) {
        static NSString *recordTableViewCellIdentifier7788 = @"recordTableViewCellIdentifier7788";
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordTableViewCellIdentifier7788];
        if (!cell) {
            cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordTableViewCellIdentifier7788];
        }
        NSDictionary *dataDic = recordDataArray[indexPath.row];
        
        cell.recordTimeString = dataDic[@"time"];
        cell.recordNote = dataDic[@"note"];
        cell.recordCount = dataDic[@"number"];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == recordTableView) {
        //todo
    }
}

#pragma mark - Navigation
-(void)setUpNavigation{
    if (self.isChargeRecord) {
        self.navigationItem.title = @"充值记录";
    }else{
        self.navigationItem.title = @"消费记录";
    }
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation RecordTableViewCell{
    UILabel *recordNumStringLabel;
    UIView *lineBottomView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        recordNumStringLabel = [[UILabel alloc] init];
        recordNumStringLabel.textColor = BB_BlueColor;
        recordNumStringLabel.font = Font(16);
        recordNumStringLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:recordNumStringLabel];
        
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = RGBColor(50, 50, 50);
        self.textLabel.font = Font(15);
        
        self.detailTextLabel.textColor = RGBColor(100, 100, 100);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = Font(13);
        
        lineBottomView = [[UIView alloc] init];
        lineBottomView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:lineBottomView];
    }
    return self;
}

-(void)layoutSubviews{
    self.textLabel.frame = (CGRect){15,10,WIDTH(self.contentView)-15-120-15,15};
    
    self.detailTextLabel.frame = (CGRect){15,35,150,15};
    
    recordNumStringLabel.frame = (CGRect){WIDTH(self.contentView)-120-15,10,120,15};
    
    lineBottomView.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
    
}

-(void)setRecordCount:(NSString *)recordCount{
    _recordCount = recordCount;
    if (recordCount) {
        recordNumStringLabel.text = [NSString stringWithFormat:@"%@点",recordCount];
    }else{
        recordNumStringLabel.text = @"";
    }
}

-(void)setRecordNote:(NSString *)recordNote{
    _recordNote = recordNote;
    if (recordNote) {
        self.textLabel.text = recordNote;
    }else{
        self.textLabel.text = @"";
    }
}

-(void)setRecordTimeString:(NSString *)recordTimeString{
    _recordTimeString = recordTimeString;
    if (recordTimeString) {
        self.detailTextLabel.text = recordTimeString;
    }else{
        self.detailTextLabel.text = @"";
    }
}

@end


