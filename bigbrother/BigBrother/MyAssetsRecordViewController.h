//
//  MyAesstsRecordViewController.h
//  BigBrother
//
//  Created by xiaoyu on 16/3/3.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAssetsRecordViewController : UIViewController

@property (nonatomic,assign) BOOL isChargeRecord;

@end

@interface RecordTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *recordID;

@property (nonatomic,copy) NSString *recordNote;

@property (nonatomic,copy) NSString *recordTimeString;

@property (nonatomic,copy) NSString *recordCount;

@end