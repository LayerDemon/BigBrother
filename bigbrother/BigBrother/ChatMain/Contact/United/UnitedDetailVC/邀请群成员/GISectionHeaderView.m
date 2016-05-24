//
//  GISectionHeaderView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "GISectionHeaderView.h"

@interface GISectionHeaderView ()

@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation GISectionHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GISectionHeaderView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)reloadWithDataDic:(NSDictionary *)dataDic
{
    self.dataDic = dataDic;
    self.iconView.image = [dataDic[@"stateValue"] integerValue] ? [UIImage imageNamed:@"icon_jt02"] : [UIImage imageNamed:@"icon_jt01"];
    self.titleLabel.text = dataDic[@"name"];
}

#pragma mark - 按钮
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.delegate clickedSectionHeaderView:self];
    }
}

@end
