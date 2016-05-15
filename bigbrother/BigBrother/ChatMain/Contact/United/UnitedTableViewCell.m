//
//  UnitedTableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedTableViewCell.h"

@implementation UnitedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(10, 7, 35, 35)];
            imageView.layer.cornerRadius = FLEXIBLE_NUM(17.5);
            imageView.clipsToBounds = YES;
            [self.contentView addSubview:imageView];
            imageView;
        });
        
        _groupNameLabel = ({
            UILabel * label = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(55, 0, 200, 50)];
            label.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
            [self.contentView addSubview:label];
            label;
        });
        
    }
    return self;
    
    
}

@end
