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

//根据手机号查询用户信息
- (void)getFriendInfoDataWithPhoneNumber:(NSNumber *)phoneNumber;

//根据手机号查询用户信息
- (void)getFriendInfoDataWithUid:(NSNumber *)uid;

@end
