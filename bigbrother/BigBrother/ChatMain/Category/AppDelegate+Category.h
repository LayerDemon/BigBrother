//
//  AppDelegate+Category.h
//  BookClub
//
//  Created by 李祖建 on 15/11/4.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Category)

//+ (void)getDeviceInfo;
//- (void)setRootViewController;
+ (void)showHintLabelWithMessage:(NSString *)message;
+ (UIViewController *)getPresentedViewController;
+ (UIViewController *)getCurrentVC;
//注册友盟推送
//+ (void)resiterUmengNotificationWithOptions:(NSDictionary *)launchOptions;
@end
