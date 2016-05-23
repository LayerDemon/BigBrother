//
//  NewFriendsTableViewCell.h
//  BigBrother
//
//  Created by zhangyi on 16/5/10.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewFriendsTableViewCell;

@protocol NewFriendsTableViewCellDelegate <NSObject>

- (void)newFriendsCell:(NewFriendsTableViewCell *)cell clickedAgreeBtn:(UIButton *)sender;
- (void)newFriendsCell:(NewFriendsTableViewCell *)cell clickedRefuseBtn:(UIButton *)sender;

@end

@interface NewFriendsTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dataDic;

@property (assign, nonatomic) id<NewFriendsTableViewCellDelegate>delegate;

@property (strong, nonatomic) UIImageView       * headImageView;
@property (strong, nonatomic) UILabel           * userNameLabel;
@property (strong, nonatomic) UILabel           * remarkLabel;

@property (strong, nonatomic) UIButton          * agreeButton;
@property (strong, nonatomic) UIButton          * refuseButton;

@property (strong, nonatomic) UILabel           * stateLabel;



- (void)loadWithDataDic:(NSDictionary *)dataDic;

@end
