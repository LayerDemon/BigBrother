//
//  CreateUnitedViewController.m
//  BigBrother
//
//  Created by zhangyi on 16/5/11.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "CreateUnitedViewController.h"
#import "ContactModel.h"

@interface CreateUnitedViewController () <UITextViewDelegate>

@property (strong, nonatomic) UIButton      * imageButton;
@property (strong, nonatomic) UITextField   * unitedTextField;
@property (strong, nonatomic) UITextView    * textView;

@property (strong, nonatomic) ContactModel  * contactModel;
@property (strong, nonatomic) NSString      * imageUrlString;

- (void)initializeDataSource;
- (void)initializeUserInterface;
@end

@implementation CreateUnitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)dealloc
{
    [_contactModel removeObserver:self forKeyPath:@"createGroupData"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"创建门派";
    }
    return self;
}


#pragma mark -- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
     UIAlertController  * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:sureAction];
   
    if ([keyPath isEqualToString:@"createGroupData"]) {
        if ([_contactModel.createGroupData[@"code"] integerValue] == 0) {
            alertController.message = @"门派创建成功～";
        }else{
            alertController.message = @"门派创建失败～";
        }
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- initialize
- (void)initializeDataSource
{
    _contactModel = ({
        ContactModel * model = [[ContactModel alloc] init];
        [model addObserver:self forKeyPath:@"createGroupData" options:NSKeyValueObservingOptionNew context:nil];
        model;
    });
}

- (void)initializeUserInterface
{
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    self.view.backgroundColor = BG_COLOR;
    //创建门派
    UIBarButtonItem * rightBut = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightBut;
    
    //上传头像
    _imageButton = ({
        UIButton * button = [self createButtonWithTitle:nil font:0 subView:self.view];
        button.frame = FLEXIBLE_FRAME(127, 20, 66, 66);
        [button addTarget:self action:@selector(chooseHeadImageView) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"mr_headimg@3x"] forState:UIControlStateNormal];
        button;
    });
    UILabel * imageLabel = [self createLabelWithText:@"上传头像" font:FLEXIBLE_NUM(13) subView:self.view];
    imageLabel.frame = FLEXIBLE_FRAME(125, 90, 70, 25);
    imageLabel.textAlignment = NSTextAlignmentCenter;

    //unitedNameLabel
    _unitedTextField = ({
        UITextField * textField = [[UITextField alloc] initWithFrame:FLEXIBLE_FRAME(25, 140, 270, 35)];
        textField.placeholder = @"  给门派起个名字";
        textField.textColor = [UIColor grayColor];
        textField.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(13)];
        textField.layer.cornerRadius = FLEXIBLE_NUM(5);
        textField.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textField];
        
        textField;
    });
    
    _textView = ({
        UITextView * textView = [[UITextView alloc] initWithFrame:FLEXIBLE_FRAME(25, 185, 270, 100)];
        textView.layer.cornerRadius = FLEXIBLE_NUM(5);
        textView.delegate = self;
        textView.textColor = [UIColor grayColor];
        textView.font = [UIFont boldSystemFontOfSize:FLEXIBLE_NUM(13)];
        [self.view addSubview:textView];
        textView;
    });
    
}

#pragma mark -- button pressed
- (void)submitButtonPressed:(UIButton *)sender
{
    NSDictionary * dataDic = [BBUserDefaults getUserDic];
    NSLog(@"dataDic -- %@",dataDic);
    
    [_contactModel createUnitedWithUserId:dataDic[@"id"] avatar:_imageUrlString name:_unitedTextField.text introduction:_textView.text];
    
    NSMutableDictionary * resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:dataDic[@"id"] forKey:@"userId"];
    [resultDic setObject:_imageUrlString forKey:@"avatar"];
    [resultDic setObject:_unitedTextField.text forKey:@"name"];
    [resultDic setObject:_imageUrlString forKey:@"introduction"];
    
//    [BBUrlConnection loadPostAfNetWorkingWithUrl:@"http://localhost:8080/rent-car/api/im/groups/add" andParameters:resultDic complete:^(NSDictionary *resultDic, NSString *errorString) {
//        NSLog(@"result -- %@ -- error -- %@",resultDic,errorString);
//    }];
    
}

#pragma mark -- <UITextViewDelegate>
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
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
        [_imageButton setImage:image forState:UIControlStateNormal];
        
        [BBUrlConnection uploadWithImage:newImage productType:BaseProductTypeCar complete:^(NSString *imageUrl) {
            NSLog(@"wocao -- %@",imageUrl);
            _imageUrlString = imageUrl;
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
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
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
