//
//  ViewController.m
//  LogBoxDemo
//
//  Created by wangjingtuan on 2017/7/21.
//  Copyright © 2017年 com.qiyi. All rights reserved.
//

#import "ViewController.h"
#import "LogBox.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __LOG_BOX__(@"this is a test");
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __LOG_BOX__(@"this is a test");
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 100; i++) {
            NSString *string = [NSString stringWithFormat:@"this is a test %ld", (long)i];
            __LOG_BOX__(string);
        }
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 10; i++) {
            NSString *string = [NSString stringWithFormat:@"this is a test hahahahah %ld", (long)i];
            __LOG_BOX__(string);
        }
    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
