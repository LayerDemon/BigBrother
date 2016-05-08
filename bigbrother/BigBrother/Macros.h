#import <Foundation/Foundation.h>
#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#endif
#import <dispatch/base.h>
//各种常常使用的宏，我进行了收集和整理，以后有人更新都依次放入此文件

///////////////////////////////////////////
// Debugging
///////////////////////////////////////////
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

///////////////////////////////////////////
// Views
///////////////////////////////////////////
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)
#define MIDDLEX(view) (CGRectGetMidX(view.frame))
#define MIDDLEY(view) (CGRectGetMidY(view.frame))
#define GLOBALWIDTH [[UIScreen mainScreen] bounds].size.width
#define GLOBALHEIGHT [[UIScreen mainScreen] bounds].size.height
#define MainWindow [UIApplication sharedApplication].keyWindow
#define CenterSubView(view) view.center = CGPointMake(WIDTH(view.superview)/2,HEIGHT(view.superview)/2)

#define VIEWWITHTAG(_OBJECT, _TAG)  [_OBJECT viewWithTag : _TAG]

///////////////////////////////////////////
// Debug Views
///////////////////////////////////////////
#define PrintStringFromView(view) [NSString stringWithFormat:@"%@ position = %@ archorPoint = %@",view,NSStringFromCGPoint(view.layer.position),NSStringFromCGPoint(view.layer.anchorPoint)]
#define PrintView(view) DLog(@"%@",PrintStringFromView(view));

///////////////////////////////////////////
// Block WeakSelf
///////////////////////////////////////////
#define weak(weakself,self) __weak typeof(self) weakself =(id)self;

///////////////////////////////////////////
// Device & OS
///////////////////////////////////////////

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Is4Inches() ([[UIScreen mainScreen] bounds].size.height == 568.0f)
#define Is3_5Inches() ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS4_7Inches() ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS5_5Inches() ([[UIScreen mainScreen] bounds].size.height == 736.0f)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion]floatValue] == v)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion]floatValue] >v)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion]floatValue] >= v)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion]floatValue]<v)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion]floatValue] <= v)

///////////////////////////////////////////
// Networking
///////////////////////////////////////////
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

///////////////////////////////////////////
// Misc
///////////////////////////////////////////
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define URLIFY(urlString) [NSURL URLWithString:urlString]
#define F(string, args...) [NSString stringWithFormat:string, args]
#define ALERT(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];


///////////////////////////////////////////
// Color
///////////////////////////////////////////
#define RGBColor(r,g,b) RGBAColor(r,g,b,1)
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


////////////////////////////////////////////
// Math
////////////////////////////////////////////
#define EXP2(x) ((x)*(x))


///////////////////////////////////////////
// Font
///////////////////////////////////////////
#define Font(size) [UIFont systemFontOfSize:(size)/1.f]

///////////////////////////////////////////
// main thread
//////////////////////////////////////////
DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void
_dispatch_main(dispatch_block_t block)
{
    if (block) {
        dispatch_async(dispatch_get_main_queue(),block);
    }
}
#undef runInMainThread
#define runInMainThread _dispatch_main

////////////////////////////////////////////
// static inline
////////////////////////////////////////////
static inline UIImage *imageWithColorInRect(UIColor *color,CGRect rect){
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imge;
}

static inline NSString* UUID(){
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil,puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL,uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

//CUSTOM
#define BB_BlueColor RGBColor(15,110,195)
#define BB_NaviColor BB_BlueColor
#define BB_WhiteColor RGBColor(245,245,245)
#define BB_FontBlackColor RGBColor(45,45,45)

#define BB_LineSeperateColor RGBAColor(200,200,200,0.2);
#define BB_CellLineSeperateColor RGBAColor(200,200,200,0.4);

//tabbar colors
#define BB_Tabbar_SelectedColor BB_BlueColor
#define BB_Tabbar_NormalColor BB_FontBlackColor
#define BB_Navigation_FontColor BB_WhiteColor

///////////////////////////////////////////
// inline method
//////////////////////////////////////////
#ifdef TARGET_OS_IPHONE
static inline NSString *imagePathByInches(NSString *strName){
    if(IS4_7Inches()){
        return [NSString stringWithFormat:@"%@6",strName];
    }else if(IS5_5Inches()){
        return [NSString stringWithFormat:@"%@6plus",strName];
    }else if(Is4Inches()){
        return [NSString stringWithFormat:@"%@5s",strName];
    }else if (Is3_5Inches()){
        return [NSString stringWithFormat:@"%@5s",strName];
    }
    return strName;
}

#endif

////////////////////////////////////////////
// NOTIFICATIONS
////////////////////////////////////////////
static NSString *BB_DidSelectTabControllernotification = @"UN_DidSelectTabControllernotification";

////////////////////////////////////////////
// static value
////////////////////////////////////////////
static float BB_TabbarHeight = 44.f;
static float BB_NarbarHeight = 64.f;


