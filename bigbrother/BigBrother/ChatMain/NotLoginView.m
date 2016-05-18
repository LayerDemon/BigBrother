//
//  NotLoginView.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/18.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "NotLoginView.h"
#import "LoginViewController.h"

@interface NotLoginView ()

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation NotLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NotLoginView" owner:self options:nil] lastObject];
        self.frame = FLEFRAME(self.frame);
        FLEXIBLE_FONT(self);
        self.autoresizesSubviews = NO;
        [self setHeight:MAINSCRREN_H];
        [self.loginBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)loginBtnPressed:(UIButton *)sender
{
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:BB_Navigation_FontColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    
    [navi.navigationBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    navi.view.backgroundColor = BB_WhiteColor;
    navi.navigationBar.barTintColor = BB_NaviColor;
    navi.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.viewController presentViewController:navi animated:YES completion:nil];
}

@end
