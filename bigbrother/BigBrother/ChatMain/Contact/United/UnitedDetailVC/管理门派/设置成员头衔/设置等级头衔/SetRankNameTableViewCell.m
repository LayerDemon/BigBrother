//
//  SetRankNameTableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/5/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SetRankNameTableViewCell.h"

@implementation SetRankNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rankLabel = ({
            UILabel * label = [self createLabelWithText:@"A级" font:FLEXIBLE_NUM(13) subView:self.contentView];
            label.frame = FLEXIBLE_FRAME(15, 0, 100, 40);
            label;
        });
        
        _rankNameLael = ({
            UILabel * label = [self createLabelWithText:@"尊上" font:FLEXIBLE_NUM(13) subView:self.contentView];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.clipsToBounds = YES;
            label.backgroundColor = ARGB_COLOR(196, 196, 196, 1);
            label.frame = FLEXIBLE_FRAME(265, 11, 35, 18);
            label.layer.cornerRadius = FLEXIBLE_NUM(2);
            label.layer.borderWidth = 0;
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
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
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

@end
