//
//  UIView+Category.h
//  BookClub
//
//  Created by 李祖建 on 15/11/27.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

- (void)setOriginY:(CGFloat)originy;

- (void)setOriginX:(CGFloat)originX;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setFlexibleOriginY:(CGFloat)originY;//适配4s的Y

- (UIViewController*)viewController;

//界面转换图片（截图）
-(UIImage *)convertViewToImageWithFrame:(CGRect)frame;
- (UIImage *)screenshotWithRect:(CGRect)rect;

/**
 *  tableView空白页
 *
 *  @param image            图片
 *  @param rowCount         数据数量
 *  @param maxFrame         最大位置
 *  @param normalFooterView 普通样式
 *
 *  @return 返回空白页
 */
+ (UIView *)tableViewDisplayWithBlankImage:(UIImage *)image ifNecessaryForRowCount:(NSUInteger)rowCount maxFrame:(CGRect)maxFrame normalFooterView:(UIView *)normalFooterView;
@end
