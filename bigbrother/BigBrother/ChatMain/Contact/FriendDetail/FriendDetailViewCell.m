//
//  FriendDetailViewCell.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FriendDetailViewCell.h"

@interface FriendDetailViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation FriendDetailViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FriendDetailViewCell" owner:self options:nil] lastObject];
        self.contentView.frame = FLEFRAME(self.contentView.frame);
        self.contentView.autoresizesSubviews = NO;
        FLEXIBLE_FONT(self);
    }
    return self;
}

#pragma makr - 加载数据
- (void)loadWithTitle:(NSString *)title DataDic:(NSDictionary *)dataDic
{
    self.titleLabel.text = title;
    self.detailLabel.textColor = _333333;
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.accessoryType = UITableViewCellAccessoryNone;
    [self.detailLabel setHeight:self.titleLabel.frame.size.height];
    if ([title isEqualToString:@"他的供求信息"]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailLabel.text = @"";
    }
    else if ([title isEqualToString:@"地区"]){
        self.detailLabel.text = [NSString isBlankStringWithString:dataDic[@"districtFullName"]] ? @"" : [NSString stringWithFormat:@"%@",dataDic[@"districtFullName"]];
        self.detailLabel.textColor = _B6B6B6;
    }
    else if ([title isEqualToString:@"性别"]){
        NSString *genderStr = dataDic[@"gender"];
        self.detailLabel.text = [genderStr isEqualToString:@"FMALE"] ? @"男" : ([genderStr isEqualToString:@"MALE"] ? @"女" : @"未知");
    }
    else if ([title isEqualToString:@"个性签名"]){
        NSString *signStr = [NSString isBlankStringWithString:dataDic[@"sign"]] ? @"" : [NSString stringWithFormat:@"%@",dataDic[@"sign"]];
        CGSize signSize = [NSString sizeWithString:signStr Font:[UIFont systemFontOfSize:FLEXIBLE_NUM(13)] maxWidth:FLEXIBLE_NUM(223) NumberOfLines:0];
        if (signSize.height > self.detailLabel.frame.size.height) {
            self.detailLabel.textAlignment = NSTextAlignmentLeft;
            [self.detailLabel setHeight:signSize.height];
        }
        self.detailLabel.text = signStr;
    }else{
        self.detailLabel.text = @"";
    }
    [self setHeight:CGRectGetMaxY(self.detailLabel.frame)+self.detailLabel.frame.origin.y];
}

@end
