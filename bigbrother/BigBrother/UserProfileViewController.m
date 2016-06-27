//
//  UserProfileViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/1.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UserProfileViewController.h"

#import "CityChooseViewController.h"
#import "ChangeTextViewController.h"
#import "TOCropViewController.h"
#import "UIImage+Resize.h"
#import "PopUpSelectedView.h"

@interface UserProfileViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate,UIScrollViewDelegate>

@end

@implementation UserProfileViewController{
    UIImageView *userHeadImageView;
    
    UILabel *nickNameLabel;
    UILabel *userPhoneLabel;
    UILabel *userSexLabel;
    UILabel *userDistrictLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = self.view.backgroundColor;
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    float offsetHeight = 0;
    UIView *userHeadView = [[UIView alloc] init];
    userHeadView.frame = (CGRect){0,offsetHeight,WIDTH(contentView),80};
    userHeadView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:userHeadView];
    
    userHeadView.userInteractionEnabled = YES;
    UITapGestureRecognizer *userHeadViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadViewTapTrigger)];
    [userHeadView addGestureRecognizer:userHeadViewTap];
    
    UILabel *userHeadNoteLabel = [[UILabel alloc] init];
    userHeadNoteLabel.frame = (CGRect){20,0,50,HEIGHT(userHeadView)};
    userHeadNoteLabel.text = @"头像";
    userHeadNoteLabel.font = Font(15);
    userHeadNoteLabel.textAlignment = NSTextAlignmentLeft;
    userHeadNoteLabel.textColor = RGBColor(50, 50, 50);
    [userHeadView addSubview:userHeadNoteLabel];
    
    userHeadImageView = [[UIImageView alloc] init];
    //    userHeadImageView.image = 默认图片 todo
    userHeadImageView.layer.cornerRadius = 4.f;
    userHeadImageView.layer.masksToBounds = YES;
    userHeadImageView.frame = (CGRect){
        WIDTH(userHeadView)-20-(HEIGHT(userHeadView)-10),
        10,
        HEIGHT(userHeadView)-20,
        HEIGHT(userHeadView)-20
    };
    [userHeadView addSubview:userHeadImageView];
    
    userHeadImageView.userInteractionEnabled = YES;
    [userHeadImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadImageViewTapTrigger)]];
    
    UIView *lineSepLineView1 = [[UIView alloc] init];
    lineSepLineView1.frame = (CGRect){0,HEIGHT(userHeadView)-0.5,WIDTH(userHeadView),0.5};
    lineSepLineView1.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [userHeadView addSubview:lineSepLineView1];
    
    offsetHeight += HEIGHT(userHeadView);
    
    UIView *nickNameView = [[UIView alloc] init];
    nickNameView.frame = (CGRect){0,offsetHeight,WIDTH(contentView),45};
    nickNameView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:nickNameView];
    
    nickNameView.userInteractionEnabled = YES;
    UITapGestureRecognizer *nickNameViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nickNameViewTapTrigger)];
    [nickNameView addGestureRecognizer:nickNameViewTap];
    
    UILabel *nickNameNoteLabel = [[UILabel alloc] init];
    nickNameNoteLabel.frame = (CGRect){20,0,50,HEIGHT(nickNameView)};
    nickNameNoteLabel.text = @"昵称";
    nickNameNoteLabel.font = Font(15);
    nickNameNoteLabel.textAlignment = NSTextAlignmentLeft;
    nickNameNoteLabel.textColor = RGBColor(50, 50, 50);
    [nickNameView addSubview:nickNameNoteLabel];
    
    nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.frame = (CGRect){WIDTH(nickNameView)-20-150-15,0,150,HEIGHT(nickNameView)};
    nickNameLabel.text = @"昵称";
    nickNameLabel.font = Font(15);
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    nickNameLabel.textColor = RGBColor(50, 50, 50);
    [nickNameView addSubview:nickNameLabel];
    
    UIImageView *nickNameMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
    nickNameMoreImageView.frame = (CGRect){WIDTH(nickNameView)-20-10,(HEIGHT(nickNameView)-11)/2,7,11};
    [nickNameView addSubview:nickNameMoreImageView];
    
    UIView *lineSepLineView2 = [[UIView alloc] init];
    lineSepLineView2.frame = (CGRect){0,HEIGHT(nickNameView)-0.5,WIDTH(nickNameView),0.5};
    lineSepLineView2.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [nickNameView addSubview:lineSepLineView2];
    
    offsetHeight += HEIGHT(nickNameView);
    
    UIView *userPhoneView = [[UIView alloc] init];
    userPhoneView.frame = (CGRect){0,offsetHeight,WIDTH(contentView),45};
    userPhoneView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:userPhoneView];
    
    userPhoneView.userInteractionEnabled = YES;
    UITapGestureRecognizer *userPhoneViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPhoneViewTapTrigger)];
    [userPhoneView addGestureRecognizer:userPhoneViewTap];
    
    UILabel *userPhoneNoteLabel = [[UILabel alloc] init];
    userPhoneNoteLabel.frame = (CGRect){20,0,50,HEIGHT(userPhoneView)};
    userPhoneNoteLabel.text = @"邮箱";
    userPhoneNoteLabel.font = Font(15);
    userPhoneNoteLabel.textAlignment = NSTextAlignmentLeft;
    userPhoneNoteLabel.textColor = RGBColor(50, 50, 50);
    [userPhoneView addSubview:userPhoneNoteLabel];
    
    userPhoneLabel = [[UILabel alloc] init];
    userPhoneLabel.frame = (CGRect){WIDTH(userPhoneView)-20-150-15,0,150,HEIGHT(userPhoneView)};
    userPhoneLabel.text = @"邮箱";
    userPhoneLabel.font = Font(15);
    userPhoneLabel.textAlignment = NSTextAlignmentRight;
    userPhoneLabel.textColor = RGBColor(50, 50, 50);
    [userPhoneView addSubview:userPhoneLabel];
    
    UIImageView *userPhoneMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
    userPhoneMoreImageView.frame = (CGRect){WIDTH(userPhoneView)-20-10,(HEIGHT(userPhoneView)-11)/2,7,11};
    [userPhoneView addSubview:userPhoneMoreImageView];
    
    UIView *lineSepLineView3 = [[UIView alloc] init];
    lineSepLineView3.frame = (CGRect){0,HEIGHT(userPhoneView)-0.5,WIDTH(userPhoneView),0.5};
    lineSepLineView3.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [userPhoneView addSubview:lineSepLineView3];
    
    offsetHeight += HEIGHT(userPhoneView);
    
    UIView *userSexView = [[UIView alloc] init];
    userSexView.frame = (CGRect){0,offsetHeight,WIDTH(contentView),45};
    userSexView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:userSexView];
    
    userSexView.userInteractionEnabled = YES;
    UITapGestureRecognizer *userSexViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userSexViewTapTrigger)];
    [userSexView addGestureRecognizer:userSexViewTap];
    
    UILabel *userSexNoteLabel = [[UILabel alloc] init];
    userSexNoteLabel.frame = (CGRect){20,0,50,HEIGHT(userSexView)};
    userSexNoteLabel.text = @"性别";
    userSexNoteLabel.font = Font(15);
    userSexNoteLabel.textAlignment = NSTextAlignmentLeft;
    userSexNoteLabel.textColor = RGBColor(50, 50, 50);
    [userSexView addSubview:userSexNoteLabel];
    
    userSexLabel = [[UILabel alloc] init];
    userSexLabel.frame = (CGRect){WIDTH(userSexView)-20-150-15,0,150,HEIGHT(userSexView)};
    userSexLabel.text = @"性别";
    userSexLabel.font = Font(15);
    userSexLabel.textAlignment = NSTextAlignmentRight;
    userSexLabel.textColor = RGBColor(50, 50, 50);
    [userSexView addSubview:userSexLabel];
    
    UIImageView *userSexMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
    userSexMoreImageView.frame = (CGRect){WIDTH(userSexView)-20-10,(HEIGHT(userSexView)-11)/2,7,11};
    [userSexView addSubview:userSexMoreImageView];
    
    UIView *lineSepLineView4 = [[UIView alloc] init];
    lineSepLineView4.frame = (CGRect){0,HEIGHT(userSexView)-0.5,WIDTH(userSexView),0.5};
    lineSepLineView4.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [userSexView addSubview:lineSepLineView4];
    
    offsetHeight += HEIGHT(userSexView);
    
    UIView *userDistrictView = [[UIView alloc] init];
    userDistrictView.frame = (CGRect){0,offsetHeight,WIDTH(contentView),45};
    userDistrictView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:userDistrictView];
    
    userDistrictView.userInteractionEnabled = YES;
    UITapGestureRecognizer *userDistrictViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDistrictViewTapTrigger)];
    [userDistrictView addGestureRecognizer:userDistrictViewTap];
    
    UILabel *userDistrictNoteLabel = [[UILabel alloc] init];
    userDistrictNoteLabel.frame = (CGRect){20,0,50,HEIGHT(userDistrictView)};
    userDistrictNoteLabel.text = @"地区";
    userDistrictNoteLabel.font = Font(15);
    userDistrictNoteLabel.textAlignment = NSTextAlignmentLeft;
    userDistrictNoteLabel.textColor = RGBColor(50, 50, 50);
    [userDistrictView addSubview:userDistrictNoteLabel];
    
    userDistrictLabel = [[UILabel alloc] init];
    userDistrictLabel.frame = (CGRect){WIDTH(userDistrictView)-20-150-15,0,150,HEIGHT(userDistrictView)};
    userDistrictLabel.text = @"地区";
    userDistrictLabel.font = Font(15);
    userDistrictLabel.textAlignment = NSTextAlignmentRight;
    userDistrictLabel.textColor = RGBColor(50, 50, 50);
    [userDistrictView addSubview:userDistrictLabel];
    
    UIImageView *userDistrictMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
    userDistrictMoreImageView.frame = (CGRect){WIDTH(userDistrictView)-20-10,(HEIGHT(userDistrictView)-11)/2,7,11};
    [userDistrictView addSubview:userDistrictMoreImageView];
    
    UIView *lineSepLineView5 = [[UIView alloc] init];
    lineSepLineView5.frame = (CGRect){0,HEIGHT(userDistrictView)-0.5,WIDTH(userDistrictView),0.5};
    lineSepLineView5.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [userDistrictView addSubview:lineSepLineView5];
    
    offsetHeight += HEIGHT(userDistrictView);
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(HEIGHT(contentView)+1, offsetHeight+10)};
    
    [self setDefaultValue];
}

