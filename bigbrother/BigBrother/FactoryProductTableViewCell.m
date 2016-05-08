//
//  FactoryProductTableViewCell.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "FactoryProductTableViewCell.h"

@implementation FactoryProductTableViewCell{
    UILabel *titleLabel;
    
    UIView *lineSepView;
    
    BOOL hasImage;
    
    NSMutableAttributedString *titleString;
    
    NSString *timeString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.imageView.backgroundColor = [UIColor redColor];
        self.imageView.layer.cornerRadius = 2.f;
        self.imageView.layer.masksToBounds = YES;
        
        //        self.textLabel.font = Font(13);
        //        self.textLabel.textColor = RGBColor(140, 140, 140);
        //        self.textLabel.textAlignment = NSTextAlignmentLeft;
        //        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.detailTextLabel.font = Font(13);
        self.detailTextLabel.textColor = RGBColor(140, 140, 140);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = Font(15);
        titleLabel.textColor = RGBColor(50, 50, 50);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        //        
        //        personCountLabel = [[UILabel alloc] init];
        //        personCountLabel.font = Font(13);
        //        personCountLabel.textColor = RGBColor(140, 140, 140);
        //        personCountLabel.textAlignment = NSTextAlignmentRight;
        //        [self.contentView addSubview:personCountLabel];
        
        lineSepView = [[UIView alloc] init];
        lineSepView.backgroundColor = RGBAColor(200, 200, 200,0.5);
        [self.contentView addSubview:lineSepView];
    }
    return self;
}

- (void)layoutSubviews{
    float imageWidth = 0;
    float upOriginY = 10;
    float leftOriginX = 10;
    float leftLabelOriginX = 10;
    
    if (hasImage) {
        imageWidth = 100;
        leftLabelOriginX = leftOriginX+imageWidth+leftOriginX;
    }
    self.imageView.frame = (CGRect){leftOriginX,upOriginY,imageWidth,HEIGHT(self.contentView)-upOriginY*2};
    
    float titleMaxSize = WIDTH(self.contentView)-leftLabelOriginX-leftOriginX;
    
    CGSize textlabelSize = [XYTools getSizeWithString:titleString.string andSize:(CGSize){titleMaxSize,MAXFLOAT} andFont:Font(15)];
    
    titleLabel.attributedText = titleString;
    titleLabel.frame = (CGRect){leftLabelOriginX,upOriginY,titleMaxSize,MIN(40, textlabelSize.height)};
    
    //    self.textLabel.frame = (CGRect){LEFT(titleLabel)+8,HEIGHT(self.contentView)-upOriginY-15-5-15,WIDTH(titleLabel),15};
    //    self.textLabel.text = subTitleString;
    self.textLabel.hidden = YES;
    
    self.detailTextLabel.frame = (CGRect){LEFT(titleLabel)+8,HEIGHT(self.contentView)-upOriginY-15,WIDTH(titleLabel),15};
    self.detailTextLabel.text = timeString;
    
    lineSepView.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
}

-(void)setProduct:(FactoryProduct *)product{
    _product = product;
    if (product) {
        NSArray *images = product.images;
        if (!images || images.count == 0) {
            hasImage = NO;
        }else{
            NSString *imageUrl = [[images firstObject] objectForKey:@"url"];
            if (imageUrl) {
                [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
                hasImage = YES;
            }else{
                hasImage = NO;
            }
        }
        
        NSString *title = product.title;
        if (!title) {
            title = @"标题";
        }
        
        NSMutableAttributedString *attriTitle;
        attriTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"【%@】%@",product.isSupply?@"供应":@"需求",title]];
        [attriTitle addAttribute:NSForegroundColorAttributeName
                           value:(id)BB_BlueColor.CGColor
                           range:NSMakeRange(0, 4)];
        
        [attriTitle addAttribute:NSForegroundColorAttributeName
                           value:(id)RGBColor(50, 50, 50).CGColor
                           range:NSMakeRange(4, attriTitle.length-4)];
        titleString = attriTitle;
        
        NSString *timeTmpString = product.createTime;
        timeString = [XYTools judgeIfToday:timeTmpString];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
