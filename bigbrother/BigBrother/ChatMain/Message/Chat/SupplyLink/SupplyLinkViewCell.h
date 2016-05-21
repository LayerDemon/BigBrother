//
//  SupplyLinkViewCell.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/19.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SupplyLinkViewCell;

@protocol SupplyLinkViewCellDelegate <NSObject>

- (void)supplyLinkViewCell:(SupplyLinkViewCell *)cell clickedSendBtn:(UIButton *)sender;

@end

@interface SupplyLinkViewCell : UITableViewCell

@property (assign, nonatomic) id<SupplyLinkViewCellDelegate>delegate;
@property (strong, nonatomic) NSDictionary *dataDic;


- (void)reloadWithDataDic:(NSDictionary *)dataDic;

- (IBAction)sendBtnPressed:(UIButton *)sender;



@end
