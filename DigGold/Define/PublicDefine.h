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

#endif /* PublicDefine_h */
