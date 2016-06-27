//
//  HousePostDetailViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HousePostDetailViewController.h"

#import "HousePostNewViewController.h"

#import "UIAlertView+Blocks.h"

#import "SingleRoomRentProduct.h"
#import "WholeHouseRentProduct.h"
#import "FactoryHouseProduct.h"
#import "WholeHouseSellProduct.h"
#import "WantHouseProduct.h"

#import "ChatViewController.h"

@interface HousePostDetailViewController ()<UIScrollViewDelegate>

@end

@implementation HousePostDetailViewController{
    UIScrollView *contentView;
    
    UIPageControl *imageShowedPageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
//    NSString *postNum = self.product.phoneNumber;
//    if (postNum) {
//        [[[UIAlertView alloc] initWithTitle:@"拨号确认"
//                                    message:[NSString stringWithFormat:@"确定拨号%@吗?",postNum]
//                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
//                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[postNum stringByReplacingOccurrencesOfString:@"-" withString:@""]]]];
//        }], nil] show];
//    }
    NSDictionary *userDic = [BBUserDefaults getUserDic];
    if (!userDic) {
        [BYToastView showToastWithMessage:@"请先登录~"];
        return;
    }
    
    if ([NSString isBlankStringWithString:self.product.imNumber]) {
        [BYToastView showToastWithMessage:@"缺少im联系方式,无法联系用户~"];
        return;
    }
    
    
    NSString *postNum = self.product.imNumber;
    
    if ([postNum isEqualToString:userDic[@"imNumber"]]) {
        [BYToastView showToastWithMessage:@"发布者是您自己哦~"];
        return;
    }
    //    发送消息
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    EMConversation *conversation = [MANAGER_CHAT getConversation:postNum type:EMConversationTypeChat createIfNotExist:YES];
    chatVC.conversation = conversation;
    chatVC.chatDic = self.product.creatorUserDic;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)initViews{
    HouseProductType type = self.product.houseType;
    
    NSString *title = self.product.title;
    if (!title) {
        title = @"";
    }
    NSString *createTime = self.product.createTime;
    if (!createTime ) {
        createTime = @"";
    }
    NSString *description = self.product.introduction;
    if (!description) {
        description = @"";
    }
    NSString *areaAddress = self.product.districtFullName;
    if (!areaAddress) {
        areaAddress = @"";
    }
    
    float offset = 0.f;
    if (type == HouseProductDanjianZuNin){
        
        NSArray *imagesArray = self.product.images;
        UIView *imageShowView = [self setUpImageShowViewWithOffset:offset imageArray:imagesArray];
        [contentView addSubview:imageShowView];
        
        offset += HEIGHT(imageShowView);
        //        return;
        SingleRoomRentProduct *product = (SingleRoomRentProduct *)self.product;
        
        int price = product.price;
        
        UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title moneyAttrString:[NSString stringWithFormat:@"%@ 元/月",price==0?@"面议":[NSString stringWithFormat:@"%d",price]] timeString:createTime];
        [contentView addSubview:titleView];
        
        offset += HEIGHT(titleView);
        offset += 10;
        
        UIView *houseRoomTypeView = [self setUpHouseRoomTypeViewWithOffset:offset roomTypeNoteString:@"房型" roomTypeString:@"单间"];
        [contentView addSubview:houseRoomTypeView];
        
        offset += HEIGHT(houseRoomTypeView);
        
        UIView *houseAreaView = [self setUpHouseAreaViewWithOffset:offset areaNoteString:@"面积" areaInt:product.area];
        [contentView addSubview:houseAreaView];
        
        offset += HEIGHT(houseAreaView);
        
        UIView *houseFloorInfoView = [self setUpHouseFloorInfoViewWithOffset:offset atFloor:product.floor totalFloor:product.totalFloor];
        [contentView addSubview:houseFloorInfoView];
        
        offset += HEIGHT(houseFloorInfoView);
        offset += 10;
        
        UIView *houseCommunityInfoView = [self setUpHouseCommunityInfoViewWithOffset:offset communityAddress:product.communityAddress communityName:product.communityName];
        [contentView addSubview:houseCommunityInfoView];
        
        offset += HEIGHT(houseCommunityInfoView);
        offset += 10;
        
        UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
        [contentView addSubview:descriptionView];
        
        offset += HEIGHT(descriptionView);
        
    }else if (type == HouseProductZhengTaoZuNin){
        NSArray *imagesArray = self.product.images;
        UIView *imageShowView = [self setUpImageShowViewWithOffset:offset imageArray:imagesArray];
        [contentView addSubview:imageShowView];
        
        offset += HEIGHT(imageShowView);
        
        WholeHouseRentProduct *product = (WholeHouseRentProduct *)self.product;
        
        int price = product.price;
        
        UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title moneyAttrString:[NSString stringWithFormat:@"%@ 万元",price==0?@"面议":[NSString stringWithFormat:@"%d",price]] timeString:createTime];
        [contentView addSubview:titleView];
        
        offset += HEIGHT(titleView);
        offset += 10;
        
        NSString *roomTypeString = product.roomValue;
        
        UIView *houseRoomTypeView = [self setUpHouseRoomTypeViewWithOffset:offset roomTypeNoteString:@"房型" roomTypeString:roomTypeString?roomTypeString:@"整套"];
        [contentView addSubview:houseRoomTypeView];
        
        offset += HEIGHT(houseRoomTypeView);
        
        UIView *houseAreaView = [self setUpHouseAreaViewWithOffset:offset areaNoteString:@"面积" areaInt:product.area];
        [contentView addSubview:houseAreaView];
        
        offset += HEIGHT(houseAreaView);
        
        UIView *houseFloorInfoView = [self setUpHouseFloorInfoViewWithOffset:offset atFloor:product.floor totalFloor:product.totalFloor];
        [contentView addSubview:houseFloorInfoView];
        
        offset += HEIGHT(houseFloorInfoView);
        offset += 10;
        
        UIView *houseCommunityInfoView = [self setUpHouseCommunityInfoViewWithOffset:offset communityAddress:product.communityAddress communityName:product.communityName];
        [contentView addSubview:houseCommunityInfoView];
        
        offset += HEIGHT(houseCommunityInfoView);
        offset += 10;
        
        UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
        [contentView addSubview:descriptionView];
        
        offset += HEIGHT(descriptionView);
        
    }else if (type == HouseProductChangFangZuNin ||
              type == HouseProductChangFangXiaoShou){
        NSArray *imagesArray = self.product.images;
        UIView *imageShowView = [self setUpImageShowViewWithOffset:offset imageArray:imagesArray];
        [contentView addSubview:imageShowView];
        
        offset += HEIGHT(imageShowView);
        
        FactoryHouseProduct *product = (FactoryHouseProduct *)self.product;
        
        float price = product.price;
        NSString *moneyString = @"";
        if (price == 0.f) {
            moneyString = @"面议";
        }else{
            if ((int)(price*10)-(int)(price)*10 == 0) {
                moneyString = [NSString stringWithFormat:@"%d",(int)price];
            }else{
                moneyString = [NSString stringWithFormat:@"%.1f",price];
            }
        }
        
        if (type == HouseProductChangFangZuNin) {
            moneyString = [NSString stringWithFormat:@"租金：%@元/㎡/天",moneyString];
        }else if (type == HouseProductChangFangXiaoShou){
            moneyString = [NSString stringWithFormat:@"售价：%@万元",moneyString];
        }
        
        UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title moneyAttrString:moneyString timeString:createTime];
        [contentView addSubview:titleView];
        
        offset += HEIGHT(titleView);
        offset += 10;
        
        UIView *areaAddressView = [self setUpAreaAddressViewWithOffset:offset areaAddressNoteString:@"区域" address:areaAddress];
        [contentView addSubview:areaAddressView];
        
        offset += HEIGHT(areaAddressView);
        
        UIView *houseAreaView = [self setUpHouseAreaViewWithOffset:offset areaNoteString:@"面积" areaInt:product.area];
        [contentView addSubview:houseAreaView];
        
        offset += HEIGHT(houseAreaView);
        
        NSString *houseAddress = product.address;
        if (!houseAddress) {
            houseAddress = @"";
        }
        
        UIView *houseAddressView = [self setUpHouseAddressViewWithOffset:offset houseAddressNoteString:@"地址" address:houseAddress];
        [contentView addSubview:houseAddressView];
        
        offset += HEIGHT(houseAddressView);
        offset += 10;
        
        UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
        [contentView addSubview:descriptionView];
        
        offset += HEIGHT(descriptionView);
        
    }else if (type == HouseProductChangFangQiuZu ||
              type == HouseProductChangFangQiuGou){
        FactoryHouseProduct *product = (FactoryHouseProduct *)self.product;
        
        float price = product.price;
        NSString *moneyString = @"";
        if (price == 0.f) {
            moneyString = @"面议";
        }else{
            if ((int)(price*10)-(int)(price)*10 == 0) {
                moneyString = [NSString stringWithFormat:@"%d",(int)price];
            }else{
                moneyString = [NSString stringWithFormat:@"%.1f",price];
            }
        }
        
        if (type == HouseProductChangFangQiuZu) {
            moneyString = [NSString stringWithFormat:@"期望租金：%@元/㎡/天",moneyString];
        }else if (type == HouseProductChangFangQiuGou){
            moneyString = [NSString stringWithFormat:@"期望售价：%@万元",moneyString];
        }
        
        UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title moneyAttrString:moneyString timeString:createTime];
        [contentView addSubview:titleView];
        
        offset += HEIGHT(titleView);
        offset += 10;
        
        UIView *areaAddressView = [self setUpAreaAddressViewWithOffset:offset areaAddressNoteString:@"期望区域" address:areaAddress];
        [contentView addSubview:areaAddressView];
        
        offset += HEIGHT(areaAddressView);
        
        UIView *houseAreaView = [self setUpHouseAreaViewWithOffset:offset areaNoteString:@"期望面积" areaInt:product.area];
        [contentView addSubview:houseAreaView];
        
        offset += HEIGHT(houseAreaView);
        offset += 10;
        
        NSString *houseAddress = product.address;
        if (!houseAddress) {
            houseAddress = @"";
        }
        
        UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
        [contentView addSubview:descriptionView];
        
        offset += HEIGHT(descriptionView);
    }else if (type == HouseProductFangWuXiaoShou){
        WholeHouseSellProduct *product = (WholeHouseSellProduct *)self.product;
        
        NSArray *imagesArray = self.product.images;
        UIView *imageShowView = [self setUpImageShowViewWithOffset:offset imageArray:imagesArray];
        [contentView addSubview:imageShowView];
        
        offset += HEIGHT(imageShowView);
        
        float price = product.price;
        NSString *moneyString = @"";
        if (price == 0.f) {
            moneyString = @"面议";
        }else{
            if ((int)(price*10)-(int)(price)*10 == 0) {
                moneyString = [NSString stringWithFormat:@"%d",(int)price];
            }else{
                moneyString = [NSString stringWithFormat:@"%.1f",price];
            }
        }
        
        UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title moneyAttrString:[NSString stringWithFormat:@"售价：%@ 万元",moneyString] timeString:createTime];
        [contentView addSubview:titleView];
        
        offset += HEIGHT(titleView);
        offset += 10;
        
        UIView *houseAreaView = [self setUpHouseAreaViewWithOffset:offset areaNoteString:@"面积" areaInt:product.area];
        [contentView addSubview:houseAreaView];
        
        offset += HEIGHT(houseAreaView);
        
        offset += 10;
        
        UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
        [contentView addSubview:descriptionView];
        
        offset += HEIGHT(descriptionView);
        
    }else if (type == HouseProductFangWuQiuZu ||
              type == HouseProductFangWuQiuGou){
        WantHouseProduct *product = (WantHouseProduct *)self.product;
        
        int price = product.price;
        
        NSString *pricePreFixString = @"";
        NSString *priceTailFixString = @"";
        if (type == HouseProductFangWuQiuZu) {
            pricePreFixString = @"期望租金";
            priceTailFixString = @"元/月";
        }else if (type == HouseProductFangWuQiuGou){
            pricePreFixString = @"期望售价";
            priceTailFixString = @"万元";
        }
        
        UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title moneyAttrString:[NSString stringWithFormat:@"%@：%@ %@",pricePreFixString,price==0?@"面议":[NSString stringWithFormat:@"%d",price],priceTailFixString] timeString:createTime];
        [contentView addSubview:titleView];
        
        offset += HEIGHT(titleView);
        offset += 10;
        
        UIView *areaAddressView = [self setUpAreaAddressViewWithOffset:offset areaAddressNoteString:@"区域" address:areaAddress];
        [contentView addSubview:areaAddressView];
        
        offset += HEIGHT(areaAddressView);
        
        UIView *houseAreaView = [self setUpHouseAreaViewWithOffset:offset areaNoteString:@"面积" areaInt:product.area];
        [contentView addSubview:houseAreaView];
        
        offset += HEIGHT(houseAreaView);
        
        NSString *expectedTypeValueString = product.expectedTypeValue;
        
        UIView *houseRoomTypeView = [self setUpHouseRoomTypeViewWithOffset:offset roomTypeNoteString:@"房型" roomTypeString:expectedTypeValueString?expectedTypeValueString:@"整套"];
        [contentView addSubview:houseRoomTypeView];
        
        offset += HEIGHT(houseRoomTypeView);
        offset += 10;
        
        UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
        [contentView addSubview:descriptionView];
        
        offset += HEIGHT(descriptionView);
        
    }else if (type == HouseProductShangPuZuNin){
        [BYToastView showToastWithMessage:@"敬请期待"];
        return;
    }else if (type == HouseProductShangPuXiaoShou){
        [BYToastView showToastWithMessage:@"敬请期待"];
        return;
    }
    
}

