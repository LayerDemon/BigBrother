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

@property (strong, nonatomic) IBOutlet UIButton *moneyTreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *supplyLinkBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupBuyLinkBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupActivityBtn;
@property (strong, nonatomic) IBOutlet UILabel *groupActivityLabel;

@end
