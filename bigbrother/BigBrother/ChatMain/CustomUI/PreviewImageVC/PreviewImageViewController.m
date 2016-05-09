//
//  PreviewImageViewController.m
//  BookClub
//
//  Created by 李祖建 on 16/1/20.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import "PreviewImageViewController.h"



@interface PreviewImageViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGesture;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;


@end

static CGRect oldframe;

@implementation PreviewImageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.fd_prefersNavigationBarHidden = NO;
        self.isAnimation = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self initializeDataSource];
    [self initializeUserInterface];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

#pragma mark - 数据初始化
- (void)initializeDataSource
{
    
}

#pragma mark - 视图初始化
- (void)initializeUserInterface
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    
    if (!self.isAnimation) {
        [self refreshScrollViewAttribute];
    }
    
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.bottomView];
    
//    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,MAINSCRREN_H-NAVBAR_H,MAINSCRREN_W,NAVBAR_H)];
//    _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    [self.view addSubview:_bottomView];
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(0, 0,80,NAVBAR_H);
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setTintColor:[UIColor whiteColor]];
//    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:cancelBtn];
//    
//    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    chooseBtn.frame = CGRectMake(MAINSCRREN_W-80, 0,80,NAVBAR_H);
//    [chooseBtn setTitle:@"选取" forState:UIControlStateNormal];
//    [chooseBtn setTintColor:[UIColor whiteColor]];
//    [chooseBtn addTarget:self action:@selector(chooseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:chooseBtn];
}

#pragma mark - 各种setter


#pragma mark - 各种Getter
- (UITapGestureRecognizer *)doubleTapGesture
{
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
        _doubleTapGesture.numberOfTapsRequired = 2;
    }
    return _doubleTapGesture;
}

- (UITapGestureRecognizer *)singleTapGesture
{
    if (!_singleTapGesture) {
        _singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        _singleTapGesture.numberOfTapsRequired = 1;
    }
    return _singleTapGesture;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,MAINSCRREN_H-NAVBAR_H,MAINSCRREN_W,NAVBAR_H)];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0,80,NAVBAR_H);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTintColor:[UIColor whiteColor]];
        [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancelBtn];
        
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.frame = CGRectMake(MAINSCRREN_W-80, 0,80,NAVBAR_H);
        [chooseBtn setTitle:@"选取" forState:UIControlStateNormal];
        [chooseBtn setTintColor:[UIColor whiteColor]];
        [chooseBtn addTarget:self action:@selector(chooseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:chooseBtn];
    }
    return _bottomView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
//        UIImage *image = [UIImage imageNamed:@"萌妹纸"];
        _imageView.frame = CGRectMake(0, 0,MAINSCRREN_W,MAINSCRREN_W/self.image.size.width*self.image.size.height);
        _imageView.image = self.image;
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 6;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
        if (self.isAnimation) {
            [_scrollView addGestureRecognizer:self.singleTapGesture];
        }
        [_scrollView addGestureRecognizer:self.doubleTapGesture];
        [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    }
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    [self refreshScrollViewAttribute];
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    [self refreshScrollViewAttribute];
}

- (void)refreshScrollViewAttribute
{
    CGFloat height = self.imageView.frame.size.height;
    if (height > self.view.frame.size.height) {
        height = self.view.frame.size.height;
    }
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width,self.imageView.frame.size.height);
    CGFloat offset = self.view.frame.size.height/2-height/2;
    self.scrollView.contentInset = UIEdgeInsetsMake(offset,0,offset,0);
}

#pragma mark - 按钮方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        self.scrollView.zoomScale = 1;
    }
}

- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        //        self.scrollView.zoomScale = 2;
        if (self.scrollView.zoomScale != 1) {
            [self.scrollView setZoomScale:1 animated:YES];
        }else{
            [self.scrollView setZoomScale:2 animated:YES];
        }
    }
}

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer*)tap{
    
//    UIView *backgroundView=tap.view;
//    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    
    CGRect currentFrame = [self.imageView convertRect:self.imageView.bounds toView:WINDOW];

    self.imageView.frame = currentFrame;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentSize = CGSizeZero;

    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame=oldframe;
        self.view.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

- (void)cancelBtnPressed:(UIButton *)sender
{
    [self.delegate clickedCancelBtn:sender];
}

- (void)chooseBtnPressed:(UIButton *)sender
{
    [self.delegate chooseWithImage:self.image];
}

#pragma mark - 自定义方法
+ (void)showImage:(UIImageView *)avatarImageView
{
    [WINDOW endEditing:YES];
    PreviewImageViewController *previewImageVC = [[PreviewImageViewController alloc]init];
    previewImageVC.isAnimation = YES;
    previewImageVC.image=avatarImageView.image;
    
    [WINDOW.rootViewController addChildViewController:previewImageVC];
    
    [WINDOW addSubview:previewImageVC.view];
    
    previewImageVC.bottomView.hidden = YES;
    
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:WINDOW];
    
    previewImageVC.imageView.frame = oldframe;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        previewImageVC.imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-previewImageVC.image.size.height*[UIScreen mainScreen].bounds.size.width/previewImageVC.image.size.width)/2, [UIScreen mainScreen].bounds.size.width, previewImageVC.image.size.height*[UIScreen mainScreen].bounds.size.width/previewImageVC.image.size.width);
        previewImageVC.view.alpha=1;
    } completion:^(BOOL finished) {
        [previewImageVC.imageView setOriginY:0];
        [previewImageVC refreshScrollViewAttribute];
        UIView *lastView = [WINDOW viewWithTag:PREVIEW_TAG];
        if (lastView) {
            [lastView removeFromSuperview];
        }
        previewImageVC.view.tag = PREVIEW_TAG;
    }];
}

+ (void)showImage:(UIImageView *)avatarImageView backgroundColor:(UIColor *)backgroundColor
{
    [WINDOW endEditing:YES];
    PreviewImageViewController *previewImageVC = [[PreviewImageViewController alloc]init];
    previewImageVC.isAnimation = YES;
    previewImageVC.image=avatarImageView.image;
    previewImageVC.view.backgroundColor = backgroundColor;
    
    [WINDOW.rootViewController addChildViewController:previewImageVC];
    
    [WINDOW addSubview:previewImageVC.view];
    
    previewImageVC.bottomView.hidden = YES;
    
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:WINDOW];
    
    previewImageVC.imageView.frame = oldframe;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        previewImageVC.imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-previewImageVC.image.size.height*[UIScreen mainScreen].bounds.size.width/previewImageVC.image.size.width)/2, [UIScreen mainScreen].bounds.size.width, previewImageVC.image.size.height*[UIScreen mainScreen].bounds.size.width/previewImageVC.image.size.width);
        previewImageVC.view.alpha=1;
    } completion:^(BOOL finished) {
        [previewImageVC.imageView setOriginY:0];
        [previewImageVC refreshScrollViewAttribute];
    }];
}

@end
