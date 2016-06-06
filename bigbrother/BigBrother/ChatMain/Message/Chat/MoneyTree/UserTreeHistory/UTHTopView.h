//
//  UTHTopView.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/31.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UTHTopView;

@protocol UTHTopViewDelegate <NSObject>

- (void)topView:(UTHTopView *)topView clickedTopBtn:(UIButton *)sender;

@end

@interface UTHTopView : UIView

@property (assign, nonatomic) id<UTHTopViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondBtn;
@property (strong, nonatomic) UIButton *lastBtn;


- (void)reloadWithDataDic:(NSDictionary *)dataDic;
//- (void)reloadPickHistoryWithDataDic:(NSDictionary *)dataDic;
//
//- (void)reloadPlanHistoryWithDataDic:(NSDictionary *)dataDic;
- (IBAction)topBtnPressed:(UIButton *)sender;



@end
