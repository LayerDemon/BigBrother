//
//  FDFooterView.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/16.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDFooterViewDelegate <NSObject>

- (void)clickedAddFriendBtn:(UIButton *)sender;
- (void)clickedDeleteFriendBtn:(UIButton *)sender;
- (void)clickedSendMessageBtn:(UIButton *)sender;

@end

@interface FDFooterView : UIView

@property (assign, nonatomic) id<FDFooterViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *firstBtn;

@property (strong, nonatomic) IBOutlet UIButton *secondBtn;
//@property (strong, nonatomic) NSDictionary *dataDic;

- (void)loadWithDataDic:(NSDictionary *)dataDic;

@end
