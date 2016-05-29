//
//  ChatFrameModel.m
//  BookClub
//
//  Created by 李祖建 on 16/2/29.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "ChatFrameModel.h"
#import "NSString+Extension.h"
#import "ChatSupplyLinkView.h"

#define timeH FLEXIBLE_NUM(36)
#define padding FLEXIBLE_NUM(8)
#define iconW FLEXIBLE_NUM(38)
#define iconH FLEXIBLE_NUM(38)
#define textW 150
#define imgMaxH FLEXIBLE_NUM(117)
#define locationW FLEXIBLE_NUM(95)
#define locationH FLEXIBLE_NUM(95)

@implementation ChatFrameModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setMessageModel:(ChatMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    if (messageModel.message.chatType == EMChatTypeGroupChat) {
        [self setGroupFrameWithMessageModel:messageModel];
    }else{
        [self setFriendFrameWithMessageModel:messageModel];
    }
}

//单聊frame
- (void)setFriendFrameWithMessageModel:(ChatMessageModel *)messageModel
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的Frame
    _timeFrame = CGRectZero;
    if (messageModel.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    
    
    //2.头像的Frame
    CGFloat iconFrameX = messageModel.isFromOther ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //名字
    _nameFrame = CGRectZero;
    
    //3.内容的Frame
    CGFloat textFrameY = iconFrameY;
    [self contentFrameWithMessageModel:messageModel frameY:textFrameY];
    _textEdgeInset = messageModel.isFromOther ? UIEdgeInsetsMake(textPadding,textPadding*3/2,textPadding, textPadding) : UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding*3/2);
    
    //语音
    CGFloat voiceFrameX = messageModel.isFromOther ? textPadding*3/2 : CGRectGetWidth(_textFrame)-FLEXIBLE_NUM(20)-textPadding*3/2;
    _voiceFrame = CGRectMake(voiceFrameX,_textFrame.size.height/2-FLEXIBLE_NUM(10),FLEXIBLE_NUM(20), FLEXIBLE_NUM(20));
    
    //菊花
    CGSize indicatorSize = FLEXIBLE_SIZE(20,20);
    CGFloat indicatorY = CGRectGetMidY(_textFrame)-indicatorSize.height/2+padding;
    CGFloat indicatorX = messageModel.isFromOther ? CGRectGetMaxX(_textFrame)+indicatorSize.width+FLEXIBLE_NUM(5) : CGRectGetMinX(_textFrame)-indicatorSize.width-FLEXIBLE_NUM(5);
    
    _indicatorFrame = (CGRect){indicatorX,indicatorY,indicatorSize};
    
    //4.cell的高度
    _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding*2;

}

