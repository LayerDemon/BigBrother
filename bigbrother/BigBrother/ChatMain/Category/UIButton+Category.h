//
//  UIButton+Category.h
//  BookClub
//
//  Created by 李祖建 on 15/11/13.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)


- (void)startAnimationWithIndicatorView:(UIActivityIndicatorView *)indicatorView;
- (void)stopAnimationWithIndicatorView:(UIActivityIndicatorView *)indicatorView title:(NSString *)title;
- (void)startAnimationWithIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle;
- (void)stopAnimationWithTitle:(NSString *)title;

- (BOOL)isStartIndicator;
@end
