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

@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (void)reloadWithDataDic:(NSDictionary *)dataDic;
@end
