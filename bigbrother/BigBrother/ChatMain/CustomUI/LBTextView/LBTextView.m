//
//  LBTextView.m
//  BookClub
//
//  Created by 李祖建 on 16/5/5.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "LBTextView.h"

@interface LBTextView ()<UITextViewDelegate>

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation LBTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = UIEdgeInsetsZero;
        self.maxHeight = frame.size.height;
        self.returnKeyType = UIReturnKeySend;
//        [self addSubview:self.placeholderLabel];
    }
    return self;
}


#pragma mark - getter
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _placeholderLabel.userInteractionEnabled = NO;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = _999999;
    }
    return _placeholderLabel;
}

#pragma mark - setter
- (void)setMaxLineNumber:(NSInteger)maxLineNumber
{
    _maxLineNumber = maxLineNumber;
    NSMutableString *lineStr = [NSMutableString string];
    for (NSInteger i = 0; i < maxLineNumber; i++) {
        [lineStr appendString:@"哦\n"];
    }
    CGSize size = [NSString sizeWithString:lineStr Font:self.font maxWidth:self.frame.size.width NumberOfLines:maxLineNumber];
    self.maxHeight = size.height+self.textContainerInset.bottom+self.textContainerInset.top;
}


- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height > self.maxHeight && self.maxHeight > 0) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,self.maxHeight);
    }
    [super setFrame:frame];
}

-(void)setContentOffset:(CGPoint)contentOffset
{
//    if(self.tracking || self.decelerating){
//        //initiated by user...
//        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    } else {
//        
//        float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
//        if(s.y < bottomOffset && self.scrollEnabled){
//            self.contentInset = UIEdgeInsetsMake(0, 0, 8, 0); //maybe use scrollRangeToVisible?
//        }
//        
//    }
    
    CGPoint newContentOffset = CGPointZero;
    if (self.contentSize.height > self.frame.size.height) {
        if (self.dragging) {
            newContentOffset = contentOffset;
        }
        else if (self.decelerating){
            newContentOffset = contentOffset;
        }
        else{
            newContentOffset = CGPointMake(self.contentOffset.x,self.contentSize.height-self.frame.size.height);
        }
    }
    
    [super setContentOffset:newContentOffset];
}



@end
