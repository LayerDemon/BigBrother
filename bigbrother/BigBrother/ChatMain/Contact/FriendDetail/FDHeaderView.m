//
//  FDHeaderView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FDHeaderView.h"

@interface FDHeaderView ()

@property (strong, nonatomic) IBOutlet UIButton *headBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *topSummaryLabel;


@end

@implementation FDHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FDHeaderView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        self.autoresizesSubviews = NO;
        FLEXIBLE_FONT(self);
    }
    return self;
}

#pragma mark - 加载数据
- (void)loadWithDataDic:(NSDictionary *)dataDic
{
    self.topSummaryLabel.hidden = YES;
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"avatar"]]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE_USER completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.nameLabel.text = dataDic[@"nickname"];
    self.numberLabel.text = dataDic[@"phoneNumber"];
}

- (void)reloadGroupWithDataDic:(NSDictionary *)dataDic
{
    self.topSummaryLabel.hidden = NO;
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"avatar"]]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE_USER completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.nameLabel.text = dataDic[@"nickname"];
    //性别
    NSString *genderStr = @"未知";
    if (![NSString isBlankStringWithString:dataDic[@"gender"]]) {
        genderStr = [dataDic[@"gender"] isEqualToString:@"FMALE"] ? @"男" : ([genderStr isEqualToString:@"MALE"] ? @"女" : @"未知");
    }
    //地址
    NSString *addrStr = [NSString isBlankStringWithString:dataDic[@"districtFullName"]] ? @"" : [NSString stringWithFormat:@"%@",dataDic[@"districtFullName"]];
    
    self.topSummaryLabel.text = [NSString stringWithFormat:@"%@    %@",genderStr,addrStr];
    
    //等级
    NSString *levelStr = [NSString stringWithFormat:@"等级：%@级",@([dataDic[@"level"] integerValue])];
    //经验
    NSString *expStr = [NSString stringWithFormat:@"经验：%@",@([dataDic[@"exp"] integerValue])];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@   %@",levelStr,expStr];
}

@end