#pragma mark - 图片显示
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
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapGresture:)];
            [imageView addGestureRecognizer:tapGesture];
            
            imageView.frame = (CGRect){WIDTH(imageViewScroller)*i,0,WIDTH(imageViewScroller),HEIGHT(imageViewScroller)};
            
            NSString *urlstring = dic[@"url"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:@"icon_defaultImageBig"]];
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

#pragma mark - 标题
-(UIView *)setUpTitleViewWithOffset:(float)offset titleString:(NSString *)title moneyAttrString:(NSString *)attrString timeString:(NSString *)time{
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
    
    UILabel *moneyPostLabel = [[UILabel alloc] init];
    moneyPostLabel.frame = (CGRect){15,BOTTOM(titleLabel)+10,WIDTH(view)-15*2-140,20};
    moneyPostLabel.text = attrString;
    moneyPostLabel.textColor = [UIColor redColor];
    moneyPostLabel.textAlignment = NSTextAlignmentLeft;
    moneyPostLabel.font = Font(14);
    [view addSubview:moneyPostLabel];
    
    UILabel *postTimeLabel = [[UILabel alloc] init];
    postTimeLabel.frame = (CGRect){WIDTH(view)-15-140,BOTTOM(titleLabel)+15,140,15};
    postTimeLabel.text = time;
    postTimeLabel.textColor = RGBColor(100, 100, 100);
    postTimeLabel.textAlignment = NSTextAlignmentRight;
    postTimeLabel.font = Font(13);
    [view addSubview:postTimeLabel];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,HEIGHT(view)-0.5,WIDTH(view),0.5};
    sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [view addSubview:sepLine];
    
    return view;
}

