//
//  LogBox.m
//  LogBox
//
//  Created by wangjingtuan on 2017/7/21.
//  Copyright © 2017年 com.qiyi. All rights reserved.
//

#import "LogBox.h"
#import <UIKit/UIKit.h>

#define LBThemeColor [UIColor colorWithWhite:0.2 alpha:1.0]
#define LBWindowPadding 20
#define LBTabBarHeight 64
#define LB_STRING_IS_NOT_NULL(string) ([string isKindOfClass:[NSString class]] && [string length] && string != nil)

#pragma mark - <<<<<<<<<<<<<<<<<<<< LBViewController >>>>>>>>>>>>>>>>>>>>

@interface LBViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) UITextView     *lbTextView;
@property (nonatomic, strong) NSMutableArray *lbLogArray;

@end

@implementation LBViewController

- (instancetype)init
{
    if (self = [super init]) {

        _lbLogArray = [[NSMutableArray alloc]init];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)showLogWithContent:(NSString *)content
{
    if (LB_STRING_IS_NOT_NULL(content)) {

        // log不为空，初始化
        [self __initTextView];
        [self __initLogArray];

        [_lbLogArray addObject:content];

        [self __printLog];
    }
}

- (void)__printLog
{
    NSMutableString *logString = [NSMutableString string];
    for (NSString *string in _lbLogArray) {
        [logString appendFormat:@"%@\n", string];
    }

    _lbTextView.text = logString;
}

- (void)__initTextView
{
    if (!_lbTextView) {

        CGRect tableFrame = self.view.frame;
        _lbTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, tableFrame.size.width - LBWindowPadding * 2, tableFrame.size.height - LBTabBarHeight - LBWindowPadding * 2)];
        _lbTextView.backgroundColor = [UIColor clearColor];
        _lbTextView.delegate = self;
        _lbTextView.font = [UIFont systemFontOfSize:14.0];
        _lbTextView.textColor = [UIColor redColor];
        _lbTextView.textAlignment = NSTextAlignmentLeft;
        _lbTextView.editable = NO;
        _lbTextView.selectable = NO;
    }

    [self.view addSubview:_lbTextView];
}

- (void)__initLogArray
{
    if (!_lbLogArray) {
        _lbLogArray = [[NSMutableArray alloc]init];
    }
}

@end

#pragma mark - <<<<<<<<<<<<<<<<<<<< LogBox >>>>>>>>>>>>>>>>>>>>

@interface LogBox ()

@property (nonatomic, strong) UIWindow *logBoxWindow;
@property (nonatomic, strong) LBViewController *lbViewController;

@end

@implementation LogBox

+ (instancetype)sharedInstance
{
    static LogBox *sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LogBox alloc] init];
    });

    return sharedInstance;
}

- (void)enableLogBox
{

    [self __initLogboxWindow];

    // 添加开启手势
    UISwipeGestureRecognizer *swipeOpenGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(__onSwipeOpenDetected:)];
    swipeOpenGesture.numberOfTouchesRequired = 1;
    swipeOpenGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:swipeOpenGesture];

    // 添加关闭手势
    UISwipeGestureRecognizer *swipeCloseGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(__onSwipeCloseDetected:)];
    swipeCloseGesture.numberOfTouchesRequired = 1;
    swipeCloseGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_logBoxWindow addGestureRecognizer:swipeCloseGesture];

}

- (void)showLogWithContent:(NSString *)content
{
    if (!LB_STRING_IS_NOT_NULL(content)) {

        // log为空，不显示界面
        _logBoxWindow.hidden = YES;


        return ;
    }


    [_lbViewController showLogWithContent:content];
}

- (void)__onSwipeOpenDetected:(UISwipeGestureRecognizer *)gesture
{
    _logBoxWindow.hidden = NO;
}

- (void)__onSwipeCloseDetected:(UISwipeGestureRecognizer *)gesture
{
    _logBoxWindow.hidden = YES;
}

- (void)__initLogboxWindow
{
    if (!_logBoxWindow) {

        CGRect keyFrame = [UIScreen mainScreen].bounds;
        keyFrame.origin.y += LBTabBarHeight;
        keyFrame.size.height -= LBTabBarHeight;

        _logBoxWindow = [[UIWindow alloc] initWithFrame:CGRectInset(keyFrame, LBWindowPadding, LBWindowPadding)];
        _logBoxWindow.backgroundColor = [UIColor lightGrayColor];
        _logBoxWindow.layer.borderColor = LBThemeColor.CGColor;
        _logBoxWindow.layer.borderWidth = 2.0;
        _logBoxWindow.windowLevel = UIWindowLevelStatusBar;

        _lbViewController = [[LBViewController alloc]init];
        _logBoxWindow.rootViewController = _lbViewController;

    }
}

@end
