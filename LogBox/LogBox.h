//
//  LogBox.h
//  LogBox
//
//  Created by wangjingtuan on 2017/7/21.
//  Copyright © 2017年 com.qiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __LOG_BOX__(log) [[LogBox sharedInstance] showLogWithContent:[NSString stringWithFormat:@"%s__%d行 \n %@ \n", __func__, __LINE__, log]];

@interface LogBox : NSObject

+ (instancetype)sharedInstance;

- (void)showLogWithContent:(NSString *)content;

@end
