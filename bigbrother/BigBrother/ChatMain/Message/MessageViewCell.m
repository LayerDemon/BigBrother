//
//  MessageViewCell.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/8.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MessageViewCell.h"

@interface MessageViewCell ()


@property (assign, nonatomic) NSInteger count;

@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;


@end

@implementation MessageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MessageViewCell" owner:self
                                            options:nil] lastObject];
        self.numLabel.layer.cornerRadius = FLEXIBLE_NUM(7);
        self.numLabel.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - 加载数据
- (void)loadDataWithConversation:(NSString *)conversation
{

}

#pragma mark - setter
- (void)setCount:(NSInteger)count
{
    _count = count;
    if (!count) {
        self.numLabel.hidden = YES;
    }
    
    
    NSString *title = [NSString stringWithFormat:@"%ld",(long)count];
    if (count > 99) {
        title = [NSString stringWithFormat:@"99+"];
    }
    
    CGSize size = [NSString sizeWithString:title Font:[UIFont systemFontOfSize:FLEXIBLE_NUM(12)] maxWidth:MAINSCRREN_W NumberOfLines:0];
    CGSize zeroSize = [NSString sizeWithString:@"1" Font:[UIFont systemFontOfSize:FLEXIBLE_NUM(12)] maxWidth:MAINSCRREN_W NumberOfLines:0];
    CGFloat offset = size.width - zeroSize.width;
    self.numLabel.text = title;
    
    self.numLabel.frame = CGRectMake(self.numLabel.frame.origin.x-offset,
                                     self.numLabel.frame.origin.y,
                                     self.numLabel.frame.size.width+offset,
                                     self.numLabel.frame.size.height);
}


@end
