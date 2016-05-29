//
//  ChatSupplyLinkView.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseProduct.h"


@interface ChatSupplyLinkView : UIView

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) BaseProduct *baseProduct;

- (void)reloadSupplyLinkWithDataDic:(NSDictionary *)dataDic;
- (void)reloadGroupLinkWithDataDic:(NSDictionary *)dataDic;

@end
