//
//  PopUpSelectedView.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "PopUpSelectedView.h"

@implementation PopUpSelectedView

static UIButton *XY_pusv_filterChooseWholeButton;
static UIView *XY_pusv_filterChooseContentView;
static UIScrollView *XY_pusv_filterChooseScrollView;
static UILabel *XY_pusv_filterChooseViewTitleLabel;
static UIButton *XY_pusv_filterChooseCancelButton;
static UIView *XY_pusv_filterChooseSepLineView;
+(void)showFilterSingleChooseViewWithArray:(NSArray *)array withTitle:(NSString *)title target:(id)target labelTapAction:(SEL)selector{
    if (!XY_pusv_filterChooseWholeButton) {
        XY_pusv_filterChooseWholeButton = [[UIButton alloc] init];
        XY_pusv_filterChooseWholeButton.backgroundColor = RGBAColor(50, 50, 50, 0.8);
        XY_pusv_filterChooseWholeButton.frame = (CGRect){0,0,GLOBALWIDTH,GLOBALHEIGHT};
        [XY_pusv_filterChooseWholeButton addTarget:self action:@selector(XY_pusv_filterChooseWholeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        XY_pusv_filterChooseContentView = [[UIView alloc] init];
        XY_pusv_filterChooseContentView.frame = (CGRect){20,30,WIDTH(XY_pusv_filterChooseWholeButton)-20*2,HEIGHT(XY_pusv_filterChooseWholeButton)-30-20};
        XY_pusv_filterChooseContentView.backgroundColor = BB_WhiteColor;
        XY_pusv_filterChooseContentView.layer.cornerRadius = 2.f;
        XY_pusv_filterChooseContentView.layer.masksToBounds = YES;
        [XY_pusv_filterChooseWholeButton addSubview:XY_pusv_filterChooseContentView];
        
        XY_pusv_filterChooseViewTitleLabel = [[UILabel alloc] init];
        XY_pusv_filterChooseViewTitleLabel.frame = (CGRect){30,0,WIDTH(XY_pusv_filterChooseContentView)-30,60};
        XY_pusv_filterChooseViewTitleLabel.text = title;
        XY_pusv_filterChooseViewTitleLabel.textColor = RGBColor(10, 10, 10);
        XY_pusv_filterChooseViewTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        XY_pusv_filterChooseViewTitleLabel.textAlignment = NSTextAlignmentLeft;
        [XY_pusv_filterChooseContentView addSubview:XY_pusv_filterChooseViewTitleLabel];
        
        XY_pusv_filterChooseScrollView = [[UIScrollView alloc] init];
        XY_pusv_filterChooseScrollView.frame = (CGRect){0,BOTTOM(XY_pusv_filterChooseViewTitleLabel),WIDTH(XY_pusv_filterChooseContentView),HEIGHT(XY_pusv_filterChooseContentView)-HEIGHT(XY_pusv_filterChooseViewTitleLabel)-50};
        XY_pusv_filterChooseScrollView.contentSize = (CGSize){WIDTH(XY_pusv_filterChooseScrollView),HEIGHT(XY_pusv_filterChooseScrollView)+1};
        XY_pusv_filterChooseScrollView.showsHorizontalScrollIndicator = NO;
        XY_pusv_filterChooseScrollView.showsVerticalScrollIndicator = NO;
        [XY_pusv_filterChooseContentView addSubview:XY_pusv_filterChooseScrollView];
        
        XY_pusv_filterChooseCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [XY_pusv_filterChooseCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        XY_pusv_filterChooseCancelButton.titleLabel.font = Font(17);
        [XY_pusv_filterChooseContentView addSubview:XY_pusv_filterChooseCancelButton];
        [XY_pusv_filterChooseCancelButton addTarget:self action:@selector(dismissFilterChooseView) forControlEvents:UIControlEventTouchUpInside];
        
        XY_pusv_filterChooseSepLineView = [[UIView alloc] init];
        XY_pusv_filterChooseSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [XY_pusv_filterChooseCancelButton addSubview:XY_pusv_filterChooseSepLineView];
        
    }
    
    [XY_pusv_filterChooseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float choooseFilterScrollerViewMaxHeight = GLOBALHEIGHT-30-30-60-50;
    float everyButtonHeight = 45;
    float activeScrollViewContentHeight = everyButtonHeight * array.count + 1;
    float activeScrollViewHeight;
    if (activeScrollViewContentHeight >= choooseFilterScrollerViewMaxHeight) {
        activeScrollViewHeight = choooseFilterScrollerViewMaxHeight;
    }else{
        activeScrollViewHeight = everyButtonHeight * array.count;
    }
    if (activeScrollViewContentHeight < 130) {
        activeScrollViewHeight = GLOBALHEIGHT*2/5.f;
        activeScrollViewContentHeight = MAX(activeScrollViewHeight+1, everyButtonHeight * array.count + 1);
    }
    
    XY_pusv_filterChooseContentView.frame = (CGRect){
        20,
        (GLOBALHEIGHT-(activeScrollViewHeight+50+60))/2,
        WIDTH(XY_pusv_filterChooseWholeButton)-20*2,
        activeScrollViewHeight+50+60
    };
    
    XY_pusv_filterChooseViewTitleLabel.frame = (CGRect){20,0,WIDTH(XY_pusv_filterChooseContentView)-20,60};
    
    XY_pusv_filterChooseScrollView.frame = (CGRect){
        0,
        BOTTOM(XY_pusv_filterChooseViewTitleLabel),
        WIDTH(XY_pusv_filterChooseContentView),
        activeScrollViewHeight
    };
    XY_pusv_filterChooseScrollView.contentSize = (CGSize){WIDTH(XY_pusv_filterChooseScrollView),activeScrollViewContentHeight};
    
    XY_pusv_filterChooseCancelButton.frame = (CGRect){0,HEIGHT(XY_pusv_filterChooseContentView)-50,WIDTH(XY_pusv_filterChooseContentView),50};
    XY_pusv_filterChooseSepLineView.frame = (CGRect){0,0,WIDTH(XY_pusv_filterChooseCancelButton),0.5};
    
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSString *name = obj[@"name"];
        UILabel *namelABEL = [[UILabel alloc] init];
        namelABEL.frame = (CGRect){20,everyButtonHeight*idx,WIDTH(XY_pusv_filterChooseContentView)-20,everyButtonHeight};
        namelABEL.text = name;
        namelABEL.textColor = RGBColor(100, 100, 100);
        namelABEL.textAlignment = NSTextAlignmentLeft;
        [XY_pusv_filterChooseScrollView addSubview:namelABEL];
        namelABEL.tag = idx;
        namelABEL.userInteractionEnabled = YES;
        
        if (target && selector) {
            UITapGestureRecognizer *namelabelTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
            [namelABEL addGestureRecognizer:namelabelTap];
        }
    }];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        XY_pusv_filterChooseWholeButton.alpha = 1.f;
    }];
    [MainWindow addSubview:XY_pusv_filterChooseWholeButton];
}