#pragma mark - 房屋地址
-(UIView *)setUpHouseAddressViewWithOffset:(float)offset houseAddressNoteString:(NSString *)noteString address:(NSString *)address{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    addressLabel.text = [NSString stringWithFormat:@"%@： %@",noteString?noteString:@"地址",address];
    addressLabel.textColor = RGBColor(50, 50, 50);
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = Font(15);
    [view addSubview:addressLabel];
    
    return view;
}

#pragma mark - 区域
-(UIView *)setUpAreaAddressViewWithOffset:(float)offset areaAddressNoteString:(NSString *)noteString address:(NSString *)address{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    addressLabel.text = [NSString stringWithFormat:@"%@： %@",noteString?noteString:@"区域",address];
    addressLabel.textColor = RGBColor(50, 50, 50);
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = Font(15);
    [view addSubview:addressLabel];
    
    return view;
}

#pragma mark - 房屋面积大小
-(UIView *)setUpHouseAreaViewWithOffset:(float)offset areaNoteString:(NSString *)areaNoteString areaInt:(int)areaInt{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    areaLabel.text = [NSString stringWithFormat:@"%@： %d㎡",areaNoteString?areaNoteString:@"面积", areaInt];
    areaLabel.textColor = RGBColor(50, 50, 50);
    areaLabel.textAlignment = NSTextAlignmentLeft;
    areaLabel.font = Font(15);
    [view addSubview:areaLabel];
    
    return view;
}

