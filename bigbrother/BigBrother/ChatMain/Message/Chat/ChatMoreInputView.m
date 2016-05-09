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

@property (strong, nonatomic) IBOutlet UIButton *picBtn;
@property (strong, nonatomic) IBOutlet UIButton *addrBtn;
@property (strong, nonatomic) IBOutlet UIButton *bookBtn;
- (IBAction)picBtnPressed:(UIButton *)sender;
- (IBAction)addrBtnPressed:(UIButton *)sender;
- (IBAction)bookBtnPressed:(UIButton *)sender;

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
- (IBAction)picBtnPressed:(UIButton *)sender {
    [self.delegate clickedPicBtn:sender];
}

- (IBAction)addrBtnPressed:(UIButton *)sender {
    [self.delegate clickedAddrBtn:sender];
}

- (IBAction)bookBtnPressed:(UIButton *)sender {
    [self.delegate clickedBookBtn:sender];
}
@end
