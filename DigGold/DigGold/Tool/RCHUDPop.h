//
//  RCHUDPop.h
//  RedChat
//
//  Created by James on 2018/8/28.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHUDPop : NSObject


/**
 移除HUD

 @param toView view
 */
+ (void)dismissHUDToView:(UIView *)toView;

/**
 弹出hud 不会自动隐藏 调用popupSuccessMessage，popupErrorMessage，dismissHUD 都可以讲hud隐藏

 @param message 文字
 @param toView 添加的view
 */
+ (void)popupMessage:(NSString *)message toView:(UIView *)toView;


/**
 填写after 可以延迟隐藏，可自动隐藏

 @param message 文字
 @param toView view
 @param after 延迟时间
 */
+ (void)popupMessage:(NSString *)message toView:(UIView *)toView after:(NSInteger)after;


/**
 用于成功之后的隐藏

 @param successMessage 成功的消息
 @param toView view
 */
+ (void)popupSuccessMessage:(NSString *)successMessage toView:(UIView *)toView;

/**
 用于失败之后的隐藏

 @param errorMessage 错误信息
 @param toView view
 */
+ (void)popupErrorMessage:(NSString *)errorMessage toView:(UIView *)toView;


/**
 弹出

 @param text 小型
 @param toView view
 */
+ (void)popupTipText:(NSString *)text toView:(UIView *)toView;

/**
 图片上传进度

 @param message 信息
 @param progress 进度
 @param toView view
 @param tipText 是否存在tip
 */
+ (void)popupAnnularDeterminateWithMessage:(NSString *)message
                                  progress:(CGFloat)progress
                                    toView:(UIView *)toView
                                   tipText:(NSString *)tipText;

///**
// 弹底部pop
//
// @param text 文字
// */
//+ (void)popupBottomTextView:(NSString *)text;
@end

