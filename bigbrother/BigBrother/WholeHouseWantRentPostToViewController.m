//
//  WholeHouseWantRentViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/2/26.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "WholeHouseWantRentPostToViewController.h"
#import "LoginViewController.h"

#import "TPKeyboardAvoidingScrollView.h"
#import "CTAssetsPickerController.h"
#import "XYW8IndicatorView.h"

@interface WholeHouseWantRentPostToViewController ()<CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>

@end

@implementation WholeHouseWantRentPostToViewController{
    
    UIScrollView *contentView;
    
    float viewHeightOffset;
    float titleLineHeight;
    
    //发布 相关
    XYW8IndicatorView *indicatorView;
    bool uploadImagesStart;
    int uploadImagesRemainCount;
    int uploadImagesTotalCount;
    int uploadImagesCurrentIndex;
    NSMutableArray *uploadResultArray;
    
    //选择图片相关
    UIView *pictureSelectView;
    UIScrollView *pictureImageContentScrollView;
    UIButton *addPictureButton;
    
    NSMutableArray *uploadImageArray;
    
    //关键字界面相关
    UIView *keyWordsView;
    NSMutableArray *keyWordsTextFiledArray;
    
    //标题界面相关
    UIView *titleView;
    UITextField *titleEditTextFiled;
    
    //产品供应地相关
    UIView *provideAreaView;
    UILabel *provideAreaInfoLabel;
    NSDictionary *provideAreaInfoDic;
    NSArray *provideAreaListArray;
    
    //价格 填写相关
    UIView *priceView;
    UITextField *priceTextFiled;
    
    //房屋类型 view相关 roomtype
    UIView *houseRoomTypeChooseView;
    UILabel *houseRoomTypeChooseInfoLabel;
    NSDictionary *houseRoomTypeChooseInfoDic;
    NSArray *houseRoomTypeChooseListArray;
    
    //房屋面积相关
    UIView *houseAreaView;
    UITextField *houseAreaTextfield;
    
    //描述相关
    UIView *decriptionView;
    UITextView *decriptionTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    titleLineHeight = 45.f;
    
    contentView = [[TPKeyboardAvoidingScrollView alloc] init];
    contentView.frame = (CGRect){0,BB_NarbarHeight,WIDTH(self.view),HEIGHT(self.view)-BB_NarbarHeight-45};
    contentView.contentSize = (CGSize){WIDTH(contentView),HEIGHT(contentView)+1};
    contentView.backgroundColor = BB_WhiteColor;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = YES;
    [self.view addSubview:contentView];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postButton.frame = (CGRect){0,HEIGHT(self.view)-45,WIDTH(self.view),45};
    [self.view addSubview:postButton];
    postButton.backgroundColor = BB_BlueColor;
    [postButton setTitle:@"发布" forState:UIControlStateNormal];
    [postButton setTitleColor:BB_WhiteColor forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self reloadViews];
}

-(void)reloadViews{
    viewHeightOffset = 10;
    
    pictureSelectView = [self setUpPictureSelectViewWithOffset:viewHeightOffset];
    [contentView addSubview:pictureSelectView];
    
    viewHeightOffset += HEIGHT(pictureSelectView);
    
    viewHeightOffset += 10;
    
    keyWordsView = [self setUpKeyWordsViewWithOffset:viewHeightOffset];
    [contentView addSubview:keyWordsView];
    
    viewHeightOffset += HEIGHT(keyWordsView);
    viewHeightOffset += 10;
    
    titleView = [self setUpTitleViewWithOffset:viewHeightOffset];
    [contentView addSubview:titleView];
    
    viewHeightOffset += HEIGHT(titleView);
    
    priceView = [self setUpPriceViewWithOffset:viewHeightOffset];
    [contentView addSubview:priceView];
    
    viewHeightOffset += HEIGHT(priceView);
    viewHeightOffset += 10;
    
    provideAreaView = [self setUpProvideAreaViewWithOffset:viewHeightOffset];
    [contentView  addSubview:provideAreaView];
    
    viewHeightOffset += HEIGHT(provideAreaView);
    
    houseAreaView = [self setUpHouseAreaViewWithOffset:viewHeightOffset];
    [contentView addSubview:houseAreaView];
    
    viewHeightOffset += HEIGHT(houseAreaView);
    
    houseRoomTypeChooseView = [self setUpHouseRoomTypeChooseViewWithOffset:viewHeightOffset];
    [contentView addSubview:houseRoomTypeChooseView];
    
    viewHeightOffset += HEIGHT(houseRoomTypeChooseView);
    viewHeightOffset += 10;
    
    decriptionView = [self setUpDesciptionViewWithOffset:viewHeightOffset];
    [contentView addSubview:decriptionView];
    
    viewHeightOffset += HEIGHT(decriptionView);
    viewHeightOffset += 10;
    
    contentView.contentSize = (CGSize){WIDTH(contentView),MAX(viewHeightOffset, HEIGHT(contentView)+1)};
}

