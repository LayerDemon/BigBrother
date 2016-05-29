//
//  ChatMoneyTreeView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "ChatMoneyTreeView.h"

@interface ChatMoneyTreeView ()

@property (strong, nonatomic) IBOutlet UIImageView *treeView;
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



@end
