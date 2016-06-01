//
//  UserTreeHistoryViewCell.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/31.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UserTreeHistoryViewCell.h"

@interface UserTreeHistoryViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation UserTreeHistoryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserTreeHistoryViewCell" owner:self options:nil] lastObject];
        self.contentView.frame = FLEFRAME(self.contentView.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
    }
    return self;
}

#pragma mark - 加载数据
- (void)reloadWithDataDic:(NSDictionary *)dataDic
{

}

@end
