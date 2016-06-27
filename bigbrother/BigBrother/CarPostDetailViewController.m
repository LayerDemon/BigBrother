//
//  CarPostDetailViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/7.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CarPostDetailViewController.h"
#import "CarPostNewViewController.h"

#import "UIAlertView+Blocks.h"

#import "RentCarProduct.h"
#import "HelpDriveProduct.h"
#import "CarPoolProduct.h"
#import "ChatViewController.h"

@interface CarPostDetailViewController ()

@end

@implementation CarPostDetailViewController{
    UIScrollView *contentView;
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
    if (![selfNum isEqualToString:self.carProduct.phoneNumber]) {
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
//    NSString *postNum = self.carProduct.phoneNumber;
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
    
    if ([NSString isBlankStringWithString:self.carProduct.imNumber]) {
        [BYToastView showToastWithMessage:@"缺少im联系方式,无法联系用户~"];
        return;
    }
    
    
    NSString *postNum = self.carProduct.imNumber;
    
    if ([postNum isEqualToString:userDic[@"imNumber"]]) {
        [BYToastView showToastWithMessage:@"发布者是您自己哦~"];
        return;
    }
    //    发送消息
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    EMConversation *conversation = [MANAGER_CHAT getConversation:postNum type:EMConversationTypeChat createIfNotExist:YES];
    chatVC.conversation = conversation;
    chatVC.chatDic = self.carProduct.creatorUserDic;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)initViews{
    float offset = 0;
    switch (self.carProduct.carType) {
        case CarProductZuChe:{
            RentCarProduct *product = (RentCarProduct *)self.carProduct;
            if (product.isSupply) {
                NSString *title = product.title;
                if (!title) {
                    title = @"";
                }
                NSString *createTime = product.createTime;
                if (!createTime) {
                    createTime = @"";
                }
                NSArray *carTypeList = product.carTypeList;
                
                NSString *addressFullName = product.districtFullName;
                if (!addressFullName) {
                    addressFullName = @"";
                }
                NSString *description = product.introduction;
                if (!description) {
                    description = @"";
                }
                UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title timeString:createTime];
                [contentView addSubview:titleView];
                
                offset += HEIGHT(titleView);
                offset += 10;
                
                UIView *serviceTypeView = [self setUpServiceTypeViewWithOffset:offset withArray:carTypeList];
                [contentView addSubview:serviceTypeView];
                
                offset += HEIGHT(serviceTypeView);
                offset += 10;
                
                UIView *addressView = [self setUpAddressViewWithOffset:offset address:addressFullName];
                [contentView addSubview:addressView];
                
                offset += HEIGHT(addressView);
                offset += 10;
                
                UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
                [contentView addSubview:descriptionView];
                
                offset += HEIGHT(descriptionView);
                
            }else{
                NSString *title = product.title;
                if (!title) {
                    title = @"";
                }
                NSString *createTime = product.createTime;
                if (!createTime) {
                    createTime = @"";
                }
                NSArray *carTypeList = product.carTypeList;
                
                NSString *addressFullName = product.districtFullName;
                if (!addressFullName) {
                    addressFullName = @"";
                }
                
                UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title timeString:createTime];
                [contentView addSubview:titleView];
                
                offset += HEIGHT(titleView);
                offset += 10;
                
                UIView *serviceTypeView = [self setUpServiceTypeViewWithOffset:offset withArray:carTypeList];
                [contentView addSubview:serviceTypeView];
                
                offset += HEIGHT(serviceTypeView);
                offset += 10;
                
                UIView *addressView = [self setUpAddressViewWithOffset:offset address:addressFullName];
                [contentView addSubview:addressView];
                
                offset += HEIGHT(addressView);
                offset += 10;
                
                UIView *dayCountView = [self setUpDayCountViewWithOffset:offset dayCount:product.dayCount];
                [contentView addSubview:dayCountView];
                
                offset += HEIGHT(dayCountView);
                offset += 10;
                
                UIView *peopleCountView = [self setUpPeopleCountViewWithOffset:offset peopleCount:product.personCount];
                [contentView addSubview:peopleCountView];
                
                offset += HEIGHT(peopleCountView);
                offset += 10;
                
                contentView.contentSize = (CGSize){WIDTH(contentView),MAX(offset+1, HEIGHT(contentView)+1)};
            }
        }
            break;
        case CarProductPinChe:{
            CarPoolProduct *product = (CarPoolProduct *)self.carProduct;
            
            NSString *carPoolType = product.carPoolType;
            NSString *carPoolTypeString;
            if (carPoolType) {
                if ([carPoolType isEqualToString:@"LONG_TRIP"]) {
                    carPoolTypeString = @"长途拼车";
                }else if ([carPoolType isEqualToString:@"SAME_CITY"]){
                    carPoolTypeString = @"同城拼车";
                }
            }
            if (!carPoolTypeString) {
                carPoolTypeString = @"";
            }
            NSString *createTime = product.createTime;
            if (!createTime) {
                createTime = @"";
            }
            
            NSString *addressFullName = product.districtFullName;
            if (!addressFullName) {
                addressFullName = @"";
            }
            NSString *description = product.introduction;
            if (!description) {
                description = @"";
            }
            
            NSString *startPo = product.start;
            NSString *endPo = product.destination;
            NSString *leaveTime = product.leaveTime;
            if (!startPo) {
                startPo = @"";
            }
            if (!endPo) {
                endPo = @"";
            }
            if (!leaveTime) {
                leaveTime = @"";
            }
            
            UIView *carPoolTypeView = [self setUpPinCheTypeViewWithOffset:offset typeString:carPoolTypeString createTime:createTime];
            [contentView addSubview:carPoolTypeView];
            
            offset += HEIGHT(carPoolTypeView);
            offset += 10;
            
            UIView *addressView = [self setUpAddressViewWithOffset:offset address:addressFullName];
            [contentView addSubview:addressView];
            
            offset += HEIGHT(addressView);
            offset += 10;
            
            
            UIView *pincheOtherView = [self setUpPinCheOtherViewWithOffset:offset start:startPo destination:endPo leaveTime:leaveTime isSupply:product.isSupply seatCount:product.seatCount];
            [contentView addSubview:pincheOtherView];
            
            offset += HEIGHT(pincheOtherView);
            offset += 10;
            
            UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
            [contentView addSubview:descriptionView];
            
            offset += HEIGHT(descriptionView);
        }
            break;
        case CarProductDaiJia:{
            HelpDriveProduct *product = (HelpDriveProduct *)self.carProduct;
            
            NSString *title = product.title;
            if (!title) {
                title = @"";
            }
            NSString *createTime = product.createTime;
            if (!createTime) {
                createTime = @"";
            }
            NSArray *serviceTypeList = product.serviceTypeList;
            
            NSString *addressFullName = product.districtFullName;
            if (!addressFullName) {
                addressFullName = @"";
            }
            NSString *description = product.introduction;
            if (!description) {
                description = @"";
            }
            UIView *titleView = [self setUpTitleViewWithOffset:offset titleString:title timeString:createTime];
            [contentView addSubview:titleView];
            
            offset += HEIGHT(titleView);
            offset += 10;
            
            UIView *serviceTypeView = [self setUpHelpDriveViewWithOffset:offset withArray:serviceTypeList isSupply:product.isSupply];
            [contentView addSubview:serviceTypeView];
            
            offset += HEIGHT(serviceTypeView);
            offset += 10;
            
            UIView *addressView = [self setUpAddressViewWithOffset:offset address:addressFullName];
            [contentView addSubview:addressView];
            
            offset += HEIGHT(addressView);
            offset += 10;
            
            if (!product.isSupply) {
                UIView *dayCountView = [self setUpDayCountViewWithOffset:offset dayCount:product.dayCount];
                [contentView addSubview:dayCountView];
                
                offset += HEIGHT(dayCountView);
                offset += 10;
            }
            
            UIView *descriptionView = [self setUpDesciptionViewWithOffset:offset description:description];
            [contentView addSubview:descriptionView];
            
            offset += HEIGHT(descriptionView);
            
            
        }
            break;
        case CarProductLvXingBaoXian:{
            [BYToastView showToastWithMessage:@"敬请期待"];
            return;
        }
            break;
        default:
            break;
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

-(UIView *)setUpServiceTypeViewWithOffset:(float)offset withArray:(NSArray *)array{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),80};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *serviceTypeNoteLabel = [[UILabel alloc] init];
    serviceTypeNoteLabel.frame = (CGRect){15,10,WIDTH(view)-15*2,20};
    serviceTypeNoteLabel.text = @"服务车型";
    serviceTypeNoteLabel.textColor = RGBColor(50, 50, 50);
    serviceTypeNoteLabel.textAlignment = NSTextAlignmentLeft;
    serviceTypeNoteLabel.font = Font(15);
    [view addSubview:serviceTypeNoteLabel];
    
    UIView *sepLineView = [[UIView alloc] init];
    sepLineView.frame = (CGRect){0,40-0.5,WIDTH(view),0.5};
    sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view addSubview:sepLineView];
    
    if (!array || array.count == 0) {
        return view;
    }
    
    UIFont *nameFont = Font(13);
    float offsetOriginX = 15;
    float offsetOriginY = 40+10;
    float offsetBetweenWidth = 10;
    float offsetBetweenHeight = 10;
    float labelPaddingX = 10;
    float labelPaddingY = 8;
    
    float usedViewWidth = offsetOriginX - offsetBetweenWidth;
    float usedViewheight = offsetOriginY;
    
    int xOffset = 0;
    int yOffset = 0;
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *cityDic = array[i];
        
        NSString *name = cityDic[@"name"];
        
        CGSize nameSize = [XYTools getSizeWithString:name andSize:(CGSize){MAXFLOAT,15} andFont:nameFont];
        
        float buttonWidth = nameSize.width + labelPaddingX * 2;
        
        float buttonHeight = nameSize.height + labelPaddingY * 2;
        
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nameButton.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
        nameButton.layer.borderWidth = 0.5f;
        [nameButton setTitle:name forState:UIControlStateNormal];
        [nameButton setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
        nameButton.backgroundColor = [UIColor whiteColor];
        nameButton.tintColor = [UIColor whiteColor];
        nameButton.titleLabel.font = nameFont;
        nameButton.tag = i;
        
        usedViewWidth += buttonWidth + offsetBetweenWidth;
        
        if (usedViewWidth <= WIDTH(view)) {
            yOffset += 0;
            xOffset += 1;
        }else{
            yOffset += 1;
            xOffset = 0;
            usedViewheight += offsetBetweenHeight + buttonHeight;
            
            usedViewWidth = offsetOriginX-offsetBetweenWidth;
            usedViewWidth += buttonWidth+offsetBetweenWidth;
        }
        
        nameButton.frame = (CGRect){
            usedViewWidth-buttonWidth,
            usedViewheight,
            buttonWidth,
            buttonHeight
        };
        [view addSubview:nameButton];
        view.frame = (CGRect){0,offset,WIDTH(contentView),BOTTOM(nameButton)+10};
    }
    
    return view;
}

