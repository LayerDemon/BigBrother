//
//  FDFooterView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FDFooterView.h"

@interface FDFooterView ()



- (IBAction)firstBtnPressed:(UIButton *)sender;

- (IBAction)sendBtnPressed:(UIButton *)sender;

@end

@implementation FDFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FDFooterView"
                                              owner:self
                                            options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
    }
    return self;
}

#pragma mark - 加载数据
- (void)loadWithDataDic:(NSDictionary *)dataDic
{
    [FRIENDCACHE_MANAGER getFriendDicWithUid:dataDic[@"id"] completed:^(id responseObject, NSError *error) {
        if (!error) {
            //如果是好友
            [self.firstBtn stopAnimationWithTitle:@"删除好友"];
            self.secondBtn.hidden = NO;
        }else{
            //如果不是好友
            [self.firstBtn stopAnimationWithTitle:@"添加好友"];
            self.secondBtn.hidden = YES;
        }
    }];
}

#pragma mark - 按钮方法
- (IBAction)firstBtnPressed:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"添加好友"]) {
        [self.delegate clickedAddFriendBtn:sender];
    }
    else if ([sender.titleLabel.text isEqualToString:@"删除好友"]){
        [self.delegate clickedDeleteFriendBtn:sender];
    }
}

- (IBAction)sendBtnPressed:(UIButton *)sender {
    [self.delegate clickedSendMessageBtn:sender];
}
@end
