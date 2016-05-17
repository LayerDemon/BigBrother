//
//  FriendModel.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (strong, nonatomic, readonly) NSDictionary *friendInfoData;
@property (strong, nonatomic, readonly) NSDictionary *addData;
@property (strong, nonatomic, readonly) NSDictionary *sectionListData;

//根据手机号查询用户信息
- (void)postFriendInfoDataWithPhoneNumber:(NSNumber *)phoneNumber;

//根据手机号查询用户信息
- (void)postFriendInfoDataWithUid:(NSNumber *)uid;

//添加好友
- (void)postAddDataWithUserId:(id)userId friendId:(id)friendId message:(NSString *)message friendsGroupId:(id)friendsGroupId;

//获取全部分组
- (void)postSectionListDataWithUserId:(id)userId;
@end
