//
//  LogBox.h
//  LogBox
//
//  Created by wangjingtuan on 2017/7/21.
//  Copyright © 2017年 com.qiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __LOG_BOX__(content) [[LogBox sharedInstance] showLogWithContent:content];

@interface LogBox : NSObject

+ (instancetype)sharedInstance;

- (void)enableLogBox;

- (void)showLogWithContent:(NSString *)content;

@end
