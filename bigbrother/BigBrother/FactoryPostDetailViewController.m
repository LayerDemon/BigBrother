//
//  FactoryPostDetailViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FactoryPostDetailViewController.h"
#import "FactoryPostNewViewController.h"
#import "UIAlertView+Blocks.h"

@interface FactoryPostDetailViewController () <UIScrollViewDelegate>

@end

@implementation FactoryPostDetailViewController{
    UIScrollView *contentView;
    UIPageControl *imageShowedPageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.backgroundColor = BB_WhiteColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    
    NSString *selfNum = [BBUserDefaults getUserPhone];
    if (![selfNum isEqualToString:self.product.phoneNumber]) {
        UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        postButton.frame = (CGRect){0,HEIGHT(self.view)-45,WIDTH(self.view),45};
        [self.view addSubview:postButton];
        postButton.backgroundColor = BB_BlueColor;
        [postButton setTitle:@"咨询" forState:UIControlStateNormal];
        [postButton setTitleColor:BB_WhiteColor forState:UIControlStateNormal];
        [postButton addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight-45};
    }
    
    [self initViews];
}

-(void)postButtonClick{
    NSString *postNum = self.product.phoneNumber;
    if (postNum) {
        [[[UIAlertView alloc] initWithTitle:@"拨号确认"
                                    message:[NSString stringWithFormat:@"确定拨号%@吗?",postNum]
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[postNum stringByReplacingOccurrencesOfString:@"-" withString:@""]]]];
        }], nil] show];
    }
}

-(void)initViews{
    float offset;
    if (self.product.isSupply) {
        NSArray *array = self.product.images;
        UIView *imageShowView = [self setUpImageShowViewWithOffset:offset imageArray:array];
        [contentView addSubview:imageShowView];
        offset += HEIGHT(imageShowView);
    }
    
    NSString *title = self.product.title;
    if (!title) {
        title = @"";
    }
    NSString *createTime = self.product.createTime;
    if (!createTime) {
        createTime = @"";
    }
    
    UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title timeString:createTime];
    [contentView addSubview:titleView];
    offset += HEIGHT(titleView);
    offset += 10;
    
    NSString *addressString = self.product.districtFullName;
    if (!addressString) {
        addressString = @"";
    }
    
    UIView *addressView = [self setUpAddressViewWithOffset:offset address:addressString];
    [contentView addSubview:addressView];
    offset += HEIGHT(addressView);
    offset += 10;
    
    NSString *description = self.product.introduction;
    if (!description) {
        description = @"";
    }
    
    UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
    [contentView addSubview:descriptionView];
    
    offset += HEIGHT(descriptionView);
}

-(UIView *)setUpImageShowViewWithOffset:(float)offset imageArray:(NSArray *)array{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),WIDTH(contentView)*9.f/16};
    view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *imageViewScroller = [[UIScrollView alloc] init];
    imageViewScroller.frame = (CGRect){0,0,WIDTH(view),HEIGHT(view)};
    imageViewScroller.delegate = self;
    imageViewScroller.tag = 10091;
    imageViewScroller.pagingEnabled = YES;
    imageViewScroller.contentSize = (CGSize){WIDTH(imageViewScroller),HEIGHT(imageViewScroller)};
    imageViewScroller.showsHorizontalScrollIndicator = NO;
    imageViewScroller.showsVerticalScrollIndicator = NO;
    [view addSubview:imageViewScroller];
    
    imageShowedPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, HEIGHT(view)-15, WIDTH(view), 15)];
    imageShowedPageControl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    imageShowedPageControl.alpha = 0;
    imageShowedPageControl.numberOfPages = 0;
    [view addSubview:imageShowedPageControl];
    
    if (array && [array isKindOfClass:[NSArray class]] && array.count != 0) {
        imageShowedPageControl.alpha = 1;
        imageShowedPageControl.numberOfPages = array.count;
        imageViewScroller.contentSize = (CGSize){WIDTH(imageViewScroller)*array.count,HEIGHT(imageViewScroller)};
        for (int i = 0; i< array.count; i++) {
            NSDictionary *dic = array[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = (CGRect){WIDTH(imageViewScroller)*i,0,WIDTH(imageViewScroller),HEIGHT(imageViewScroller)};
            
            NSString *urlstring = dic[@"url"];
            [imageView setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:@"icon_defaultImageBig"]];
            [imageViewScroller addSubview:imageView];
        }
    }
    
    UIView *bottomSepLineView = [[UIView alloc] init];
    bottomSepLineView.frame = (CGRect){0,HEIGHT(view)-0.5,WIDTH(view),0.5};
    bottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [view addSubview:bottomSepLineView];
    
    return view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 10091) {
        float offsetX = scrollView.contentOffset.x;
        int offsetCount = (int)(offsetX/scrollView.frame.size.width);
        
        imageShowedPageControl.currentPage = offsetCount;
    }
}

