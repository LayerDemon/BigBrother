//
//  PopUpSelectedView.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopUpSelectedView : NSObject

//单选
+(void)showFilterSingleChooseViewWithArray:(NSArray *)array withTitle:(NSString *)title target:(id)target labelTapAction:(SEL)selector;
//支持多选
+(void)showFilterMutitypeChooseViewWithArray:(NSArray *)array withTitle:(NSString *)title normalTextColor:(UIColor *)normalColor selectedTextColor:(UIColor *)selectColor doneButtonBlock:(void(^)(NSArray *selectedIndexArray))block;

+(void)dismissFilterChooseView;

@end
