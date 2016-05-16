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

#import "EaseLocalDefine.h"

#import <UIKit/UIKit.h>
//通用类
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>//
#import "FlexibleFrame.h"//比例适配
#import "JSONKit.h"//json解析
#import "EMSDK.h"//环信
#import "EMErrorDefs.h"
#import "EaseConvertToCommonEmoticonsHelper.h"//表情映射
#import "PreviewImageViewController.h"//图片预览
#import "MJRefresh.h"//刷新
#import "EaseSDKHelper.h"//环信发送消息类
#import "ChatMessageModel.h"
//#import "MWPhoto.h"
//#import "MWPhotoBrowser.h"

#import "UIImage+UIImageExt.h"//图片压缩

#import "UIImageView+WebCache.h"//图片缓存
#import "UIButton+WebCache.h"
#import "CustomIndicatorView.h"

#import "NetworkingManager.h"
#import "JSONKit.h"
#import "UIKit+AFNetworking.h"

//延展
#import "AppDelegate+Category.h"
#import "UIButton+Category.h"
#import "UIViewController+Category.h"
#import "NSDate+Category.h"
#import "NSString+Category.h"
#import "UIView+Category.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UILabel+Category.h"
#import "UIImage+ResizeImage.h"
#import "UIImage+Category.h"
#import "NSString+Category.h"


//单例
#define WINDOW ((AppDelegate *)[UIApplication sharedApplication].delegate).window//window
#define MANAGER_CHAT [EMClient sharedClient].chatManager

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


//主题色
#define ARGB_COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]  //颜色
#define ITEM_SELECT_COLOR ARGB_COLOR(227,217,178, 1)
#define ITEM_NORMAL_COLOR ARGB_COLOR(135, 135, 135, 1)
#define BG_COLOR ARGB_COLOR(229, 229, 229, 1)
#define NAVTITLE_TINTCOLOR ARGB_COLOR(82, 82, 82, 1)
#define THEMECOLOR_LINE   ARGB_COLOR(239,240,240,1)
#define THEMECOLOR_BACK   ARGB_COLOR(240, 240, 240, 1)

//主题
#define SDProgressViewBackgroundColor ARGB_COLOR(240, 240, 240, 0.9)
#define _E3D9B2 ARGB_COLOR(227, 217, 178, 1)
#define _EEEEEE ARGB_COLOR(238, 238, 238, 1)
#define _525252 ARGB_COLOR(82, 82, 82, 1)
#define _D4D4D4 ARGB_COLOR(212, 212, 212, 1)
#define _999999 ARGB_COLOR(153, 153, 153, 1)
#define _808080 ARGB_COLOR(128, 128, 128, 1)
#define _D3D3D3 ARGB_COLOR(211, 211, 211, 1)
#define _B6B6B6 ARGB_COLOR(182, 182, 182, 1)
#define _333333 ARGB_COLOR(51, 51, 51, 1)
#define _76A4B3 ARGB_COLOR(118, 164, 179, 1)
#define _EB7527 ARGB_COLOR(235, 117, 39, 1)
#define _393A3E ARGB_COLOR(57, 58, 62, 0.9)
#define _FF7373 ARGB_COLOR(255, 115, 115, 1)
#define _D8D8D8 ARGB_COLOR(216, 216, 216, 1)
#define _DDDDDD ARGB_COLOR(221, 221, 221, 1)
#define _33B982 ARGB_COLOR(51, 185, 130, 1)
#define _F7F7F7 ARGB_COLOR(247, 247, 247, 1)

//默认图片
#define PLACEHOLDERIMAGE_USER [UIImage imageNamed:@"choujiang"]
#define PLACEHOLDERIMAGE_GROUP [UIImage imageNamed:@"choujiang"]
#define PLACEHOLER_IMA        [UIImage imageNamed:@"好看2.jpg"]
//TGA
#define LINEVIEW_TAG 500
#define TEXTFIELD_TAG 300
#define MJHEADER_TAG 700
#define MJFOOTER_TAG 800

#define INDICATORVIEW_TAG 2000
#define HINTLABEL_TAG 5000
#define PREVIEW_TAG 6000

//状态类型
#define TITLE_ALERT @"书乡提示"
#define ACTIONSTYLE_CANCEL @"-CANCLE"
#define ACTIONSTYLE_NORMAL @"-NORMAL"
#define ACTIONSTYLE_DESTRUCTIVE @"-DESTRUCTIVE"
#define ACTIONSTYLE_DISABLED @"+DISABELD"

//消息
#define MESSAGE_NOTOPENCAERA @"相机访问受限，请设置相机访问权限~\n设置- >隐私- >相机"
#define MESSAGE_NOTLOCATION @"定位需要打开定位服务~\n设置- >隐私- >定位服务"

//网络请求
#define BASE_URL @"http://121.42.161.141:8080/rent-car/api"

//假数据
#define TESTUSER_DIC @{@"authStatus":@"NOT_SUBMIT",@"authType":@"authType",@"avatar":@"http://y2.ifengimg.com/cmpp/2016/03/30/20/fdcb9b54-c0bd-46ec-974c-a2cad87c4a51_size16_w540_h303.jpg",@"balance":@(0),@"birthday":@"",@"createdTime":@"2016-05-10 09:33:40",@"districtFullName":@"",@"districtId":@"",@"gender":@"UNKNOWN",@"id":@(57),@"imNumber":@"1121",@"imPass":@"123456",@"isAdmin":@(0),@"isLocked":@(0),@"lastLoginTime":@"2016-05-10 20:26:58",@"nickname":@"1121",@"phoneNumber":@"17780526454",@"recommender":@"",@"username":@""};

#define TESTGROUP_DIC @{@"id":@(1),@"name":@"傻逼后台~",@"troduction":@"傻逼后台 脑残一个~。",@"memberCount":@(2),@"status":@"activity",@"avatar":@"http://travel.cnr.cn/list/20160330/W020160330613338597321.jpg",@"capacity":@(500),@"groupNumber":@(2001),@"chatgroupid":@"194668361525756352"}



#endif /* ChatHeader_pch_h */
