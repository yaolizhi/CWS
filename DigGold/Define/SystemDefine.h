//
//  SystemDefine.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#ifndef SystemDefine_h
#define SystemDefine_h

//获取当前iOS系统版本号
#define SystemVersion   [[[UIDevice currentDevice] systemVersion] floatValue]

//获取当前APP版本号
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


//系统字体对应字号
#define systemFont(x) [UIFont systemFontOfSize:x]

//自定义字体大小
#define WLFontSize(s) [UIFont fontWithName:@"Helvetica" size:s]

// 粗体
#define WLFontBoldSize(s) [UIFont fontWithName:@"Helvetica-Bold" size:s]

//weakSelf
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

//写
#define SSKJUserDefaultsSET(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]

// 取
#define SSKJUserDefaultsGET(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

// 删
#define SSKJUserDefaultsRemove(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

// 存
#define SSKJUserDefaultsSynchronize [[NSUserDefaults standardUserDefaults] synchronize]

//日志宏定义、日志函数 宏定义
#if (DEBUG || TESTCASE)
#define SsLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define SsLog(...)
#endif

//屏幕尺寸、比例、视图坐标、导航栏高度、状态栏高度
#import "ScreenDefine.h"

//iPhone机型设备 宏定义
#import "DeviceDefine.h"

//颜色 宏定义
#import "ColorDefine.h"

//接口地址 宏定义
#import "URLDefine.h"


#import "PublicDefine.h"
#endif /* SystemDefine_h */
