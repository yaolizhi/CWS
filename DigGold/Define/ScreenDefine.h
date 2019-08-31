//
//  ScreenDefine.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#ifndef ScreenDefine_h
#define ScreenDefine_h


//屏幕相关
#define AppWindow ([UIApplication sharedApplication].keyWindow)

#define WindowContent  ([[UIScreen mainScreen] bounds])

#define ScreenSize      [UIScreen mainScreen].bounds.size

#define ScreenWidth     ([[UIScreen mainScreen] bounds].size.width)

#define ScreenHeight    ([[UIScreen mainScreen] bounds].size.height)

#define ScreenMaxLength (MAX(ScreenWidth,ScreenHeight))

#define ScreenMinLength (MIN(ScreenWidth,ScrrenHeight))

#define NavHeight (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)

#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)


//各屏幕尺寸比例

#define ScaleW(width)  width*ScreenWidth/375

#define ScaleH(height) height*ScreenHeight/667

//字体尺寸比例

#define ScaleFont(size) ([WLTools setDifferenceScreenFontSizeWithFontOfSize:size])

//新添加字符串拼接
#define F(string, args...)                  [NSString stringWithFormat:string, args]

#endif /* ScreenDefine_h */
