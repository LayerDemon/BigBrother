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
            [button addTarget:self action:@selector(agreeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        _refuseButton = ({
            UIButton * button = [self createButtonWithTitle:@"拒绝" font:FLEXIBLE_NUM(12) subView:self.contentView];
            [button setTitleColor:BB_NaviColor forState:UIControlStateNormal];
            button.frame = FLEXIBLE_FRAME(245, 12, 60, 26);
            button.layer.cornerRadius = FLEXIBLE_NUM(5);
            button.layer.borderColor = BB_NaviColor.CGColor;
            button.layer.borderWidth = FLEXIBLE_NUM(0.8);
            [button addTarget:self action:@selector(refuseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 加载数据
- (void)loadWithDataDic:(NSDictionary *)dataDic
{
    self.dataDic = dataDic;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLDERIMAGE_USER completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    NSDictionary *requstTypeDic = @{@"GROUP_APPLY":@"[请求加入群]",
                                    @"GROUP_INVITE":@"[邀请加入群]",
                                    @"FRIEND_APPLY":@"[申请添加好友]"};
    NSString *requestType = dataDic[@"requestType"];

    self.userNameLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"nickname"],requstTypeDic[requestType]];
    self.remarkLabel.text = dataDic[@"message"];
    
    NSString *status = dataDic[@"status"];
    self.agreeButton.hidden = ![status isEqualToString:@"NOT_HANDLED"];
    self.refuseButton.hidden = ![status isEqualToString:@"NOT_HANDLED"];
    self.stateLabel.hidden = [status isEqualToString:@"NOT_HANDLED"];
    if ([status isEqualToString:@"ACCEPTED"] ||
        [status isEqualToString:@"OTHER_ADMIN_ACCEPTED"]) {
        self.stateLabel.text = @"已同意~";
    }
    else if ([status isEqualToString:@"REJECTED"]){
        self.stateLabel.text = @"已拒绝~";
    }
    else if ([status isEqualToString:@"NOT_HANDLED"]){
        self.stateLabel.text = @"";
        if ([dataDic[@"type"] isEqualToString:@"SENT"] ||
            [dataDic[@"userId"] integerValue] == [[BBUserDefaults getUserID] integerValue]) {
            self.agreeButton.hidden = YES;
            self.refuseButton.hidden = YES;
            self.stateLabel.hidden = NO;
            self.stateLabel.text = @"待处理~";
        }
    }
    else{
        self.stateLabel.text = @"未知~";
    }
}

#pragma mark -  按钮
- (void)agreeButtonPressed:(UIButton *)sender
{
    [self.delegate newFriendsCell:self clickedAgreeBtn:sender];
}

- (void)refuseButtonPressed:(UIButton *)sender
{
    [self.delegate newFriendsCell:self clickedRefuseBtn:sender];
}

@end
