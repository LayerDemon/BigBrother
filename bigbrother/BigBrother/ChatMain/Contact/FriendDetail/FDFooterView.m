//
//  FDFooterView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FDFooterView.h"

@interface FDFooterView ()

@property (strong, nonatomic) IBOutlet UIButton *firstBtn;

@property (strong, nonatomic) IBOutlet UIButton *secondBtn;

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
    //如果是好友
    [self.firstBtn stopAnimationWithTitle:@"删除好友"];
//    [self.firstBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    self.secondBtn.hidden = NO;
    //如果不是好友
    [self.firstBtn stopAnimationWithTitle:@"添加好友"];
//    [self.firstBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    self.secondBtn.hidden = YES;
}

@end
