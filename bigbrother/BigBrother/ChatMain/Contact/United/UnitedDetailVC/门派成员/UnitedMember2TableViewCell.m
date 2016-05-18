//
//  UnitedMember2TableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/5/18.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedMember2TableViewCell.h"

@implementation UnitedMember2TableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(10, 7, 35, 35)];
            imageView.layer.cornerRadius = FLEXIBLE_NUM(17.5);
            imageView.backgroundColor = [UIColor yellowColor];
            imageView.clipsToBounds = YES;
            [self.contentView addSubview:imageView];
            imageView;
        });
        
        _statusLabel = ({
            UILabel * label = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(55, 17, 28, 14)];
            label.layer.cornerRadius = FLEXIBLE_NUM(3);
            label.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(10)];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.clipsToBounds = YES;
            [self.contentView addSubview:label];
            label;
        });
        
        _userNameLabel = ({
            UILabel * label = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(88, 0, 200, 50)];
            label.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
            [self.contentView addSubview:label];
            label;
        });
        
    }
    return self;
    
    
}
@end
