//
//  UIViewController+Category.h
//  BookClub
//
//  Created by 李祖建 on 15/11/5.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)<UIAlertViewDelegate,UIActionSheetDelegate>

//标题
- (void)setIndicatorTitle:(NSString *)title;
- (void)setMenuIndicatorTitle:(NSString *)title;//带下拉标志的标题
- (void)startTitleIndicator;
- (void)stopTitleIndicator;


//弹框
- (void)showAlertControlWithMessage:(NSString *)message;

- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                  buttonTitles:(NSArray *)buttonTitles;

- (void)showActionSheetViewWithTitle:(NSString *)title
                             message:(NSString *)message
                        buttonTitles:(NSArray *)buttonTitles;

- (void)clickedAlertButtonWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle;


@end
