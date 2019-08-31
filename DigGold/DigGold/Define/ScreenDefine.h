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

#define IS_IPHONE_X ((KDeviceHeight == 812.0f || KDeviceHeight == 896.0f) ? YES : NO)
#define Height_NavContentBar 44.0f

#define Height_StatusBar ((IS_IPHONE_X) ? 44.0f : 20.0f)

#define Height_NavBar ((IS_IPHONE_X) ? 88.0f : 64.0f)

#define Height_TabBar ((IS_IPHONE_X) ? 83.0f : 49.0f)

#define BottomHeight_TabBar ((IS_IPHONE_X) ? 20.0f : 0.0f)

//新添加字符串拼接
#define F(string, args...)                  [NSString stringWithFormat:string, args]

//各屏幕尺寸比例

#define ScaleW(width)  [F(@"%f", width*ScreenWidth/375.0f) integerValue]

#define ScaleH(height) [F(@"%f", height*ScreenHeight/667.0f) integerValue]

//字体尺寸比例

#define ScaleFont(size) ([WLTools setDifferenceScreenFontSizeWithFontOfSize:size])


#endif /* ScreenDefine_h */
