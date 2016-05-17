//
//  MessageView.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView

- (void)addWithSuperView:(UIView *)superView;


//刷新数据源
-(void)refreshDataSource;

#pragma mark - registerNotifications
-(void)registerNotifications;

-(void)unregisterNotifications;

@end
