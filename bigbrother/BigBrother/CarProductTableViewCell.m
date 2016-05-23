//
//  CarProductTableViewCell.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CarProductTableViewCell.h"
#import "RentCarProduct.h"
#import "HelpDriveProduct.h"
#import "CarPoolProduct.h"

@implementation CarProductTableViewCell{
    UILabel *titleLabel;
    
    UILabel *personCountLabel;
    
    UIView *lineSepView;
    
    BOOL hasImage;
    
    NSMutableAttributedString *titleString;
    
    NSString *subTitleString;
    
    NSString *timeString;
    
    NSString *personString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.imageView.backgroundColor = [UIColor redColor];
        self.imageView.layer.cornerRadius = 2.f;
        self.imageView.layer.masksToBounds = YES;
        
        self.textLabel.font = Font(13);
        self.textLabel.textColor = RGBColor(140, 140, 140);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
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
        
        personCountLabel = [[UILabel alloc] init];
        personCountLabel.font = Font(13);
        personCountLabel.textColor = RGBColor(140, 140, 140);
        personCountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:personCountLabel];
        
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
    
    float personLabelWidth = 40;
    if (self.product.carType == CarProductPinChe) {
        personLabelWidth = 120;
    }
    
    self.textLabel.frame = (CGRect){LEFT(titleLabel)+8,HEIGHT(self.contentView)-upOriginY-15-5-15,WIDTH(titleLabel)-personLabelWidth,15};
    self.textLabel.text = subTitleString;
    
    personCountLabel.text = personString;
    personCountLabel.frame = (CGRect){WIDTH(titleLabel)-personLabelWidth,Y(self.textLabel),personLabelWidth,15};
    
    self.detailTextLabel.text = timeString;
    self.detailTextLabel.frame = (CGRect){LEFT(titleLabel)+8,HEIGHT(self.contentView)-upOriginY-15,WIDTH(titleLabel),15};
    
    lineSepView.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
}

-(void)setProduct:(CarProduct *)product{
    _product = product;
    if (product) {
        NSArray *images = product.images;
        if (!images || images.count == 0) {
            hasImage = NO;
        }else{
            NSString *imageUrl = [[images firstObject] objectForKey:@"url"];
            if (imageUrl) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                hasImage = YES;
            }else{
                hasImage = NO;
            }
        }
        
        NSString *title = product.title;
        if (!title) {
            title = @"标题";
        }
        if (product.carType == CarProductPinChe) {
            CarPoolProduct *carPoolProduct = (CarPoolProduct *)product;
            NSString *start = carPoolProduct.start;
            NSString *destination = carPoolProduct.destination;
            
            if (!start) {
                start = @"";
            }
            if (!destination) {
                destination = @"";
            }
            title = [start stringByAppendingString:[NSString stringWithFormat:@" - %@",destination]];
        }
        NSMutableAttributedString *attriTitle;
        NSString *styleStr = product.isSupply?@"供应":@"需求";
        NSString *tempStr = [NSString stringWithFormat:@"【%@】%@",styleStr,title];
        attriTitle = [[NSMutableAttributedString alloc] initWithString:tempStr];
        
        
        [attriTitle addAttribute:NSForegroundColorAttributeName
                           value:BB_BlueColor
                           range:[tempStr rangeOfString:[NSString stringWithFormat:@"【%@】",styleStr]]];
        [attriTitle addAttribute:NSForegroundColorAttributeName
                           value:RGBColor(50, 50, 50)
                           range:[tempStr rangeOfString:title]];
        
        titleString = attriTitle;
        
        NSString *timeTmpString = product.createTime;
        timeString = [XYTools judgeIfToday:timeTmpString];
        
        if (product.carType == CarProductZuChe) {
            RentCarProduct *rentCarProduct = (RentCarProduct *)product;
            if (product.isSupply) {
                NSArray *cartypeList = rentCarProduct.carTypeList;
                NSMutableArray *arTmp = [NSMutableArray array];
                for (NSDictionary *carTypeDic in cartypeList) {
                    NSString *carTypeName = carTypeDic[@"name"];
                    [arTmp addObject:carTypeName];
                }
                subTitleString = [arTmp componentsJoinedByString:@"、 "];
                
                personCountLabel.hidden = YES;
                personString = @"";
            }else{
                if (rentCarProduct.dayCount == 0) {
                    subTitleString = @"";
                }else{
                    subTitleString = [NSString stringWithFormat:@"租%d天",rentCarProduct.dayCount];
                }
                
                personCountLabel.hidden = NO;
                personString = [NSString stringWithFormat:@"%d人",rentCarProduct.personCount];
            }
        }else if (product.carType == CarProductDaiJia){
            personString = @"";
            personCountLabel.hidden = YES;
            HelpDriveProduct *helpDriveProduct = (HelpDriveProduct *)product;
            if (product.isSupply) {
                NSString *districtFullName = helpDriveProduct.districtFullName;
                subTitleString = districtFullName;
            }else{
                if (helpDriveProduct.dayCount == 0) {
                    subTitleString = @"";
                }else{
                    subTitleString = [NSString stringWithFormat:@"租%d天",helpDriveProduct.dayCount];
                }
            }
        }else if (product.carType == CarProductPinChe){
            CarPoolProduct *carPoolP = (CarPoolProduct *)product;
            
            NSString *districtFullName = carPoolP.districtFullName;
            subTitleString = districtFullName;
            
            NSString *leaveTime = carPoolP.leaveTime;
            if (!leaveTime || ![leaveTime isKindOfClass:[NSString class]] || [leaveTime isEqualToString:@""]) {
                leaveTime = @"未知时间";
            }
            personString = [NSString stringWithFormat:@"%@出发",leaveTime];
            personCountLabel.hidden = NO;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
