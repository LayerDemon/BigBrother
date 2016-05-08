//
//  ChatHeader_pch.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#ifndef ChatHeader_pch_h
#define ChatHeader_pch_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//系统版本
#define SYSTEMVERSION [UIDevice currentDevice].systemVersion.floatValue

//通用类
#import "FlexibleFrame.h"//比例适配
#import "EMSDK.h"//环信
#import "EMErrorDefs.h"
#import "ConvertToCommonEmoticonsHelper.h"//表情映射


#import "UIImageView+WebCache.h"//图片缓存
#import "UIButton+WebCache.h"


//延展
#import "NSDate+Category.h"
#import "NSString+Category.h"
#import "UIView+Category.h"


//屏幕适配
#define SXNOTFOUND 2000
#define TABBAR_H 48
#define NAVBAR_H 64

#define MAINSCRREN_B [UIScreen mainScreen].bounds
#define MAINSCRREN_W [UIScreen mainScreen].bounds.size.width
#define MAINSCRREN_H [UIScreen mainScreen].bounds.size.height

#define FLEXIBLE_FRAME(x,y,w,h) [FlexibleFrame frameFromIphone5Frame:CGRectMake(x, y, w, h)]
#define FLEFRAME(frame) [FlexibleFrame frameFromIphone5Frame:frame]

#define FLEXIBLE_NUM(num) [FlexibleFrame flexibleFloat:num]
#define FLEXIBLE_SIZE(w,h) CGSizeMake(FLEXIBLE_NUM(w),FLEXIBLE_NUM(h))
#define FLEXIBLE_CENTER(w,h) CGPointMake(FLEXIBLE_NUM(w),FLEXIBLE_NUM(h))
#define FLE_SCREEN_SIZE FLEXIBLE_FRAME(0,0,320,568)
#define FLEXIBLE_FONT(superView) [FlexibleFrame flexibleFontSizeWithSuperView:(superView)]
#define FLEXIBLE_SUBVIEW(superView) [FlexibleFrame flexibleWithSuperView:(superView)]


//默认图片
#define PLACEHOLDERIMAGE_USER [UIImage imageNamed:@"choujiang"]
#define PLACEHOLDERIMAGE_GROUP [UIImage imageNamed:@"choujiang"]

//TGA
#define LINEVIEW_TAG 500

#endif /* ChatHeader_pch_h */
