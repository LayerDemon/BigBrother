//
//  UnitedMember2TableViewCell.h
//  BigBrother
//
//  Created by zhangyi on 16/5/18.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitedMember2TableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) UIImageView       * headImageView;
@property (strong, nonatomic) UILabel           * statusLabel;
@property (strong, nonatomic) UILabel           * userNameLabel;


@end
