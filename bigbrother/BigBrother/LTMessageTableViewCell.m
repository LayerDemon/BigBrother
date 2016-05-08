//
//  LTMessageTableViewCell.m
//  BigBrother
//
//  Created by StephenGao on 16/3/20.
//  Copyright © 2016年 bigbrother. All rights reserved.
//
#import "LTMessageTableViewCell.h"

@implementation LTMessageTableViewCell{
    UIButton *userHeadB;
    UILabel *userNameL;
    UILabel *userMessageL;
    UILabel *timeL;
    UIButton *noticeB;
    UIView *lineSepView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        userHeadB = [[UIButton alloc]init];
        userHeadB.layer.masksToBounds = YES;
        [self.contentView addSubview:userHeadB];
        
        userNameL = [[UILabel alloc] init];
        userNameL.font = Font(15);
        userNameL.textColor = [UIColor blackColor];
        userNameL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:userNameL];
        
        userMessageL = [[UILabel alloc] init];
        userMessageL.font = Font(13);
        userMessageL.textColor = [UIColor lightGrayColor];
        userMessageL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:userMessageL];
        
        timeL = [[UILabel alloc] init];
        timeL.font = Font(13);
        timeL.textColor = [UIColor lightGrayColor];
        timeL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeL];
        
        noticeB = [[UIButton alloc]init];
        [noticeB setBackgroundColor:[UIColor redColor]];
        [noticeB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        noticeB.layer.masksToBounds = YES;
        [self.contentView addSubview:noticeB];
        
        lineSepView = [[UIView alloc] init];
        lineSepView.backgroundColor = RGBAColor(200, 200, 200,0.5);
        [self.contentView addSubview:lineSepView];
    }
    return self;
}

- (void)layoutSubviews{
    float imageWidth = 45;
//    float upOriginY = 10;
    float leftOriginX = 10;
    
    userHeadB.frame = (CGRect){leftOriginX,(HEIGHT(self.contentView)-imageWidth)/2.0,imageWidth,imageWidth};
    userHeadB.backgroundColor = [UIColor grayColor];
    userHeadB.layer.cornerRadius = imageWidth/2.0;
    
    
    
    lineSepView.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
}

//-(void)setProduct:(FactoryProduct *)product{
//    _product = product;
//    if (product) {
//        NSArray *images = product.images;
//        if (!images || images.count == 0) {
//            hasImage = NO;
//        }else{
//            NSString *imageUrl = [[images firstObject] objectForKey:@"url"];
//            if (imageUrl) {
//                [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
//                hasImage = YES;
//            }else{
//                hasImage = NO;
//            }
//        }
//        
//        NSString *title = product.title;
//        if (!title) {
//            title = @"标题";
//        }
//        
//        NSMutableAttributedString *attriTitle;
//        attriTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"【%@】%@",product.isSupply?@"供应":@"需求",title]];
//        [attriTitle addAttribute:NSForegroundColorAttributeName
//                           value:(id)BB_BlueColor.CGColor
//                           range:NSMakeRange(0, 4)];
//        
//        [attriTitle addAttribute:NSForegroundColorAttributeName
//                           value:(id)RGBColor(50, 50, 50).CGColor
//                           range:NSMakeRange(4, attriTitle.length-4)];
//        titleString = attriTitle;
//        
//        NSString *timeTmpString = product.createTime;
//        timeString = [XYTools judgeIfToday:timeTmpString];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
