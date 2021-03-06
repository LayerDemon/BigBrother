//
//  UnitedTableViewCell.h
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnitedTableViewCell;

@protocol UnitedTableViewCellDelegate <NSObject>

- (void)unitedTableViewCell:(UnitedTableViewCell *)cell clickedHeadImageView:(UIImageView *)imageView;

@end

@interface UnitedTableViewCell : UITableViewCell

@property (assign, nonatomic) id<UnitedTableViewCellDelegate>delegate;

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) UIImageView       * headImageView;
@property (strong, nonatomic) UILabel           * groupNameLabel;


@end
