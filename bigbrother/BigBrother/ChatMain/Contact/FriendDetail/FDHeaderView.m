//
//  FDHeaderView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FDHeaderView.h"

@interface FDHeaderView ()

@property (strong, nonatomic) IBOutlet UIButton *headBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation FDHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FDHeaderView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        self.autoresizesSubviews = NO;
        FLEXIBLE_FONT(self);
    }
    return self;
}

#pragma mark - 加载数据
- (void)loadWithDataDic:(NSDictionary *)dataDic
{
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"avatar"]]] forState:UIControlStateNormal];
    self.nameLabel.text = dataDic[@"nickname"];
    self.numberLabel.text = dataDic[@"phoneNumber"];
}

@end