#pragma mark - 发布 网络请求
//发送按钮点击
-(void)postButtonClick{
    [self resignAllInputs];
    
    if (![BBUserDefaults getUserID]) {
        [BYToastView showToastWithMessage:@"还未登录"];
        NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Navigation_FontColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        
        [navi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
        
        navi.view.backgroundColor = BB_WhiteColor;
        navi.navigationBar.barTintColor = BB_NaviColor;
        navi.navigationBar.barStyle = UIBarStyleBlack;
        
        [self presentViewController:navi animated:YES completion:nil];
        return;
    }
    
    NSMutableArray *keywordMutableArray = [NSMutableArray array];
    for (UITextField *tf in keyWordsTextFiledArray) {
        if (tf) {
            NSString *keyWordsTmpString = tf.text;
            if (![keyWordsTmpString isEqualToString:@""]) {
                if (![XYTools checkString:keyWordsTmpString canEmpty:YES]) {
                    [BYToastView showToastWithMessage:@"关键字不能包含特殊字符"];
                    return;
                }else{
                    [keywordMutableArray addObject:@{@"name":keyWordsTmpString}];
                }
            }
        }
    }
    
    NSString *titleString = titleEditTextFiled.text;
    if (![XYTools checkString:titleString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"标题不能包含特殊字符"];
        return;
    }
    
    NSString *priceString = priceTextFiled.text;
    if (![XYTools checkString:priceString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"价格不能包含特殊字符"];
        return;
    }
    
    NSString *houseAreaString = houseAreaTextfield.text;
    if (![XYTools checkString:houseAreaString canEmpty:NO]) {
        [BYToastView showToastWithMessage:@"面积不能包含特殊字符"];
        return;
    }
    
    if (!provideAreaInfoDic && provideAreaInfoDic.count ==0) {
        [BYToastView showToastWithMessage:@"未选择服务区域信息"];
        return;
    }
    long provideID = [[provideAreaInfoDic objectForKey:@"id"] longValue];
    
    if (!houseRoomTypeChooseInfoDic && houseRoomTypeChooseInfoDic.count ==0) {
        [BYToastView showToastWithMessage:@"未选择房间厅室信息"];
        return;
    }
    long houseRoomTypeID = [[houseRoomTypeChooseInfoDic objectForKey:@"id"] longValue];
    
    NSString *desciptionString = decriptionTextView.text;
    if (![XYTools checkString:desciptionString canEmpty:YES]) {
        [BYToastView showToastWithMessage:@"详情描述不能包含特殊字符"];
        return;
    }
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:titleString forKey:@"title"];
    [paramsDic setObject:keywordMutableArray forKey:@"keywords"];
    [paramsDic setObject:priceString forKey:@"price"];
    [paramsDic setObject:houseAreaString forKey:@"area"];
    [paramsDic setObject:@(provideID) forKey:@"districtId"];
    [paramsDic setObject:@(houseRoomTypeID) forKey:@"expectedTypeId"];
    [paramsDic setObject:desciptionString forKey:@"introduction"];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    indicatorView = [XYW8IndicatorView new];
    indicatorView.frame = (CGRect){0,0,WIDTH(keyWindow),HEIGHT(keyWindow)};
    [keyWindow addSubview:indicatorView];
    indicatorView.dotColor = [UIColor whiteColor];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicatorView.loadingLabel.text = @"";
    [indicatorView startAnimating];
    
    [self resetUploadStatus];
    [self uploadBaseProductToServerWithParameters:paramsDic];
}

-(void)uploadBaseProductToServerWithParameters:(NSMutableDictionary *)params{
    if (!params) {
        [BYToastView showToastWithMessage:@"上传参数错误"];
        return;
    }
    [self uploadContentImageArray:uploadImageArray andParamsDic:params];
}