#pragma mark - 上传图片按钮点击事件
-(void)userHeadViewTapTrigger{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择图片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机", @"从相册获取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //相机
#if TARGET_IPHONE_SIMULATOR//模拟器
            NSLog(@"模拟器不能调用相机");
#elif TARGET_OS_IPHONE//真机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
            
            [self presentViewController:picker animated:YES completion:nil];
#endif
        }
            break;
        case 1:{
            //相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
            
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:chosenImage];
        cropController.delegate = self;
        cropController.aspectRadio = (CGSize){1,1};
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}

#pragma mark - TOCropViewControllerDelegate
/**
 *  裁剪完成后调用的代理
 *
 *  @param cropViewController
 *  @param image              裁剪后的图片
 *  @param cropRect           裁剪后对比于原图中的相对尺寸
 *  @param angle              角度
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    cropViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = image;
    if (!chosenImage) {
        return;
    }
    userHeadImageView.image = chosenImage;
    [self updateUserImage:chosenImage];
}

// 点击取消或从外部应用调回时触发的代理  如果canceled为yes 标识 可以认为是用户手动点击了取消按钮
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
}

-(void)userHeadImageViewTapTrigger{
    if (![BBUserDefaults getUserHeadImageUrl] || [[BBUserDefaults getUserHeadImageUrl] isEqualToString:@""]) {
        [self userHeadViewTapTrigger];
        return;
    }
    [self showBigWithImage:userHeadImageView.image];
}

static CGRect rectInFullScreen;
-(void)showBigWithImage:(UIImage *)image{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgColorView.alpha = 0.f;
    bgColorView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    bgColorView.tag = 7978;
    [keyWindow addSubview:bgColorView];
    
    UIScrollView *fullscreenBottomView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    fullscreenBottomView.contentSize = CGSizeMake(WIDTH(fullscreenBottomView), HEIGHT(fullscreenBottomView));
    fullscreenBottomView.backgroundColor = [UIColor clearColor];
    fullscreenBottomView.minimumZoomScale = 0.3f;
    fullscreenBottomView.maximumZoomScale = 3.f;
    fullscreenBottomView.contentMode = UIViewContentModeCenter;
    fullscreenBottomView.bounces = YES;
    fullscreenBottomView.bouncesZoom = YES;
    fullscreenBottomView.showsHorizontalScrollIndicator = NO;
    fullscreenBottomView.showsVerticalScrollIndicator = NO;
    fullscreenBottomView.delegate = self;
    fullscreenBottomView.tag = 9797;
    [keyWindow addSubview:fullscreenBottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCheckImgView)];
    [fullscreenBottomView addGestureRecognizer:tap];
    
    rectInFullScreen = (CGRect){X(userHeadImageView),Y(userHeadImageView)+BB_NarbarHeight,WIDTH(userHeadImageView),HEIGHT(userHeadImageView)};
    UIImageView *imgViewIsShowing = [[UIImageView alloc] initWithFrame:rectInFullScreen];
    
    UIImage *imgToShow = image;
    imgViewIsShowing.image = imgToShow;
    imgViewIsShowing.contentMode = UIViewContentModeScaleAspectFit;
    imgViewIsShowing.tag = 1001;
    [fullscreenBottomView addSubview:imgViewIsShowing];
    
    [UIView animateWithDuration:0.3f animations:^{
        imgViewIsShowing.frame = fullscreenBottomView.bounds;
        bgColorView.alpha = 1.f;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (scale<1.f) {
        [scrollView setZoomScale:1.f animated:YES];
        if (scale<0.7f)
            [self exitCheckImgView];
    }
}

-(void)exitCheckImgView{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    if (viewScroll) {
        if (viewScroll.zoomScale > 1.f) {
            [viewScroll setZoomScale:1.f animated:YES];
            [self performSelector:@selector(exitCheckBigImgView) withObject:nil afterDelay:0.5f];
        }else{
            [self exitCheckBigImgView];
        }
    }
}

-(void)exitCheckBigImgView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *viewBg = [keyWindow viewWithTag:7978];
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    [UIView animateWithDuration:0.3f animations:^{
        ((UIView*)[viewScroll.subviews firstObject]).frame = rectInFullScreen;
        viewScroll.alpha = 0.f;
        viewBg.alpha = 0.f;
    }completion:^(BOOL finished) {
        [viewScroll removeFromSuperview];
        [viewBg removeFromSuperview];
    }];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag == 9797) {
        UIImageView *subView = (UIImageView*)[scrollView viewWithTag:1001];
        return subView;
    }
    return nil;
}

-(void)nickNameViewTapTrigger{
    ChangeTextViewController *cttVC = [[ChangeTextViewController alloc] init];
    cttVC.updateKey = @"nickname";
    cttVC.title = @"修改昵称";
    NSString *defaultText = nickNameLabel.text;
    if ([defaultText isEqualToString:@""] || [defaultText isEqualToString:@"未设置"]) {
        defaultText = @"";
    }
    cttVC.defaultText = defaultText;
    [self.navigationController pushViewController:cttVC animated:YES];
}

-(void)userPhoneViewTapTrigger{
    return;
}

static NSArray *sexSelectDataArray;
-(void)userSexViewTapTrigger{
    sexSelectDataArray = @[@{@"name":@"男",@"value":@"MALE"},@{@"name":@"女",@"value":@"FEMALE"}];
    [PopUpSelectedView showFilterSingleChooseViewWithArray:sexSelectDataArray withTitle:@"选择性别" target:self labelTapAction:@selector(userSexChooseFinishTap:)];
}

-(void)userSexChooseFinishTap:(UITapGestureRecognizer *)tap{
    NSDictionary *dic = sexSelectDataArray[tap.view.tag];
    [PopUpSelectedView dismissFilterChooseView];
    NSString *valueString = dic[@"value"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:valueString forKey:@"gender"];
    [self updateUserInfoWithParams:params];
}

-(void)userDistrictViewTapTrigger{
    CityChooseViewController *ccVC = [[CityChooseViewController alloc] init];
    ccVC.isToSetDefaultCity = NO;
    ccVC.completeBlock = ^(long cityID,NSString *cityName){
        if (cityID == 0 || !cityName ||[cityName isEqualToString:@""]) {
            [BYToastView showToastWithMessage:@"修改地区失败,请稍候再试"];
        }else{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@(cityID) forKey:@"districtId"];
            [self updateUserInfoWithParams:params];
        }
    };
    [self.navigationController pushViewController:ccVC animated:YES];
}

-(void)updateUserImage:(UIImage *)image{
    if (image) {
        image = [image resizeImageGreaterThan:800];
    }
    [BYToastView showToastWithMessage:@"正在修改头像..."];
    [BBUrlConnection uploadWithImage:image productType:0 complete:^(NSString *imageUrl) {
        if (imageUrl) {
            [self updateUserInfoWithImageUrlString:imageUrl];
        }else{
            [BYToastView showToastWithMessage:@"图片上传失败,请稍后重试"];
        }
    }];
}

-(void)updateUserInfoWithImageUrlString:(NSString *)imageUrl{
    if (!imageUrl) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:imageUrl forKey:@"avatar"];
    [self updateUserInfoWithParams:params];
}

-(void)updateUserInfoWithParams:(NSMutableDictionary *)params{
    if (!params) {
        [BYToastView showToastWithMessage:@"修改失败,请稍候重试"];
    }
    [BYToastView showToastWithMessage:@"修改用户信息中..."];
    [BBUrlConnection updateUserInfoWithParams:params complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if ([resultDic[@"code"] intValue] != 0) {
            [BYToastView showToastWithMessage:@"修改失败,请稍候重试"];
            return;
        }
        NSDictionary *userInfo = resultDic[@"data"];
        if (!userInfo || ![userInfo isKindOfClass:[NSDictionary class]]) {
            [BYToastView showToastWithMessage:@"修改失败,请稍候重试"];
            return;
        }
        NSString *idstring = userInfo[@"id"];
        
        if (idstring) {
            if ([idstring isKindOfClass:[NSNumber class]]) {
                idstring = [NSString stringWithFormat:@"%ld",(long)[idstring longLongValue]];
            }
            [BBUserDefaults setUserID:idstring];
        }
        
        NSString *nicknameString = userInfo[@"nickname"];
        if (nicknameString && [nicknameString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserNickName:nicknameString];
        }
        
        NSString *phoneNumString = userInfo[@"userEmail"];
        if (phoneNumString && [phoneNumString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserPhone:phoneNumString];
        }
        
        
        NSString *imageUrlString = userInfo[@"avatar"];
        if (imageUrlString && [imageUrlString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserHeadImageUrl:imageUrlString];
        }
        
        NSString *sexString = userInfo[@"gender"];
        if (sexString && [sexString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserSex:sexString];
        }
        
        NSString *districtIdString = userInfo[@"districtId"];
        if (districtIdString) {
            if ([districtIdString isKindOfClass:[NSString class]]) {
                [BBUserDefaults setUserDistrictIdString:districtIdString];
            }else if([districtIdString isKindOfClass:[NSNumber class]]) {
                [BBUserDefaults setUserDistrictIdString:[NSString stringWithFormat:@"%lld",[districtIdString longLongValue]]];
            }
        }
        
        NSString *districtFullNameString = userInfo[@"districtFullName"];
        if (districtFullNameString && [districtFullNameString isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserDistrictFullNameString:districtFullNameString];
        }
        
        NSNumber *balanceNum = userInfo[@"balance"];
        if (balanceNum) {
            if([balanceNum isKindOfClass:[NSNumber class]]) {
                [BBUserDefaults setUserBalance:[balanceNum intValue]];
            }
        }
        
        NSString *lastLoginTime = userInfo[@"lastLoginTime"];
        if (lastLoginTime && [lastLoginTime isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserLastLoginTime:lastLoginTime];
        }
        
        NSString *authType = userInfo[@"authType"];
        if (authType && [authType isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserAuthType:authType];
        }
        
        NSString *authStatus = userInfo[@"authStatus"];
        if (authStatus && [authStatus isKindOfClass:[NSString class]]) {
            [BBUserDefaults setUserAuthStatusString:authStatus];
        }
        [self setDefaultValue];
        [BYToastView showToastWithMessage:@"修改成功"];
    }];
}

-(void)setDefaultValue{
    NSString *imageUrl = [BBUserDefaults getUserHeadImageUrl];
    if (imageUrl) {
        [userHeadImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:userHeadImageView.image];
    }
    
    NSString *nickNameString = [BBUserDefaults getUserNickName];
    if (nickNameString) {
        nickNameLabel.text = nickNameString;
        nickNameLabel.textColor = RGBColor(50, 50, 50);
    }else{
        nickNameLabel.text = @"未填写";
        nickNameLabel.textColor = RGBColor(150, 150, 150);
    }
    
    NSString *userPhoneString = [BBUserDefaults getUserPhone];
    if (userPhoneString) {
        userPhoneLabel.text = userPhoneString;
        userPhoneLabel.textColor = RGBColor(50, 50, 50);
    }else{
        userPhoneLabel.text = @"未填写";
        userPhoneLabel.textColor = RGBColor(150, 150, 150);
    }
    
    NSString *userSex = [BBUserDefaults getUserSex];
    if (userSex) {
        if ([userSex isEqualToString:@"MALE"]) {
            userSexLabel.text = @"男";
            userSexLabel.textColor = RGBColor(50, 50, 50);
        }else if ([userSex isEqualToString:@"FEMALE"]) {
            userSexLabel.text = @"女";
            userSexLabel.textColor = RGBColor(50, 50, 50);
        }else{
            userSexLabel.text = @"未设置";
            userSexLabel.textColor = RGBColor(150, 150, 150);
        }
    }else{
        userSexLabel.text = @"未设置";
        userSexLabel.textColor = RGBColor(150, 150, 150);
    }
    
    NSString *userDistrictFullNameString = [BBUserDefaults getUserDistrictFullNameString];
    if (userDistrictFullNameString) {
        userDistrictLabel.text = userDistrictFullNameString;
        userDistrictLabel.textColor = RGBColor(50, 50, 50);
    }else{
        userDistrictLabel.text = @"未设置";
        userDistrictLabel.textColor = RGBColor(150, 150, 150);
    }
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"个人信息";
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigation];
    if (userHeadImageView) {
        [self setDefaultValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
