//
//  NewFriendModel.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HandleAction_ACCEPT @"ACCEPT"
#define HandleAction_REJECT @"REJECT"


@interface NewFriendModel : NSObject

@property (strong, nonatomic, readonly) NSDictionary *agreeData;
@property (strong, nonatomic, readonly) NSDictionary *refuseData;

/**
 *  好友请求处理
 */
- (void)postFriendHandleDataWithUserId:(NSNumber *)userId requestId:(NSNumber *)requestId action:(NSString *)action;


/**
 *  加入门派请求处理
 */
- (void)postGroupHandleDataWithAdminId:(NSNumber *)adminId requestId:(NSNumber *)requestId action:(NSString *)action;

/**
 *  门派邀请请求处理
 */
- (void)postGroupInviteHandleDataWithUserId:(NSNumber *)userId requestId:(NSNumber *)requestId action:(NSString *)action;
@end
