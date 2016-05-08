//
//  SuggestionPostViewController.m
//  BigBrother
//
//  Created by xiaoyu on 16/3/4.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "SuggestionPostViewController.h"

@interface SuggestionPostViewController () <UITextViewDelegate>

@end

@implementation SuggestionPostViewController{
    
    UITextView *postSuggestPlaceholderTextFiled;
    UITextView *postSuggestTextFiled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BB_WhiteColor;
    
    UIView *topFixView = [[UIView alloc] init];
    topFixView.frame = CGRectZero;
    [self.view addSubview:topFixView];
    
    postSuggestPlaceholderTextFiled = [[UITextView alloc] init];
    postSuggestPlaceholderTextFiled.backgroundColor = [UIColor whiteColor];
    postSuggestPlaceholderTextFiled.frame = (CGRect){10,BB_NarbarHeight+10,(WIDTH(self.view)-20),250};
    postSuggestPlaceholderTextFiled.textColor = RGBColor(200, 200, 200);
    postSuggestPlaceholderTextFiled.font = Font(15);
    postSuggestPlaceholderTextFiled.keyboardType = UIKeyboardTypeDefault;
    postSuggestPlaceholderTextFiled.returnKeyType = UIReturnKeyNext;
    postSuggestPlaceholderTextFiled.text = @"请输入反馈,我们将不断为您改进";
    [postSuggestPlaceholderTextFiled setEditable:NO];
    postSuggestPlaceholderTextFiled.userInteractionEnabled = NO;
    postSuggestPlaceholderTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postSuggestPlaceholderTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:postSuggestPlaceholderTextFiled];
    postSuggestPlaceholderTextFiled.layer.cornerRadius = 2.f;
    postSuggestPlaceholderTextFiled.layer.masksToBounds = YES;
    postSuggestPlaceholderTextFiled.layer.borderWidth = 0.5f;
    postSuggestPlaceholderTextFiled.layer.borderColor = RGBAColor(200, 200, 200, 0.4).CGColor;
    postSuggestPlaceholderTextFiled.hidden = NO;
    
    
    postSuggestTextFiled = [[UITextView alloc] init];
    postSuggestTextFiled.backgroundColor = [UIColor whiteColor];
    postSuggestTextFiled.frame = postSuggestPlaceholderTextFiled.frame;
    postSuggestTextFiled.textColor = RGBColor(100, 100, 100);
    postSuggestTextFiled.font = Font(15);
    postSuggestTextFiled.tag = 19100;
    postSuggestTextFiled.delegate = self;
    postSuggestTextFiled.keyboardType = UIKeyboardTypeDefault;
    postSuggestTextFiled.returnKeyType = UIReturnKeyNext;
    postSuggestTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    postSuggestTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:postSuggestTextFiled];
    postSuggestTextFiled.layer.cornerRadius = 2.f;
    postSuggestTextFiled.layer.masksToBounds = YES;
    postSuggestTextFiled.layer.borderWidth = 0.5f;
    postSuggestTextFiled.layer.borderColor = RGBAColor(200, 200, 200, 0.4).CGColor;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.tag == 19100) {
        if (![text isEqualToString:@""]){
            postSuggestPlaceholderTextFiled.hidden = YES;
        }
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
            postSuggestPlaceholderTextFiled.hidden = NO;
        }
    }
    return YES;
}


#pragma mark - Navigation
-(void)setUpNavigation{
    self.navigationItem.title = @"意见反馈";
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.navigationItem setRightBarButtonItem:nil];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = Font(16);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rightButtonTitle = @"提交";
    [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    rightButton.frame = (CGRect){0,0,60,20};
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemClick{
    //todo 提交意见反馈
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