-(void)resetUploadStatus{
    uploadImagesStart = YES;
    uploadImagesRemainCount = 0;
    uploadImagesTotalCount = 0;
    uploadImagesCurrentIndex = 0;
    uploadResultArray = nil;
}

-(void)uploadContentImageArray:(NSArray *)array andParamsDic:(NSMutableDictionary *)params{
    if (!uploadImageArray || uploadImageArray.count == 0) {
        [self uploadContentImageToServerWithImagesUrlArray:nil params:params];
    }else{
        if (uploadImagesStart) {
            uploadImagesRemainCount = (int)array.count;
            uploadImagesTotalCount = uploadImagesRemainCount;
            uploadImagesCurrentIndex = 0;
            uploadImagesStart = NO;
            uploadResultArray = [NSMutableArray array];
            [self uploadContentImageArray:array andParamsDic:params];
        }else{
            indicatorView.loadingLabel.text = [NSString stringWithFormat:@"正在上传第 %d/%d 张图片",uploadImagesCurrentIndex+1,uploadImagesTotalCount];
            double uploadstart = [[NSDate date] timeIntervalSince1970];
            
            id tmp = uploadImageArray[uploadImagesCurrentIndex];
            if ([tmp isKindOfClass:[NSString class]]) {
                NSString *imageUrl = (NSString *)tmp;
                if (imageUrl) {
                    [uploadResultArray addObject:imageUrl];
                    uploadImagesRemainCount --;
                    uploadImagesCurrentIndex++;
                    if (uploadImagesRemainCount == 0) {
                        [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] params:params];
                        return;
                    }else{
                        [self uploadContentImageArray:array andParamsDic:params];
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
                        [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] params:params];
                        return;
                    }else{
                        [self uploadContentImageArray:array andParamsDic:params];
                    }
                }else{
                    [indicatorView stopAnimating:YES];
                    [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                    [self resetUploadStatus];
                }
            }else if ([tmp isKindOfClass:[UIImage class]]){
                UIImage *uploadContentImage = (UIImage *)tmp;
                
                [BBUrlConnection uploadWithImage:uploadContentImage productType:BaseProductTypeFactory complete:^(NSString *imageUrl) {
                    double uploadend = [[NSDate date] timeIntervalSince1970];
                    float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (imageUrl) {
                            [uploadResultArray addObject:imageUrl];
                            uploadImagesRemainCount --;
                            uploadImagesCurrentIndex++;
                            if (uploadImagesRemainCount == 0) {
                                [self uploadContentImageToServerWithImagesUrlArray:[NSArray arrayWithArray:uploadResultArray] params:params];
                                return;
                            }else{
                                [self uploadContentImageArray:array andParamsDic:params];
                            }
                        }else{
                            [indicatorView stopAnimating:YES];
                            [BYToastView showToastWithMessage:@"图片上传失败,请重试"];
                            [self resetUploadStatus];
                        }
                    });
                }];
            }
        }
    }
}

-(void)uploadContentImageToServerWithImagesUrlArray:(NSArray *)array params:(NSMutableDictionary *)params{
    if (array) {
        
        NSMutableArray *imagesArrayTmp = [NSMutableArray array];
        for (int i = 0; i<array.count; i++) {
            id object = array[i];
            if (object) {
                if ([object isKindOfClass:[NSString class]]) {
                    NSString *objString = (NSString *)object;
                    if (objString) {
                        [imagesArrayTmp addObject:@{@"url":objString,@"orderBy":@(i)}];
                    }
                }
            }else if ([object isKindOfClass:[NSDictionary class]]){
                NSString *urlString = [object objectForKey:@"url"];
                if (urlString) {
                    [imagesArrayTmp addObject:@{@"url":urlString,@"orderBy":@(i)}];
                }
            }
        }
        if (params) {
            [params setObject:imagesArrayTmp forKey:@"images"];
        }
    }
    [self uploadWithParams:params];
}

