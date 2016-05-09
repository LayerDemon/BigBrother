//
//  PreviewImageViewController.h
//  BookClub
//
//  Created by 李祖建 on 16/1/20.
//  Copyright © 2016年 LittleBitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreviewImageViewControllerDelegate <NSObject>

- (void)clickedCancelBtn:(UIButton *)sender;
- (void)chooseWithImage:(UIImage *)image;

@end

@interface PreviewImageViewController : UIViewController

@property (assign, nonatomic) id<PreviewImageViewControllerDelegate>delegate;

@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) BOOL isAnimation;

+ (void)showImage:(UIImageView *)avatarImageView;
+ (void)showImage:(UIImageView *)avatarImageView backgroundColor:(UIColor *)backgroundColor;
//- (void)hideImage:(UITapGestureRecognizer*)tap;

@end
