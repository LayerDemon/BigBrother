//
//  UnitedActivityTableViewCell.h
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitedActivityTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView       * headImageView;
@property (strong, nonatomic) UILabel           * unitedNameLabel;
@property (strong, nonatomic) UILabel           * locationLabel;
@property (strong, nonatomic) UILabel           * timeLabel;
@property (strong, nonatomic) UILabel           * joinNumLabel;

@end