//群组frame
- (void)setGroupFrameWithMessageModel:(ChatMessageModel *)messageModel
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的Frame
    //    _timeFrame = CGRectMake(0, 0,MAINSCRREN_W,0);
    _timeFrame = CGRectZero;
    if (messageModel.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX,timeFrameY, timeFrameW, timeFrameH);
    }
    
    
    //2.头像的Frame
    CGFloat iconFrameX = messageModel.isFromOther ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame)+padding;
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //名字
    CGFloat nameFrameY = iconFrameY + padding/2;
    CGFloat nameFrameW = MAINSCRREN_W - padding*2 - iconFrameW;
    CGFloat nameFrameX = messageModel.isFromOther ?  CGRectGetMaxX(_iconFrame) + padding : MAINSCRREN_W-(padding*2 + iconFrameW + nameFrameW);
    CGFloat nameFrameH = FLEXIBLE_NUM(16);
    _nameFrame = messageModel.isFromOther ? CGRectMake(nameFrameX, nameFrameY, nameFrameW, nameFrameH) : CGRectMake(nameFrameX, nameFrameY, nameFrameW, nameFrameH);
    
    //3.内容的Frame.
    CGFloat textFrameY = messageModel.isFromOther ? CGRectGetMaxY(_iconFrame)-padding-FLEXIBLE_NUM(5) : CGRectGetMaxY(_iconFrame)-padding-FLEXIBLE_NUM(5);
    [self contentFrameWithMessageModel:messageModel frameY:textFrameY];
    
    //4.内容的insert 
    _textEdgeInset = messageModel.isFromOther ? UIEdgeInsetsMake(textPadding,textPadding*3/2,textPadding, textPadding) : UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding*3/2);
    
    //语音
    CGFloat voiceFrameX = messageModel.isFromOther ? textPadding*3/2 : CGRectGetWidth(_textFrame)-FLEXIBLE_NUM(20)-textPadding*3/2;
    _voiceFrame = CGRectMake(voiceFrameX,_textFrame.size.height/2-FLEXIBLE_NUM(10),FLEXIBLE_NUM(20), FLEXIBLE_NUM(20));
    
    //菊花
    CGSize indicatorSize = FLEXIBLE_SIZE(20,20);
    CGFloat indicatorY = CGRectGetMidY(_textFrame)-indicatorSize.height/2+padding;
    CGFloat indicatorX = messageModel.isFromOther ? CGRectGetMaxX(_textFrame)+indicatorSize.width+FLEXIBLE_NUM(5) : CGRectGetMinX(_textFrame)-indicatorSize.width-FLEXIBLE_NUM(5);
    
    _indicatorFrame = (CGRect){indicatorX,indicatorY,indicatorSize};
    //4.cell的高度
    _cellHeight = MAX(CGRectGetMaxY(_iconFrame),CGRectGetMaxY(_textFrame)) + padding;
}

- (void)contentFrameWithMessageModel:(ChatMessageModel *)messageModel frameY:(CGFloat)frameY
{
    //默认文字~
    CGSize textMaxSize = CGSizeMake(MAINSCRREN_W-(2 * padding + iconW)*2+FLEXIBLE_NUM(5), MAXFLOAT);
    CGSize textSize = [messageModel.text sizeWithFont:[UIFont systemFontOfSize:FLEXIBLE_NUM(14.0)] maxSize:textMaxSize];
    CGSize textRealSize = CGSizeMake(textSize.width+textPadding*5/2+2,textSize.height + textPadding*2+2);
    CGFloat textFrameY = frameY;
    CGFloat textFrameX = messageModel.isFromOther ? (2 * padding + iconW) : (MAINSCRREN_W - (padding * 2 + iconW + textRealSize.width));
    
    EMMessageBodyType messageBodyType = messageModel.messageBodyType;
    switch (messageBodyType) {
        case EMMessageBodyTypeVoice:
        {
            CGSize voiceSize = [@"后台傻逼~后台傻逼~" sizeWithFont:[UIFont systemFontOfSize:FLEXIBLE_NUM(14.0)] maxSize:textMaxSize];
            textRealSize = CGSizeMake(voiceSize.width,voiceSize.height+textPadding*2+2);
        }
            break;
        case EMMessageBodyTypeCustom:
        {
            textRealSize = [self textRealSizeWithMessageExt:messageModel.messageExt];
        }
            break;
        default:
            break;
    }
    textFrameX = messageModel.isFromOther ? (2 * padding + iconW) : (MAINSCRREN_W - (padding * 2 + iconW + textRealSize.width));
    
    _textFrame = (CGRect){textFrameX,textFrameY,textRealSize};
}

- (CGSize)textRealSizeWithMessageExt:(NSDictionary *)messageExt
{
    NSInteger resultValue = [messageExt[@"resultValue"] integerValue];
    CGSize textRealSize = CGSizeZero;
    switch (resultValue) {
        case 1://摇钱树
        {
            textRealSize = CGSizeMake(100, 100);
        }
            break;
        case 2://供应链接
        {
            ChatSupplyLinkView *supplyLinkView = [[ChatSupplyLinkView alloc]init];
            textRealSize = supplyLinkView.frame.size;
        }
            break;
        case 3://供应链接
        {
            ChatSupplyLinkView *supplyLinkView = [[ChatSupplyLinkView alloc]init];
            textRealSize = supplyLinkView.frame.size;
        }
            break;
            
        default:
            textRealSize = CGSizeZero;
            break;
    }
    return textRealSize;
}


@end