-(UIView *)setUpAddressViewWithOffset:(float)offset address:(NSString *)address{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    addressLabel.text = [NSString stringWithFormat:@"地址： %@",address];
    addressLabel.textColor = RGBColor(50, 50, 50);
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = Font(15);
    [view addSubview:addressLabel];
    
    return view;
}

-(UIView *)setUpDayCountViewWithOffset:(float)offset dayCount:(int)dayCount{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *dayCountLabel = [[UILabel alloc] init];
    dayCountLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    dayCountLabel.text = [NSString stringWithFormat:@"天数：%d天",dayCount];
    dayCountLabel.textColor = RGBColor(50, 50, 50);
    dayCountLabel.textAlignment = NSTextAlignmentLeft;
    dayCountLabel.font = Font(15);
    [view addSubview:dayCountLabel];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,HEIGHT(view)-0.5,WIDTH(view),0.5};
    sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [view addSubview:sepLine];
    
    return view;
}

-(UIView *)setUpPeopleCountViewWithOffset:(float)offset peopleCount:(int)peopleCount{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),40};
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *pCountLabel = [[UILabel alloc] init];
    pCountLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,HEIGHT(view)};
    pCountLabel.text = [NSString stringWithFormat:@"人数：%d",peopleCount];
    pCountLabel.textColor = RGBColor(50, 50, 50);
    pCountLabel.textAlignment = NSTextAlignmentLeft;
    pCountLabel.font = Font(15);
    [view addSubview:pCountLabel];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = (CGRect){0,HEIGHT(view)-0.5,WIDTH(view),0.5};
    sepLine.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [view addSubview:sepLine];
    
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

