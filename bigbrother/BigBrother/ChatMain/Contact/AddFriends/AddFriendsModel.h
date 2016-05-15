//
//  AddFriendsModel.h
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFriendsModel : NSObject

@property (strong, nonatomic, readonly) id      searchFriendsData;
@property (strong, nonatomic, readonly) id      searchGroupsData;


//获取所有的好友
- (void)searchFriendsWithTerms:(NSString *)terms;
//搜索门派
- (void)searchGroupsWithTerms:(NSString *)terms;


@end
