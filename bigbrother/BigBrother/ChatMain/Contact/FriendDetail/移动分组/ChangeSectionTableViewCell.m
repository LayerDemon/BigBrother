
//
//  ChangeSectionTableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/6/7.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChangeSectionTableViewCell.h"

@implementation ChangeSectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _sectionNameLabel = ({
            UILabel * label = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(10, 0, 200, 40)];
            label.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
            [self.contentView addSubview:label];
            label;
        });
        
        _sectionMarkImageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(280, 10, 20, 20)];
            imageView.image = [UIImage imageNamed:@"对"];
            [self.contentView addSubview:imageView];
            imageView;
        });
    }
    return self;
}

@end
