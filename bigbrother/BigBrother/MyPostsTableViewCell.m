//
//  MyPostsTableViewCell.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/5.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "MyPostsTableViewCell.h"

@implementation MyPostsTableViewCell{
    UILabel *postTypeShowLabel;
    
    UILabel *statusLabel;
    
    UIView *centerMatchView;
    UILabel *centerMatchNoteLabel;
    UILabel *centerMatchCountLabel;
    UIImageView *centerMoreImage;
    
    UIView *bottomView;
    
    UILabel *bottomStatusLabel;
    
    UIButton *onTopButton;
    UIButton *editButton;
    UIButton *deleteButton;
    UILabel *pointsCountLabel;
    
    UIView *topBottomSepLineView;
    UIView *centerBottomSepLineView;
    UIView *bottomBottomSepView;
}

static float centerViewHeight = 40.f;
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
        
        centerMatchView = [[UIView alloc] init];
        [self.contentView addSubview:centerMatchView];
        
        [centerMatchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerMatchViewTap)]];
        
        centerMatchNoteLabel = [[UILabel alloc] init];
        centerMatchNoteLabel.font = Font(15);
        centerMatchNoteLabel.textColor = RGBColor(50, 50, 50);
        centerMatchNoteLabel.textAlignment = NSTextAlignmentLeft;
        [centerMatchView addSubview:centerMatchNoteLabel];
        
        centerMatchCountLabel = [[UILabel alloc] init];
        centerMatchCountLabel.font = Font(15);
        centerMatchCountLabel.textColor = BB_BlueColor;
        centerMatchCountLabel.textAlignment = NSTextAlignmentRight;
        [centerMatchView addSubview:centerMatchCountLabel];
        
        centerMoreImage = [[UIImageView alloc] init];
        centerMoreImage.image = [UIImage imageNamed:@"icon_more"];
        [centerMatchView addSubview:centerMoreImage];
        
        centerBottomSepLineView = [[UIView alloc] init];
        centerBottomSepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
        [centerMatchView addSubview:centerBottomSepLineView];
        
        bottomView = [[UIView alloc] init];
        [self.contentView addSubview:bottomView];
        
        bottomStatusLabel = [[UILabel alloc] init];
        bottomStatusLabel.font = Font(15);
        bottomStatusLabel.textColor = BB_BlueColor;
        bottomStatusLabel.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:bottomStatusLabel];
        
        onTopButton = [[UIButton alloc] init];
        onTopButton.backgroundColor = BB_BlueColor;
        onTopButton.layer.cornerRadius = 2.f;
        onTopButton.layer.masksToBounds = YES;
        onTopButton.titleLabel.font = Font(13);
        [onTopButton setTitle:@"置顶" forState:UIControlStateNormal];
        [onTopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [onTopButton addTarget:self action:@selector(onTopButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:onTopButton];
        
        editButton = [[UIButton alloc] init];
        editButton.backgroundColor = BB_BlueColor;
        editButton.layer.cornerRadius = 2.f;
        editButton.layer.masksToBounds = YES;
        editButton.titleLabel.font = Font(13);
        [editButton setTitle:@"" forState:UIControlStateNormal];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:editButton];
        
        deleteButton = [[UIButton alloc] init];
        deleteButton.backgroundColor = BB_BlueColor;
        deleteButton.layer.cornerRadius = 2.f;
        deleteButton.layer.masksToBounds = YES;
        deleteButton.titleLabel.font = Font(13);
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:deleteButton];
        
        pointsCountLabel = [[UILabel alloc] init];
        pointsCountLabel.font = Font(15);
        pointsCountLabel.textColor = BB_BlueColor;
        pointsCountLabel.textAlignment = NSTextAlignmentRight;
        [bottomView addSubview:pointsCountLabel];
        
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
    
    if (self.postInfo.infoType == MyPostInfoTableShowTypeUnAuth) {
        centerMatchView.hidden = YES;
    }else if (self.postInfo.infoType == MyPostInfoTableShowTypeShowing) {
        centerMatchView.hidden = NO;
        centerMatchView.frame = (CGRect){0,offsetHieght,WIDTH(self.contentView),40};
        centerMatchNoteLabel.frame = (CGRect){15,0,WIDTH(centerMatchView)/2-15,HEIGHT(centerMatchView)};
        centerMatchCountLabel.frame = (CGRect){WIDTH(centerMatchView)/2,0,WIDTH(centerMatchView)/2-10-15,HEIGHT(centerMatchView)};
        centerMoreImage.frame = (CGRect){WIDTH(centerMatchView)-15-7,(HEIGHT(centerMatchView)-11)/2,7,11};
        centerBottomSepLineView.frame = (CGRect){0,HEIGHT(centerMatchView)-0.5,WIDTH(centerMatchView),0.5};
        offsetHieght += HEIGHT(centerMatchView);
    }else if (self.postInfo.infoType == MyPostInfoTableShowTypeDone) {
        centerMatchView.hidden = NO;
        centerMatchView.frame = (CGRect){0,offsetHieght,WIDTH(self.contentView),40};
        centerMatchNoteLabel.frame = (CGRect){15,0,WIDTH(centerMatchView)/2-15,HEIGHT(centerMatchView)};
        centerMatchCountLabel.hidden = YES;
        centerMoreImage.frame = (CGRect){WIDTH(centerMatchView)-15-7,(HEIGHT(centerMatchView)-11)/2,7,11};
        centerBottomSepLineView.frame = (CGRect){0,HEIGHT(centerMatchView)-0.5,WIDTH(centerMatchView),0.5};
        offsetHieght += HEIGHT(centerMatchView);
    }
    bottomView.frame = (CGRect){0,offsetHieght,WIDTH(self.contentView),40};
    
    offsetHieght += HEIGHT(bottomView);
    if (self.postInfo.infoType == MyPostInfoTableShowTypeUnAuth) {
        bottomStatusLabel.hidden = NO;
        onTopButton.hidden = YES;
        editButton.hidden = YES;
        deleteButton.hidden = NO;
        pointsCountLabel.hidden = YES;
        
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        bottomStatusLabel.frame = (CGRect){15,0,100,HEIGHT(bottomView)};
        deleteButton.frame = (CGRect){WIDTH(bottomView)-15-60,9,60,24};
    }else if (self.postInfo.infoType == MyPostInfoTableShowTypeShowing) {
        bottomStatusLabel.hidden = YES;
        onTopButton.hidden = NO;
        editButton.hidden = NO;
        deleteButton.hidden = NO;
        pointsCountLabel.hidden = YES;
        
        [editButton setTitle:@"" forState:UIControlStateNormal];
        if ([self.postInfo.status isEqualToString:@"SHOWING"]) {
            [editButton setTitle:@"下架" forState:UIControlStateNormal];
        }else if ([self.postInfo.status isEqualToString:@"CANCELED"]) {
            [editButton setTitle:@"上架" forState:UIControlStateNormal];
        }
        [deleteButton setTitle:@"详情" forState:UIControlStateNormal];
        deleteButton.frame = (CGRect){WIDTH(bottomView)-15-60,9,60,24};
        editButton.frame = (CGRect){WIDTH(bottomView)-15-60-10-60,9,60,24};
        onTopButton.frame = (CGRect){WIDTH(bottomView)-15-60-10-60-10-60,9,60,24};
    }else if (self.postInfo.infoType == MyPostInfoTableShowTypeDone) {
        bottomStatusLabel.hidden = NO;
        onTopButton.hidden = YES;
        editButton.hidden = YES;
        deleteButton.hidden = YES;
        pointsCountLabel.hidden = NO;
        bottomStatusLabel.frame = (CGRect){15,0,100,HEIGHT(bottomView)};
        
        pointsCountLabel.frame = (CGRect){WIDTH(bottomView)-15-150,0,150,HEIGHT(bottomView)};
    }
    bottomBottomSepView.frame = (CGRect){0,offsetHieght,WIDTH(self.contentView),bottomBottomSepViewHeight};
}

