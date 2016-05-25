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
@property (strong, nonatomic) IBOutlet UISwitch *switchView;


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
        self.backgroundColor = [UIColor whiteColor];
        [self.switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
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


/**
 *  刷新群资料
 */
- (void)reloadGroupWithTitle:(NSString *)title dataDic:(NSDictionary *)dataDic
{
    self.titleLabel.text = title;
    self.detailLabel.textColor = _333333;
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.detailLabel.backgroundColor = [UIColor whiteColor];
    [self.detailLabel setHeight:self.titleLabel.frame.size.height];
    self.switchView.hidden = YES;
    [self.detailLabel setWidth:FLEXIBLE_NUM(223)];
    if ([title isEqualToString:@"他的供求信息"]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailLabel.text = @"";
    }
    else if ([title isEqualToString:@"账号"]){
        self.detailLabel.text = dataDic[@"userInfo"][@"phoneNumber"];
    }
    else if ([title isEqualToString:@"入群时间"]){
        self.detailLabel.text = dataDic[@"userInfo"][@"createdTime"];
    }
    else if ([title isEqualToString:@"职务"]){
        NSDictionary *roleDic = @{@"USER":@"群成员",
                                  @"OWNER":@"群主",
                                  @"ADMIN":@"管理员"};
        NSString *roleKey = dataDic[@"role"];
        self.detailLabel.text = [NSString isBlankStringWithString:roleDic[roleKey]] ?roleDic[@"USER"] : roleDic[roleKey];
    }
    else if ([title isEqualToString:@"成员头衔"]){
        NSDictionary *colorDic = @{@"A":ARGB_COLOR(238, 163, 59, 1),
                                   @"B":ARGB_COLOR(102, 202, 63, 1),
                                   @"C":_999999,
                                   @"D":_999999,
                                   @"E":_999999,
                                   @"F":_999999,
                                   @"G":_999999};
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.text = dataDic[@"gradeName"];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        CGSize signSize = [NSString sizeWithString:self.detailLabel.text Font:[UIFont systemFontOfSize:FLEXIBLE_NUM(13)] maxWidth:FLEXIBLE_NUM(223) NumberOfLines:0];
        [self.detailLabel setWidth:signSize.width+FLEXIBLE_NUM(6)];
        self.detailLabel.layer.cornerRadius = FLEXIBLE_NUM(2);
        self.detailLabel.layer.masksToBounds = YES;
        NSString *gradeKey = dataDic[@"grade"];
        self.detailLabel.backgroundColor = colorDic[gradeKey];
    }
    else if ([title isEqualToString:@"设置为管理员"]){
        self.switchView.hidden = NO;
        self.switchView.on = [dataDic[@"role"] isEqualToString:@"ADMIN"];
        self.detailLabel.text = @"";
    }
    else if ([title isEqualToString:@"设置禁言"]){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailLabel.text = @"";
    }
    
    [self.detailLabel setOriginX:self.contentView.frame.size.width-FLEXIBLE_NUM(8)-self.detailLabel.frame.size.width];
}

- (void)switchValueChanged:(UISwitch *)sender
{
    [self.delegate friendDetailViewCell:self didChangedSwitchValue:sender];
}

@end
