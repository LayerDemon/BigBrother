//
//  UTHTopView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/31.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UTHTopView.h"

@interface UTHTopView ()


@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *pickCountLabel;



@end

@implementation UTHTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UTHTopView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
        self.headImgView.layer.cornerRadius = self.headImgView.frame.size.height/2;
        self.headImgView.layer.masksToBounds = YES;
        
        
    }
    return self;
}

#pragma mark - 加载数据
- (void)reloadWithDataDic:(NSDictionary *)dataDic
{
    NSDictionary *userDic = [BBUserDefaults getUserDic];
    NSString *urlStr = [NSString isBlankStringWithString:userDic[@"avatar"]] ? @"" : userDic[@"avatar"];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:PLACEHOLDERIMAGE_USER completed:nil];
    self.nameLabel.text = userDic[@"nickname"];
    if (self.lastBtn.tag-BUTTON_TAG == 0) {
        [self reloadPickHistoryWithDataDic:dataDic];
    }else{
        [self reloadPlanHistoryWithDataDic:dataDic];
    }
}

- (void)reloadPickHistoryWithDataDic:(NSDictionary *)dataDic
{
    NSString *moneyCountStr = [NSString stringWithFormat:@"%@点",dataDic[@"userMoneySum"]];
    NSMutableAttributedString *moneyAttriStr = [[NSMutableAttributedString alloc] initWithString:moneyCountStr];
    [moneyAttriStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:FLEXIBLE_NUM(20)]
                          range:[moneyCountStr rangeOfString:@"点"]];
    self.moneyCountLabel.attributedText = moneyAttriStr;
    
    self.pickCountLabel.text = [NSString stringWithFormat:@"共摇到钱币：%@次",dataDic[@"pageResult"][@"totalElements"]];
}

- (void)reloadPlanHistoryWithDataDic:(NSDictionary *)dataDic
{
    NSString *moneyCountStr = [NSString stringWithFormat:@"%@点",dataDic[@"userMoneySum"]];
    NSMutableAttributedString *moneyAttriStr = [[NSMutableAttributedString alloc] initWithString:moneyCountStr];
    [moneyAttriStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:FLEXIBLE_NUM(20)]
                          range:[moneyCountStr rangeOfString:@"点"]];
    self.moneyCountLabel.attributedText = moneyAttriStr;
    self.pickCountLabel.text = [NSString stringWithFormat:@"种下摇钱树：%@棵",dataDic[@"pageResult"][@"totalElements"]];
}

#pragma mark - 按钮方法
- (IBAction)topBtnPressed:(UIButton *)sender {
    if (self.lastBtn != sender) {
        self.lastBtn.selected = NO;
        sender.selected = YES;
        self.lastBtn = sender;
        [UIView animateWithDuration:0.2 animations:^{
            self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
        } completion:^(BOOL finished) {
            
        }];
        [self.delegate topView:self clickedTopBtn:sender];
    }
}
@end