+(void)dismissFilterChooseView{
    [UIView animateWithDuration:0.2f animations:^{
        XY_pusv_filterChooseWholeButton.alpha = 0.f;
        XY_mutitype_pusv_filterChooseWholeButton.alpha = 0.f;
    } completion:^(BOOL finished) {
        [XY_pusv_filterChooseWholeButton removeFromSuperview];
        [XY_mutitype_pusv_filterChooseWholeButton removeFromSuperview];
    }];
}

+(void)XY_pusv_filterChooseWholeButtonClick{
    [self dismissFilterChooseView];
}

static UIButton *XY_mutitype_pusv_filterChooseWholeButton;
static UIView *XY_mutitype_pusv_filterChooseContentView;
static UIScrollView *XY_mutitype_pusv_filterChooseScrollView;
static UILabel *XY_mutitype_filterChooseViewTitleLabel;
static UIButton *XY_mutitype_filterChooseCancelButton;
static UIButton *XY_mutitype_filterChooseDoneButton;
static UIView *XY_mutitype_filterChooseSepLineView;

static NSMutableArray *selectedIndexListArray;
static UIColor *XY_mutitype_pusv_NormalTextColor;
static UIColor *XY_mutitype_pusv_SelectedTextColor;

static void (^doneButtonClickBlock)(NSArray *selectedIndexArray);

