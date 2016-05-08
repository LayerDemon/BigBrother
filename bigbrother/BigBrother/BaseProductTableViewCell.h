//
//  BaseProductTableViewCell.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/21.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseProduct.h"

static float BaseProductTableViewCellHeight = 100.f;
@interface BaseProductTableViewCell : UITableViewCell

@property (nonatomic,strong) BaseProduct *baseProduct;

@end
