//
//  PostMacthTableViewCell.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/12.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "PostMacthTableViewCell.h"

@implementation PostMacthTableViewCell{
    UILabel *postTypeShowLabel;
    
    UIView *bottomView;
    
    UIButton *ignoreButton;
    UIButton *acceptButton;
    UIButton *detailButton;
    
    UIView *topBottomSepLineView;
    UIView *bottomBottomSepView;
}

static float bottomBottomSepViewHeight = 10.f;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        postTypeShowLabel = [[UILabel alloc] init];
        postTypeShowLabel.font = Font(12);
        postTypeShowLabel.textColor = RGBColor(100, 100, 100);
        postTypeShowLabel.textAlignment = NSTextAlignmentRight;
        postTypeShowLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:postTypeShowLabel];
        
        self.textLabel.font = Font(15);
        self.textLabel.textColor = RGBColor(50, 50, 50);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        self.detailTextLabel.textColor = RGBColor(100, 100, 100);
        self.detailTextLabel.font = Font(12);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        bottomView = [[UIView alloc] init];
        [self.contentView addSubview:bottomView];
        
        ignoreButton = [[UIButton alloc] init];
        ignoreButton.backgroundColor = BB_BlueColor;
        ignoreButton.layer.cornerRadius = 2.f;
        ignoreButton.layer.masksToBounds = YES;
        ignoreButton.titleLabel.font = Font(13);
        [ignoreButton setTitle:@"忽略" forState:UIControlStateNormal];
        [ignoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ignoreButton addTarget:self action:@selector(ignoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:ignoreButton];
        
        acceptButton = [[UIButton alloc] init];
        acceptButton.backgroundColor = BB_BlueColor;
        acceptButton.layer.cornerRadius = 2.f;
        acceptButton.layer.masksToBounds = YES;
        acceptButton.titleLabel.font = Font(13);
        [acceptButton setTitle:@"认可" forState:UIControlStateNormal];
        [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [acceptButton addTarget:self action:@selector(acceptButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:acceptButton];
        
        detailButton = [[UIButton alloc] init];
        detailButton.backgroundColor = BB_BlueColor;
        detailButton.layer.cornerRadius = 2.f;
        detailButton.layer.masksToBounds = YES;
        detailButton.titleLabel.font = Font(13);
        [detailButton setTitle:@"详情" forState:UIControlStateNormal];
        [detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:detailButton];
        
        topBottomSepLineView = [[UIView alloc] init];
        topBottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [self.contentView addSubview:topBottomSepLineView];
        
        bottomBottomSepView = [[UIView alloc] init];
        bottomBottomSepView.backgroundColor = BB_WhiteColor;
        [self.contentView addSubview:bottomBottomSepView];
    }
    return self;
}

-(void)layoutSubviews{
    self.textLabel.frame = (CGRect){15,8,WIDTH(self.contentView)-15*2,20};
    
    self.detailTextLabel.frame = (CGRect){15,BOTTOM(self.textLabel)+10,WIDTH(self.contentView)-15-15-100,15};
    
    postTypeShowLabel.frame = (CGRect){WIDTH(self.contentView)-15-100,TOP(self.detailTextLabel),100,HEIGHT(self.detailTextLabel)};
    
    topBottomSepLineView.frame = (CGRect){0,60-0.5,WIDTH(self.contentView),0.5};
    
    float offsetHieght = BOTTOM(topBottomSepLineView);
    
    bottomView.frame = (CGRect){0,offsetHieght,WIDTH(self.contentView),40};
    
    offsetHieght += HEIGHT(bottomView);
    if (self.tableType == PostMacthTableTypeMine) {
        ignoreButton.hidden = YES;
        acceptButton.hidden = YES;
        detailButton.hidden = NO;
        
        detailButton.frame = (CGRect){WIDTH(bottomView)-15-60,9,60,24};
    }else if (self.tableType == PostMacthTableTypeNeither) {
        ignoreButton.hidden = NO;
        acceptButton.hidden = NO;
        detailButton.hidden = NO;
        
        detailButton.frame = (CGRect){WIDTH(bottomView)-15-60,9,60,24};
        acceptButton.frame = (CGRect){WIDTH(bottomView)-15-60-10-60,9,60,24};
        ignoreButton.frame = (CGRect){WIDTH(bottomView)-15-60-10-60-10-60,9,60,24};
    }else if (self.tableType == PostMacthTableTypeOther) {
        ignoreButton.hidden = YES;
        acceptButton.hidden = YES;
        detailButton.hidden = NO;
        
        detailButton.frame = (CGRect){WIDTH(bottomView)-15-60,9,60,24};
    }
    bottomBottomSepView.frame = (CGRect){0,offsetHieght,WIDTH(self.contentView),bottomBottomSepViewHeight};
}

-(void)ignoreButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postMatchTableCell:didClickIgnoreButton:)]) {
        [self.delegate postMatchTableCell:self didClickIgnoreButton:ignoreButton];
    }
}

-(void)acceptButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postMatchTableCell:didClickAcceptButton:)]) {
        [self.delegate postMatchTableCell:self didClickAcceptButton:acceptButton];
    }
}

-(void)detailButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postMatchTableCell:didClickDetailButton:)]) {
        [self.delegate postMatchTableCell:self didClickDetailButton:detailButton];
    }
}

-(void)setPostInfo:(MyPostInfo *)postInfo{
    _postInfo = postInfo;
    if (postInfo) {
        NSString *showType = postInfo.showingPostType;
        if (showType) {
            postTypeShowLabel.text = [NSString stringWithFormat:@"【%@】",showType];
        }else{
            postTypeShowLabel.text = @"";
        }
        
        NSString *createTime = postInfo.createdTime;
        if (createTime) {
            self.detailTextLabel.text = [NSString stringWithFormat:@"发布时间:%@",createTime];
        }else{
            self.detailTextLabel.text = @"";
        }
        NSString *titleString = postInfo.title;
        if (titleString) {
            self.textLabel.text = titleString;
        }else{
            self.textLabel.text = @"";
        }
        //        if (self.tableType == PostMacthTableTypeNeither) {
        //            
        //        }else if (self.tableType == PostMacthTableTypeOther){
        //            
        //        }else if (self.tableType == PostMacthTableTypeMine){
        //            
        //        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
