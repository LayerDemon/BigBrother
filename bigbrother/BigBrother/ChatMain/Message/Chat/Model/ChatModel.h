//
//  ChatModel.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (strong, nonatomic, readonly) NSDictionary *supplyLinkData;

/**
 *  获取我发布的信息
 *
 *  @param supplyDemandType 供需类型，ASK和PROVIDE//供应或需求
 *  @param creator          用户id
 *  @param status           状态，有FINISHED已结束，NOT_AUDITED未审核，AUDIT_PASSED审核通过。
 */
- (void)getSupplyLinkDataWithSupplyDemandType:(NSString *)supplyDemandType creator:(NSString *)creator status:(NSString *)status page:(NSInteger)page pageSize:(NSInteger)pageSize;

@end
