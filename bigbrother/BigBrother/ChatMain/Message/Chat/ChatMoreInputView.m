//
//  ChatMoreInputView.m
//  BookClub
//
//  Created by 李祖建 on 16/2/26.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "ChatMoreInputView.h"

@interface ChatMoreInputView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (strong, nonatomic) UIImagePickerController *picker;//相机、相册

@property (strong, nonatomic) IBOutlet UIButton *moneyTreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *supplyLinkBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupBuyLinkBtn;
@property (strong, nonatomic) IBOutlet UIButton *groupActivityBtn;



- (IBAction)moneyTreeBtnPressed:(UIButton *)sender;
- (IBAction)supplyLinkBtnPressed:(UIButton *)sender;
- (IBAction)groupBuyLinkBtnPressed:(UIButton *)sender;
- (IBAction)groupActivityBtnPressed:(UIButton *)sender;

@end

@implementation ChatMoreInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChatMoreInputView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
    }
    return self;
}



#pragma mark - 按钮方法

- (IBAction)moneyTreeBtnPressed:(UIButton *)sender {
    [self.delegate clickedMoneyTreeBtn:sender];
}

- (IBAction)supplyLinkBtnPressed:(UIButton *)sender {
    [self.delegate clickedSupplyLinkBtn:sender];
}

- (IBAction)groupBuyLinkBtnPressed:(UIButton *)sender {
    [self.delegate clickedGroupBuyLinkBtn:sender];
}

- (IBAction)groupActivityBtnPressed:(UIButton *)sender {
    [self.delegate clickedGroupActivityBtn:sender];
}

@end
