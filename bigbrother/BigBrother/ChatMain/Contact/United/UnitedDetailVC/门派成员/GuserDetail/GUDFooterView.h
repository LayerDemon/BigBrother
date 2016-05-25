//
//  GUDFooterView.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/24.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GUDFooterViewDelegate <NSObject>

- (void)clickedAddFriendBtn:(UIButton *)sender;
- (void)clickedDeleteFriendBtn:(UIButton *)sender;
- (void)clickedSendMessageBtn:(UIButton *)sender;

@end

@interface GUDFooterView : UIView

@property (assign, nonatomic) id<GUDFooterViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *addFriendBtn;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

- (void)reloadWithCurrentUserDic:(NSDictionary *)currentUserDic userDic:(NSDictionary *)userDic;
@end
