//
//  AppDelegate.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "EMSDK.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册环信
    //AppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
//    EMOptions *options = [EMOptions optionsWithAppkey:@"rentcarproject#rentcar"];
//    options.apnsCertName = @"";
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    //    环信
    NSMutableString *apnsCertName = [[NSMutableString alloc]init];
#if DEBUG
    apnsCertName = [NSMutableString stringWithString:@"shuxiang_dev"];
#else
    apnsCertName = [NSMutableString stringWithString:@"shuxiang_dis"];
#endif
    
    NSLog(@"%@",apnsCertName);
    //AppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"recordteam#bigbrother"];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //iOS8 注册APNS
    //    [application respondsToSelector:@selector(registerForRemoteNotifications)]
    if (SYSTEMVERSION >= 8.0) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
#endif
    }
    
    
    
    //
    ViewController *vc = [ViewController new];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Navigation_FontColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [navi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    navi.view.backgroundColor = BB_WhiteColor;
    navi.navigationBar.barTintColor = BB_NaviColor;
    navi.navigationBar.tintColor = BB_WhiteColor;
    navi.navigationBar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[EMClient sharedClient] applicationDidEnterBackground:application];
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
