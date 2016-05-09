//
//  AppDelegate+Category.m
//  BookClub
//
//  Created by 李祖建 on 15/11/4.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "ViewController.h"
//#import "LRViewController.h"
//#import "GuideView.h"
//#import "EditMapViewController.h"

#define DEVICE_URL @"/device"

@implementation AppDelegate (Category)

//+ (void)getDeviceInfo
//{
//    id isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
//    if (!isFirst) {
//        
//        NSString *deviceSerial = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        //        NSString *deviceSerial = [UUID getUUID];
//        NSString *deviceType = @"IOS";
//        NSString *deviceModel = [UIDevice currentDevice].model;
//        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
//        NSString *resolution = [NSString stringWithFormat:@"%.0lfx%.0lf",MAINSCRREN_W,MAINSCRREN_H];
//        
//        NSDictionary *params = @{@"deviceSerial":deviceSerial,@"deviceType":deviceType,@"deviceModel":deviceModel,@"systemVersion":systemVersion,@"resolution":resolution};
//        [NetworkingManager postWithURL:DEVICE_URL params:params successAction:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//            id object = [string objectFromJSONString];
//            //            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
//            [[NSUserDefaults standardUserDefaults] setObject:object[@"deviceId"] forKey:@"deviceId"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSLog(@"%@",object);
//            
//        } failAction:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//    }
//}

//- (void)setRootViewController
//{
//    NSString *loginInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginInfo"];
//    if (!loginInfo) {
////        LRViewController *lrVC = [[LRViewController alloc]init];
////        UINavigationController *lrNC = [[UINavigationController alloc]initWithRootViewController:lrVC];
////        [lrNC.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
////        // 添加上这一句，可以去掉导航条下边的shadowImage，就可以正常显示了
////        lrNC.navigationBar.shadowImage = [[UIImage alloc] init];
////        lrNC.navigationController.navigationBar.tintColor = NAVTITLE_TINTCOLOR;
////        self.window.rootViewController = lrNC;
//    }else{
//        MainViewController *mainVC = [[MainViewController alloc]init];
//        UINavigationController *mainNC = [[UINavigationController alloc]initWithRootViewController:mainVC];
//        mainNC.navigationBar.barTintColor = ITEM_SELECT_COLOR;
//        mainNC.navigationBar.translucent = NO;
//        [mainNC.navigationBar setBackgroundImage:[[UIImage alloc]init]
//                                      forBarMetrics:UIBarMetricsDefault];
//        mainNC.navigationBar.shadowImage = [[UIImage alloc] init];
//        mainNC.navigationBar.tintColor = NAVTITLE_TINTCOLOR;
//        
//        NSDictionary *userDic = [NSDictionary userDic];
//        
//        if (!userDic[@"description"]) {
//            [mainVC selectItemWithIndex:0];
//            EditMapViewController *editVC = [[EditMapViewController alloc]init];
//            editVC.isReg = YES;
//            [mainVC.navigationController pushViewController:editVC animated:NO];
//        }
//        
//        self.window.rootViewController = mainNC;
//    }
//}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

//注册友盟推送
//+ (void)resiterUmengNotificationWithOptions:(NSDictionary *)launchOptions
//{
//    //set AppKey and AppSecret
//    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
//    {
//        //register remoteNotification types （iOS 8.0及其以上版本）
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"Accept";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"category1";//这组动作的唯一标示
//        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        
//        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
//                                                                                     categories:[NSSet setWithObject:categorys]];
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
//        
//    } else{
//        //register remoteNotification types (iOS 8.0以下)
//        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         |UIRemoteNotificationTypeSound
//         |UIRemoteNotificationTypeAlert];
//    }
//#else
//    
//    //register remoteNotification types (iOS 8.0以下)
//    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//     |UIRemoteNotificationTypeSound
//     |UIRemoteNotificationTypeAlert];
//    
//#endif
//    //for log
//    [UMessage setLogEnabled:YES];
//
//}


#pragma mark - 显示---------------------------------------------------------------------------
//消息提示~
+ (void)showHintLabelWithMessage:(NSString *)message
{
    [WINDOW endEditing:YES];
    CGSize messageSize = [NSString sizeWithString:message Font:[UIFont systemFontOfSize:FLEXIBLE_NUM(14)] maxWidth:MAINSCRREN_W-FLEXIBLE_NUM(50) NumberOfLines:0];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0,MAINSCRREN_H-FLEXIBLE_NUM(80)-TABBAR_H,messageSize.width+FLEXIBLE_NUM(30), FLEXIBLE_NUM(44))];
    lable.center = CGPointMake(MAINSCRREN_W/2,lable.center.y);
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
    lable.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    lable.layer.cornerRadius = lable.frame.size.height/2;
    lable.layer.masksToBounds = YES;
    lable.tag = HINTLABEL_TAG;
    
    UILabel *lastLabel = (UILabel *)[WINDOW viewWithTag:HINTLABEL_TAG];
    if (lastLabel) {
        lastLabel.text = [NSString stringWithFormat:@"%@",message];
        [lastLabel setWidth:messageSize.width+FLEXIBLE_NUM(30)];
        lastLabel.center = CGPointMake(MAINSCRREN_W/2,lastLabel.center.y);
    }else{
        lable.text = message;
        //动画
        [lable setOriginY:lable.frame.origin.y+FLEXIBLE_NUM(10)];
        lable.alpha = 0;
        [WINDOW addSubview:lable];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            lable.alpha = 1;
            [lable setOriginY:lable.frame.origin.y-FLEXIBLE_NUM(10)];
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.3 delay:1.5 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                lable.alpha = 0;
                [lable setOriginY:lable.frame.origin.y+FLEXIBLE_NUM(10)];
            } completion:^(BOOL finished) {
                [lable removeFromSuperview];
            }];
        }];
    }
}



//+ (void)startLoaderAnimation
//{
//    [WINDOW endEditing:YES];
//    
//}

@end
