//
//  DatePickerView.m
//  小火箭－商家
//
//  Created by zhangyi on 16/4/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()


@property (strong, nonatomic) UIView            * dateView;
@property (strong, nonatomic) UIButton          * backButton;
@property (strong, nonatomic) UILabel           * titleLabel;

@end

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface
{
    self.hidden = YES;
    _backButton = ({
        UIButton * button = [self createButtonWithTitle:@"" font:0 subView:self];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        button.alpha = 0;
        button.frame = CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H);
        [button addTarget:self action:@selector(endChooseTime) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    _dateView = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, MAINSCRREN_H, MAINSCRREN_W, FLEXIBLE_NUM(220))];
        view.backgroundColor = RGBACOLOR(239, 239, 239, 1);
        view.userInteractionEnabled = YES;
        [self addSubview:view];
        view;
    });
    
    NSArray * titleArray = [NSArray arrayWithObjects:@"取消",@"确定", nil];
    for (int j = 0; j < 2; j ++) {
        UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.userInteractionEnabled = YES;
        [sureButton setTitle:titleArray[j] forState:UIControlStateNormal];
        sureButton.frame = FLEXIBLE_FRAME(10 + 250 * j, 0, 50, 40);
        if (j == 0) {
            [sureButton addTarget:self action:@selector(endChooseTime) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [sureButton addTarget:self action:@selector(chooseTimeInDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
        }
        sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(15)];
        [sureButton setTitleColor:BB_NaviColor forState:UIControlStateNormal];
        [_dateView addSubview:sureButton];
    }
    
    UILabel * titleLabel = [self createLabelWithText:@"" font:FLEXIBLE_NUM(14) subView:_dateView];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = FLEXIBLE_FRAME(50, 0, 220, 40);
    _titleLabel = titleLabel;
    
    _datePiker = ({
        UIDatePicker * datePicker = [[UIDatePicker alloc] initWithFrame:FLEXIBLE_FRAME(0, 40, MAINSCRREN_W, 180)];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.userInteractionEnabled = YES;
        [_dateView addSubview:datePicker];
        datePicker;
    });

}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

#pragma mark -- button pressed
- (void)chooseTimeInDatePickerView:(NSDate *)date
{
    if ([_delegate respondsToSelector:@selector(chooseTimeInDatePickerView:)]) {
        [_delegate chooseTimeInDatePickerView:_datePiker.date];
    }
    [self endChooseTime];
}

- (void)beginChooseTime
{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _dateView.frame = CGRectMake(0, MAINSCRREN_H - FLEXIBLE_NUM(220), MAINSCRREN_W, FLEXIBLE_NUM(220));
        _backButton.alpha = 1;
    }];
}

- (void)endChooseTime
{
    [UIView animateWithDuration:0.2 animations:^{
         _dateView.frame = CGRectMake(0, MAINSCRREN_H, MAINSCRREN_W, FLEXIBLE_NUM(220));
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
   
}

#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    label.font = [UIFont systemFontOfSize:font];
    [subView addSubview:label];
    return label;
}

#pragma mark -- create button 
- (UIButton *)createButtonWithTitle:(NSString *)title font:(CGFloat)font subView:(UIView *)subView
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [subView addSubview:button];
    return button;
}

#pragma mark -- create view
- (UIView *)createViewWithBackColor:(UIColor *)color subView:(UIView *)subView
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = color;
    [subView addSubview:view];
    return view;
}

@end
