//
//  LBAdaptiveTextView.m
//  BookClub
//
//  Created by 李祖建 on 16/5/6.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "LBAdaptiveTextView.h"

@interface LBAdaptiveTextView ()



@end

@implementation LBAdaptiveTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.textView];
    }
    return self;
}

#pragma mark - getter
- (LBTextView *)textView
{
    if (!_textView) {
        
        _textView = [[LBTextView alloc]initWithFrame:self.bounds];
        
    }
    return _textView;
}



@end