-(void)uploadWithParams:(NSMutableDictionary *)paramsDic{
    indicatorView.loadingLabel.text = @"提交至服务器";
    double uploadstart = [[NSDate date] timeIntervalSince1970];
    [BBUrlConnection uploadNewWholeHouseWantRentInfoWithParams:paramsDic complete:^(NSDictionary *resultDic, NSString *errorString) {
        double uploadend = [[NSDate date] timeIntervalSince1970];
        float delay = uploadend-uploadstart >5?0.2:5-(uploadend-uploadstart);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating:YES];
            if (errorString) {
                [BYToastView showToastWithMessage:errorString];
            }else{
                int code = [resultDic[@"code"] intValue];
                if (code == 0) {
                    [BYToastView showToastWithMessage:@"发布成功,感谢您的支持"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [BYToastView showToastWithMessage:@"发送失败,请稍候重试"];
                }
            }
        });
    }];
}

#pragma mark - 上传图片 view 及相关事件
-(UIView *)setUpPictureSelectViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+70+10*2};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,155,titleLineHeight};
    noteLabel.text = @"上传图片";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.frame = (CGRect){0,HEIGHT(noteLabel)-0.5,WIDTH(view),0.5};
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view addSubview:lineSepView];
    
    pictureImageContentScrollView = [[UIScrollView alloc] init];
    pictureImageContentScrollView.frame = (CGRect){10,HEIGHT(noteLabel)+10,WIDTH(view)-20,70};;
    pictureImageContentScrollView.contentSize = (CGSize){WIDTH(pictureImageContentScrollView)+1,HEIGHT(pictureImageContentScrollView)};
    pictureImageContentScrollView.backgroundColor = [UIColor whiteColor];
    pictureImageContentScrollView.showsHorizontalScrollIndicator = NO;
    pictureImageContentScrollView.showsVerticalScrollIndicator = NO;
    pictureImageContentScrollView.bounces = YES;
    [view addSubview:pictureImageContentScrollView];
    
    addPictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addPictureButton.frame = (CGRect){0,0,HEIGHT(pictureImageContentScrollView),HEIGHT(pictureImageContentScrollView)};
    addPictureButton.tintColor = RGBColor(200, 200, 200);
    [addPictureButton setImage:[UIImage imageNamed:@"icon_addImage"] forState:UIControlStateNormal];
    [pictureImageContentScrollView addSubview:addPictureButton];
    [addPictureButton addTarget:self action:@selector(addPictureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+70+10*2};
    return view;
}

-(void)addPictureButtonClick{
    [self resignAllInputs];
    
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
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.maximumNumberOfSelection = 10;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.delegate = self;
            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (!uploadImageArray){
        uploadImageArray = [NSMutableArray array];
    }
    [uploadImageArray addObject:chosenImage];
    [self reloadImageSrollContainer:uploadImageArray];
}

#pragma mark - CTAssetsPickerControllerDelegate
-(void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if (!uploadImageArray){
        uploadImageArray = [NSMutableArray array];
    }
    [assets enumerateObjectsUsingBlock:^(ALAsset *imageAsset, NSUInteger idx, BOOL *stop) {
        UIImage *uploadImage = [UIImage imageWithCGImage:[[imageAsset defaultRepresentation] fullResolutionImage]];
        UIImage *reszieImage = [self fixImageOrientationWithimage:uploadImage orientation:(ALAssetOrientation)[[imageAsset valueForProperty:ALAssetPropertyOrientation] intValue]];
        [uploadImageArray addObject:reszieImage];
    }];
    [self reloadImageSrollContainer:uploadImageArray];
}

-(UIImage *)fixImageOrientationWithimage:(UIImage *)img orientation:(ALAssetOrientation)imageOrientation{
    
    UIImageOrientation orient = (int)imageOrientation;
    
    CGImageRef imgRef = img.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
    
}

-(void)reloadImageSrollContainer:(NSArray *)array{
    [pictureImageContentScrollView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (obj != addPictureButton) {
            [obj removeFromSuperview];
        }
    }];
    float everyButtonWidth = WIDTH(addPictureButton);
    for (int i = 0;i<array.count;i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = (CGRect){(everyButtonWidth+10)*i,0,everyButtonWidth,everyButtonWidth};
        button.tag = i;
        [button addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageContentScrollView addSubview:button];
        
        UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, everyButtonWidth, everyButtonWidth)];
        UIImage *image = array[i];
        postImageView.image = image;
        [button addSubview:postImageView];
        
        UIButton *deleteButton = [[UIButton alloc] init];
        deleteButton.frame = CGRectMake(everyButtonWidth-15, -6, 25, 25);
        [button addSubview:deleteButton];
        [deleteButton setImage:[UIImage imageNamed:@"imagedelete"] forState:UIControlStateNormal];
        deleteButton.tag = i;
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    addPictureButton.frame = (CGRect){10+(everyButtonWidth+8)*array.count,0,everyButtonWidth,everyButtonWidth};
    
    pictureImageContentScrollView.contentSize = (CGSize){MAX(WIDTH(pictureImageContentScrollView)+1, (everyButtonWidth+10)*(array.count+1)),HEIGHT(pictureImageContentScrollView)};
}

