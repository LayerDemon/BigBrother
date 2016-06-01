//
//  CashCowTableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CashCowTableViewCell.h"

@implementation CashCowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(20, 16, 34, 34)];
            imageView.image = [UIImage imageNamed:@"好看2.jpg"];
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = FLEXIBLE_NUM(17);
            [self.contentView addSubview:imageView];
            imageView;
        });
        
        _userNameLabel = ({
            UILabel * label = [self createLabelWithText:@"走油咖喱锅" font:FLEXIBLE_NUM(12) subView:self.contentView];
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
            label.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(12)];
            label.frame = FLEXIBLE_FRAME(60, 10, 150, 30);
            label;
        });
      
        
        _timeLabel = ({
            UILabel * label = [self createLabelWithText:@"12月12日 12:21" font:FLEXIBLE_NUM(12) subView:self.contentView];
            label.textColor = [UIColor grayColor];
            label.frame = FLEXIBLE_FRAME(60, 30, 150, 30);
            label;
        });
        
        _numLabel = ({
            UILabel * label = [self createLabelWithText:@"10点" font:FLEXIBLE_NUM(12) subView:self.contentView];
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
            label.frame = FLEXIBLE_FRAME(260, 10, 50, 30);
            label;
        });
    }
    return self;
}
#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    label.font = [UIFont systemFontOfSize:font];
    [subView addSubview:label];
    return label;
}

#pragma mark -- create button 
- (UIButton *)createButtonWithTitle:(NSString *)title font:(CGFloat)font subView:(UIView *)subView
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [subView addSubview:button];
    return button;
}

#pragma mark -- create view
- (UIView *)createViewWithBackColor:(UIColor *)color subView:(UIView *)subView
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = color;
    [subView addSubview:view];
    return view;
}

#pragma mark - 加载数据
- (void)reloadWithDataDic:(NSDictionary *)dataDic
{

}

@end
