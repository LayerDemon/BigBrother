//
//  HouseProductTableViewCell.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "HouseProductTableViewCell.h"

#import "SingleRoomRentProduct.h"
#import "WholeHouseRentProduct.h"
#import "FactoryHouseProduct.h"
#import "WholeHouseSellProduct.h"
#import "WantHouseProduct.h"

@implementation HouseProductTableViewCell{
    UILabel *titleLabel;
    
    UILabel *priceLabel;
    
    UIView *lineSepView;
    
    BOOL hasImage;
    
    NSMutableAttributedString *titleString;
    
    NSString *subTitleString;
    
    NSString *timeString;
    
    NSString *priceString;
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
        
        self.detailTextLabel.font = Font(13);
        self.detailTextLabel.textColor = RGBColor(140, 140, 140);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = Font(15);
        titleLabel.textColor = RGBColor(50, 50, 50);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        //        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        
        priceLabel = [[UILabel alloc] init];
        priceLabel.font = Font(16);
        priceLabel.textColor = BB_BlueColor;
        priceLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.minimumScaleFactor = 12.f/16;
        priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:priceLabel];
        
        
        lineSepView = [[UIView alloc] init];
        lineSepView.backgroundColor = RGBAColor(200, 200, 200,0.5);
        [self.contentView addSubview:lineSepView];
        
        //        self.textLabel.backgroundColor = [UIColor yellowColor];
        //        self.detailTextLabel.backgroundColor = [UIColor grayColor];
        //        titleLabel.backgroundColor = [UIColor redColor];
        //        priceLabel.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews{
    float imageWidth = 0;
    float upOriginY = 10;
    float leftOriginX = 10;
    float leftLabelOriginX = 10;
    
    if (hasImage) {
        imageWidth = HEIGHT(self.contentView);
        leftLabelOriginX = leftOriginX+imageWidth+leftOriginX;
    }
    self.imageView.frame = (CGRect){leftOriginX,upOriginY,imageWidth,HEIGHT(self.contentView)-upOriginY*2};
    
    float titleMaxSize = WIDTH(self.contentView)-leftLabelOriginX-leftOriginX;
    
    titleLabel.attributedText = titleString;
    self.textLabel.text = subTitleString;
    priceLabel.text = priceString;
    self.detailTextLabel.text = timeString;
    
    float priceLabelWidth = 40;
    
    if (self.product.houseType == HouseProductChangFangZuNin ||
        self.product.houseType == HouseProductChangFangQiuZu ||
        self.product.houseType == HouseProductChangFangXiaoShou ||
        self.product.houseType == HouseProductChangFangQiuGou){
        priceLabel.font = Font(14);
        priceLabel.minimumScaleFactor = 11.f/14;
        priceLabelWidth = 90;
        
        titleLabel.numberOfLines = 1;
        
        priceLabel.textAlignment = NSTextAlignmentRight;
        
        titleLabel.frame = (CGRect){leftLabelOriginX,upOriginY,titleMaxSize,16};
        
        self.textLabel.frame = (CGRect){LEFT(titleLabel)+8,HEIGHT(self.contentView)-upOriginY/2-15-5-15,WIDTH(titleLabel),15};
        priceLabel.frame = (CGRect){
            RIGHT(titleLabel)-priceLabelWidth,
            HEIGHT(self.contentView)-upOriginY/2-15,
            priceLabelWidth,
            15};
        self.detailTextLabel.frame = (CGRect){
            LEFT(titleLabel)+8,
            HEIGHT(self.contentView)-upOriginY/2-15,
            WIDTH(titleLabel)-WIDTH(priceLabel)-10,
            15};
    }else if (self.product.houseType == HouseProductFangWuQiuZu ||
              self.product.houseType == HouseProductFangWuQiuGou){
        
        priceLabel.font = Font(16);
        priceLabel.minimumScaleFactor = 12.f/16;
        priceLabel.textAlignment = NSTextAlignmentLeft;
        
        titleLabel.numberOfLines = 1;
        
        priceLabelWidth = 70;
        
        titleLabel.frame = (CGRect){leftLabelOriginX,upOriginY,titleMaxSize,16};
        
        self.textLabel.frame = (CGRect){LEFT(titleLabel)+8,HEIGHT(self.contentView)-upOriginY/2-15-5-15,WIDTH(titleLabel),15};
        
        priceLabel.frame = (CGRect){
            LEFT(titleLabel)+8,
            HEIGHT(self.contentView)-upOriginY/2-15,
            priceLabelWidth,
            15};
        self.detailTextLabel.frame = (CGRect){
            LEFT(titleLabel)+8+priceLabelWidth+5,
            HEIGHT(self.contentView)-upOriginY/2-15,
            WIDTH(titleLabel)-(WIDTH(priceLabel)+5),
            15};
    }else{
        priceLabel.font = Font(16);
        priceLabel.minimumScaleFactor = 12.f/16;
        priceLabel.textAlignment = NSTextAlignmentLeft;
        
        titleLabel.numberOfLines = 2;
        
        if (self.product.houseType == HouseProductDanjianZuNin) {
            priceLabelWidth = 50;
        }else if (self.product.houseType == HouseProductFangWuXiaoShou){
            priceLabelWidth = 70;
        }
        
        CGSize textlabelSize = [XYTools getSizeWithString:titleString.string andSize:(CGSize){titleMaxSize,MAXFLOAT} andFont:Font(15)];
        titleLabel.frame = (CGRect){leftLabelOriginX,upOriginY,titleMaxSize,MIN(40, textlabelSize.height)};
        
        self.textLabel.frame = (CGRect){LEFT(titleLabel)+8,HEIGHT(self.contentView)-upOriginY/2-15-5-15,WIDTH(titleLabel)-priceLabelWidth,15};
        priceLabel.frame = (CGRect){
            LEFT(titleLabel)+8,
            HEIGHT(self.contentView)-upOriginY/2-15,
            priceLabelWidth,
            15};
        self.detailTextLabel.frame = (CGRect){
            LEFT(titleLabel)+8+priceLabelWidth+5,
            HEIGHT(self.contentView)-upOriginY/2-15,
            WIDTH(titleLabel)-(WIDTH(priceLabel)+5),
            15};
    }
    
    lineSepView.frame = (CGRect){0,HEIGHT(self.contentView)-0.5,WIDTH(self.contentView),0.5};
}

