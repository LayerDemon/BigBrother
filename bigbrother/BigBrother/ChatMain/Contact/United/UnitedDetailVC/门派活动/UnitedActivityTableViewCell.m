//
//  UnitedActivityTableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedActivityTableViewCell.h"

@implementation UnitedActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(10, 10, 70, 95)];
            imageView.clipsToBounds = YES;
            [self.contentView addSubview:imageView];
            imageView;
        });
        
        _unitedNameLabel = ({
            UILabel * label = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(90, 0, 210, 50)];
            label.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
            [self.contentView addSubview:label];
            label;
        });
        
        NSArray * imageArray = [[NSArray alloc] initWithObjects:@"icon_wz02",@"icon_time2",@"icon_user01", nil];
        for (int i = 0; i < 3; i ++) {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[i]]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = FLEXIBLE_FRAME(90, 50 + 20 * i, 10, 10);
            [self.contentView addSubview:imageView];
            
            UILabel * contentLabel = [[UILabel alloc] initWithFrame:FLEXIBLE_FRAME(105, 45 + 20 * i, 225, 20)];
            contentLabel.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(10)];
            contentLabel.textColor = [UIColor grayColor];
            [self.contentView addSubview:contentLabel];
            if (i == 0) {
                _locationLabel = contentLabel;
            }else if (i == 1){
                _timeLabel = contentLabel;
            }else{
                _joinNumLabel = contentLabel;
            }
        }
        
    }
    return self;
    
    
}
@end
