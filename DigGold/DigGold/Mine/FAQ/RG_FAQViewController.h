//
//  RG_FAQViewController.h
//  DigGold
//
//  Created by James on 2018/12/31.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "DigGold_Base_ViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RG_FAQType_QJ,//什么是
    RG_FAQType_JS,//游戏介绍
    RG_FAQType_GP,//游戏公平性
    RG_FAQType_TP,//自动逃跑
} RG_FAQType;
@interface RG_FAQViewController : DigGold_Base_ViewController
- (instancetype)initWithSelectedType:(RG_FAQType)type;
@end

NS_ASSUME_NONNULL_END
