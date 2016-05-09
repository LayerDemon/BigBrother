//
//  UIImage+Category.m
//  BookClub
//
//  Created by 李祖建 on 15/12/15.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "UIImage+Category.h"
#import <Accelerate/Accelerate.h>


@implementation UIImage (Category)

#pragma mark - 获取黑白图
+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type
{
    
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
}

+ (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

+ (UIImage *)getBlurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
//    error = vImageBoxConvolve_ARGB8888(&outBuffer,
//                                       &inBuffer,
//                                       NULL,
//                                       0,
//                                       0,
//                                       boxSize,
//                                       boxSize,
//                                       NULL,
//                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

////模糊图
//+ (UIImage *)getBlurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
//{
//    //模糊度,
//    if ((blur < 0.1f) || (blur > 2.0f)) {
//        blur = 0.5f;
//    }
//    
//    //boxSize必须大于0
//    int boxSize = (int)(blur * 100);
//    boxSize -= (boxSize % 2) + 1;
//    NSLog(@"boxSize:%i",boxSize);
//    //图像处理
//    CGImageRef img = image.CGImage;
//    //需要引入#import <Accelerate/Accelerate.h>
//    /*
//     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
//     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
//     */
//    
//    //图像缓存,输入缓存，输出缓存
//    vImage_Buffer inBuffer, outBuffer;
//    vImage_Error error;
//    //像素缓存
//    void *pixelBuffer;
//    
//    //数据源提供者，Defines an opaque type that supplies Quartz with data.
//    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
//    // provider’s data.
//    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
//    
//    //宽，高，字节/行，data
//    inBuffer.width = CGImageGetWidth(img);
//    inBuffer.height = CGImageGetHeight(img);
//    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
//    
//    //像数缓存，字节行*图片高
//    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    
//    outBuffer.data = pixelBuffer;
//    outBuffer.width = CGImageGetWidth(img);
//    outBuffer.height = CGImageGetHeight(img);
//    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    
//    
//    // 第三个中间的缓存区,抗锯齿的效果
//    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    vImage_Buffer outBuffer2;
//    outBuffer2.data = pixelBuffer2;
//    outBuffer2.width = CGImageGetWidth(img);
//    outBuffer2.height = CGImageGetHeight(img);
//    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
//    
//    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
////    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    
//    if (error) {
//        NSLog(@"error from convolution %ld", error);
//    }
//    
//    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
//    //颜色空间DeviceRGB
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
//    CGContextRef ctx = CGBitmapContextCreate(
//                                             outBuffer.data,
//                                             outBuffer.width,
//                                             outBuffer.height,
//                                             8,
//                                             outBuffer.rowBytes,
//                                             colorSpace,
//                                             CGImageGetBitmapInfo(image.CGImage));
//    
//    //根据上下文，处理过的图片，重新组件
//    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
//    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
//    
//    //clean up
//    CGContextRelease(ctx);
//    //    CGColorSpaceRelease(colorSpace);
//    
//    free(pixelBuffer);
//    free(pixelBuffer2);
//    CFRelease(inBitmapData);
//    
//    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(imageRef);
//    
//    return returnImage;
//}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor

{
    
    //image must be nonzero size
    
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f)
        return self;
    
    //boxsize must be an odd integer
    
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    
    CGImageRef imageRef = self.CGImage;
    
    vImage_Buffer buffer1, buffer2;
    
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    size_t bytes = buffer1.rowBytes * buffer1.height;
    
    buffer1.data = malloc(bytes);
    
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
        
    {
        
        //perform blur
        
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        
        void *temp = buffer1.data;
        
        buffer1.data = buffer2.data;
        
        buffer2.data = temp;
        
    }
    
    //free buffers
    
    free(buffer2.data);
    
    free(tempBuffer);
    
    //create image context from buffer
    
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
//    
//    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
//        
//    {
//        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
//        
//        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
//        
//        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
//    }
    
    //create image from context
    
    imageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    
    CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    
    free(buffer1.data);
    
    return image;
    
}

@end
