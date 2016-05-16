//
//  NewFriendsTableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/5/10.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "NewFriendsTableViewCell.h"

@implementation NewFriendsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:FLEXIBLE_FRAME(10, 5, 34, 34)];
            imageView.image = [UIImage imageNamed:@"好看2.jpg"];
            imageView.layer.cornerRadius = FLEXIBLE_NUM(17);
            imageView.clipsToBounds = YES;
            [self.contentView addSubview:imageView];
            imageView;
        });
        
        _userNameLabel = ({
            UILabel * label = [self createLabelWithText:@"旧梦之翼" font:FLEXIBLE_NUM(14) subView:self.contentView];
            label.frame = FLEXIBLE_FRAME(50, 0, 150, 30);
            label.textColor = [UIColor blackColor];
            label;
        });
        
        _remarkLabel = ({
            UILabel * label = [self createLabelWithText:@"我是康康，请加我" font:FLEXIBLE_NUM(12) subView:self.contentView];
            label.frame = FLEXIBLE_FRAME(50, 25, 150, 17);
            label.textColor = [UIColor grayColor];
            label;
        });
        
        _agreeButton = ({
            UIButton * button = [self createButtonWithTitle:@"同意" font:FLEXIBLE_NUM(12) subView:self.contentView];
            [button setTitleColor:BB_NaviColor forState:UIControlStateNormal];
            button.frame = FLEXIBLE_FRAME(180, 12, 60, 26);
            button.layer.cornerRadius = FLEXIBLE_NUM(5);
            button.layer.borderColor = BB_NaviColor.CGColor;
            button.layer.borderWidth = FLEXIBLE_NUM(1);
            button;
        });
        _refuseButton = ({
            UIButton * button = [self createButtonWithTitle:@"拒绝" font:FLEXIBLE_NUM(12) subView:self.contentView];
            [button setTitleColor:BB_NaviColor forState:UIControlStateNormal];
            button.frame = FLEXIBLE_FRAME(245, 12, 60, 26);
            button.layer.cornerRadius = FLEXIBLE_NUM(5);
            button.layer.borderColor = BB_NaviColor.CGColor;
            button.layer.borderWidth = FLEXIBLE_NUM(0.8);
            button;
        });
        _stateLabel = ({
            UILabel * label = [self createLabelWithText:@"已拒绝" font:FLEXIBLE_NUM(12) subView:self.contentView];
            label.hidden = YES;
            label.frame = FLEXIBLE_FRAME(260, 0, 50, 50);
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

@end
