//
//  UIButton+Category.m
//  BookClub
//
//  Created by 李祖建 on 15/11/13.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

- (void)startAnimationWithIndicatorView:(UIActivityIndicatorView *)indicatorView
{
    [self setTitle:@"" forState:UIControlStateNormal];
    [indicatorView startAnimating];
}

- (void)stopAnimationWithIndicatorView:(UIActivityIndicatorView *)indicatorView title:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [indicatorView stopAnimating];
}

- (void)startAnimationWithIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[CustomIndicatorView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    CustomIndicatorView *indicatorView = [[CustomIndicatorView alloc]initWithActivityIndicatorStyle:indicatorStyle];
    indicatorView.tag = INDICATORVIEW_TAG;
    indicatorView.hidesWhenStopped = YES;
    self.userInteractionEnabled = NO;
    indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
    indicatorView.tempTitle = self.titleLabel.text;
    [self setTitle:@"" forState:UIControlStateNormal];
}

- (void)stopAnimationWithTitle:(NSString *)title
{
    CustomIndicatorView *indicatorView = (CustomIndicatorView *)[self viewWithTag:INDICATORVIEW_TAG];
    [indicatorView stopAnimating];
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }else{
        [self setTitle:indicatorView.tempTitle forState:UIControlStateNormal];
        if (self.selected) {
            [self setTitle:indicatorView.tempTitle forState:UIControlStateSelected];
        }
    }
    [indicatorView removeFromSuperview];
    self.userInteractionEnabled = YES;
}


- (BOOL)isStartIndicator
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[CustomIndicatorView class]]) {
            return YES;
            break;
        }
    }
    return NO;
}
@end
