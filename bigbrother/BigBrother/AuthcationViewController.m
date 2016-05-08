//
//  AuthcationViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/29.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "AuthcationViewController.h"

#import "TOCropViewController.h"
#import "XYW8IndicatorView.h"

@interface AuthcationViewController () <UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>

@end

@implementation AuthcationViewController{
    //发布 相关
    XYW8IndicatorView *indicatorView;
    bool uploadImagesStart;
    int uploadImagesRemainCount;
    int uploadImagesTotalCount;
    int uploadImagesCurrentIndex;
    NSMutableArray *uploadResultArray;
    NSMutableArray *uploadImageArray;
    
    UIButton *personalButton;
    UIButton *companyButton;
    
    UIView *selectedLineView;
    
    UIScrollView *contentView;
    
    float IDPicWidth;
    float IDPicHeight;
    
    UIImageView *personalIDFrontImageView;
    UIImageView *personalIDBackImageView;
    
    UIImage *personalIDFrontImage;
    UIImage *personalIDBackImage;
    
    UIImageView *companyIDFrontImageView;
    UIImageView *companyIDBackImageView;
    UIImageView *companyAuthLicenceImageView;
    
    UIImage *companyLicenceImage;
    UIImage *companyIDFrontImage;
    UIImage *companyIDBackImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    UIView *selectView = [[UIView alloc] init];
    selectView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),45};
    selectView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:selectView];
    
    personalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    personalButton.frame = (CGRect){0,0,WIDTH(selectView)/2,HEIGHT(selectView)};
    [personalButton setTitle:@"个人认证" forState:UIControlStateNormal];
    [personalButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    personalButton.titleLabel.font = Font(15);
    [selectView addSubview:personalButton];
    [personalButton addTarget:self action:@selector(personalButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    companyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    companyButton.frame = (CGRect){WIDTH(selectView)/2,0,WIDTH(selectView)/2,HEIGHT(selectView)};
    [companyButton setTitle:@"企业认证" forState:UIControlStateNormal];
    [companyButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
    companyButton.titleLabel.font = Font(15);
    [selectView addSubview:companyButton];
    [companyButton addTarget:self action:@selector(companyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepLineView = [[UIView alloc] init];
    sepLineView.frame = (CGRect){WIDTH(selectView)/2,5,0.5,HEIGHT(selectView)-10};
    sepLineView.backgroundColor = RGBAColor(200, 200, 200, 0.2);
    [selectView addSubview:sepLineView];
    
    selectedLineView = [[UIView alloc] init];
    selectedLineView.frame = (CGRect){0,45-2,WIDTH(self.view)/2,2};
    selectedLineView.backgroundColor = BB_BlueColor;
    [selectView addSubview:selectedLineView];
    
    contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = self.view.backgroundColor;
    contentView.frame = (CGRect){0,BOTTOM(selectView),WIDTH(self.view),HEIGHT(self.view)-BOTTOM(selectView)};
    contentView.delegate = self;
    contentView.tag = 89898;
    contentView.pagingEnabled = YES;
    contentView.contentSize = (CGSize){WIDTH(contentView)*2,HEIGHT(contentView)};
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    IDPicWidth = (WIDTH(contentView)-15*2);
    IDPicHeight = IDPicWidth * 54.f/86.f;
    
    [self initPersonalAuthView];
    
    [self initCompanyAuthView];
}

-(void)personalButtonClick{
    [contentView setContentOffset:(CGPoint){0,0} animated:YES];
    [personalButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    [companyButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
}

-(void)companyButtonClick{
    [contentView setContentOffset:(CGPoint){WIDTH(contentView),0} animated:YES];
    [companyButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
    [personalButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
}

#pragma mark - 上传图片请求网络
-(void)resetUploadStatus{
    uploadImagesStart = YES;
    uploadImagesRemainCount = 0;
    uploadImagesTotalCount = 0;
    uploadImagesCurrentIndex = 0;
    uploadResultArray = nil;
}

-(void)uploadContentImageArray:(NSArray *)array type:(NSString *)typeString{
    if (!uploadImageArray || uploadImageArray.count == 0) {
        [self uploadContentImageToServerWithImagesUrlArray:nil type:typeString];
    }else{
        if (uploadImagesStart) {
            uploadImagesRemainCount = (int)array.count;
            uploadImagesTotalCount = uploadImagesRemainCount;
            uploadImagesCurrentIndex = 0;
            uploadImagesStart = NO;
            uploadResultArray = [NSMutableArray array];
            [self uploadContentImageArray:array type:typeString];
        }else{
            indicatorView.loadingLabel.text = [NSString stringWithFormat:@"正在上传第 %d/%d 张图片",uploadImagesCurrentIndex+1,uploadImagesTotalCount];
            id tmp = uploadImageArray[uploadImagesCurrentIndex];
            if ([tmp isKindOfClass:[NSString class]]) {
                NSString *imageUrl = (NSString *)tmp;
                if (imageUrl) {
                    [uploadResultArray addObject:imageUrl];
                    uploadImagesRemainCount --;
                    uploadImagesCurrentIndex++;
                    if (uploadImagesRemainCount == 0) {
                        [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] type:typeString];
                        return;
                    }else{
                        [self uploadContentImageArray:array type:typeString];
                    }
                }else{
                    [indicatorView stopAnimating:YES];
                    [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                    [self resetUploadStatus];
                }
            }else if ([tmp isKindOfClass:[NSDictionary class]]){
                NSString *imageUrl = [tmp objectForKey:@"url"];
                if (imageUrl) {
                    [uploadResultArray addObject:imageUrl];
                    uploadImagesRemainCount --;
                    uploadImagesCurrentIndex++;
                    if (uploadImagesRemainCount == 0) {
                        [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] type:typeString];
                        return;
                    }else{
                        [self uploadContentImageArray:array type:typeString];
                    }
                }else{
                    [indicatorView stopAnimating:YES];
                    [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                    [self resetUploadStatus];
                }
            }else if ([tmp isKindOfClass:[UIImage class]]){
                UIImage *uploadContentImage = (UIImage *)tmp;
                
                [BBUrlConnection uploadWithImage:uploadContentImage productType:0 complete:^(NSString *imagereturnUrl) {
                    //                    double uploadend = [[NSDate date] timeIntervalSince1970];
                    if (imagereturnUrl) {
                        [uploadResultArray addObject:imagereturnUrl];
                        uploadImagesRemainCount --;
                        uploadImagesCurrentIndex++;
                        if (uploadImagesRemainCount == 0) {
                            [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] type:typeString];
                            return;
                        }else{
                            [self uploadContentImageArray:array type:typeString];
                        }
                    }else{
                        [indicatorView stopAnimating:YES];
                        [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                        [self resetUploadStatus];
                    }
                }];
            }
        }
    }
}

-(void)uploadContentImageToServerWithImagesUrlArray:(NSArray *)array type:(NSString *)typeString{
    if (array) {
        if (typeString) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if ([typeString isEqualToString:@"PERSONAL"]) {
                if (array.count == 2) {
                    [params setObject:array[0] forKey:@"identityCardFrontUrl"];
                    [params setObject:array[1] forKey:@"identityCardBackUrl"];
                }
            }else if ([typeString isEqualToString:@"COMPANY"]){
                if (array.count == 3) {
                    [params setObject:array[0] forKey:@"businessLicenceUrl"];
                    [params setObject:array[1] forKey:@"identityCardFrontUrl"];
                    [params setObject:array[2] forKey:@"identityCardBackUrl"];
                }
            }
            if (params) {
                [params setObject:typeString forKey:@"type"];
                [self uploadWithParams:params];
                return;
            }
        }
    }
    [BYToastView showToastWithMessage:@"上传认证信息失败,请稍候再试"];
}

-(void)uploadWithParams:(NSMutableDictionary *)paramsDic{
    indicatorView.loadingLabel.text = @"提交至服务器";
    double uploadstart = [[NSDate date] timeIntervalSince1970];
    
    [BBUrlConnection createAuthcationWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        double uploadend = [[NSDate date] timeIntervalSince1970];
        float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating:YES];
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                int code = [resultDic[@"code"] intValue];
                if (code == 0) {
                    [BYToastView showToastWithMessage:@"上传成功,请耐心等待审核"];
                    if (self.isFromLogin) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    [BYToastView showToastWithMessage:@"上传失败,请稍候重试"];
                }
            }
        });
    }];
}

#pragma mark - 初始化个人认证界面
-(void)initPersonalAuthView{
    UIScrollView *personalAuthcationView = [[UIScrollView alloc] init];
    personalAuthcationView.frame = (CGRect){0,0,WIDTH(contentView),HEIGHT(contentView)};
    personalAuthcationView.backgroundColor = contentView.backgroundColor;
    personalAuthcationView.showsHorizontalScrollIndicator = NO;
    personalAuthcationView.showsVerticalScrollIndicator = NO;
    [contentView addSubview:personalAuthcationView];
    
    UILabel *personalAuthNoteLabel = [[UILabel alloc] init];
    personalAuthNoteLabel.frame = (CGRect){0,20,WIDTH(contentView),20};
    personalAuthNoteLabel.font = Font(15);
    personalAuthNoteLabel.text = @"完善资料享受更多特权";
    personalAuthNoteLabel.textColor = RGBColor(50, 50, 50);
    personalAuthNoteLabel.textAlignment = NSTextAlignmentCenter;
    [personalAuthcationView addSubview:personalAuthNoteLabel];
    
    UIView *personalAuthIDFrontView = [[UIView alloc] init];
    personalAuthIDFrontView.frame = (CGRect){15,BOTTOM(personalAuthNoteLabel)+20,IDPicWidth,IDPicHeight};
    personalAuthIDFrontView.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    personalAuthIDFrontView.layer.borderWidth = 1;
    personalAuthIDFrontView.layer.cornerRadius = 2.f;
    personalAuthIDFrontView.layer.masksToBounds = YES;
    personalAuthIDFrontView.tag = 101;
    personalAuthIDFrontView.userInteractionEnabled = YES;
    [personalAuthcationView addSubview:personalAuthIDFrontView];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTrigger:)];
    [personalAuthIDFrontView addGestureRecognizer:viewTap];
    
    UIImageView *authFrontPicAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_addpic"]];
    authFrontPicAdd.frame = (CGRect){
        (WIDTH(personalAuthIDFrontView)-64)/2,
        (HEIGHT(personalAuthIDFrontView)-64-35)/2,
        64,
        64,
    };
    authFrontPicAdd.userInteractionEnabled = NO;
    [personalAuthIDFrontView addSubview:authFrontPicAdd];
    
    UILabel *personalAuthIDFrontNoteLabel = [[UILabel alloc] init];
    personalAuthIDFrontNoteLabel.frame = (CGRect){0,BOTTOM(authFrontPicAdd)+20,WIDTH(personalAuthIDFrontView),20};
    personalAuthIDFrontNoteLabel.font = Font(16);
    personalAuthIDFrontNoteLabel.text = @"上传个人身份证正面照";
    personalAuthIDFrontNoteLabel.textColor = RGBColor(100, 100, 100);
    personalAuthIDFrontNoteLabel.textAlignment = NSTextAlignmentCenter;
    personalAuthIDFrontNoteLabel.userInteractionEnabled = NO;
    [personalAuthIDFrontView addSubview:personalAuthIDFrontNoteLabel];
    //    
    personalIDFrontImageView = [[UIImageView alloc] init];
    personalIDFrontImageView.backgroundColor = [UIColor clearColor];
    personalIDFrontImageView.frame = personalAuthIDFrontView.bounds;
    personalIDFrontImageView.userInteractionEnabled = NO;
    [personalAuthIDFrontView addSubview:personalIDFrontImageView];
    
    
    UIView *personalAuthIDBackView = [[UIView alloc] init];
    personalAuthIDBackView.frame = (CGRect){15,BOTTOM(personalAuthIDFrontView)+20,IDPicWidth,IDPicHeight};
    personalAuthIDBackView.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    personalAuthIDBackView.layer.borderWidth = 1;
    personalAuthIDBackView.layer.cornerRadius = 2.f;
    personalAuthIDBackView.layer.masksToBounds = YES;
    personalAuthIDBackView.userInteractionEnabled = YES;
    personalAuthIDBackView.tag = 102;
    [personalAuthcationView addSubview:personalAuthIDBackView];
    
    UITapGestureRecognizer *viewTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTrigger:)];
    [personalAuthIDBackView addGestureRecognizer:viewTap2];
    
    UIImageView *authBackPicAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_addpic"]];
    authBackPicAdd.frame = (CGRect){
        (WIDTH(personalAuthIDBackView)-64)/2,
        (HEIGHT(personalAuthIDBackView)-64-35)/2,
        64,
        64,
    };
    authBackPicAdd.userInteractionEnabled = NO;
    [personalAuthIDBackView addSubview:authBackPicAdd];
    
    UILabel *personalAuthIDBackNoteLabel = [[UILabel alloc] init];
    personalAuthIDBackNoteLabel.frame = (CGRect){0,BOTTOM(authBackPicAdd)+20,WIDTH(personalAuthIDBackView),20};
    personalAuthIDBackNoteLabel.font = Font(16);
    personalAuthIDBackNoteLabel.text = @"上传个人身份证背面照";
    personalAuthIDBackNoteLabel.textColor = RGBColor(100, 100, 100);
    personalAuthIDBackNoteLabel.textAlignment = NSTextAlignmentCenter;
    personalAuthIDBackNoteLabel.userInteractionEnabled = NO;
    [personalAuthIDBackView addSubview:personalAuthIDBackNoteLabel];
    
    personalIDBackImageView = [[UIImageView alloc] init];
    personalIDBackImageView.backgroundColor = [UIColor clearColor];
    personalIDBackImageView.frame = personalAuthIDBackView.bounds;
    personalIDBackImageView.userInteractionEnabled = NO;
    [personalAuthIDBackView addSubview:personalIDBackImageView];
    
    
    UIButton *personalDoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    personalDoneButton.frame = (CGRect){15,BOTTOM(personalAuthIDBackView)+30,WIDTH(personalAuthcationView)-15*2,45};
    personalDoneButton.backgroundColor = BB_BlueColor;
    [personalDoneButton setTitle:@"提交" forState:UIControlStateNormal];
    [personalDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    personalDoneButton.titleLabel.font = Font(15);
    personalDoneButton.layer.cornerRadius = 4.f;
    personalDoneButton.layer.masksToBounds = YES;
    [personalDoneButton addTarget:self action:@selector(personalDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [personalAuthcationView addSubview:personalDoneButton];
    
    personalAuthcationView.contentSize = (CGSize){WIDTH(personalAuthcationView),MAX(HEIGHT(personalAuthcationView)+1, BOTTOM(personalDoneButton)+30)};
}

-(void)personalDoneButtonClick{
    if (!personalIDFrontImage) {
        [BYToastView showToastWithMessage:@"请上传个人身份证正面图片"];
        return;
    }
    if (!personalIDBackImage) {
        [BYToastView showToastWithMessage:@"请上传个人身份证背面图片"];
        return;
    }
    
    uploadImageArray = [NSMutableArray array];
    [uploadImageArray addObject:personalIDFrontImage];
    [uploadImageArray addObject:personalIDBackImage];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"";
    [indicatorView startAnimating];
    
    [self resetUploadStatus];
    
    [self uploadContentImageArray:uploadImageArray type:@"PERSONAL"];
}

#pragma mark - 初始化企业认证界面
-(void)initCompanyAuthView{
    UIScrollView *companyAuthcationView = [[UIScrollView alloc] init];
    companyAuthcationView.frame = (CGRect){WIDTH(contentView),0,WIDTH(contentView),HEIGHT(contentView)};
    companyAuthcationView.backgroundColor = contentView.backgroundColor;
    companyAuthcationView.showsHorizontalScrollIndicator = NO;
    companyAuthcationView.showsVerticalScrollIndicator = NO;
    [contentView addSubview:companyAuthcationView];
    
    UILabel *companyAuthNoteLabel = [[UILabel alloc] init];
    companyAuthNoteLabel.frame = (CGRect){0,20,WIDTH(contentView),20};
    companyAuthNoteLabel.font = Font(15);
    companyAuthNoteLabel.text = @"完善资料享受更多特权";
    companyAuthNoteLabel.textColor = RGBColor(50, 50, 50);
    companyAuthNoteLabel.textAlignment = NSTextAlignmentCenter;
    [companyAuthcationView addSubview:companyAuthNoteLabel];
    
    UIView *companyAuthLicenceView = [[UIView alloc] init];
    companyAuthLicenceView.frame = (CGRect){15,BOTTOM(companyAuthNoteLabel)+20,IDPicWidth,IDPicHeight};
    companyAuthLicenceView.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    companyAuthLicenceView.layer.borderWidth = 1;
    companyAuthLicenceView.layer.cornerRadius = 2.f;
    companyAuthLicenceView.layer.masksToBounds = YES;
    companyAuthLicenceView.userInteractionEnabled = YES;
    companyAuthLicenceView.tag = 201;
    [companyAuthcationView addSubview:companyAuthLicenceView];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTrigger:)];
    [companyAuthLicenceView addGestureRecognizer:viewTap];
    
    UIImageView *companyAuthLicencePicAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_addpic"]];
    companyAuthLicencePicAdd.frame = (CGRect){
        (WIDTH(companyAuthLicenceView)-64)/2,
        (HEIGHT(companyAuthLicenceView)-64-35)/2,
        64,
        64,
    };
    companyAuthLicencePicAdd.userInteractionEnabled = NO;
    [companyAuthLicenceView addSubview:companyAuthLicencePicAdd];
    
    UILabel *companyAuthLicenceNoteLabel = [[UILabel alloc] init];
    companyAuthLicenceNoteLabel.frame = (CGRect){0,BOTTOM(companyAuthLicencePicAdd)+20,WIDTH(companyAuthLicenceView),20};
    companyAuthLicenceNoteLabel.font = Font(16);
    companyAuthLicenceNoteLabel.text = @"上传企业营业执照";
    companyAuthLicenceNoteLabel.textColor = RGBColor(100, 100, 100);
    companyAuthLicenceNoteLabel.textAlignment = NSTextAlignmentCenter;
    companyAuthLicenceNoteLabel.userInteractionEnabled = NO;
    [companyAuthLicenceView addSubview:companyAuthLicenceNoteLabel];
    
    companyAuthLicenceImageView = [[UIImageView alloc] init];
    companyAuthLicenceImageView.backgroundColor = [UIColor clearColor];
    companyAuthLicenceImageView.frame = companyAuthLicenceView.bounds;
    companyAuthLicenceImageView.userInteractionEnabled = NO;
    [companyAuthLicenceView addSubview:companyAuthLicenceImageView];
    
    UIView *companyAuthIDFrontView = [[UIView alloc] init];
    companyAuthIDFrontView.frame = (CGRect){15,BOTTOM(companyAuthLicenceView)+20,IDPicWidth,IDPicHeight};
    companyAuthIDFrontView.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    companyAuthIDFrontView.layer.borderWidth = 1;
    companyAuthIDFrontView.layer.cornerRadius = 2.f;
    companyAuthIDFrontView.layer.masksToBounds = YES;
    companyAuthIDFrontView.userInteractionEnabled = YES;
    companyAuthIDFrontView.tag = 202;
    [companyAuthcationView addSubview:companyAuthIDFrontView];
    
    UITapGestureRecognizer *viewTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTrigger:)];
    [companyAuthIDFrontView addGestureRecognizer:viewTap2];
    
    UIImageView *authFrontPicAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_addpic"]];
    authFrontPicAdd.frame = (CGRect){
        (WIDTH(companyAuthIDFrontView)-64)/2,
        (HEIGHT(companyAuthIDFrontView)-64-35)/2,
        64,
        64,
    };
    authFrontPicAdd.userInteractionEnabled = NO;
    [companyAuthIDFrontView addSubview:authFrontPicAdd];
    
    UILabel *companyAuthIDFrontNoteLabel = [[UILabel alloc] init];
    companyAuthIDFrontNoteLabel.frame = (CGRect){0,BOTTOM(authFrontPicAdd)+20,WIDTH(companyAuthIDFrontView),20};
    companyAuthIDFrontNoteLabel.font = Font(16);
    companyAuthIDFrontNoteLabel.text = @"上传个人身份证正面照";
    companyAuthIDFrontNoteLabel.textColor = RGBColor(100, 100, 100);
    companyAuthIDFrontNoteLabel.textAlignment = NSTextAlignmentCenter;
    companyAuthIDFrontNoteLabel.userInteractionEnabled = NO;
    [companyAuthIDFrontView addSubview:companyAuthIDFrontNoteLabel];
    
    companyIDFrontImageView = [[UIImageView alloc] init];
    companyIDFrontImageView.backgroundColor = [UIColor clearColor];
    companyIDFrontImageView.frame = companyAuthIDFrontView.bounds;
    companyIDFrontImageView.userInteractionEnabled = NO;
    [companyAuthIDFrontView addSubview:companyIDFrontImageView];
    
    UIView *companyAuthIDBackView = [[UIView alloc] init];
    companyAuthIDBackView.frame = (CGRect){15,BOTTOM(companyAuthIDFrontView)+20,IDPicWidth,IDPicHeight};
    companyAuthIDBackView.layer.borderColor = RGBAColor(200, 200, 200, 0.5).CGColor;
    companyAuthIDBackView.layer.borderWidth = 1;
    companyAuthIDBackView.layer.cornerRadius = 2.f;
    companyAuthIDBackView.layer.masksToBounds = YES;
    companyAuthIDBackView.userInteractionEnabled = YES;
    companyAuthIDBackView.tag = 203;
    [companyAuthcationView addSubview:companyAuthIDBackView];
    
    UITapGestureRecognizer *viewTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapTrigger:)];
    [companyAuthIDBackView addGestureRecognizer:viewTap3];
    
    UIImageView *authBackPicAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_addpic"]];
    authBackPicAdd.frame = (CGRect){
        (WIDTH(companyAuthIDBackView)-64)/2,
        (HEIGHT(companyAuthIDBackView)-64-35)/2,
        64,
        64,
    };
    authBackPicAdd.userInteractionEnabled = NO;
    [companyAuthIDBackView addSubview:authBackPicAdd];
    
    UILabel *companyAuthIDBackNoteLabel = [[UILabel alloc] init];
    companyAuthIDBackNoteLabel.frame = (CGRect){0,BOTTOM(authBackPicAdd)+20,WIDTH(companyAuthIDBackView),20};
    companyAuthIDBackNoteLabel.font = Font(16);
    companyAuthIDBackNoteLabel.text = @"上传法人身份证背面照";
    companyAuthIDBackNoteLabel.textColor = RGBColor(100, 100, 100);
    companyAuthIDBackNoteLabel.textAlignment = NSTextAlignmentCenter;
    companyAuthIDBackNoteLabel.userInteractionEnabled = NO;
    [companyAuthIDBackView addSubview:companyAuthIDBackNoteLabel];
    
    companyIDBackImageView = [[UIImageView alloc] init];
    companyIDBackImageView.backgroundColor = [UIColor clearColor];
    companyIDBackImageView.frame = companyAuthIDBackView.bounds;
    companyIDBackImageView.userInteractionEnabled = NO;
    [companyAuthIDBackView addSubview:companyIDBackImageView];
    
    
    UIButton *companyDoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    companyDoneButton.frame = (CGRect){15,BOTTOM(companyAuthIDBackView)+30,WIDTH(companyAuthcationView)-15*2,45};
    companyDoneButton.backgroundColor = BB_BlueColor;
    [companyDoneButton setTitle:@"提交" forState:UIControlStateNormal];
    [companyDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    companyDoneButton.titleLabel.font = Font(15);
    companyDoneButton.layer.cornerRadius = 4.f;
    companyDoneButton.layer.masksToBounds = YES;
    [companyDoneButton addTarget:self action:@selector(companyDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [companyAuthcationView addSubview:companyDoneButton];
    
    companyAuthcationView.contentSize = (CGSize){WIDTH(companyAuthcationView),MAX(HEIGHT(companyAuthcationView)+1, BOTTOM(companyDoneButton)+30)};
}

-(void)companyDoneButtonClick{
    if (!companyLicenceImage) {
        [BYToastView showToastWithMessage:@"请上传企业营业执照图片"];
        return;
    }
    if (!companyIDFrontImage) {
        [BYToastView showToastWithMessage:@"请上传企业法人身份证正面图片"];
        return;
    }
    if (!companyIDBackImage) {
        [BYToastView showToastWithMessage:@"请上传企业法人身份证背面图片"];
        return;
    }
    
    uploadImageArray = [NSMutableArray array];
    [uploadImageArray addObject:companyLicenceImage];
    [uploadImageArray addObject:companyIDFrontImage];
    [uploadImageArray addObject:companyIDBackImage];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"";
    [indicatorView startAnimating];
    
    [self resetUploadStatus];
    
    [self uploadContentImageArray:uploadImageArray type:@"COMPANY"];
}

static NSInteger clickTag;
#pragma mark - 上传图片按钮点击事件
-(void)viewTapTrigger:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    clickTag = tag;
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
        cropController.aspectRadio = (CGSize){86,54};
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
    switch (clickTag) {
        case 101:{
            personalIDFrontImage = chosenImage;
            personalIDFrontImageView.image = chosenImage;
        }
            break;
        case 102:{
            personalIDBackImage = chosenImage;
            personalIDBackImageView.image = chosenImage;
        }
            break;
        case 201:{
            companyLicenceImage = chosenImage;
            companyAuthLicenceImageView.image = chosenImage;
        }
            break;
        case 202:{
            companyIDFrontImage = chosenImage;
            companyIDFrontImageView.image = chosenImage;
        }
            break;
        case 203:{
            companyIDBackImage = chosenImage;
            companyIDBackImageView.image = chosenImage;
        }
            break;
        default:
            break;
    }
}

// 点击取消或从外部应用调回时触发的代理  如果canceled为yes 标识 可以认为是用户手动点击了取消按钮
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 89898) {
        float xOff = scrollView.contentOffset.x;
        if (xOff < 0 || xOff > scrollView.contentSize.width) {
            return;
        }
        selectedLineView.frame = (CGRect){xOff/2,45-2,WIDTH(self.view)/2,2};
        if (xOff == 0) {
            [personalButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            [companyButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
        }else if (xOff == WIDTH(scrollView)){
            [companyButton setTitleColor:BB_BlueColor forState:UIControlStateNormal];
            [personalButton setTitleColor:RGBColor(50, 50, 50) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"认证";
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
