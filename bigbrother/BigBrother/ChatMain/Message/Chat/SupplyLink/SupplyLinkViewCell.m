//
//  SupplyLinkViewCell.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/19.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SupplyLinkViewCell.h"

@interface SupplyLinkViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SupplyLinkViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        FLEXIBLE_FONT(self);
    }
    return self;
}

#pragma mark - 加载数据
- (void)reloadWithDataDic:(NSDictionary *)dataDic
{
    self.dataDic = dataDic;
    self.titleLabel.text = dataDic[@"title"];
    self.timeLabel.text = dataDic[@"createdTime"];
}

#pragma mark - 按钮方法
- (IBAction)sendBtnPressed:(UIButton *)sender {
    [self.delegate supplyLinkViewCell:self clickedSendBtn:sender];
}
@end