-(void)imageButtonClick:(UIButton *)button{
    UIImage *image = uploadImageArray[button.tag];
    if (image) {
        [self checkImgInFullScreen:button withImage:image];
    }
}

-(void)deleteButtonClick:(UIButton *)buttn{
    [uploadImageArray removeObjectAtIndex:buttn.tag];
    
    [self reloadImageSrollContainer:uploadImageArray];
}

#pragma mark - checkImgInFullScreen
static CGRect rectInFullScreen;
-(void)checkImgInFullScreen:(UIView*)view withImage:(UIImage *)image{
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
    
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    rectInFullScreen = [view convertRect:view.frame toView:window];
    
    //修正frame
    CGRect fixRect = (CGRect){
        view.frame.origin.x-pictureImageContentScrollView.contentOffset.x,
        rectInFullScreen.origin.y,
        rectInFullScreen.size.width,
        rectInFullScreen.size.height};
    rectInFullScreen = fixRect;
    
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
        UIImageView *subView = (UIImageView *)[scrollView viewWithTag:1001];
        return subView;
    }else{
        return nil;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (scrollView.tag == 9797) {
        if (scale < 1.f) {
            [scrollView setZoomScale:1.f animated:YES];
            if (scale < 0.7f)
                [self exitCheckImgView];
        }
    }
}


#pragma mark - 标题 view 及相关事件
-(UIView *)setUpTitleViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,35,HEIGHT(view)};
    noteLabel.text = @"标题";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    titleEditTextFiled = [[UITextField alloc] init];
    titleEditTextFiled.frame = (CGRect){
        RIGHT(noteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(noteLabel)+10)-10,
        titleLineHeight
    };
    titleEditTextFiled.textColor = RGBColor(80, 80, 80);
    titleEditTextFiled.font = Font(15);
    titleEditTextFiled.minimumFontSize = 10;
    titleEditTextFiled.adjustsFontSizeToFitWidth = YES;
    titleEditTextFiled.returnKeyType = UIReturnKeyDone;
    titleEditTextFiled.keyboardType = UIKeyboardTypeDefault;
    [titleEditTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [titleEditTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [titleEditTextFiled setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(titleEditTextFiled)}]];
    [titleEditTextFiled setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(titleEditTextFiled)}]];
    titleEditTextFiled.leftViewMode = UITextFieldViewModeAlways;
    titleEditTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:titleEditTextFiled];
    
    return view;
}

#pragma mark - 关键字界面 view
-(UIView *)setUpKeyWordsViewWithOffset:(float)offset{
    UIView *viewTmp = [[UIView alloc] init];
    viewTmp.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+35*2+10};
    viewTmp.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,55,titleLineHeight};
    noteLabel.text = @"关键字";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [viewTmp addSubview:noteLabel];
    
    UILabel *noteDesribeLabel = [[UILabel alloc] init];
    noteDesribeLabel.frame = (CGRect){RIGHT(noteLabel),0,WIDTH(viewTmp)-10*2-RIGHT(noteLabel),titleLineHeight};
    noteDesribeLabel.text = @"（非必填，有助于提交成交率）";
    noteDesribeLabel.textColor = RGBColor(100, 100, 100);
    noteDesribeLabel.textAlignment = NSTextAlignmentLeft;
    noteDesribeLabel.font = Font(14);
    [viewTmp addSubview:noteDesribeLabel];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.frame = (CGRect){0,HEIGHT(noteLabel)-0.5,WIDTH(viewTmp),0.5};
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [viewTmp addSubview:lineSepView];
    
    float textFiledBetweenWidth = 15;
    float textFiledBetweenHeight = 10;
    float textFiledWidth = (WIDTH(viewTmp)-10*2-textFiledBetweenWidth*2)/3;
    
    keyWordsTextFiledArray = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        int xOff = i % 3;
        int yOff = (int)(i / 3);
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = (CGRect){
            10+(textFiledWidth+textFiledBetweenWidth)*xOff,
            HEIGHT(noteLabel) + textFiledBetweenHeight + (35+textFiledBetweenHeight)*yOff,
            textFiledWidth,
            35
        };
        textField.layer.cornerRadius = 2.f;
        textField.layer.masksToBounds = YES;
        textField.layer.borderWidth = 0.5f;
        textField.layer.borderColor = RGBAColor(100, 100, 100, 0.5).CGColor;
        textField.textColor = RGBColor(100, 100, 100);
        textField.font = Font(14);
        textField.minimumFontSize = 10;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeDefault;
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        [textField setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(textField)}]];
        [textField setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(textField)}]];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.rightViewMode = UITextFieldViewModeAlways;
        
        [viewTmp addSubview:textField];
        
        [keyWordsTextFiledArray addObject:textField];
    }
    
    viewTmp.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+35*2+textFiledBetweenHeight*3};
    
    return viewTmp;
}