-(void)setProduct:(HouseProduct *)product{
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
        
        
        if (product.houseType == HouseProductDanjianZuNin) {
            //单间租赁
            SingleRoomRentProduct *singleRoomProduct = (SingleRoomRentProduct *)product;
            NSString *districtFullName = singleRoomProduct.districtFullName;
            subTitleString = districtFullName;
            
            priceString = [NSString stringWithFormat:@"%d元",singleRoomProduct.price];
            //priceString = [NSString stringWithFormat:@"%d元",18888];
            
        }else if (product.houseType == HouseProductZhengTaoZuNin){
            //整套租赁
            WholeHouseRentProduct *wholeHouseRentProduct = (WholeHouseRentProduct *)product;
            NSString *districtFullName = wholeHouseRentProduct.districtFullName;
            subTitleString = districtFullName;
            float price = wholeHouseRentProduct.price;
            priceString = [NSString stringWithFormat:@"%d元",(int)price];
        }else if (product.houseType == HouseProductFangWuXiaoShou){
            //房屋销售
            WholeHouseSellProduct *wholeHouseSellProduct = (WholeHouseSellProduct *)product;
            NSString *districtFullName = wholeHouseSellProduct.districtFullName;
            subTitleString = districtFullName;
            
            float priceFlo = wholeHouseSellProduct.price;
            NSString *priStringTmp;
            if (priceFlo < 0.1f) {
                priStringTmp = @"面议";
            }else{
                if ((priceFlo*10)-((int)priceFlo)*10 == 0) {
                    priStringTmp = [NSString stringWithFormat:@"%d万元",(int)priceFlo];
                }else{
                    priStringTmp = [NSString stringWithFormat:@"%.1f万元",priceFlo];
                }
            }
            priceString = priStringTmp;
            
        }else if (product.houseType == HouseProductChangFangZuNin ||
                  product.houseType == HouseProductChangFangQiuZu){
            //厂房租赁
            //厂房求租
            hasImage = NO;
            FactoryHouseProduct *factoryHouseProduct = (FactoryHouseProduct *)product;
            NSString *districtFullName = factoryHouseProduct.districtFullName;
            districtFullName = districtFullName?districtFullName:@"未知";
            int areaTmp = factoryHouseProduct.area;
            NSString *areaString;
            if (areaTmp <= 0) {
                areaString = @"未知";
            }
            areaString = [NSString stringWithFormat:@"%d㎡",areaTmp];
            
            subTitleString = [districtFullName stringByAppendingString:[NSString stringWithFormat:@"   %@",areaString]];
            
            float priceFlo = factoryHouseProduct.price;
            NSString *priStringTmp;
            if (priceFlo < 0.1f) {
                priStringTmp = @"面议";
            }else{
                if ((priceFlo*10)-((int)priceFlo)*10 == 0) {
                    priStringTmp = [NSString stringWithFormat:@"%d元/㎡/天",(int)priceFlo];
                }else{
                    priStringTmp = [NSString stringWithFormat:@"%.1f元/㎡/天",priceFlo];
                }
            }
            priceString = priStringTmp;
        }else if (product.houseType == HouseProductChangFangXiaoShou ||
                  product.houseType == HouseProductChangFangQiuGou){
            //厂房销售
            //厂房求购
            hasImage = NO;
            FactoryHouseProduct *factoryHouseProduct = (FactoryHouseProduct *)product;
            NSString *districtFullName = factoryHouseProduct.districtFullName;
            districtFullName = districtFullName?districtFullName:@"未知";
            int areaTmp = factoryHouseProduct.area;
            NSString *areaString;
            if (areaTmp <= 0) {
                areaString = @"未知";
            }
            areaString = [NSString stringWithFormat:@"%d㎡",areaTmp];
            
            subTitleString = [districtFullName stringByAppendingString:[NSString stringWithFormat:@"   %@",areaString]];
            
            float priceFlo = factoryHouseProduct.price;
            NSString *priStringTmp;
            if (priceFlo < 0.1f) {
                priStringTmp = @"面议";
            }else{
                if ((priceFlo*10)-((int)priceFlo)*10 == 0) {
                    priStringTmp = [NSString stringWithFormat:@"%d万元",(int)priceFlo];
                }else{
                    priStringTmp = [NSString stringWithFormat:@"%.1f万元",priceFlo];
                }
            }
            priceString = priStringTmp;
            
        }else if (product.houseType == HouseProductFangWuQiuZu){
            //房屋求租
            hasImage = NO;
            
            WantHouseProduct *wantHouseProduct = (WantHouseProduct *)product;
            NSString *districtFullName = wantHouseProduct.districtFullName;
            subTitleString = districtFullName;
            
            float priceFlo = wantHouseProduct.price;
            NSString *priStringTmp;
            if (priceFlo < 0.1f) {
                priStringTmp = @"面议";
            }else{
                priStringTmp = [NSString stringWithFormat:@"%d元/月",(int)priceFlo];
            }
            priceString = priStringTmp;
        }else if (product.houseType == HouseProductFangWuQiuGou){
            //房屋求购
            hasImage = NO;
            
            WantHouseProduct *wantHouseProduct = (WantHouseProduct *)product;
            NSString *districtFullName = wantHouseProduct.districtFullName;
            subTitleString = districtFullName;
            
            float priceFlo = wantHouseProduct.price;
            NSString *priStringTmp;
            if (priceFlo < 0.1f) {
                priStringTmp = @"面议";
            }else{
                if ((priceFlo*10)-((int)priceFlo)*10 == 0) {
                    priStringTmp = [NSString stringWithFormat:@"%d万元",(int)priceFlo];
                }else{
                    priStringTmp = [NSString stringWithFormat:@"%.1f万元",priceFlo];
                }
            }
            priceString = priStringTmp;
        }else if (product.houseType == HouseProductShangPuZuNin){
            //商铺租赁
        }else if (product.houseType == HouseProductShangPuXiaoShou){
            //商铺销售
        }
        
        
        
        //        if (product.houseType == CarProductZuChe) {
        //            RentCarProduct *rentCarProduct = (RentCarProduct *)product;
        //            if (product.isSupply) {
        //                NSArray *cartypeList = rentCarProduct.carTypeList;
        //                NSMutableArray *arTmp = [NSMutableArray array];
        //                for (NSDictionary *carTypeDic in cartypeList) {
        //                    NSString *carTypeName = carTypeDic[@"name"];
        //                    [arTmp addObject:carTypeName];
        //                }
        //                subTitleString = [arTmp componentsJoinedByString:@"、 "];
        //                
        //                personCountLabel.hidden = YES;
        //                personString = @"";
        //            }else{
        //                if (rentCarProduct.dayCount == 0) {
        //                    subTitleString = @"";
        //                }else{
        //                    subTitleString = [NSString stringWithFormat:@"租%d天",rentCarProduct.dayCount];
        //                }
        //                
        //                personCountLabel.hidden = NO;
        //                personString = [NSString stringWithFormat:@"%d人",rentCarProduct.personCount];
        //            }
        //        }else if (product.carType == CarProductDaiJia){
        //            personString = @"";
        //            personCountLabel.hidden = YES;
        //            HelpDriveProduct *helpDriveProduct = (HelpDriveProduct *)product;
        //            if (product.isSupply) {
        //                NSString *districtFullName = helpDriveProduct.districtFullName;
        //                subTitleString = districtFullName;
        //            }else{
        //                if (helpDriveProduct.dayCount == 0) {
        //                    subTitleString = @"";
        //                }else{
        //                    subTitleString = [NSString stringWithFormat:@"租%d天",helpDriveProduct.dayCount];
        //                }
        //            }
        //        }else if (product.carType == CarProductPinChe){
        //            CarPoolProduct *carPoolP = (CarPoolProduct *)product;
        //            
        //            NSString *districtFullName = carPoolP.districtFullName;
        //            subTitleString = districtFullName;
        //            
        //            NSString *leaveTime = carPoolP.leaveTime;
        //            if (!leaveTime || ![leaveTime isKindOfClass:[NSString class]] || [leaveTime isEqualToString:@""]) {
        //                leaveTime = @"未知时间";
        //            }
        //            personString = [NSString stringWithFormat:@"%@出发",leaveTime];
        //            personCountLabel.hidden = NO;
        //        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
