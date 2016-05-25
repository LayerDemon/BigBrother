//
//  RootViewController.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/25.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (strong, nonatomic) ViewController *rootVC;

@end

@implementation RootViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.rootVC = (ViewController *)rootViewController;
    }
    return self;
}

@end
