//
//  ContactModel.h
//  BigBrother
//
//  Created by zhangyi on 16/5/9.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (strong, nonatomic, readonly) id        allFriendsData;


//获取所有的好友
- (void)getAllFriendWithUserId:(NSString *)userId;

//创建门派
- (void)createUnitedWithUserId:(NSString *)userId avatar:(NSString *)avatar name:(NSString *)name introduction:(NSString *)introduction;


@end
