//
//  CashCowTableViewCell.h
//  BigBrother
//
//  Created by zhangyi on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashCowTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView       * headImageView;
@property (strong, nonatomic) UILabel           * userNameLabel;
@property (strong, nonatomic) UILabel           * timeLabel;
@property (strong, nonatomic) UILabel           * numLabel;

- (void)reloadWithDataDic:(NSDictionary *)dataDic;

@end
