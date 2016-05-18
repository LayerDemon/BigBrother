//
//  ChatMoreInputView.h
//  BookClub
//
//  Created by 李祖建 on 16/2/26.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatMoreInputViewDelegate <NSObject>

- (void)clickedMoneyTreeBtn:(UIButton *)sender;
- (void)clickedSupplyLinkBtn:(UIButton *)sender;
- (void)clickedGroupBuyLinkBtn:(UIButton *)sender;
- (void)clickedGroupActivityBtn:(UIButton *)sender;

@end

@interface ChatMoreInputView : UIView

@property (assign, nonatomic) id<ChatMoreInputViewDelegate>delegate;

@end
