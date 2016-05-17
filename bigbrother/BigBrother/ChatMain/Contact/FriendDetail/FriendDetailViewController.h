//
//  FriendDetailViewController.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDHeaderView.h"
#import "FriendDetailViewCell.h"
#import "FDFooterView.h"
#import "FriendModel.h"

@interface FriendDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *currentUserDic;
@property (assign, nonatomic) BOOL isChatPush;//是否是chatpush过来的。

@end
