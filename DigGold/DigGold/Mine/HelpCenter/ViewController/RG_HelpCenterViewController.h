//
//  RG_HelpCenterViewController.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "DigGold_Base_ViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RG_HelpCenterType_YYXY,//用户协议
    RG_HelpCenterType_YSZC,//隐私政策
    RG_HelpCenterType_CJWT,//常见问题
    RG_HelpCenterType_SXF,//手续费
    RG_HelpCenterType_WJMM,//忘记密码
    RG_HelpCenterType_ZCDL,//注册和登录
    RG_HelpCenterType_JSWT,//技术问题
    RG_HelpCenterType_LXWM,//联系我们
} RG_HelpCenterType;
@interface RG_HelpCenterViewController : DigGold_Base_ViewController
- (instancetype)initWithSelectedType:(RG_HelpCenterType)type;
@end

NS_ASSUME_NONNULL_END
