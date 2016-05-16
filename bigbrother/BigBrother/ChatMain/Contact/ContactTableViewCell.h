//
//  ContactTableViewCell.h
//  BigBrother
//
//  Created by zhangyi on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView       * headImageView;
@property (strong, nonatomic) UILabel           * userNameLabel;
@property (strong, nonatomic) UILabel           * statusLabel;

@property (strong, nonatomic) NSDictionary *dataDic;

@end
