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

@interface ChatViewCell ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *iconBtn;
@property (strong, nonatomic) UIButton *textBtn;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addrLabel;


@end

@implementation ChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        [self addGestureRecognizer:longPressGesture];
        
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

- (UILabel *)addrLabel
{
    if (!_addrLabel) {
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,locationW-textPadding/2,FLEXIBLE_NUM(35)-textPadding)];
        _addrLabel.textAlignment = NSTextAlignmentCenter;
        _addrLabel.textColor = [UIColor whiteColor];
        _addrLabel.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(10)];
        _addrLabel.numberOfLines = 2;
        _addrLabel.backgroundColor = [UIColor clearColor];
        _addrLabel.hidden = YES;
    }
    return _addrLabel;
}

- (UIButton *)sendStateBtn
{
    if (!_sendStateBtn) {
        _sendStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendStateBtn.frame = FLEXIBLE_FRAME(0,0,20, 20);
        [_sendStateBtn addTarget:self action:@selector(sendStateBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_sendStateBtn setBackgroundImage:[UIImage imageNamed:@"mc_sendfail_btn"] forState:UIControlStateSelected];
        [_sendStateBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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

//- (UIActivityIndicatorView *)indicatorView
//{
//    if (!_indicatorView) {
//        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        //        _indicatorView.frame = FLEXIBLE_FRAME(0,0,20, 20);
//        _indicatorView.hidesWhenStopped = YES;
//    }
//    return _indicatorView;
//}

#pragma mark - 按钮方法
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
//        [self.delegate chatViewCell:self longPressGestureRecognizer:sender];
    }
}

- (void)iconBtnPressed:(UIButton *)sender
{
    [self.delegate cell:self clickedIconBtn:sender];
}

- (void)contentBtnPressed:(UIButton *)sender
{
    EMMessageBodyType messageBodyType = self.cellFrameModel.messageModel.messageBodyType;
    switch (messageBodyType) {
        case EMMessageBodyTypeImage:
            //显示大图
            [self showLocalImage];
            break;
        case EMMessageBodyTypeLocation:
            //跳转到地图
            [self pushLocationVC];
            break;
        case EMMessageBodyTypeVoice:
            //跳转到地图
            [self.delegate chatViewCell:self clickedVoiceBtn:sender];
            break;
            
        default:
            
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
    
    //    if (!messageModel.showTime) {
    //        _timeLabel.hidden = YES;
    //    }
    
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
    NSString *textBg = messageModel.isFromOther ? @"chat_receiver_bg" : @"chat_sender_bg";
    UIColor *textColor = _525252;
    [self.textBtn setTitleColor:textColor forState:UIControlStateNormal];
    [self.textBtn setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
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
    self.addrLabel.hidden = YES;
    self.voiceImageView.hidden = YES;
    [self.textBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.textBtn setTitle:@"" forState:UIControlStateNormal];
    
    switch (messageModel.messageBodyType) {
        case EMMessageBodyTypeText:
        {
            [self.textBtn setTitle:messageModel.text forState:UIControlStateNormal];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            [self setContentImageWithMessageModel:messageModel];
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            [self.textBtn setImage:[UIImage imageNamed:@"chat_location_preview"] forState:UIControlStateNormal];
            self.addrLabel.hidden = NO;
            self.addrLabel.text = messageModel.locationMessageBody.address;
            [self.addrLabel setOriginY:self.textBtn.imageView.frame.size.height-self.addrLabel.frame.size.height];
            [self.textBtn.imageView addSubview:self.addrLabel];
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
            
            if (messageModel.isMediaPlaying) {
                [self.voiceImageView startAnimating];
            }
            else{
                [self.voiceImageView stopAnimating];
            }
        }
            break;
            
        default:
            break;
    }
}

//设置图片~根据下载情况~
- (void)setContentImageWithMessageModel:(ChatMessageModel *)messageModel
{
    [self.textBtn setTitle:@"" forState:UIControlStateNormal];
    EMImageMessageBody *imageMessageBody = messageModel.imageMessageBody;
    [self.textBtn setImage:[UIImage imageNamed:@"h_bg_placeholder"] forState:UIControlStateNormal];
    [self.textBtn startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    if (imageMessageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
        [self.textBtn setImage:[UIImage imageWithContentsOfFile:imageMessageBody.localPath] forState:UIControlStateNormal];
        [self.textBtn stopAnimationWithTitle:@""];        
        return;
    }
    
    if (imageMessageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
        [self.textBtn setImage:[UIImage imageWithContentsOfFile:imageMessageBody.thumbnailLocalPath] forState:UIControlStateNormal];
        [self.textBtn stopAnimationWithTitle:@""];
        return;
    }
    
    if (imageMessageBody.thumbnailDownloadStatus != EMDownloadStatusSuccessed) {
        [MANAGER_CHAT asyncDownloadMessageThumbnail:messageModel.message progress:nil completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                EMImageMessageBody *aImageMessageBody = (EMImageMessageBody *)message.body;
                [self.textBtn setImage:[UIImage imageWithContentsOfFile:aImageMessageBody.thumbnailLocalPath] forState:UIControlStateNormal];
            }
            [self.textBtn stopAnimationWithTitle:@""];
        }];
//        [MANAGER_CHAT asyncDownloadMessageAttachments:messageModel.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
//            
//        } onQueue:nil];
    }
    

    
}




#pragma mark - 点击消息后的各种操作
//显示大图
- (void)showLocalImage
{
    ChatMessageModel *messageModel = self.cellFrameModel.messageModel;
    EMImageMessageBody *imageMessageBody = messageModel.imageMessageBody;
    if (imageMessageBody.downloadStatus == EMDownloadStatusSuccessed) {
        //显示大图
        [PreviewImageViewController showImage:self.textBtn.imageView];
    }else{
        //下载
        [self.textBtn startAnimationWithIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.textBtn setImage:[UIImage getGrayImage:self.textBtn.imageView.image] forState:UIControlStateNormal];
        [MANAGER_CHAT asyncDownloadMessageAttachments:messageModel.message progress:nil completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                EMImageMessageBody *aImageMessageBody = (EMImageMessageBody *)message.body;
                [self.textBtn setImage:[UIImage imageWithContentsOfFile:aImageMessageBody.localPath] forState:UIControlStateNormal];
                [PreviewImageViewController showImage:self.textBtn.imageView];
            }else{
                [AppDelegate showHintLabelWithMessage:@"大图下载失败~"];
            }
            [self.textBtn stopAnimationWithTitle:@""];
        }];
    }
}

- (void)pushLocationVC
{
//    ChatMessageModel *messageModel = self.cellFrameModel.messageModel;
//    EMLocationMessageBody *locationMessageBody = messageModel.locationMessageBody;
//    ShowMapViewController *showMapVC = [[ShowMapViewController alloc]init];
//    showMapVC.coordinate = CLLocationCoordinate2DMake(locationMessageBody.latitude, locationMessageBody.longitude);
//    showMapVC.address = locationMessageBody.address;
//    [self.viewController.navigationController pushViewController:showMapVC animated:YES];
}

@end
