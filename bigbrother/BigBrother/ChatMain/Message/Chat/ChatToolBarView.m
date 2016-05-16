//
//  ChatToolBarView.m
//  BookClub
//
//  Created by 李祖建 on 16/2/26.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "ChatToolBarView.h"
#import "ChatMoreInputView.h"
#import "AGEmojiKeyBoardView.h"

//聊天
#define kToolBarH 48
#define kTextFieldH 30

typedef NS_ENUM(NSInteger, ChatToolInputStyle) {
    ChatToolInputStyle_Text = 0,
    ChatToolInputStyle_Emoji,
    ChatToolInputStyle_Voice,
    ChatToolInputStyle_More
};

@interface ChatToolBarView ()<ChatMoreInputViewDelegate,UITextFieldDelegate,AGEmojiKeyboardViewDelegate,AGEmojiKeyboardViewDataSource,UITextViewDelegate>

@property (strong, nonatomic) AGEmojiKeyboardView *emojiBoard;

@end

@implementation ChatToolBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChatToolBarView" owner:self options:nil] lastObject];
        self.frame = CGRectMake(0,MAINSCRREN_H-kToolBarH-NAVBAR_H,MAINSCRREN_W,kToolBarH);
        self.autoresizesSubviews = NO;
        
        //调整位置
        [self.textView setWidth:CGRectGetMinX(self.emojiBtn.frame)-FLEXIBLE_NUM(8)*2-CGRectGetMaxX(self.voiceBtn.frame)];
        [self.textView setOriginX:CGRectGetMaxX(self.voiceBtn.frame)+FLEXIBLE_NUM(8)];
        self.textView.center = CGPointMake(self.textView.center.x, self.frame.size.height/2);
        self.recordBtn.frame = self.textView.frame;
        [self addSubview:self.textView];
        
        self.textView.enablesReturnKeyAutomatically = YES;
        self.textView.delegate = self;
        ChatMoreInputView *inputView = [[ChatMoreInputView alloc]init];
        inputView.delegate = self;
        self.moreTempField.inputView = inputView;
        
        [self bringSubviewToFront:self.textView];
        [self sendSubviewToBack:self.recordBtn];
        
        [self.recordBtn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.recordBtn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self.recordBtn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBtn addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [self.recordBtn addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];

    }
    return self;
}

#pragma mark - getter
- (LBTextView *)textView
{
    if (!_textView) {
        _textView = [[LBTextView alloc]initWithFrame:FLEXIBLE_FRAME(8, 9, 236, 30)];
        _textView.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.cornerRadius = _textView.frame.size.height/4;
        _textView.maxLineNumber = 2;
        _textView.delegate = self;
        _textView.tag = TEXTFIELD_TAG+10;
    }
    return _textView;
}

- (AGEmojiKeyboardView *)emojiBoard
{
    if (!_emojiBoard) {
        _emojiBoard = [[AGEmojiKeyboardView alloc]initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, 236) dataSource:self];
//        _emojiBoard.superTextField = self.textField;
        _emojiBoard.superTextView = self.textView;
        _emojiBoard.delegate = self;
        _emojiBoard.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _emojiBoard;
}

- (EaseRecordView *)recordView
{
    if (!_recordView) {
        _recordView = [[EaseRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    return _recordView;
}

#pragma mark - AGEmojiKeyboardViewDelegate,AGEmojiKeyboardViewDataSource>
- (UIColor *)randomColor {
    return _DDDDDD;
//    return [UIColor colorWithRed:drand48()
//                           green:drand48()
//                            blue:drand48()
//                           alpha:drand48()];
}

- (UIImage *)randomImage {
    CGSize size = CGSizeMake(30, 10);
    UIGraphicsBeginImageContextWithOptions(size , NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(context, rect);
    
    fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGFloat xxx = 3;
    rect = CGRectMake(xxx, xxx, size.width - 2 * xxx, size.height - 2 * xxx);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

//    img = [UIImage imageNamed:@"chat_emoji_btn.png"];
    
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
//    if (category == AGEmojiKeyboardViewCategoryImageCar) {
//        UIImage *img = [self randomImage];
//        img = [UIImage imageNamed:@"emoji_tab0"];
//        return img;
//    }
//    UIImage *img = [self randomImage];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"emoji_tab%ldPress",(long)category]];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (!img) {
        img = [UIImage imageNamed:@"KBSkinFilter_delete"];
    }
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
//    if (category == AGEmojiKeyboardViewCategoryImageFace) {
//        return [UIImage imageNamed:@"emoji_tab0"];
//    }
//    UIImage *img = [self randomImage];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"emoji_tab%ld",(long)category]];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (!img) {
        img = [UIImage imageNamed:@"KBSkinFilter_delete"];
    }
    return img;
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    
//    UIImage *img = [self randomImage];
    UIImage *img = [UIImage imageNamed:@"KBSkinFilter_delete"];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
//    self.textField.text = [self.textField.text stringByAppendingString:emoji];
    self.textView.text = [self.textView.text stringByAppendingString:emoji];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
//    [self.textField deleteBackward];
    [self.textView deleteBackward];
}

- (void)emojiKeyBoardViewDidPressSendBtn:(AGEmojiKeyboardView *)emojiKeyBoardView
{
//    [self textFieldShouldReturn:self.textField];
//    [self textFieldShouldReturn:self.textView];
    [self.delegate toolBarShouldReturn:self];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate toolBarShouldReturn:self];
    return YES;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    
//    CGFloat lastHeight = self.frame.size.height;
    if (!textView.text.length) {
        textView.contentSize = CGSizeMake(textView.frame.size.width,FLEXIBLE_NUM(30));
    }
    
    CGFloat lastMaxY = CGRectGetMaxY(self.frame);
    [self.textView setHeight:self.textView.contentSize.height];
    [UIView animateWithDuration:0.1 animations:^{
        
        [self setHeight:CGRectGetMaxY(self.textView.frame)+self.textView.frame.origin.y];
        [self setOriginY:lastMaxY-self.frame.size.height];
    }];
    
    [self.emojiBoard refreshSendBtnState];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, self.textView.contentSize.height);
//    //    self.textView.contentInset = UIEdgeInsetsZero;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    CGFloat lastMaxY = CGRectGetMaxY(self.frame);
    [self.textView setHeight:self.textView.contentSize.height];
    [UIView animateWithDuration:0.1 animations:^{
        
        [self setHeight:CGRectGetMaxY(self.textView.frame)+self.textView.frame.origin.y];
        [self setOriginY:lastMaxY-self.frame.size.height];
    }];
    
    if ([text
         isEqualToString:@"\n"])
    {
        [self.delegate toolBarShouldReturn:self];
        [self textViewDidChange:self.textView];
//        [textView resignFirstResponder];
        return NO;
        
    }
    //    self.textView.contentInset = UIEdgeInsetsZero;
    return YES;
}