#pragma mark - 价格price view 及相关事件
-(UIView *)setUpPriceViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"期望租金";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    
    UILabel *unitNoteLabel = [[UILabel alloc] init];
    unitNoteLabel.frame = (CGRect){WIDTH(view)-10-35,0,35,HEIGHT(noteLabel)};
    unitNoteLabel.text = @"元/月";
    unitNoteLabel.textColor = RGBColor(50, 50, 50);
    unitNoteLabel.textAlignment = NSTextAlignmentRight;
    unitNoteLabel.font = Font(14);
    [view addSubview:unitNoteLabel];
    
    priceTextFiled = [[UITextField alloc] init];
    priceTextFiled.frame = (CGRect){
        RIGHT(noteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(noteLabel)+10)-WIDTH(unitNoteLabel)-10,
        titleLineHeight
    };
    priceTextFiled.textColor = RGBColor(80, 80, 80);
    priceTextFiled.font = Font(15);
    priceTextFiled.textAlignment = NSTextAlignmentRight;
    priceTextFiled.minimumFontSize = 10;
    priceTextFiled.adjustsFontSizeToFitWidth = YES;
    priceTextFiled.returnKeyType = UIReturnKeyDone;
    priceTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    [priceTextFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [priceTextFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [priceTextFiled setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(priceTextFiled)}]];
    [priceTextFiled setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(priceTextFiled)}]];
    priceTextFiled.leftViewMode = UITextFieldViewModeAlways;
    priceTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:priceTextFiled];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    lineSepView.frame = (CGRect){0,0,WIDTH(view),0.5};
    [view addSubview:lineSepView];
    
    return view;
}

#pragma mark - 面积 view 及相关事件
-(UIView *)setUpHouseAreaViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"期望面积";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    UILabel *unitNoteLabel = [[UILabel alloc] init];
    unitNoteLabel.frame = (CGRect){WIDTH(view)-10-20,0,20,HEIGHT(noteLabel)};
    unitNoteLabel.text = @"㎡";
    unitNoteLabel.textColor = RGBColor(50, 50, 50);
    unitNoteLabel.textAlignment = NSTextAlignmentRight;
    unitNoteLabel.font = Font(14);
    [view addSubview:unitNoteLabel];
    
    houseAreaTextfield = [[UITextField alloc] init];
    houseAreaTextfield.frame = (CGRect){
        RIGHT(noteLabel)+10,
        0,
        WIDTH(view)-(RIGHT(noteLabel)+10)-WIDTH(unitNoteLabel)-10,
        titleLineHeight
    };
    houseAreaTextfield.textColor = RGBColor(80, 80, 80);
    houseAreaTextfield.font = Font(15);
    houseAreaTextfield.textAlignment = NSTextAlignmentRight;
    houseAreaTextfield.minimumFontSize = 10;
    houseAreaTextfield.adjustsFontSizeToFitWidth = YES;
    houseAreaTextfield.returnKeyType = UIReturnKeyDone;
    houseAreaTextfield.keyboardType = UIKeyboardTypePhonePad;
    [houseAreaTextfield setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [houseAreaTextfield setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [houseAreaTextfield setLeftView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(houseAreaTextfield)}]];
    [houseAreaTextfield setRightView:[[UIView alloc] initWithFrame:(CGRect){0,0,5,HEIGHT(houseAreaTextfield)}]];
    houseAreaTextfield.leftViewMode = UITextFieldViewModeAlways;
    houseAreaTextfield.rightViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:houseAreaTextfield];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    lineSepView.frame = (CGRect){0,0,WIDTH(view),0.5};
    [view addSubview:lineSepView];
    
    return view;
}