-(UIView *)setUpTitleViewWithOffset:(float)offset titleString:(NSString *)title timeString:(NSString *)time{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),70};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = (CGRect){15,10,WIDTH(view)-15*2,20};
    titleLabel.text = title;
    titleLabel.textColor = RGBColor(50, 50, 50);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = Font(15);
    [view addSubview:titleLabel];
    
    UILabel *postTimeLabel = [[UILabel alloc] init];
    postTimeLabel.frame = (CGRect){15,BOTTOM(titleLabel)+10,WIDTH(view)-15*2,20};
    postTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",time];
    postTimeLabel.textColor = RGBColor(100, 100, 100);
    postTimeLabel.textAlignment = NSTextAlignmentLeft;
    postTimeLabel.font = Font(14);
    [view addSubview:postTimeLabel];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,HEIGHT(view)-0.5,WIDTH(view),0.5};
    sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [view addSubview:sepLine];
    
    return view;
}

-(UIView *)setUpAddressViewWithOffset:(float)offset address:(NSString *)address{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    addressLabel.text = [NSString stringWithFormat:@"区域： %@",address];
    addressLabel.textColor = RGBColor(50, 50, 50);
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = Font(15);
    [view addSubview:addressLabel];
    
    return view;
}

-(UIView *)setUpDesciptionViewWithOffset:(float)offset description:(NSString *)descriptionString{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),80};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *descriptionNoteLabel = [[UILabel alloc] init];
    descriptionNoteLabel.frame = (CGRect){15,10,WIDTH(view)-15*2,20};
    descriptionNoteLabel.text = @"详情描述";
    descriptionNoteLabel.textColor = RGBColor(50, 50, 50);
    descriptionNoteLabel.textAlignment = NSTextAlignmentLeft;
    descriptionNoteLabel.font = Font(15);
    [view addSubview:descriptionNoteLabel];
    
    UIView *sepLineView = [[UIView alloc] init];
    sepLineView.frame = (CGRect){0,40-0.5,WIDTH(view),0.5};
    sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view addSubview:sepLineView];
    
    CGSize textSize = [XYTools getSizeWithString:descriptionString andSize:(CGSize){WIDTH(view)-15*2,MAXFLOAT} andFont:Font(15)];
    
    UITextView *decriptionTextView = [[UITextView alloc] init];
    decriptionTextView.backgroundColor = [UIColor whiteColor];
    decriptionTextView.frame = (CGRect){15,40,WIDTH(view)-15*2,textSize.height+20};
    decriptionTextView.textColor = RGBColor(100, 100, 100);
    decriptionTextView.font = Font(15);
    [decriptionTextView setSelectable:YES];
    [decriptionTextView setEditable:NO];
    decriptionTextView.scrollEnabled = NO;
    decriptionTextView.returnKeyType = UIReturnKeyNext;
    decriptionTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    decriptionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    decriptionTextView.text = descriptionString;
    [view addSubview:decriptionTextView];
    
    float remainHeight = HEIGHT(contentView)-offset;
    if (40+textSize.height+20 > remainHeight) {
        view.frame = (CGRect){0,offset,WIDTH(contentView),40+textSize.height+20};
    }else{
        view.frame = (CGRect){0,offset,WIDTH(contentView),remainHeight};
    }
    contentView.contentSize = (CGSize){WIDTH(contentView),BOTTOM(view)+1};
    return view;
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    NSString *titleName = @"工业产品详情";
    
    self.navigationItem.title = titleName;
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIImage *imageArrow = [UIImage imageNamed:@"icon_fb"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setImage:imageArrow forState:UIControlStateNormal];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(16);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rightButtonTitle = @" 发布";
    [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,60,20};
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    FactoryPostNewViewController *fpnVC = [[FactoryPostNewViewController alloc] init];
    [self.navigationController pushViewController:fpnVC animated:YES];
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