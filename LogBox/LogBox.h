//
//  LogBox.h
//  LogBox
//
//  Created by wangjingtuan on 2017/7/21.
//  Copyright © 2017年 com.qiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __LOG_BOX__(...) [[LogBox sharedInstance] showLogWithContent:[NSString stringWithFormat:@"%s__[第%d行] \n %@ \n", __func__, __LINE__, __VA_ARGS__]];

@interface LogBox : NSObject

+ (instancetype)sharedInstance;

- (void)showLogWithContent:(NSString *)content;

@end
