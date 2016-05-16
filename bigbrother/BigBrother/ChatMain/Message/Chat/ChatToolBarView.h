//
//  ChatToolBarView.h
//  BookClub
//
//  Created by 李祖建 on 16/2/26.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTextView.h"
#import "EaseRecordView.h"

@class ChatToolBarView;

@protocol ChatToolBarViewDelegate <NSObject>

- (void)clickedPicBtn:(UIButton *)sender;
- (void)clickedAddrBtn:(UIButton *)sender;
//- (void)clickedBookBtn:(UIButton *)sender;
- (void)toolBarShouldReturn:(ChatToolBarView *)toolBar;


/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(EaseRecordView *)recordView;

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(EaseRecordView *)recordView;

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(EaseRecordView *)recordView;

/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction:(EaseRecordView *)recordView;

/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction:(EaseRecordView *)recordView;

@end

@interface ChatToolBarView : UIView

@property (assign, nonatomic) id<ChatToolBarViewDelegate>delegate;

//@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) EaseRecordView *recordView;
@property (strong, nonatomic) LBTextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *moreTempField;
@property (strong, nonatomic) IBOutlet UIButton *emojiBtn;
@property (strong, nonatomic) IBOutlet UIButton *voiceBtn;
@property (strong, nonatomic) IBOutlet UIButton *recordBtn;

- (IBAction)emojiBtnPressed:(UIButton *)sender;
- (IBAction)moreBtnPressed:(UIButton *)sender;
- (IBAction)voiceBtnPressed:(UIButton *)sender;

@end
