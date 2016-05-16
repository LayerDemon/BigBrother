//
//  NewFriendsTableViewCell.h
//  BigBrother
//
//  Created by zhangyi on 16/5/10.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendsTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView       * headImageView;
@property (strong, nonatomic) UILabel           * userNameLabel;
@property (strong, nonatomic) UILabel           * remarkLabel;

@property (strong, nonatomic) UIButton          * agreeButton;
@property (strong, nonatomic) UIButton          * refuseButton;

@property (strong, nonatomic) UILabel           * stateLabel;

@end
