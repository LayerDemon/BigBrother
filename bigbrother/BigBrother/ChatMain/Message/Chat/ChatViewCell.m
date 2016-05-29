//
//  GroupChatViewCell.m
//  BookClub
//
//  Created by 李祖建 on 15/12/11.
//  Copyright © 2015年 LittleBitch. All rights reserved.
//

#import "ChatViewCell.h"
//#import "ShowMapViewController.h"



#define locationW FLEXIBLE_NUM(95)

#define CUSTOMMESSAGEVIEW_TAG 1000

@interface ChatViewCell ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *iconBtn;
@property (strong, nonatomic) UIButton *textBtn;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *gradeLabel;


@end

@implementation ChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        
//        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
//        [self addGestureRecognizer:longPressGesture];
        
        [self.textBtn.titleLabel OpenEdit];
        
    }
    return self;
}

#pragma mark - getter
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = _999999;
        _timeLabel.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(10)];
    }
    return _timeLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = _999999;
        _nameLabel.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
    }
    return _nameLabel;
}

- (UIButton *)iconBtn
{
    if (!_iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconBtn addTarget:self action:@selector(iconBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconBtn;
}

- (UIButton *)textBtn
{
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textBtn.titleLabel.numberOfLines = 0;
        _textBtn.titleLabel.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(14)];
        _textBtn.contentEdgeInsets = UIEdgeInsetsMake(textPadding,textPadding,textPadding,textPadding);
        _textBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_textBtn addTarget:self action:@selector(contentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_textBtn addSubview:self.voiceImageView];
    }
    return _textBtn;
}

