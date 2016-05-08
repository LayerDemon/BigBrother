//
//  FactroyPostToViewController.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/24.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FactoryProduct.h"

@interface FactroyPostToViewController : UIViewController

@property (nonatomic,strong) NSDictionary *postProductInfoDic;

@property (nonatomic,strong) FactoryProduct *factoryProduct;

@end
