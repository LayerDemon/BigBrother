//
//  FlexibleFrame.h
//  layer狂魔33
//
//  Created by rimi on 15/6/11.
//  Copyright (c) 2015年 zhangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FlexibleFrame : NSObject

- (CGFloat)ratio;
+ (CGFloat)flexibleFloat:(CGFloat)aFloat;
+ (CGRect)frameFromIphone5Frame:(CGRect)iphone5Frame;

+ (void)flexibleWithSuperView:(UIView *)superView;
+ (void)flexibleFontSizeWithSuperView:(UIView *)superView;
@end
