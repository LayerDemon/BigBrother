//
//  LBTextView.h
//  BookClub
//
//  Created by 李祖建 on 16/5/5.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBTextView : UITextView

@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) NSInteger maxLineNumber;

//@property (assign, nonatomic) BOOL isDragging;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setMaxLineNumber:(NSInteger)maxLineNumber;
@end
