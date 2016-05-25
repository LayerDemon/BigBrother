//
//  UnitedDetailViewController.h
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitedDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary      * unitedDic;

@property (assign, nonatomic) NSInteger          pushMark;      //0：代表管理或群主  1:代表普通成员

@property (strong, nonatomic) NSDictionary *userDic;
@end