-(void)centerMatchViewTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myPostTableCell:didTapMatchView:)]) {
        [self.delegate myPostTableCell:self didTapMatchView:centerMatchView];
    }
}

-(void)onTopButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myPostTableCell:didClickOnTopButton:)]) {
        [self.delegate myPostTableCell:self didClickOnTopButton:onTopButton];
    }
}

-(void)editButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myPostTableCell:didClickEditButton:)]) {
        [self.delegate myPostTableCell:self didClickEditButton:editButton];
    }
}

-(void)deleteButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myPostTableCell:didClickDeleteButton:)]) {
        [self.delegate myPostTableCell:self didClickDeleteButton:deleteButton];
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
        int matchCount = postInfo.matchedCount;
        if (postInfo.infoType == MyPostInfoTableShowTypeUnAuth) {
            centerMatchView.hidden = YES;
            centerMatchNoteLabel.text = @"";
            centerMatchCountLabel.text = @"";
            bottomStatusLabel.textColor = BB_BlueColor;
            onTopButton.hidden = YES;
            editButton.hidden = NO;
            deleteButton.hidden = NO;
            pointsCountLabel.hidden = YES;
            pointsCountLabel.text = @"";
        }else if (postInfo.infoType == MyPostInfoTableShowTypeShowing) {
            centerMatchView.hidden = NO;
            centerMatchNoteLabel.text = @"匹配的信息";
            centerMatchCountLabel.text = [NSString stringWithFormat:@"%d条",matchCount];
            onTopButton.hidden = NO;
            editButton.hidden = NO;
            deleteButton.hidden = NO;
            pointsCountLabel.hidden = YES;
            pointsCountLabel.text = @"";
        }else if (postInfo.infoType == MyPostInfoTableShowTypeDone) {
            centerMatchView.hidden = NO;
            centerMatchNoteLabel.text = @"认可的信息";
            centerMatchCountLabel.text = @"";
            bottomStatusLabel.textColor = RGBColor(150, 150, 150);
            onTopButton.hidden = YES;
            editButton.hidden = YES;
            deleteButton.hidden = YES;
            pointsCountLabel.hidden = NO;
            //todo 具体点数服务器没有接口获取
            pointsCountLabel.text = [NSString stringWithFormat:@"%@%d点",postInfo.isProvide?@"收入：":@"消费：",0];
        }
        NSString *showingStatus = postInfo.showingStatus;
        if (showingStatus) {
            bottomStatusLabel.text = showingStatus;
        }else{
            bottomStatusLabel.text = @"";
        }
        if (postInfo.onTop) {
            [onTopButton setTitle:@"已置顶" forState:UIControlStateNormal];
        }else{
            [onTopButton setTitle:@"置顶" forState:UIControlStateNormal];
        }
    }
}

+(CGFloat)staticHeightWithPostInfo:(MyPostInfo *)postInfo{
    NSString *status = postInfo.status;
    //todo 还需要判断一个 审核未通过的判断
    if ([status isEqualToString:@"PENDING_AUDIT"]) {
        return 60+centerViewHeight+bottomBottomSepViewHeight;
    }else{
        return 60+centerViewHeight*2+bottomBottomSepViewHeight;
    }
    return 60+centerViewHeight+bottomBottomSepViewHeight;
}

@end
