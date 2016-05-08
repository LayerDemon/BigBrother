//
//  PostMacthTableViewCell.h
//  BigBrother
//
//  Created by xiaoyu on 16/3/12.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPostInfo.h"

typedef NS_ENUM(NSUInteger, PostMacthTableType) {
    PostMacthTableTypeMine,
    PostMacthTableTypeOther,
    PostMacthTableTypeNeither,
};

@class PostMacthTableViewCell;
@protocol PostMacthTableViewCellDelegate <NSObject>

-(void)postMatchTableCell:(PostMacthTableViewCell *)cell didClickIgnoreButton:(UIButton *)ignoreButton;

-(void)postMatchTableCell:(PostMacthTableViewCell *)cell didClickAcceptButton:(UIButton *)accrptButton;

-(void)postMatchTableCell:(PostMacthTableViewCell *)cell didClickDetailButton:(UIButton *)detailButton;

@end

@interface PostMacthTableViewCell : UITableViewCell

@property (nonatomic,strong) MyPostInfo *postInfo;

@property (nonatomic,assign) PostMacthTableType tableType;

@property (nonatomic,weak) id<PostMacthTableViewCellDelegate> delegate;

@end
