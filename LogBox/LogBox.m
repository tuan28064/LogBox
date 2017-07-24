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
#define LBButtonWidth 60
#define LBButtonHeight 28

#pragma mark - <<<<<<<<<<<<<<<<<<<< LBViewController >>>>>>>>>>>>>>>>>>>>

@interface LBViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) UITextView      *lbTextView;
@property (nonatomic, strong) NSMutableArray  *lbLogArray;
@property (nonatomic, strong) NSDateFormatter *lbDateFormatter;
@property (nonatomic, strong) UIButton        *lbCloseButton;
@property (nonatomic, strong) UIButton        *lbClearButton;

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
        [self __initButton];
        [self __initLogArray];
        [self __initDateFormatter];

        [_lbLogArray addObject:content];

        // 打印
        [self __printLog];
    }
}

- (void)__printLog
{
    NSMutableString *logString = [NSMutableString string];
    for (NSString *string in _lbLogArray) {
        [logString appendFormat:@"%@ \n %@ \n", [_lbDateFormatter stringFromDate:[NSDate date]], string];
    }

    _lbTextView.text = logString;

    // 滚动到最后一行
    [_lbTextView scrollRangeToVisible:NSMakeRange(_lbTextView.text.length, 1)];
}

- (void)__initTextView
{
    if (!_lbTextView) {

        CGRect textViewFrame = [UIScreen mainScreen].bounds;
        _lbTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 4 * 2 + LBButtonHeight, textViewFrame.size.width - LBWindowPadding * 2, textViewFrame.size.height - LBTabBarHeight - LBWindowPadding * 2 - 4 * 2 - LBButtonHeight)];
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

- (void)__initButton
{
    if (!_lbCloseButton) {

        _lbCloseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _lbCloseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 2 * LBWindowPadding - LBButtonWidth - 4, 4, LBButtonWidth, LBButtonHeight);
        _lbCloseButton.backgroundColor = LBThemeColor;
        [_lbCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lbCloseButton setTitle:@"Close" forState:UIControlStateNormal];
        [_lbCloseButton addTarget:self action:@selector(__closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }

    [self.view addSubview:_lbCloseButton];

    if (!_lbClearButton) {

        _lbClearButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _lbClearButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 2 * LBWindowPadding - 2 * (4 + LBButtonWidth), 4, LBButtonWidth, LBButtonHeight);
        _lbClearButton.backgroundColor = LBThemeColor;
        [_lbClearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lbClearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [_lbClearButton addTarget:self action:@selector(__clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }

    [self.view addSubview:_lbClearButton];
}

- (void)__initLogArray
{
    if (!_lbLogArray) {
        _lbLogArray = [[NSMutableArray alloc]init];
    }
}

- (void)__initDateFormatter
{
    if (!_lbDateFormatter) {
        _lbDateFormatter = [[NSDateFormatter alloc]init];
        [_lbDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.sss"];
    }
}

#pragma mark -------------------- action methods --------------------

- (void)__closeButtonClick:(UIButton *)button
{
    self.view.window.hidden = YES;
}

- (void)__clearButtonClick:(UIButton *)button
{
    [_lbLogArray removeAllObjects];

    _lbTextView.text = @"";
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

- (void)showLogWithContent:(NSString *)content
{
    if (!LB_STRING_IS_NOT_NULL(content)) {

        return ;
    }

    // 初始化
    [self __initLogboxWindow];

    [_lbViewController showLogWithContent:content];
}

- (void)__onSwipeOpenDetected:(UISwipeGestureRecognizer *)gesture
{
    _logBoxWindow.hidden = NO;
}

- (void)__initLogboxWindow
{
    if (!_logBoxWindow) {

        CGRect originFrame = [UIScreen mainScreen].bounds;
        originFrame.origin.y += LBTabBarHeight;
        originFrame.size.height -= LBTabBarHeight;

        _logBoxWindow = [[UIWindow alloc] initWithFrame:CGRectInset(originFrame, LBWindowPadding, LBWindowPadding)];
        _logBoxWindow.backgroundColor = [UIColor lightGrayColor];
        _logBoxWindow.layer.borderColor = LBThemeColor.CGColor;
        _logBoxWindow.layer.borderWidth = 2.0;
        _logBoxWindow.windowLevel = UIWindowLevelStatusBar;

        _lbViewController = [[LBViewController alloc]init];
        _logBoxWindow.rootViewController = _lbViewController;

    }
    _logBoxWindow.hidden = NO;

    // 添加开启手势
    UISwipeGestureRecognizer *swipeOpenGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(__onSwipeOpenDetected:)];
    swipeOpenGesture.numberOfTouchesRequired = 5;
    swipeOpenGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:swipeOpenGesture];
}

@end