#pragma mark - 拼车服务单独加载
-(UIView *)setUpPinCheTypeViewWithOffset:(float)offset typeString:(NSString *)typeString createTime:(NSString *)time{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),70};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = (CGRect){15,10,WIDTH(view)-15*2,20};
    titleLabel.text = [NSString stringWithFormat:@"拼车类型：%@",typeString];;
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

-(UIView *)setUpPinCheOtherViewWithOffset:(float)offset start:(NSString *)start destination:(NSString *)destination leaveTime:(NSString *)leaveTime isSupply:(BOOL)isSupply seatCount:(int)seatCount{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),160};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *startPositionLabel = [[UILabel alloc] init];
    startPositionLabel.frame = (CGRect){15,0,WIDTH(view)-15*2,40};
    startPositionLabel.text = [NSString stringWithFormat:@"起点：%@",start];
    startPositionLabel.textColor = RGBColor(50, 50, 50);
    startPositionLabel.textAlignment = NSTextAlignmentLeft;
    startPositionLabel.font = Font(15);
    [view addSubview:startPositionLabel];
    
    UILabel *destPositionLabel = [[UILabel alloc] init];
    destPositionLabel.frame = (CGRect){15,40,WIDTH(view)-15*2,40};
    destPositionLabel.text = [NSString stringWithFormat:@"终点：%@",destination];
    destPositionLabel.textColor = RGBColor(50, 50, 50);
    destPositionLabel.textAlignment = NSTextAlignmentLeft;
    destPositionLabel.font = Font(15);
    [view addSubview:destPositionLabel];
    
    UILabel *leaveTimeLabel = [[UILabel alloc] init];
    leaveTimeLabel.frame = (CGRect){15,80,WIDTH(view)-15*2,40};
    leaveTimeLabel.text = [NSString stringWithFormat:@"出发时间：%@",leaveTime];
    leaveTimeLabel.textColor = RGBColor(50, 50, 50);
    leaveTimeLabel.textAlignment = NSTextAlignmentLeft;
    leaveTimeLabel.font = Font(15);
    [view addSubview:leaveTimeLabel];
    
    UILabel *seatCountLabel = [[UILabel alloc] init];
    seatCountLabel.frame = (CGRect){15,120,WIDTH(view)-15*2,40};
    seatCountLabel.text = [NSString stringWithFormat:@"%@：%d个",isSupply?@"提供座位":@"需要座位",seatCount];
    seatCountLabel.textColor = RGBColor(50, 50, 50);
    seatCountLabel.textAlignment = NSTextAlignmentLeft;
    seatCountLabel.font = Font(15);
    [view addSubview:seatCountLabel];
    
    return view;
}

