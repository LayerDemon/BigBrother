//
//  FriendDetailViewCell.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendDetailViewCell;

@protocol FriendDetailViewCellDelegate <NSObject>

- (void)friendDetailViewCell:(FriendDetailViewCell *)cell didChangedSwitchValue:(UISwitch *)switchView;

@end

@interface FriendDetailViewCell : UITableViewCell


@property (assign, nonatomic) id<FriendDetailViewCellDelegate>delegate;
@property (strong, nonatomic) NSString                  * sectionNameString;


- (void)loadWithTitle:(NSString *)title DataDic:(NSDictionary *)dataDic;


/**
 *  刷新群资料
 */
- (void)reloadGroupWithTitle:(NSString *)title dataDic:(NSDictionary *)dataDic;

@end
