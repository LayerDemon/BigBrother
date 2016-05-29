//
//  ChatSupplyLinkView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChatSupplyLinkView.h"

#import "CarProduct.h"
#import "HelpDriveProduct.h"
#import "RentCarProduct.h"
#import "CarPoolProduct.h"

#import "HouseProduct.h"
#import "SingleRoomRentProduct.h"
#import "WholeHouseRentProduct.h"
#import "WholeHouseSellProduct.h"
#import "WantHouseProduct.h"
#import "FactoryHouseProduct.h"

#import "FactoryProduct.h"

@interface ChatSupplyLinkView ()


@property (strong, nonatomic) IBOutlet UIButton *typeBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;


@end

@implementation ChatSupplyLinkView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChatSupplyLinkView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
    }
    return self;
}

#pragma mark - 数据加载 
- (void)reloadSupplyLinkWithDataDic:(NSDictionary *)dataDic
{
    self.dataDic = dataDic;
    self.titleLabel.text = dataDic[@"title"];
    self.timeLabel.text = dataDic[@"createdTime"];
    self.typeBtn.backgroundColor = ARGB_COLOR(36, 175, 208, 1);
    if (self.titleLabel.text.length > 2) {
        [self.typeBtn setTitle:[self.titleLabel.text substringToIndex:2] forState:UIControlStateNormal];
    }else{
        [self.typeBtn setTitle:self.titleLabel.text forState:UIControlStateNormal];
    }
    self.urlLabel.text = @"";
    
    NSString *postType = dataDic[@"postType"];
    if ([postType isEqualToString:@"HELP_DRIVE"]) {
        self.baseProduct = [HelpDriveProduct productWithNetWorkDictionary:dataDic];
    }
    else if ([postType isEqualToString:@"PRODUCT"]){
        self.baseProduct = [FactoryProduct productWithNetWorkDictionary:dataDic];
    }
    else if ([postType isEqualToString:@"RENT_CAR"]){
        self.baseProduct = [RentCarProduct productWithNetWorkDictionary:dataDic];
    }
}

- (void)reloadGroupLinkWithDataDic:(NSDictionary *)dataDic
{
    self.dataDic = dataDic;
    self.typeBtn.backgroundColor = ARGB_COLOR(252, 164, 41, 1);
    [self.typeBtn setTitle:@"团购" forState:UIControlStateNormal];
    self.titleLabel.text = dataDic[@"title"];
    self.timeLabel.text = dataDic[@"createdTime"];
    self.urlLabel.text = dataDic[@"url"];
    [self.urlLabel sizeToFit];
}

@end

