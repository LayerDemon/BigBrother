//
//  MyPostsTableViewCell.h
//  BigBrother
//
//  Created by xiaoyu on 16/3/5.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPostInfo.h"

@class MyPostsTableViewCell;
@protocol MyPostsTableViewCellDelegate <NSObject>

-(void)myPostTableCell:(MyPostsTableViewCell *)cell didTapMatchView:(UIView *)matchView;

-(void)myPostTableCell:(MyPostsTableViewCell *)cell didClickOnTopButton:(UIButton *)onTopButton;

-(void)myPostTableCell:(MyPostsTableViewCell *)cell didClickEditButton:(UIButton *)editButton;

-(void)myPostTableCell:(MyPostsTableViewCell *)cell didClickDeleteButton:(UIButton *)deleteButton;

@end

@interface MyPostsTableViewCell : UITableViewCell

@property (nonatomic,weak) id<MyPostsTableViewCellDelegate> delegate;

@property (nonatomic,strong) MyPostInfo *postInfo;

+(CGFloat)staticHeightWithPostInfo:(MyPostInfo *)postInfo;

@end
