//
//  SwitchHelper.h
//  DigGold
//
//  Created by 姚立志 on 2019/9/1.
//  Copyright © 2019 MingShao. All rights reserved.
//



#pragma mark 用于切换视图控制器 （比如，切换tabbar 和 login 视图控制器）




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchHelper : NSObject


#pragma mark 切换到根视图控制器
+(void)switchRootViewController:(BOOL)digGoldSwitch;


#pragma mark 切换到登录视图控制器
+(void)switchLoginViewController:(UIViewController*)tagert;


@end

NS_ASSUME_NONNULL_END
