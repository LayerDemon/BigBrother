//
//  ChatMoneyTreeView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChatMoneyTreeView.h"
#import "MoneyTreeModel.h"
#import "ChatMessageModel.h"

@interface ChatMoneyTreeView ()

@property (strong, nonatomic) IBOutlet UIButton *treeBtn;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *hintBtn;

@property (strong, nonatomic) MoneyTreeModel *model;
@property (strong, nonatomic) NSDictionary *userDic;
@property (strong, nonatomic) ChatMessageModel *messageModel;

@end

@implementation ChatMoneyTreeView

- (void)dealloc
{
    [_model removeObserver:self forKeyPath:@"moneyTreeData"];
    [_model removeObserver:self forKeyPath:@"pickData"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChatMoneyTreeView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
        self.userDic = [BBUserDefaults getUserDic];
        self.canPick = NO;
    }
    return self;
}

#pragma mark - 加载数据
- (void)reloadMoneyTreeWithMessageModel:(ChatMessageModel *)messageModel
{
    self.messageModel = messageModel;
    self.createUserDic = messageModel.message.ext[@"userPojo"];
    
    [self reloadMoneyTreeWithDataDic:messageModel.message.ext[@"customPojo"]];
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
    if (totalCount < 2) {
        remainCount = totalCount;
    }
//    NSInteger count = 2 - [dataDic[@"count"] integerValue];
    if (remainCount > 0) {
        NSString *countStr = [NSString stringWithFormat:@"点击摇钱树，你还有%@次机会",@(remainCount)];
        NSMutableAttributedString *countAttriStr = [[NSMutableAttributedString alloc] initWithString:countStr];
        [countAttriStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor redColor]
                                  range:[countStr rangeOfString:[NSString stringWithFormat:@"%@",@(remainCount)]]];
        self.countLabel.attributedText = countAttriStr;
        self.hintBtn.hidden = YES;
        [self.treeBtn setBackgroundImage:[UIImage imageNamed:@"yqs03"] forState:UIControlStateNormal];
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"已领完，等下一棵长出再来吧~"];
        self.hintBtn.hidden = NO;
        [self.treeBtn setBackgroundImage:[UIImage imageNamed:@"yqs02"] forState:UIControlStateNormal];
    }
    
    
    NSString *userGender = userDic[@"gender"];
    
    if (![dataDic[@"receiveTarget"] isEqualToString:@"ALL"]) {
        if ([userGender isEqualToString:dataDic[@"receiveTarget"]]) {
//            [self.treeBtn setBackgroundImage:[UIImage getGrayImage:[UIImage imageNamed:@"yqs03"]] forState:UIControlStateNormal];
            self.hintBtn.hidden = NO;
            self.countLabel.text = @"性别不符，摇不出来哦~";
        }
    }
    
    //是否可以摇
    self.canPick = self.hintBtn.hidden;
}

#pragma mark - getter
- (MoneyTreeModel *)model
{
    if (!_model) {
        _model = [[MoneyTreeModel alloc]init];
        [_model addObserver:self forKeyPath:@"moneyTreeData" options:NSKeyValueObservingOptionNew context:nil];
        [_model addObserver:self forKeyPath:@"pickData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"moneyTreeData"]) {
        [self moneyTreeDataParse];
    }
    if ([keyPath isEqualToString:@"pickData"]) {
        [self pickDataParse];
    }
}

#pragma mark - 刷新数据源
- (void)startPickMoneyTree
{
    [self.hintBtn startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.hintBtn.hidden = NO;
    
    [self.model postPickDataWithMoneyTreeId:self.dataDic[@"id"] operator:@([self.userDic[@"id"] integerValue])];
    
}

//- (void)reloadDataSource
//{
//    [self.model postMoneyTreeDataWithMoneyTreeId:@([self.dataDic[@"id"] integerValue])];
//}

#pragma mark - 数据处理
- (void)moneyTreeDataParse
{
    [self.hintBtn stopAnimationWithTitle:@""];

    NSMutableDictionary *customPojo = [NSMutableDictionary dictionaryWithDictionary:self.model.moneyTreeData];
    NSMutableDictionary *messageExt = [NSMutableDictionary dictionaryWithDictionary:self.messageModel.message.ext];
    NSString *userJoinCountKey = [NSString stringWithFormat:@"%@_joinCount",self.userDic[@"id"]];
    NSInteger joinCount = [messageExt[@"customPojo"][userJoinCountKey] integerValue];
    NSInteger leftCount = [customPojo[@"leftCoinCount"] integerValue];
    [customPojo setObject:@(joinCount) forKey:userJoinCountKey];
    if (leftCount >= 0 && joinCount < 2) {
        [customPojo setObject:@(joinCount+1) forKey:userJoinCountKey];
    }
    
    if ([customPojo[@"id"] integerValue] == [messageExt[@"customPojo"][@"id"] integerValue]) {
        [messageExt setObject:customPojo forKey:@"customPojo"];
    }
    self.messageModel.message.ext = messageExt;
    [[EMClient sharedClient].chatManager updateMessage:self.messageModel.message];
    
    [self reloadMoneyTreeWithDataDic:customPojo];
//#warning --- 测试
//    [self testUpdateMessage];
}

- (void)pickDataParse
{
    [BYToastView showToastWithMessage:[NSString stringWithFormat:@"你使出全身力气，从摇钱树摇下%@金币",self.model.pickData[@"money"]]];
    [self.model postMoneyTreeDataWithMoneyTreeId:@([self.dataDic[@"id"] integerValue])];
}

//- (void)testUpdateMessage
//{
//    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.messageModel.message.ext];
//    NSMutableDictionary *tempCustomPojo = [NSMutableDictionary dictionaryWithDictionary:tempDic[@"customPojo"]];
//    NSString *lastMessage = tempCustomPojo[@"message"];
//    NSRange messageRange = [lastMessage rangeOfString:[NSString stringWithFormat:@"%@_",@([tempCustomPojo[@"message"] integerValue])]];
//    if (messageRange.location != NSNotFound) {
//        lastMessage = [lastMessage substringFromIndex:messageRange.length];
//    }
//    NSString *newMessage = [NSString stringWithFormat:@"%@_%@",@([tempCustomPojo[@"message"] integerValue] + 1),lastMessage];
//    [tempCustomPojo setObject:newMessage forKey:@"message"];
//    [tempDic setObject:tempCustomPojo forKey:@"customPojo"];
//    self.messageModel.message.ext = tempDic;
//    [[EMClient sharedClient].chatManager updateMessage:self.messageModel.message];
//    [self reloadMoneyTreeWithDataDic:tempCustomPojo];
//}

@end