#pragma mark - 房屋户型
-(UIView *)setUpHouseRoomTypeViewWithOffset:(float)offset roomTypeNoteString:(NSString *)areaNoteString roomTypeString:(NSString *)roomType{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    label.text = [NSString stringWithFormat:@"%@： %@",areaNoteString?areaNoteString:@"户型", roomType];
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [view addSubview:label];
    
    return view;
}

#pragma mark - 房屋楼层信息
-(UIView *)setUpHouseFloorInfoViewWithOffset:(float)offset atFloor:(int)floor totalFloor:(int)totalFloor{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    label.text = [NSString stringWithFormat:@"楼层： %d/%d",floor, totalFloor];
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [view addSubview:label];
    
    return view;
}

#pragma mark - 房屋小区信息
-(UIView *)setUpHouseCommunityInfoViewWithOffset:(float)offset communityAddress:(NSString *)communityAddress communityName:(NSString *)communityName{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),80};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){15,0,WIDTH(view)-15*2,40};
    label.text = [NSString stringWithFormat:@"小区名称： %@",communityName];
    label.textColor = RGBColor(50, 50, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [view addSubview:label];
    
    UIView *sepLineView = [[UIView alloc] init];
    sepLineView.frame = (CGRect){0,40-0.5,WIDTH(view),0.5};
    sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [view addSubview:sepLineView];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = (CGRect){15,40,WIDTH(view)-15*2,40};
    label2.text = [NSString stringWithFormat:@"小区地址： %@",communityAddress];
    label2.textColor = RGBColor(50, 50, 50);
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = Font(15);
    [view addSubview:label2];
    
    return view;
}