#pragma mark - 厅室选择的 view 和相关事件
-(UIView *)setUpHouseRoomTypeChooseViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *houseRoomTypeChooseViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseRoomTypeChooseViewTap)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:houseRoomTypeChooseViewTap];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"期望户型";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    houseRoomTypeChooseInfoLabel = [[UILabel alloc] init];
    houseRoomTypeChooseInfoLabel.frame = (CGRect){RIGHT(noteLabel)+10,0,WIDTH(view)-RIGHT(noteLabel)-10-10,HEIGHT(view)};
    houseRoomTypeChooseInfoLabel.text = @"";
    houseRoomTypeChooseInfoLabel.textColor = RGBColor(50, 50, 50);
    houseRoomTypeChooseInfoLabel.textAlignment = NSTextAlignmentRight;
    houseRoomTypeChooseInfoLabel.font = Font(14);
    [view addSubview:houseRoomTypeChooseInfoLabel];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    lineSepView.frame = (CGRect){0,0,WIDTH(view),0.5};
    [view addSubview:lineSepView];
    
    [self getRoomTypeListList];
    return view;
}

-(void)houseRoomTypeChooseViewTap{
    [self resignAllInputs];
    if (!houseRoomTypeChooseListArray || houseRoomTypeChooseListArray.count == 0) {
        [BYToastView showToastWithMessage:@"数据不存在,请稍候再试"];
        [self getRoomTypeListList];
        return;
    }
    [PopUpSelectedView showFilterSingleChooseViewWithArray:houseRoomTypeChooseListArray withTitle:@"厅室选择" target:self labelTapAction:@selector(houseRoomTypeChooseClick:)];
}

-(void)houseRoomTypeChooseClick:(UITapGestureRecognizer *)tap{
    if (!houseRoomTypeChooseListArray || houseRoomTypeChooseListArray.count == 0) {
        return;
    }
    NSDictionary *dic = houseRoomTypeChooseListArray[tap.view.tag];
    houseRoomTypeChooseInfoDic = dic;
    NSString *name = dic[@"name"];
    houseRoomTypeChooseInfoLabel.text = name;
    [PopUpSelectedView dismissFilterChooseView];
}

-(void)getRoomTypeListList{
    [BBUrlConnection getRoomTypeListComplete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取厅室信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSArray *dataArray = resultDic[@"data"];
        if (code != 0 || !dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取厅室信息失败,请稍后再试"];
            return;
        }
        
        NSMutableArray *supplyTmpShowedArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArray) {
            int gategroyIDTmp = [dic[@"id"] intValue];
            NSString *name = dic[@"name"];
            [supplyTmpShowedArray addObject:@{@"id":@(gategroyIDTmp),@"name":name}];
        }
        houseRoomTypeChooseListArray = [NSArray arrayWithArray:supplyTmpShowedArray];
    }];
}

#pragma mark - 供应地的 view 和相关事件
-(UIView *)setUpProvideAreaViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight};
    view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *provideAreaViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(provideAreaViewTap)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:provideAreaViewTap];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,65,HEIGHT(view)};
    noteLabel.text = @"期望地区";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    provideAreaInfoLabel = [[UILabel alloc] init];
    provideAreaInfoLabel.frame = (CGRect){RIGHT(noteLabel)+10,0,WIDTH(view)-RIGHT(noteLabel)-10-10,HEIGHT(view)};
    provideAreaInfoLabel.text = @"";
    provideAreaInfoLabel.textColor = RGBColor(50, 50, 50);
    provideAreaInfoLabel.textAlignment = NSTextAlignmentRight;
    provideAreaInfoLabel.font = Font(14);
    [view addSubview:provideAreaInfoLabel];
    
    [self getAreaList];
    return view;
}

