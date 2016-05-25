//
//  DatePickerView.h
//  小火箭－商家
//
//  Created by zhangyi on 16/4/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SureButtonPressedDelegate <NSObject>

- (void)chooseTimeInDatePickerView:(NSDate *)date;

@end

@interface DatePickerView : UIView

@property (assign, nonatomic)   id<SureButtonPressedDelegate>       delegate;
@property (strong, nonatomic)   UIDatePicker                        * datePiker;
@property (strong, nonatomic)   NSString                            * title;


- (void)beginChooseTime;
- (void)endChooseTime;

@end
