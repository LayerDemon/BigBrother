//
//  UserTreeHistoryViewCell.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/31.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTreeHistoryViewCell : UITableViewCell

- (void)reloadPickHistoryWithDataDic:(NSDictionary *)dataDic;

- (void)reloadPlanHistoryWithDataDic:(NSDictionary *)dataDic;

@end
