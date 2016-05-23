//
//  GroupInviteViewCell.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "GroupInviteViewCell.h"

@interface GroupInviteViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation GroupInviteViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GroupInviteViewCell" owner:self options:nil] lastObject];
        self.contentView.frame = FLEFRAME(self.contentView.frame);
        FLEXIBLE_FONT(self);
        self.contentView.autoresizesSubviews = NO;
        self.headImgView.layer.cornerRadius = FLEXIBLE_NUM(36)/2;
        self.headImgView.layer.masksToBounds = YES;
//        [self.headImgView setWidth:self.headImgView.frame.size.height];
    }
    return self;
}

#pragma mark - 加载数据
- (void)reloadWithDataDic:(NSDictionary *)dataDic
{
    self.dataDic = dataDic[@"friend"];
    NSString *urlStr = [NSString isBlankStringWithString:self.dataDic[@"avatar"]] ? @"" : self.dataDic[@"avatar"];
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:PLACEHOLDERIMAGE_USER completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.nameLabel.text = self.dataDic[@"nickname"];
}



@end
