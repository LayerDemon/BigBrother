//
//  ChatMoneyTreeView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChatMoneyTreeView.h"

@interface ChatMoneyTreeView ()

@property (strong, nonatomic) IBOutlet UIButton *treeBtn;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation ChatMoneyTreeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChatMoneyTreeView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
    }
    return self;
}

- (void)reloadMoneyTreeWithDataDic:(NSDictionary *)dataDic
{
    NSDictionary *userDic = [BBUserDefaults getUserDic];
    self.dataDic = dataDic;
    self.contentLabel.text = dataDic[@"message"];
    NSInteger totalCount = [dataDic[@"leftCoinCount"] integerValue] > 2 ? 2 : [dataDic[@"leftCoinCount"] integerValue];
    NSString *userJoinCountKey = [NSString stringWithFormat:@"%@_joinCount",userDic[@"id"]];
    NSInteger joinCount = [dataDic[userJoinCountKey] integerValue];
    NSInteger remainCount = totalCount - joinCount;
//    NSInteger count = 2 - [dataDic[@"count"] integerValue];
    
    if (remainCount > 0) {
        NSString *countStr = [NSString stringWithFormat:@"点击摇钱树，你还有%@次机会",@(remainCount)];
        NSMutableAttributedString *countAttriStr = [[NSMutableAttributedString alloc] initWithString:countStr];
        [countAttriStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor redColor]
                                  range:[countStr rangeOfString:[NSString stringWithFormat:@"%@",@(remainCount)]]];
        self.countLabel.attributedText = countAttriStr;
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"已领完，等下一棵长出再来吧~"];
        [self.treeBtn setBackgroundImage:[UIImage getGrayImage:[UIImage imageNamed:@"yqs03"]] forState:UIControlStateNormal];
    }
    
    
    NSString *userGender = userDic[@"gender"];
    
    if (![dataDic[@"receiveTarget"] isEqualToString:@"ALL"]) {
        if ([userGender isEqualToString:dataDic[@"receiveTarget"]]) {
            [self.treeBtn setBackgroundImage:[UIImage getGrayImage:[UIImage imageNamed:@"yqs03"]] forState:UIControlStateNormal];
            self.countLabel.text = @"性别不符，摇不出来哦~";
        }
    }
    
}

@end
