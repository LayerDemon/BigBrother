//
//  GUDFooterView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/24.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "GUDFooterView.h"

@interface GUDFooterView ()



- (IBAction)addFriendBtnPressed:(UIButton *)sender;
- (IBAction)sendBtnPressed:(UIButton *)sender;
- (IBAction)deleteBtnPressed:(UIButton *)sender;

@end

@implementation GUDFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GUDFooterView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
    }
    return self;
}

- (void)reloadWithCurrentUserDic:(NSDictionary *)currentUserDic userDic:(NSDictionary *)userDic;
{
    
    if ([currentUserDic[@"id"] integerValue] == [userDic[@"id"] integerValue]) {
        self.addFriendBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.sendBtn.hidden = YES;
        return;
    }
    
    [FRIENDCACHE_MANAGER getFriendDicWithUid:currentUserDic[@"id"] completed:^(id responseObject, NSError *error) {
        if (!error) {
            self.addFriendBtn.hidden = YES;
            [self.addFriendBtn setOriginY:FLEXIBLE_NUM(37)-self.addFriendBtn.frame.size.height-FLEXIBLE_NUM(8)];
        }else{
            self.addFriendBtn.hidden = NO;
            [self.addFriendBtn setOriginY:FLEXIBLE_NUM(37)];
        }
        [self.sendBtn setOriginY:CGRectGetMaxY(self.addFriendBtn.frame)+FLEXIBLE_NUM(8)];
//        [self.deleteBtn setOriginY:CGRectGetMaxY(self.sendBtn.frame)+FLEXIBLE_NUM(6)];
        [self setHeight:CGRectGetMaxY(self.deleteBtn.frame)+FLEXIBLE_NUM(37)];
//        if ([currentUserDic[@"role"] isEqualToString:@"OWNER"]) {
//            self.deleteBtn.hidden = YES;
//        }
//        else if ([currentUserDic[@"role"] isEqualToString:@"ADMIN"]){
//            if ([userDic[@"role"] isEqualToString:@"OWNER"]) {
//                self.deleteBtn.hidden = NO;
//            }else{
//                self.deleteBtn.hidden = YES;
//            }
//        }
//        else{
//            if ([userDic[@"role"] isEqualToString:@"ADMIN"] ||
//                [userDic[@"role"] isEqualToString:@"OWNER"]) {
//                self.deleteBtn.hidden = NO;
//            }else{
//                self.deleteBtn.hidden = YES;
//            }
//        }
        
    }];
}

- (IBAction)addFriendBtnPressed:(UIButton *)sender {
    [self.delegate clickedAddFriendBtn:sender];
}

- (IBAction)sendBtnPressed:(UIButton *)sender {
    [self.delegate clickedSendMessageBtn:sender];
}

- (IBAction)deleteBtnPressed:(UIButton *)sender {
    [self.delegate clickedDeleteFriendBtn:sender];
}
@end