//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    
//}

#pragma mark - ChatMoreInputViewDelegate
- (void)clickedPicBtn:(UIButton *)sender
{
    [self.delegate clickedPicBtn:sender];
}

- (void)clickedAddrBtn:(UIButton *)sender
{
    [self.delegate clickedAddrBtn:sender];
}

- (void)clickedBookBtn:(UIButton *)sender
{
//    [self.delegate clickedBookBtn:sender];
}

#pragma mark - record 录音按钮事件~
- (void)recordButtonTouchDown
{
    if (self.delegate && [_delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
        [self.delegate didStartRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpOutside
{
    if (self.delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)])
    {
        [self.delegate didCancelRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpInside
{
    self.recordBtn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)])
    {
        [self.delegate didFinishRecoingVoiceAction:self.recordView];
    }
    self.recordBtn.enabled = YES;
}

- (void)recordDragOutside
{
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction:)])
    {
        [self.delegate didDragOutsideAction:self.recordView];
    }
}

- (void)recordDragInside
{
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction:)])
    {
        [self.delegate didDragInsideAction:self.recordView];
    }
}

#pragma mark - 按钮
- (IBAction)emojiBtnPressed:(UIButton *)sender {
    ChatToolInputStyle inputStyle = sender.selected ? ChatToolInputStyle_Text : ChatToolInputStyle_Emoji;
    [self changeInputStyleWithInputStyle:inputStyle];
    sender.selected = !sender.selected;
    self.voiceBtn.selected = NO;
}

- (IBAction)moreBtnPressed:(UIButton *)sender {
    [self changeInputStyleWithInputStyle:ChatToolInputStyle_More];
    self.voiceBtn.selected = NO;
    self.emojiBtn.selected = NO;
}

- (IBAction)voiceBtnPressed:(UIButton *)sender {
    ChatToolInputStyle inputStyle = sender.selected ? ChatToolInputStyle_Text : ChatToolInputStyle_Voice;
    
    [self changeInputStyleWithInputStyle:inputStyle];
    
    sender.selected = !sender.selected;
    self.emojiBtn.selected = NO;
}

#pragma mark - 自定义
- (void)changeInputStyleWithInputStyle:(ChatToolInputStyle)inputStyle
{
    switch (inputStyle) {
        case ChatToolInputStyle_Text:
        {
            self.textView.inputView = nil;
            [self.textView becomeFirstResponder];
            [self.textView reloadInputViews];
            [self sendSubviewToBack:self.recordBtn];
            [self bringSubviewToFront:self.textView];
        }
            break;
        case ChatToolInputStyle_Emoji:
        {
            self.textView.inputView = self.emojiBoard;
            [self.emojiBoard refreshSendBtnState];
            [self.textView becomeFirstResponder];
            [self.textView reloadInputViews];
            [self sendSubviewToBack:self.recordBtn];
            [self bringSubviewToFront:self.textView];
            
        }
            break;
        case ChatToolInputStyle_Voice:
        {
            [WINDOW endEditing:YES];
            self.recordBtn.selected = NO;
            [self sendSubviewToBack:self.textView];
            [self bringSubviewToFront:self.recordBtn];
        }
            break;
        case ChatToolInputStyle_More:
        {
            [self.textView resignFirstResponder];
            [self.moreTempField becomeFirstResponder];
            [self sendSubviewToBack:self.recordBtn];
            [self bringSubviewToFront:self.textView];
        }
            break;
            
        default:
            break;
    }
}

@end