+(void)showFilterMutitypeChooseViewWithArray:(NSArray *)array withTitle:(NSString *)title normalTextColor:(UIColor *)normalColor selectedTextColor:(UIColor *)selectColor doneButtonBlock:(void(^)(NSArray *selectedIndexArray))block{
    if (!XY_mutitype_pusv_filterChooseWholeButton) {
        XY_mutitype_pusv_filterChooseWholeButton = [[UIButton alloc] init];
        XY_mutitype_pusv_filterChooseWholeButton.backgroundColor = RGBAColor(50, 50, 50, 0.8);
        XY_mutitype_pusv_filterChooseWholeButton.frame = (CGRect){0,0,GLOBALWIDTH,GLOBALHEIGHT};
        [XY_mutitype_pusv_filterChooseWholeButton addTarget:self action:@selector(XY_mutitype_pusv_filterChooseWholeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        XY_mutitype_pusv_filterChooseContentView = [[UIView alloc] init];
        XY_mutitype_pusv_filterChooseContentView.frame = (CGRect){20,30,WIDTH(XY_mutitype_pusv_filterChooseWholeButton)-20*2,HEIGHT(XY_mutitype_pusv_filterChooseWholeButton)-30-20};
        XY_mutitype_pusv_filterChooseContentView.backgroundColor = BB_WhiteColor;
        XY_mutitype_pusv_filterChooseContentView.layer.cornerRadius = 2.f;
        XY_mutitype_pusv_filterChooseContentView.layer.masksToBounds = YES;
        [XY_mutitype_pusv_filterChooseWholeButton addSubview:XY_mutitype_pusv_filterChooseContentView];
        
        XY_mutitype_filterChooseViewTitleLabel = [[UILabel alloc] init];
        XY_mutitype_filterChooseViewTitleLabel.frame = (CGRect){30,0,WIDTH(XY_mutitype_pusv_filterChooseContentView)-30,60};
        XY_mutitype_filterChooseViewTitleLabel.text = title;
        XY_mutitype_filterChooseViewTitleLabel.textColor = RGBColor(10, 10, 10);
        XY_mutitype_filterChooseViewTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        XY_mutitype_filterChooseViewTitleLabel.textAlignment = NSTextAlignmentLeft;
        [XY_mutitype_pusv_filterChooseContentView addSubview:XY_mutitype_filterChooseViewTitleLabel];
        
        XY_mutitype_pusv_filterChooseScrollView = [[UIScrollView alloc] init];
        XY_mutitype_pusv_filterChooseScrollView.frame = (CGRect){0,BOTTOM(XY_mutitype_filterChooseViewTitleLabel),WIDTH(XY_mutitype_pusv_filterChooseContentView),HEIGHT(XY_mutitype_pusv_filterChooseContentView)-HEIGHT(XY_mutitype_filterChooseViewTitleLabel)-50};
        XY_mutitype_pusv_filterChooseScrollView.contentSize = (CGSize){WIDTH(XY_mutitype_pusv_filterChooseScrollView),HEIGHT(XY_mutitype_pusv_filterChooseScrollView)+1};
        XY_mutitype_pusv_filterChooseScrollView.showsHorizontalScrollIndicator = NO;
        XY_mutitype_pusv_filterChooseScrollView.showsVerticalScrollIndicator = NO;
        [XY_mutitype_pusv_filterChooseContentView addSubview:XY_mutitype_pusv_filterChooseScrollView];
        
        XY_mutitype_filterChooseDoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [XY_mutitype_filterChooseDoneButton setTitle:@"完成" forState:UIControlStateNormal];
        XY_mutitype_filterChooseDoneButton.titleLabel.font = Font(17);
        [XY_mutitype_pusv_filterChooseContentView addSubview:XY_mutitype_filterChooseDoneButton];
        [XY_mutitype_filterChooseDoneButton addTarget:self action:@selector(XY_mutitype_filterChooseDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        XY_mutitype_filterChooseCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [XY_mutitype_filterChooseCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        XY_mutitype_filterChooseCancelButton.titleLabel.font = Font(17);
        [XY_mutitype_pusv_filterChooseContentView addSubview:XY_mutitype_filterChooseCancelButton];
        [XY_mutitype_filterChooseCancelButton addTarget:self action:@selector(dismissFilterChooseView) forControlEvents:UIControlEventTouchUpInside];
        
        XY_mutitype_filterChooseSepLineView = [[UIView alloc] init];
        XY_mutitype_filterChooseSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [XY_mutitype_filterChooseCancelButton addSubview:XY_mutitype_filterChooseSepLineView];
        
    }
    
    [XY_mutitype_pusv_filterChooseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float choooseFilterScrollerViewMaxHeight = GLOBALHEIGHT-30-30-60-50;
    float everyButtonHeight = 45;
    float activeScrollViewContentHeight = everyButtonHeight * array.count + 1;
    float activeScrollViewHeight;
    if (activeScrollViewContentHeight >= choooseFilterScrollerViewMaxHeight) {
        activeScrollViewHeight = choooseFilterScrollerViewMaxHeight;
    }else{
        activeScrollViewHeight = everyButtonHeight * array.count;
    }
    if (activeScrollViewContentHeight < 130) {
        activeScrollViewHeight = GLOBALHEIGHT*2/5.f;
        activeScrollViewContentHeight = MAX(activeScrollViewHeight+1, everyButtonHeight * array.count + 1);
    }
    
    XY_mutitype_pusv_filterChooseContentView.frame = (CGRect){
        20,
        (GLOBALHEIGHT-(activeScrollViewHeight+50+60))/2,
        WIDTH(XY_mutitype_pusv_filterChooseWholeButton)-20*2,
        activeScrollViewHeight+50+60
    };
    
    XY_mutitype_filterChooseViewTitleLabel.frame = (CGRect){20,0,WIDTH(XY_mutitype_pusv_filterChooseContentView)-20,60};
    
    XY_mutitype_pusv_filterChooseScrollView.frame = (CGRect){
        0,
        BOTTOM(XY_mutitype_filterChooseViewTitleLabel),
        WIDTH(XY_mutitype_pusv_filterChooseContentView),
        activeScrollViewHeight
    };
    XY_mutitype_pusv_filterChooseScrollView.contentSize = (CGSize){WIDTH(XY_mutitype_pusv_filterChooseScrollView),activeScrollViewContentHeight};
    
    XY_mutitype_filterChooseDoneButton.frame = (CGRect){
        0,
        HEIGHT(XY_mutitype_pusv_filterChooseContentView)-50,
        WIDTH(XY_mutitype_pusv_filterChooseContentView)/2,
        50};
    
    XY_mutitype_filterChooseCancelButton.frame = (CGRect){
        WIDTH(XY_mutitype_pusv_filterChooseContentView)/2,
        HEIGHT(XY_mutitype_pusv_filterChooseContentView)-50,
        WIDTH(XY_mutitype_pusv_filterChooseContentView)/2,
        50};
    
    XY_mutitype_filterChooseSepLineView.frame = (CGRect){0,0,WIDTH(XY_mutitype_pusv_filterChooseContentView),0.5};
    
    if (block) {
        doneButtonClickBlock = block;
    }else{
        doneButtonClickBlock = nil;
    }
    
    if (!normalColor) {
        normalColor = [UIColor colorWithRed:100/255.f green:100/255.f blue:100/255.f alpha:1];
    }
    if (!selectColor) {
        selectColor = [UIColor colorWithRed:15/255.f green:110/255.f blue:195/255.f alpha:1];
    }
    XY_mutitype_pusv_NormalTextColor = normalColor;
    XY_mutitype_pusv_SelectedTextColor = selectColor;
    
    selectedIndexListArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSString *name = obj[@"name"];
        UILabel *namelABEL = [[UILabel alloc] init];
        namelABEL.frame = (CGRect){20,everyButtonHeight*idx,WIDTH(XY_mutitype_pusv_filterChooseContentView)-20,everyButtonHeight};
        namelABEL.text = name;
        namelABEL.textColor = XY_mutitype_pusv_NormalTextColor;
        namelABEL.textAlignment = NSTextAlignmentLeft;
        [XY_mutitype_pusv_filterChooseScrollView addSubview:namelABEL];
        namelABEL.tag = idx;
        namelABEL.userInteractionEnabled = YES;
        
        [selectedIndexListArray addObject:@(NO)];
        
        UITapGestureRecognizer *namelabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mutitypeLabelTapTrigger:)];
        [namelABEL addGestureRecognizer:namelabelTap];
        
    }];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        XY_mutitype_pusv_filterChooseWholeButton.alpha = 1.f;
    }];
    [MainWindow addSubview:XY_mutitype_pusv_filterChooseWholeButton];
}

+(void)XY_mutitype_pusv_filterChooseWholeButtonClick{
    [self dismissFilterChooseView];
}

+(void)mutitypeLabelTapTrigger:(UITapGestureRecognizer *)tap{
    UILabel *labelView = (UILabel *)tap.view;
    int tag = (int)labelView.tag;
    BOOL selected = tag / 10000;
    int index = tag % 10000;
    
    if (selected) {
        labelView.tag = index;
        labelView.textColor = XY_mutitype_pusv_NormalTextColor;
    }else{
        labelView.tag = 10000+index;
        labelView.textColor = XY_mutitype_pusv_SelectedTextColor;
    }
    
    [selectedIndexListArray replaceObjectAtIndex:index withObject:@(!selected)];
}

+(void)XY_mutitype_filterChooseDoneButtonClick{
    [self dismissFilterChooseView];
    if (doneButtonClickBlock) {
        NSArray *array = [NSArray arrayWithArray:selectedIndexListArray];
        doneButtonClickBlock(array);
    }
}

@end
