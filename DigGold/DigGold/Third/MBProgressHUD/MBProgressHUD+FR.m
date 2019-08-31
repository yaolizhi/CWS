//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD+FR.h"

@implementation MBProgressHUD (FR)

+ (void)HUDShowViewWith:(UIColor *)color{
    
    if (color ==nil) {
        color = [UIColor clearColor];
    }
    
    UIView* view = [UIApplication sharedApplication].keyWindow ;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType =  MBProgressHUDAnimationFade;
    hud.bezelView.color = color;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor blackColor];
    hud.backgroundView.alpha = 0.4;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    hud.button.hidden = YES;
    
    UIImageView * loading = [[UIImageView alloc]init];

    
    loading.image = [UIImage imageNamed:@"image_00"];
    NSMutableArray *progressImages = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"image_%.2d",i++];
        UIImage *image = [UIImage imageNamed:imageName];
        [progressImages addObject:image];
        
    }
    hud.customView = [[UIImageView alloc] init];
    
    ((UIImageView *)hud.customView).animationImages = progressImages;
    ((UIImageView *)hud.customView).animationRepeatCount = 0;
    
    [((UIImageView *)hud.customView) startAnimating];
    

    [hud hideAnimated:NO afterDelay:7.0];
}


+ (void)HUDShowView{
    
    UIView* view = [UIApplication sharedApplication].keyWindow ;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType =  MBProgressHUDAnimationFade;
    hud.bezelView.color = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    hud.button.hidden = YES;
    UIImageView * loading = [[UIImageView alloc]init];
    loading.image = [UIImage imageNamed:@"image_00"];
    NSMutableArray *progressImages = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"image_%.2d",i++];
        UIImage *image = [UIImage imageNamed:imageName];
        [progressImages addObject:image];
        
    }
    hud.customView = [[UIImageView alloc] init];
    
    ((UIImageView *)hud.customView).animationImages = progressImages;
    ((UIImageView *)hud.customView).animationRepeatCount = 0;
    
    [((UIImageView *)hud.customView) startAnimating];
    
    [hud hideAnimated:NO afterDelay:7.0];
}


#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow ;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.text = [NSString stringWithFormat:@"\r\n\r\n%@",text];
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    // 设置图片
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.button.hidden = YES;
    // 再设置模式
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
     [hud hideAnimated:NO afterDelay:1.5];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow ;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置图片
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
//    hud.contentColor = kFontColor;
    
    hud.label.text = error;
    hud.label.numberOfLines = 0;
    hud.square = NO;
    hud.button.hidden = YES;
    
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:NO afterDelay:1.5];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置图片
//    hud.label.text =[NSString stringWithFormat:@"\r\n\r\n%@",success];
    hud.label.text = success;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success.png"]];
    hud.button.hidden = YES;
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:NO afterDelay:1.0];
    
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toViewLong:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置图片
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    
    hud.label.text = error;
    hud.label.numberOfLines = 0;
    hud.square = NO;
    hud.button.hidden = YES;
    
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:NO afterDelay:3];
}

+ (void)showError:(id)error
{
    NSString *stringerror = @"";
    if ([error isKindOfClass:[NSString class]]) {
        stringerror = error;
    }
    if ( [stringerror isEqualToString:Localized(@"网络异常", nil)]||[stringerror containsString:Localized(@"网络异常", nil)])
    {
        
        return;
    }
    NSString *Error = [NSString stringWithFormat:@"%@",error];
    [self showError:Error toView:nil];
}

+ (void)hideHUD
{
    UIView* view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:NO];
}

+ (void)showError:(NSString *)error WithColor:(UIColor *)color {
    
    UIView * view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置图片
    hud.bezelView.color = color;
//    hud.label.text = [NSString stringWithFormat:@"\r\n\r\n%@",error];
    hud.label.text = error;
    hud.label.numberOfLines = 0;
    hud.square = NO;
    hud.button.hidden = YES;
    hud.contentColor = [UIColor whiteColor];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 消失
    [hud hideAnimated:NO afterDelay:3.0];
}

@end
