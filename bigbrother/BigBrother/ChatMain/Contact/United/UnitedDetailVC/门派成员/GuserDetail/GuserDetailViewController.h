//
//  GuserDetailViewController.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/24.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuserDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *groupDic;
@property (strong, nonatomic) NSDictionary *currentUserDic;
@property (strong, nonatomic) NSDictionary *userDic;
@property (assign, nonatomic) BOOL isChatPush;//是否是chatpush过来的。

@end
