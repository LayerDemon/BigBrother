//
//  FChatViewController.m
//  BookClub
//
//  Created by 李祖建 on 15/11/16.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//
#import "UIImage+ResizeImage.h"

@implementation UIImage (ResizeImage)

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH,imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
}

@end
