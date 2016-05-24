//
//  CreateUnitedActivityViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CreateUnitedActivityViewController.h"
#import "UnitedInfoModel.h"
#import "DatePickerView.h"

#define TIME_TAG 1080

@interface CreateUnitedActivityViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SureButtonPressedDelegate>

@property (strong, nonatomic) UITextField       * unitedNameTextField;
@property (strong, nonatomic) UITextField       * startTimeTextField;
@property (strong, nonatomic) UITextField       * endTimeTextField;
@property (strong, nonatomic) UITextField       * unitedAddressTextField;
@property (strong, nonatomic) UITextField       * unitedMoneyTextField;

@property (strong, nonatomic) UIButton          * unitedImageButton;
@property (strong, nonatomic) UIButton          * united2ImageButton;
@property (strong, nonatomic) UITextView        * unitedContentTextView;

@property (strong, nonatomic) UnitedInfoModel   * unitedInfoModel;
@property (strong, nonatomic) NSString          * imageString;

@property (strong, nonatomic) NSDate            * dateOne;
@property (strong, nonatomic) NSDate            * dateTwo;
@property (strong, nonatomic) DatePickerView    * datePickerView;

@property (assign, nonatomic) NSInteger         selectedIndex;
@property (strong, nonatomic) NSDateFormatter   * dateFormatter;

@property (strong, nonatomic) NSMutableArray    * imageArray;

@property (assign, nonatomic) NSInteger         imageButtonIndex;

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
    [_unitedInfoModel removeObserver:self forKeyPath:@"createUnitedActivityData"];
}

