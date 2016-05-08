//
//  UIView+Category.m
//  BookClub
//
//  Created by 李祖建 on 15/11/27.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (void)setOriginY:(CGFloat)originy
{
    self.frame = CGRectMake(self.frame.origin.x,originy,self.frame.size.width, self.frame.size.height);
}

- (void)setOriginX:(CGFloat)originX
{
    self.frame = CGRectMake(originX,self.frame.origin.y,self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,width,self.frame.size.height);
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setFlexibleOriginY:(CGFloat)originY
{
    CGFloat scale = 1;
    if (MAINSCRREN_H <= 480) {
        scale = MAINSCRREN_H/568.0;
    }
    
    self.frame = CGRectMake(self.frame.origin.x,originY*scale,self.frame.size.width, self.frame.size.height);
}


//界面转换图片（截图）
-(UIImage *)convertViewToImageWithFrame:(CGRect)frame
{
    
//    UIGraphicsBeginImageContext(CGSizeMake(0,0));
////
//    [self drawViewHierarchyInRect:CGRectMake(0, 0, 10, 10) afterScreenUpdates:YES];
//
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return image;
    
    UIImage *img;

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
//    if () {
//
//
//    } else {
//        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//        img = UIGraphicsGetImageFromCurrentImageContext();
//    }

    UIGraphicsEndImageContext();
    return img;
}


- (UIImage *)screenshot
{
    return [self screenshotWithRect:self.bounds];
}

- (UIImage *)screenshotWithRect:(CGRect)rect;
{
    
    if (rect.origin.y+rect.size.height > self.frame.size.height) {
        rect.origin.y = self.frame.size.height-rect.size.height;
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        return nil;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    //[self layoutIfNeeded];
    
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else
    {
        [self.layer renderInContext:context];
    }
    
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    //    image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
    
    return image;
}


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
+ (UIView *)tableViewDisplayWithBlankImage:(UIImage *)image ifNecessaryForRowCount:(NSUInteger)rowCount maxFrame:(CGRect)maxFrame normalFooterView:(UIView *)normalFooterView
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *footerView = [[UIView alloc]initWithFrame:maxFrame];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat scale = footerView.frame.size.width/image.size.width;
        CGFloat width = footerView.frame.size.width;
        CGFloat height = image.size.height*scale;
        if (height > footerView.frame.size.height/3*2) {
            CGFloat newScale = (footerView.frame.size.height/3*2)/image.size.height;
            width = image.size.width*newScale;
            height = footerView.frame.size.height/3*2;
        }
        
        imageView.frame = CGRectMake(0, 0,width,height);
        imageView.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
        //        imageView.image = image;
        [footerView addSubview:imageView];
        return footerView;
    }
    if (!normalFooterView) {
        return [[UIView alloc]init];
    }
    return normalFooterView;
}

@end
