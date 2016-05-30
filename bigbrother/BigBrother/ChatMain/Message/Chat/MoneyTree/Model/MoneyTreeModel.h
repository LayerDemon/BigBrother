//
//  MoneyTreeModel.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyTreeModel : NSObject

@property (strong, nonatomic, readonly) NSDictionary *createData;

/**
 *  创建摇钱树
 */
- (void)getCreateDataWithGoldCoinCount:(NSInteger)goldCoinCount sum:(NSInteger)sum receiveTarget:(NSString *)receiveTarget message:(NSString *)message creator:(NSNumber *)creator groupId:(NSNumber *)groupId;

@end
