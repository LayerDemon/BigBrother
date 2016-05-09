//
//  ChatFrameModel.h
//  BookClub
//
//  Created by 李祖建 on 16/2/29.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChatMessageModel.h"

#define textPadding FLEXIBLE_NUM(8)

@interface ChatFrameModel : NSObject

@property (nonatomic, strong) ChatMessageModel *messageModel;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect nameFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGRect indicatorFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
