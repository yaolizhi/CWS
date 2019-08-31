//
//  ColorDefine.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h

//由十六进制转换成是十进制
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

// 主背景色
#define kMainBackgroundColor UIColorFromRGB(0xffffff)

//主题字体颜色
#define kMainTextColor UIColorFromRGB(0x3c72d1)

// 灰色字体颜色
#define kGaryTextColor  UIColorFromRGB(0x999999)

//线的颜色
#define kLineColor UIColorFromRGB(0xf2f2f2)


#endif /* ColorDefine_h */
