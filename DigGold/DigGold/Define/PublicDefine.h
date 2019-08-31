//
//  PublicDefine.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#ifndef PublicDefine_h
#define PublicDefine_h

#import <UIKit/UIKit.h>

static NSString * const AppLanguage = @"appLanguage";

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

// 语言国际化
#define Localized(key, comment) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]
//数据储存
#define kUserDefaults [NSUserDefaults standardUserDefaults]
//1：已登录  0：未登录
#define kLogined [kUserDefaults objectForKey:@"logined"]
//token
#define KToken [kUserDefaults objectForKey:@"token"]
//1 是英文  0 中文
#define IsEnglish [kUserDefaults objectForKey:@"IsEnglish"]

#define kLoginSuccessNotifition @"kLoginSuccessNotifition"
#define kLogoutSuccessNotifition @"kLogoutSuccessNotifition"
#define kUpdateHeaderSuccessNotifition @"kUpdateHeaderSuccessNotifition"
#define kWebSocketConnentFailedNotifition @"kWebSocketConnentFailedNotifition"
#define kWebConnentSuccessNotifition @"kWebConnentSuccessNotifition"
#define kCarrayCoinSuccessNotifition @"kCarrayCoinSuccessNotifition"
#define kApplyDLSSuccessNotifition @"kApplyDLSSuccessNotifition"

#define kWebScortContentSuccessNotifition @"kWebScortContentSuccessNotifition"

#endif /* PublicDefine_h */
