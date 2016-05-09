//
//  UIImage+Category.h
//  BookClub
//
//  Created by 李祖建 on 15/12/15.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type;
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;
//模糊图
+ (UIImage *)getBlurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
@end
