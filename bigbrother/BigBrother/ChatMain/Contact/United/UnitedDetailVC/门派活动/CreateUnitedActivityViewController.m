//
//  CreateUnitedActivityViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CreateUnitedActivityViewController.h"
#import "UnitedInfoModel.h"

@interface CreateUnitedActivityViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UITextField       * unitedNameTextField;
@property (strong, nonatomic) UITextField       * startTimeTextField;
@property (strong, nonatomic) UITextField       * endTimeTextField;
@property (strong, nonatomic) UITextField       * unitedAddressTextField;
@property (strong, nonatomic) UITextField       * unitedMoneyTextField;

@property (strong, nonatomic) UIButton          * unitedImageButton;
@property (strong, nonatomic) UITextView        * unitedContentTextView;

@property (strong, nonatomic) UnitedInfoModel   * unitedInfoModel;
@property (strong, nonatomic) NSString          * imageString;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation CreateUnitedActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"创建活动";
    }
    return self;
}

- (void)dealloc
{
    
}


#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        model;
    });
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //活动名称
    _unitedNameTextField = [self createTextFieldWithTitle:@"活动名称：" height:5];
    _unitedNameTextField.text = @"aiyowei";
    
    //活动海报
    UILabel * unitedImageLabel = [self createLabelWithText:@"活动海报：" font:FLEXIBLE_NUM(13) subView:self.view];
    unitedImageLabel.frame = FLEXIBLE_FRAME(15, 50, 75, 40);
    
    _unitedImageButton = ({
        UIButton * button = [self createButtonWithTitle:nil font:0 subView:self.view];
        [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseHeadImageView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = FLEXIBLE_FRAME(90, 55, 80, 80);
        button;
    });
    
    //开始时间
    _startTimeTextField = [self createTextFieldWithTitle:@"开始时间：" height:150];
    _startTimeTextField.text = @"2015年8月14日";
    
    //结束时间
    _endTimeTextField = [self createTextFieldWithTitle:@"结束时间：" height:190];
    _endTimeTextField.text = @"jkglajgkl";
    //活动地点
    _unitedAddressTextField = [self createTextFieldWithTitle:@"活动地点：" height:235];
    _unitedAddressTextField.text = @"gkajgkalj";
    
    //活动费用
    _unitedMoneyTextField = [self createTextFieldWithTitle:@"活动费用：" height:275];
    _unitedMoneyTextField.text = @"200";
    
    //活动内容
    UIView * unitedContentBGView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    unitedContentBGView.frame = FLEXIBLE_FRAME(0, 320, 320, 130);
    
    UILabel * contentTitleLabel = [self createLabelWithText:@"活动内容：" font:FLEXIBLE_NUM(13) subView:unitedContentBGView];
    contentTitleLabel.frame = FLEXIBLE_FRAME(15, 0, 75, 40);
    
    _unitedContentTextView = ({
        UITextView * textView = [[UITextView alloc] initWithFrame:FLEXIBLE_FRAME(15, 35, 290, 75)];
        textView.textColor = [UIColor grayColor];
        textView.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(12)];
//        textView.backgroundColor = [UIColor yellowColor];
        textView.text = @"到底怎么了";
        [unitedContentBGView addSubview:textView];
        textView;
    });
}

#pragma mark -- button pressed
- (void)rightButtonPressed:(UIBarButtonItem *)sender
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    
    [_unitedInfoModel createUnitedActivityWithGroupId:[_unitedDic[@"id"] integerValue] creator:[dataDic[@"id"] integerValue] name:_unitedNameTextField.text startTime:@"2013-04-13 12:36:54" endTime:@"2013-04-14 12:36:54" location:_unitedAddressTextField.text cost:[_unitedMoneyTextField.text integerValue] content:_unitedContentTextView.text images:@[@{@"url":_imageString,@"orderBy":@(1)}]];
}


#pragma mrak -- my methods
- (UITextField *)createTextFieldWithTitle:(NSString *)title height:(NSInteger)height
{
    UIView * bgView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    bgView.frame = FLEXIBLE_FRAME(0, height, 320, 40);
    
    UILabel * titleLabel = [self createLabelWithText:title font:FLEXIBLE_NUM(13) subView:bgView];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 75, 40);
    
    UITextField * textField = [[UITextField alloc] initWithFrame:FLEXIBLE_FRAME(90, 0, 220, 40)];
    textField.textColor = [UIColor grayColor];
    textField.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(12)];
    [bgView addSubview:textField];
//    textField.backgroundColor = [UIColor yellowColor];
    UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:bgView];
    lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    
    return  textField;
}


- (void)chooseHeadImageView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * localAction = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LocalPhoto];
    }];
    
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:localAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //关闭相册界面
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        //加在视图中
        UIImage * newImage = [self imageCompressForWidth:image targetWidth:300];
        [_unitedImageButton setImage:image forState:UIControlStateNormal];
        
        [BBUrlConnection uploadWithImage:newImage productType:BaseProductTypeCar complete:^(NSString *imageUrl) {
            NSLog(@"wocao -- %@",imageUrl);
            _imageString = imageUrl;
        }];
        //        _headImageView.image = image;
        //        _headImage = image;
        //        [_indicatorView startAnimating];
        //        [_userInfoModel changeImageWithUrl:BASE_URL fileImages:@[image] name:nil params:@{@"method":@"mk.user_center.editMemberAvatar.post",@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]}];
    }
}

#pragma mark -- 缩放图片
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -- 将图片存储在沙盒中
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark -- 从沙盒中取出路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}



#pragma mark -- create label
- (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font subView:(UIView *)subView
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    label.font = [UIFont systemFontOfSize:font];
    [subView addSubview:label];
    return label;
}

#pragma mark -- create button 
- (UIButton *)createButtonWithTitle:(NSString *)title font:(CGFloat)font subView:(UIView *)subView
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [subView addSubview:button];
    return button;
}

#pragma mark -- create view
- (UIView *)createViewWithBackColor:(UIColor *)color subView:(UIView *)subView
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = color;
    [subView addSubview:view];
    return view;
}

@end
