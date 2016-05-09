//
//  ChatToolBarView.h
//  BookClub
//
//  Created by 李祖建 on 16/2/26.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTextView.h"

@class ChatToolBarView;

@protocol ChatToolBarViewDelegate <NSObject>

- (void)clickedPicBtn:(UIButton *)sender;
- (void)clickedAddrBtn:(UIButton *)sender;
//- (void)clickedBookBtn:(UIButton *)sender;
- (void)toolBarShouldReturn:(ChatToolBarView *)toolBar;

@end

@interface ChatToolBarView : UIView

@property (assign, nonatomic) id<ChatToolBarViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) LBTextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *moreTempField;
@property (strong, nonatomic) IBOutlet UIButton *emojiBtn;

- (IBAction)emojiBtnPressed:(UIButton *)sender;
- (IBAction)moreBtnPressed:(UIButton *)sender;

@end