#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"createUnitedActivityData"]) {
        UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSDictionary    * dataDic = _unitedInfoModel.createUnitedActivityData;
        if ([dataDic[@"code"] integerValue] == 0) {
            alertController.message = @"门派活动创建成功～";
            [self presentViewController:alertController animated:YES completion:nil];
            [self performSelector:@selector(alertControllerDismissWithAlertController:) withObject:alertController afterDelay:1];
        }else{
            alertController.message = @"门派活动创建失败～";
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark -- alterController dismiss
- (void)alertControllerDismissWithAlertController:(UIAlertController *)alertController
{
    [alertController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _unitedInfoModel = ({
        UnitedInfoModel * model = [[UnitedInfoModel alloc] init];
        [model addObserver:self forKeyPath:@"createUnitedActivityData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = THEMECOLOR_BACK;
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //活动名称
    _unitedNameTextField = [self createTextFieldWithTitle:@"活动名称：" height:5];
//    _unitedNameTextField.text = @"aiyowei";
    
    //活动海报
    UILabel * unitedImageLabel = [self createLabelWithText:@"活动海报：" font:FLEXIBLE_NUM(13) subView:self.view];
    unitedImageLabel.frame = FLEXIBLE_FRAME(15, 50, 75, 40);
    
    _unitedImageButton = ({
        UIButton * button = [self createButtonWithTitle:nil font:0 subView:self.view];
        [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseHeadImageView:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = TIME_TAG + 10;
        button.frame = FLEXIBLE_FRAME(90, 55, 80, 80);
        button;
    });
    _united2ImageButton = ({
        UIButton * button = [self createButtonWithTitle:nil font:0 subView:self.view];
        [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseHeadImageView:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = TIME_TAG + 11;
        button.hidden = YES;
        button.frame = FLEXIBLE_FRAME(190, 55, 80, 80);
        button;
    });
    
    
    //开始时间
    UIButton * startTimeButton = [self createButtonWithTitle:@"开始时间：" height:150];
    [startTimeButton addTarget:self action:@selector(timeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    startTimeButton.tag = TIME_TAG;
    
    //结束时间   
    UIButton * endTimeButton = [self createButtonWithTitle:@"结束时间：" height:190];
    [endTimeButton addTarget:self action:@selector(timeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    endTimeButton.tag = TIME_TAG + 1;
    
    //活动地点
    _unitedAddressTextField = [self createTextFieldWithTitle:@"活动地点：" height:235];
//    _unitedAddressTextField.text = @"gkajgkalj";
    
    //活动费用
    _unitedMoneyTextField = [self createTextFieldWithTitle:@"活动费用：" height:275];
    _unitedMoneyTextField.keyboardType = UIKeyboardTypeNumberPad;
//    _unitedMoneyTextField.text = @"200";
    
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
//        textView.text = @"到底怎么了";
        [unitedContentBGView addSubview:textView];
        textView;
    });
    
    _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, MAINSCRREN_W, MAINSCRREN_H)];
    _datePickerView.delegate = self;
    [WINDOW addSubview:_datePickerView];
}

#pragma mark -- button Pressed
- (void)timeButtonPressed:(UIButton *)sender
{
    [_datePickerView beginChooseTime];
    _selectedIndex = sender.tag - TIME_TAG;
    if (_selectedIndex == 0) {
        _datePickerView.title = @"开始时间";
        if (_dateTwo) {
            _datePickerView.datePiker.minimumDate = [NSDate distantPast];
            _datePickerView.datePiker.maximumDate = _dateTwo;
        }
    }else{
        _datePickerView.title = @"结束时间";
        if (_dateOne) {
            _datePickerView.datePiker.minimumDate = _dateOne;
            _datePickerView.datePiker.maximumDate = [NSDate distantFuture];
        }
    }
}


- (void)rightButtonPressed:(UIBarButtonItem *)sender
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    
    UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:sureAction];
    
    if (_unitedNameTextField.text.length == 0) {
        alertController.message = @"活动名称不能为空～";
         [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (!_dateOne) {
        alertController.message = @"活动开始时间不能为空～";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (!_dateTwo) {
        alertController.message = @"活动结束时间不能为空～";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (_unitedAddressTextField.text.length == 0) {
        alertController.message = @"活动地址不能为空～";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (_unitedMoneyTextField.text.length == 0) {
        alertController.message = @"活动费用不能为空～";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (_unitedContentTextView.text.length == 0) {
        alertController.message = @"活动详情不能为空～";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (_imageArray.count == 0) {
        alertController.message = @"请选择活动海报～";
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSString * beginDate = [_dateFormatter stringFromDate:_dateOne];
    NSString * endDate = [_dateFormatter stringFromDate:_dateTwo];
    
    NSMutableArray * resultImageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _imageArray.count; i ++) {
        NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] init];
        [mutableDic setObject:_imageArray[i] forKey:@"url"];
        [mutableDic setObject:@(i) forKey:@"orderBy"];
        [resultImageArray addObject:mutableDic];
    }
    
    [_unitedInfoModel createUnitedActivityWithGroupId:[_unitedDic[@"id"] integerValue] creator:[dataDic[@"id"] integerValue] name:_unitedNameTextField.text startTime:beginDate endTime:endDate location:_unitedAddressTextField.text cost:[_unitedMoneyTextField.text integerValue] content:_unitedContentTextView.text images:resultImageArray];
}

#pragma mark -- <SureButtonPressedDelegate>
- (void)chooseTimeInDatePickerView:(NSDate *)date
{
    if (_selectedIndex == 0) {
        _dateOne = date;
    }else{
        _dateTwo = date;
    }
    UIButton * timeButton = (UIButton *)[self.view viewWithTag:TIME_TAG + _selectedIndex];
    [timeButton setTitle:[_dateFormatter stringFromDate:date] forState:UIControlStateNormal];
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
    UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:bgView];
    lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    
    return  textField;
}

- (UIButton *)createButtonWithTitle:(NSString *)title height:(NSInteger)height
{
    UIView * bgView = [self createViewWithBackColor:[UIColor whiteColor] subView:self.view];
    bgView.frame = FLEXIBLE_FRAME(0, height, 320, 40);
    
    UILabel * titleLabel = [self createLabelWithText:title font:FLEXIBLE_NUM(13) subView:bgView];
    titleLabel.frame = FLEXIBLE_FRAME(15, 0, 75, 40);
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = FLEXIBLE_FRAME(90, 0, 220, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:FLEXIBLE_NUM(12)];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bgView addSubview:button];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView * lineView = [self createViewWithBackColor:THEMECOLOR_LINE subView:bgView];
    lineView.frame = FLEXIBLE_FRAME(0, 39, 320, 1);
    
    return  button;
}


- (void)chooseHeadImageView:(UIButton *)sender
{
    _imageButtonIndex = sender.tag - TIME_TAG - 10;
    
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
        
        [BBUrlConnection uploadWithImage:newImage productType:BaseProductTypeCar complete:^(NSString *imageUrl) {
            NSLog(@"wocao -- %@",imageUrl);
            if (!_imageArray) {
                _imageArray = [[NSMutableArray alloc] init];
            }
            
            if (_imageButtonIndex == 0) {
                if (_imageArray.count == 0) {
                     [_imageArray addObject:imageUrl];
                }else{
                    [_imageArray replaceObjectAtIndex:0 withObject:imageUrl];
                }
                _united2ImageButton.hidden = NO;
                [_unitedImageButton setImage:newImage forState:UIControlStateNormal];
            }else{
                if (_imageArray.count == 1) {
                    [_imageArray addObject:imageUrl];
                }else{
                    [_imageArray replaceObjectAtIndex:1 withObject:imageUrl];
                }
                
                [_united2ImageButton setImage:newImage forState:UIControlStateNormal];
            }

        }];
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