- (UIButton *)sendStateBtn
{
    if (!_sendStateBtn) {
        _sendStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendStateBtn.frame = FLEXIBLE_FRAME(0,0,20, 20);
        [_sendStateBtn addTarget:self action:@selector(sendStateBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_sendStateBtn setBackgroundImage:[UIImage imageNamed:@"mc_sendfail_btn"] forState:UIControlStateSelected];
        [_sendStateBtn setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    }
    return _sendStateBtn;
}

- (UIImageView *)voiceImageView
{
    if (!_voiceImageView) {
        _voiceImageView = [[UIImageView alloc]init];
        _voiceImageView.backgroundColor = [UIColor clearColor];
        _voiceImageView.animationDuration = 1;
        _voiceImageView.animationRepeatCount = 0;
        _voiceImageView.hidden = YES;
        _voiceImageView.userInteractionEnabled = YES;
    }
    return _voiceImageView;
}

- (ChatSupplyLinkView *)supplyLinkView
{
    if (!_supplyLinkView) {
        _supplyLinkView = [[ChatSupplyLinkView alloc]init];
    }
    return _supplyLinkView;
}

#pragma mark - 按钮方法
//- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender
//{
//    if (sender.state == UIGestureRecognizerStateBegan) {
////        [self.delegate chatViewCell:self longPressGestureRecognizer:sender];
//    }
//}

//点击头像
- (void)iconBtnPressed:(UIButton *)sender
{
    [self.delegate cell:self clickedIconBtn:sender];
}

//点击内容
- (void)contentBtnPressed:(UIButton *)sender
{
    EMMessageBodyType messageBodyType = self.cellFrameModel.messageModel.messageBodyType;
    switch (messageBodyType) {
        case EMMessageBodyTypeVoice:
            //播放音频
            [self.delegate chatViewCell:self clickedVoiceBtn:sender];
            break;
        case EMMessageBodyTypeCustom:
            //播放音频
            [self clickedCustomMessageWithMessageExt:self.cellFrameModel.messageModel.messageExt];
            break;
            
        default:
            
            break;
    }
}

- (void)clickedCustomMessageWithMessageExt:(NSDictionary *)messageExt
{
    NSInteger resultValue = [messageExt[@"resultValue"] integerValue];
    
    switch (resultValue) {
        case 1://摇钱树
            
            break;
        case 2://供应链接
            [self.delegate chatViewCell:self clickedSupplyLinkBtn:self.textBtn];
            break;
        case 3://供应链接
            [self.delegate chatViewCell:self clickedGroupLinkBtn:self.textBtn];
            break;
            
        default:
//            [AppDelegate showHintLabelWithMessage:@"已经没有更多了~"];
            break;
    }
    
}

- (void)sendStateBtnPressed:(UIButton *)sender
{
    if (sender.selected) {
        [self.delegate chatViewCell:self clickedSendStateBtn:sender];
    }
}

#pragma mark - 自定义方法
- (void)refreshWithCellFrameModel:(ChatFrameModel *)cellFrameModel
{
    self.cellFrameModel = cellFrameModel;
    
    ChatMessageModel *messageModel = cellFrameModel.messageModel;
    
    //时间~
    self.timeLabel.frame = cellFrameModel.timeFrame;
    self.timeLabel.text = messageModel.time;
    
    //头像~
    self.iconBtn.frame = cellFrameModel.iconFrame;
    NSString *iconUrl = messageModel.isFromOther ? messageModel.otherDic[@"avatar"] : messageModel.userDic[@"avatar"];
    UIImage *placeholderImage = self.iconBtn.imageView.image ? self.iconBtn.imageView.image : PLACEHOLDERIMAGE_USER;
    //    [_iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:iconUrl] forState:UIControlStateNormal placeholderImage:placeholderImage];
//    [self.iconBtn setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    self.iconBtn.contentMode = UIViewContentModeScaleAspectFit;
    self.iconBtn.layer.cornerRadius = self.iconBtn.frame.size.width/2;
    self.iconBtn.clipsToBounds = YES;

//    
    //昵称~
    self.nameLabel.frame = cellFrameModel.nameFrame;
    //    self.nameLabel.backgroundColor = [UIColor blackColor];
    self.nameLabel.text = messageModel.isFromOther ? messageModel.otherDic[@"nickname"] : messageModel.userDic[@"nickname"];
    if (messageModel.isFromOther && messageModel.otherDic[@"remarks"]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",messageModel.otherDic[@"remarks"]];
    }
    self.nameLabel.textAlignment = messageModel.isFromOther ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    //语音样式
    self.voiceImageView.image = messageModel.isFromOther ? [UIImage imageNamed:@"chat_receiver_audio_playing_full"] : [UIImage imageNamed:@"chat_sender_audio_playing_full"];
    self.voiceImageView.frame = cellFrameModel.voiceFrame;
    NSArray *senderImages = @[[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"],[UIImage imageNamed:@"chat_sender_audio_playing_003"]];
    NSArray *receiverImages = @[[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"]];
    self.voiceImageView.animationImages = messageModel.isFromOther ? receiverImages : senderImages;
    
    //消息~
    self.textBtn.frame = cellFrameModel.textFrame;
    self.textBtn.contentEdgeInsets = cellFrameModel.textEdgeInset;
    UIColor *textColor = _525252;
    [self.textBtn setTitleColor:textColor forState:UIControlStateNormal];
    
    [self contentWithMessageModel:messageModel];
    
    
    
    
    //菊花
    self.sendStateBtn.hidden = cellFrameModel.messageModel.isFromOther;
    if (!messageModel.isFromOther) {
        self.sendStateBtn.frame = cellFrameModel.indicatorFrame;
        if (messageModel.message.status == EMMessageStatusSuccessed) {
            [self.sendStateBtn stopAnimationWithTitle:@""];
            self.sendStateBtn.selected = NO;
        }
        else if (messageModel.message.status == EMMessageStatusFailed){
            [self.sendStateBtn stopAnimationWithTitle:@""];
            self.sendStateBtn.selected = YES;
        }
        else if (messageModel.message.status == EMMessageStatusDelivering){
            [self.sendStateBtn startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.sendStateBtn.selected = NO;
        }
    }
    [self setHeight:cellFrameModel.cellHeight];
 
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.iconBtn];
    [self.contentView addSubview:self.textBtn];
    [self.contentView addSubview:self.sendStateBtn];
    
    if (self.cellFrameModel.messageModel.message.chatType == EMChatTypeGroupChat) {
        self.nameLabel.hidden = NO;
    }else{
        self.nameLabel.hidden = YES;
    }
}


//获取对应类型的内容
- (void)contentWithMessageModel:(ChatMessageModel *)messageModel
{
    UIView *lastMessageView = [self.textBtn viewWithTag:CUSTOMMESSAGEVIEW_TAG];
    if (lastMessageView) {
        [lastMessageView removeFromSuperview];
    }
    self.voiceImageView.hidden = YES;
    NSString *textBg = messageModel.isFromOther ? @"chat_receiver_bg" : @"chat_sender_bg";
    [self.textBtn setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    [self.textBtn setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self.textBtn setTitle:@"" forState:UIControlStateNormal];
    
    switch (messageModel.messageBodyType) {
        case EMMessageBodyTypeText:
        {
            [self.textBtn setTitle:messageModel.text forState:UIControlStateNormal];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            self.voiceImageView.hidden = NO;
            if (messageModel.isFromOther) {
                if (messageModel.isMediaPlayed){
//                    _bubbleView.isReadView.hidden = YES;
                } else {
//                    _bubbleView.isReadView.hidden = NO;
                }
            }
            
//            [self.voiceImageView startAnimating];
            if (messageModel.isMediaPlaying) {
                [self.voiceImageView startAnimating];
            }
            else{
                [self.voiceImageView stopAnimating];
            }
        }
            break;
        case EMMessageBodyTypeCustom:
        {
            UIView *customMessageView = [self customMessageViewWithMessageExt:messageModel.messageExt];
            [self.textBtn addSubview:customMessageView];
        }
            break;
        default:
            break;
    }
}

- (UIView *)customMessageViewWithMessageExt:(NSDictionary *)messageExt
{
    NSInteger resultValue = [messageExt[@"resultValue"] integerValue];
    
    UIView *customMessageView;
    switch (resultValue) {
        case 1://摇钱树
            
            break;
        case 2://供应链接
        {
            [self.supplyLinkView reloadSupplyLinkWithDataDic:messageExt[@"customPojo"]];
            customMessageView = self.supplyLinkView;
//            [supplyLinkView removeFromSuperview];
        }
            break;
        case 3://供应链接
        {
            [self.supplyLinkView reloadGroupLinkWithDataDic:messageExt[@"customPojo"]];
            customMessageView = self.supplyLinkView;
            //            [supplyLinkView removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
    
    customMessageView.tag = CUSTOMMESSAGEVIEW_TAG;
    customMessageView.userInteractionEnabled = NO;
    return customMessageView;
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    ChatSupplyLinkView *supplyLinkView = [[ChatSupplyLinkView alloc]init];
//    [supplyLinkView reloadSupplyLinkWithDataDic:self.cellFrameModel.messageModel.messageExt];
////    [self addSubview:supplyLinkView];
//    UIImage *contentImage = [supplyLinkView screenshotWithRect:supplyLinkView.bounds];
//    [self.textBtn setImage:contentImage forState:UIControlStateNormal];
//    [self.textBtn setBackgroundImage:contentImage forState:UIControlStateNormal];
//}

@end
