//
//  ChatViewCell.h
//  BookClub
//
//  Created by 李祖建 on 16/2/26.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatFrameModel.h"

@class ChatViewCell;

@protocol ChatViewCellDelegate <NSObject>

- (void)cell:(ChatViewCell *)cell clickedIconBtn:(UIButton *)sender;
- (void)chatViewCell:(ChatViewCell *)cell longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender;

- (void)chatViewCell:(ChatViewCell *)cell clickedSendStateBtn:(UIButton *)sender;

- (void)chatViewCell:(ChatViewCell *)cell clickedVoiceBtn:(UIButton *)sender;

@end

@interface ChatViewCell : UITableViewCell


@property (assign, nonatomic) id<ChatViewCellDelegate>delegate;

//@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UIButton *sendStateBtn;
@property (strong, nonatomic) ChatFrameModel *cellFrameModel;
@property (strong, nonatomic) UIImageView *voiceImageView;

- (void)refreshWithCellFrameModel:(ChatFrameModel *)cellFrameModel;
@end
