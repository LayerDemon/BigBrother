//
//  UILabel+Category.m
//  BookClub
//
//  Created by 李祖建 on 15/11/9.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

//
////绑定事件
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
////        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
////        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu:) name:UIMenuControllerWillShowMenuNotification object:nil];
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
//    }
//    return self;
//}
//
////同上
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu:) name:UIMenuControllerWillShowMenuNotification object:nil];
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
////    [self OpenEdit];
//}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}


//打开编辑（绑定事件）
- (void)OpenEdit
{
    self.userInteractionEnabled = YES;//用户交互总开关
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    
    [self addGestureRecognizer:longPressGesture];
//    self.highlightedTextColor = [UIColor redColor];
}



- (BOOL)canBecomeFirstResponder
{
    
    return YES;
}


//- (BOOL)resignFirstResponder
//{
//    NSLog(@"-------akjsdasdkasjdlkasdkl");
//
//    return YES;
//}
//
//- (BOOL)canResignFirstResponder
//{
//    NSLog(@"-------akjsdasdkasjdlkasdkl");
//    return YES;
//}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
}

-(void)longPressGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    
    
    
//    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
//                             
//                                                      action:@selector(copy:)];
    
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu:) name:UIMenuControllerWillShowMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
        self.highlighted = YES;
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    }
    
    
}

- (void)showMenu:(NSNotification *)sender
{
//    self.highlighted = YES;
    self.highlightedTextColor = self.backgroundColor;
    self.backgroundColor = _F7F7F7;
}

- (void)hiddenMenu:(NSNotification *)sender
{
//    self.highlighted = NO;
    self.backgroundColor = self.highlightedTextColor;
    self.highlightedTextColor = self.textColor;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