-(void)provideAreaViewTap{
    [self resignAllInputs];
    if (!provideAreaListArray || provideAreaListArray.count == 0) {
        [BYToastView showToastWithMessage:@"数据不存在,请稍候再试"];
        [self getAreaList];
        return;
    }
    [PopUpSelectedView showFilterSingleChooseViewWithArray:provideAreaListArray withTitle:@"产品供应地" target:self labelTapAction:@selector(provideAreaActiveSelectClick:)];
}

-(void)provideAreaActiveSelectClick:(UITapGestureRecognizer *)tap{
    if (!provideAreaListArray || provideAreaListArray.count == 0) {
        return;
    }
    NSDictionary *dic = provideAreaListArray[tap.view.tag];
    provideAreaInfoDic = dic;
    NSString *name = dic[@"name"];
    provideAreaInfoLabel.text = name;
    [PopUpSelectedView dismissFilterChooseView];
}

-(void)getAreaList{
    int cityID = [BBUserDefaults getCityID];
    [BBUrlConnection getAllDistrictWithCityID:cityID complete:^(NSDictionary *resultDic, NSString *errorString) {
        if (errorString) {
            [BYToastView showToastWithMessage:errorString];
            return;
        }
        if (!resultDic || [resultDic isKindOfClass:[NSNull class]]) {
            [BYToastView showToastWithMessage:@"获取供应区域信息失败,请稍后再试"];
            return;
        }
        int code = [resultDic[@"code"] intValue];
        NSDictionary *dataDic = resultDic[@"data"];
        if (code != 0 || !dataDic) {
            [BYToastView showToastWithMessage:@"获取供应区域信息失败,请稍后再试"];
            return;
        }
        
        NSArray *districtsArray = dataDic[@"districts"];
        if (!districtsArray || districtsArray.count == 0 || ![districtsArray isKindOfClass:[NSArray class]]) {
            [BYToastView showToastWithMessage:@"获取供应区域信息失败,请稍后再试"];
            return;
        }
        
        NSMutableArray *districtsTmpShowedArray = [NSMutableArray array];
        for (NSDictionary *dic in districtsArray) {
            int districtIDTmp = [dic[@"id"] intValue];
            NSString *name1 = dic[@"name"];
            NSString *name2 = dic[@"suffix"];
            NSString *name = [name1 stringByAppendingString:name2];
            [districtsTmpShowedArray addObject:@{@"id":@(districtIDTmp),@"name":name}];
        }
        provideAreaListArray = [NSArray arrayWithArray:districtsTmpShowedArray];
    }];
}

#pragma mark - 产品描述 view 及相关事件
-(UIView *)setUpDesciptionViewWithOffset:(float)offset{
    UIView *view = [[UIView alloc] init];
    view.frame = (CGRect){0,offset,WIDTH(contentView),titleLineHeight+200};
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = (CGRect){10,0,35,titleLineHeight};
    noteLabel.text = @"描述";
    noteLabel.textColor = RGBColor(50, 50, 50);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:noteLabel];
    
    UIView *lineSepView = [[UIView alloc] init];
    lineSepView.frame = (CGRect){0,HEIGHT(noteLabel)-0.5,WIDTH(view),0.5};
    lineSepView.backgroundColor = RGBAColor(200, 200, 200, 0.5);
    [view addSubview:lineSepView];
    
    decriptionTextView = [[UITextView alloc] init];
    decriptionTextView.backgroundColor = [UIColor whiteColor];
    decriptionTextView.frame = (CGRect){10,HEIGHT(noteLabel)+10,WIDTH(view)-10,200};
    decriptionTextView.textColor = RGBColor(100, 100, 100);
    decriptionTextView.font = Font(15);
    decriptionTextView.keyboardType = UIKeyboardTypeDefault;
    decriptionTextView.returnKeyType = UIReturnKeyNext;
    decriptionTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    decriptionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [view addSubview:decriptionTextView];
    
    view.frame = (CGRect){0,offset,WIDTH(contentView),BOTTOM(decriptionTextView)+10};
    return view;
}

#pragma mark -
-(void)resignAllInputs{
    for (UITextField *tf in keyWordsTextFiledArray) {
        [tf resignFirstResponder];
    }
    
    [titleEditTextFiled resignFirstResponder];
    [priceTextFiled resignFirstResponder];
    [houseAreaTextfield resignFirstResponder];
    [decriptionTextView resignFirstResponder];
}

#pragma mark - Nacigation
-(void)setUpNavigation{
    if (!self.title) {
        self.title = @"房屋求租-发布";
    }
    
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
