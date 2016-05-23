//
//  GroupInviteViewCell.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/23.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupInviteViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dataDic;


- (void)reloadWithDataDic:(NSDictionary *)dataDic;
@end