#pragma mark - 描述相关
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
    NSString *titleString;
    switch (self.product.houseType) {
        case HouseProductDanjianZuNin:
            titleString = @"单间租赁详情";
            break;
        case HouseProductZhengTaoZuNin:
            titleString = @"整套租赁详情";
            break;
        case HouseProductChangFangZuNin:
            titleString = @"厂房租赁详情";
            break;
        case HouseProductChangFangQiuZu:
            titleString = @"厂房求租详情";
            break;
        case HouseProductFangWuXiaoShou:
            titleString = @"房屋销售详情";
            break;
        case HouseProductChangFangXiaoShou:
            titleString = @"厂房销售详情";
            break;
        case HouseProductChangFangQiuGou:
            titleString = @"厂房求购详情";
            break;
        case HouseProductFangWuQiuZu:
            titleString = @"房屋求租详情";
            break;
        case HouseProductShangPuZuNin:
            titleString = @"商铺租赁详情";
            break;
        case HouseProductShangPuXiaoShou:
            titleString = @"商铺销售详情";
            break;
        default:
            break;
    }
    
    self.navigationItem.title = titleString;
    
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
    HousePostNewViewController *hpnVC = [[HousePostNewViewController alloc] init];
    [self.navigationController pushViewController:hpnVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 点击图片
- (void)imageViewTapGresture:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    [PreviewImageViewController showImage:imageView];
}

@end
