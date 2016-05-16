//
//  AddFriendTableViewCell.m
//  BigBrother
//
//  Created by zhangyi on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "AddFriendTableViewCell.h"

@implementation AddFriendTableViewCell


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
        
        _statusLabel = ({
            UILabel * label = [self createLabelWithText:@"[离线]" font:FLEXIBLE_NUM(12) subView:self.contentView];
            label.frame = FLEXIBLE_FRAME(50, 25, 150, 17);
            label.textColor = [UIColor grayColor];
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
