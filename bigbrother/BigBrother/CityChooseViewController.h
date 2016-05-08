//
//  PositionChooseViewController.h
//  BigBrother
//
//  Created by xiaoyu on 16/2/22.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CityChooseCompleteBlock)(long cityID,NSString *cityName);
@interface CityChooseViewController : UIViewController

@property (nonatomic,copy) CityChooseCompleteBlock completeBlock;

@property (nonatomic,assign) BOOL isToSetDefaultCity;

@end

@interface CityChooseTableViewCell : UITableViewCell

@end