#pragma mark - 代驾服务额外视图
-(UIView *)setUpHelpDriveViewWithOffset:(float)offset withArray:(NSArray *)array isSupply:(BOOL)isSupply{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),80};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *serviceTypeNoteLabel = [[UILabel alloc] init];
    serviceTypeNoteLabel.frame = (CGRect){15,10,WIDTH(view)-15*2,20};
    serviceTypeNoteLabel.text = isSupply?@"提供服务":@"需求服务";
    serviceTypeNoteLabel.textColor = RGBColor(50, 50, 50);
    serviceTypeNoteLabel.textAlignment = NSTextAlignmentLeft;
    serviceTypeNoteLabel.font = Font(15);
    [view addSubview:serviceTypeNoteLabel];
    
    UIView *sepLineView = [[UIView alloc] init];
    sepLineView.frame = (CGRect){0,40-0.5,WIDTH(view),0.5};
    sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view addSubview:sepLineView];
    
    if (!array || array.count == 0) {
        return view;
    }
    
    UIFont *nameFont = Font(13);
    float offsetOriginX = 15;
    float offsetOriginY = 40+10;
    float offsetBetweenWidth = 10;
    float offsetBetweenHeight = 10;
    float labelPaddingX = 10;
    float labelPaddingY = 8;
    
    float usedViewWidth = offsetOriginX - offsetBetweenWidth;
    float usedViewheight = offsetOriginY;
    
    int xOffset = 0;
    int yOffset = 0;
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *cityDic = array[i];
        
        NSString *name = cityDic[@"name"];
        
        CGSize nameSize = [XYTools getSizeWithString:name andSize:(CGSize){MAXFLOAT,15} andFont:nameFont];
        
        float buttonWidth = nameSize.width + labelPaddingX * 2;
        
        float buttonHeight = nameSize.height + labelPaddingY * 2;
        
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nameButton.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
        nameButton.layer.borderWidth = 0.5f;
        [nameButton setTitle:name forState:UIControlStateNormal];
        [nameButton setTitleColor:RGBColor(100, 100, 100) forState:UIControlStateNormal];
        nameButton.backgroundColor = [UIColor whiteColor];
        nameButton.tintColor = [UIColor whiteColor];
        nameButton.titleLabel.font = nameFont;
        nameButton.tag = i;
        
        usedViewWidth += buttonWidth + offsetBetweenWidth;
        
        if (usedViewWidth <= WIDTH(view)) {
            yOffset += 0;
            xOffset += 1;
        }else{
            yOffset += 1;
            xOffset = 0;
            usedViewheight += offsetBetweenHeight + buttonHeight;
            
            usedViewWidth = offsetOriginX-offsetBetweenWidth;
            usedViewWidth += buttonWidth+offsetBetweenWidth;
        }
        
        nameButton.frame = (CGRect){
            usedViewWidth-buttonWidth,
            usedViewheight,
            buttonWidth,
            buttonHeight
        };
        [view addSubview:nameButton];
        view.frame = (CGRect){0,offset,WIDTH(contentView),BOTTOM(nameButton)+10};
    }
    
    return view;
}


#pragma mark - Nacigation
-(void)setUpNavigation{
    NSString *titleName = @"用车服务详情";
    switch (self.carProduct.carType) {
        case CarProductZuChe:{
            titleName = @"租车服务详情";
        }
            break;
        case CarProductPinChe:{
            titleName = @"拼车服务详情";
        }
            break;
        case CarProductDaiJia:{
            titleName = @"代驾服务详情";
        }
            break;
        case CarProductLvXingBaoXian:{
            titleName = @"旅行保险详情";
        }
            break;
        default:
            break;
    }
    
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
    CarPostNewViewController *cpnVC = [CarPostNewViewController new];
    [self.navigationController pushViewController:cpnVC animated:YES];
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