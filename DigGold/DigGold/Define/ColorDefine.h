//
//  ColorDefine.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h
#define WLColor(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]
//由十六进制转换成是十进制
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

// 纯白色
#define COLOR_WHITE UIColorFromRGB(0xEEEEEE)
// 主背景色
#define kMainBackgroundColor UIColorFromRGB(0x0E1A2A)

//导航颜色
#define kMainNavbarColor UIColorFromRGB(0x0E1A2A)

//背景副颜色
#define kMainSubBackgroundColor UIColorFromRGB(0x101F32)

//绿色
#define kMainGreenColor UIColorFromRGB(0x6185e5)

//亮线颜色
#define kLightLineColor UIColorFromRGB(0x495366)

//灰白
#define kMainGaryWhiteColor UIColorFromRGB(0x8e94a3) //0xE4E5FF

//黄色
#define kMainYellowColor UIColorFromRGB(0xda744e)
//主题字体颜色
#define kMainTextColor UIColorFromRGB(0xffffff)

//灰色
#define kMainBetGaryColor UIColorFromRGB(0x172941)

#define kMainTitleColor UIColorFromRGB(0x6185e5) //0x57BD8B
#define kMainTitleDColor UIColorFromRGB(0xD4744e)

#define kMainNoEnableTitleColor UIColorFromRGB(0x172941)
//主题副标题
//
#define kMainSubTextColor UIColorFromRGB(0xE4E5FF)

// 灰色字体颜色
#define kGaryTextColor  UIColorFromRGB(0xBBBBBB)

//线的颜色
#define kLineColor UIColorFromRGB(0x495366)
#define kLine9Color UIColorFromRGB(0x999999)


//虚线颜色
#define kImaginaryLineColor UIColorFromRGB(0xb8b8d7)
//b8b8d7

#endif /* ColorDefine_h */
