//
//  RCHUDPop.m
//  RedChat
//
//  Created by James on 2018/8/28.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import "RCHUDPop.h"

@implementation RCHUDPop
static MBProgressHUD *recordHUD;
static UIView *bottomView;
//static MBProgressHUD *recordAnnularHUD;
+ (void)popupMessage:(NSString *)message toView:(UIView *)toView {
    [self popupHUDWithMessage:message toView:toView];
}

+ (void)popupMessage:(NSString *)message toView:(UIView *)toView after:(NSInteger)after {
    if (!message||message.length==0) {
        [self dismissHUDToView:toView];
        return;
    }
    MBProgressHUD *hud = [self popupHUDWithMessage:message toView:toView];
    [hud hideAnimated:NO afterDelay:after];
}

+ (void)popupSuccessMessage:(NSString *)successMessage toView:(UIView *)toView {
    if (!successMessage||successMessage.length==0) {
        [self dismissHUDToView:toView];
        return;
    }
    MBProgressHUD *hud = [self popupHUDWithMessage:successMessage toView:toView];
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hudSuccess"]];
    hud.square = YES;
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:NO afterDelay:2];
}

+ (void)popupErrorMessage:(NSString *)errorMessage toView:(UIView *)toView {
    if (!errorMessage||errorMessage.length==0) {
        [self dismissHUDToView:toView];
        return;
    }
    MBProgressHUD *hud = [self popupHUDWithMessage:errorMessage toView:toView];
    hud.square = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hudFailure"]];
    [hud hideAnimated:NO afterDelay:2];
}

+ (void)popupTipText:(NSString *)text toView:(UIView *)toView {
    if (!text||text.length==0) {
        [self dismissHUDToView:toView];
        return;
    }
    if (recordHUD) {
        [self dismissHUDToView:toView];
    }
    [self.class popupBottomTextView:text];
    
    
//    MBProgressHUD *hud = [self popupHUDWithMessage:nil toView:toView];
//    // 设置图片
//    hud.bezelView.color = [UIColor blackColor];
//    hud.contentColor = [UIColor whiteColor];
//
//    hud.label.text = text;
//    hud.label.numberOfLines = 0;
//    hud.square = NO;
//    hud.button.hidden = YES;
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hideAnimated:NO afterDelay:2];
}

+ (void)popupAnnularDeterminateWithMessage:(NSString *)message
                                  progress:(CGFloat)progress
                                    toView:(UIView *)toView
                                   tipText:(NSString *)tipText {
    recordHUD = [self popupHUDWithMessage:message toView:toView];
    recordHUD.mode = MBProgressHUDModeAnnularDeterminate;
    recordHUD.progress = progress;
    
    if (tipText && tipText.length > 0) {
        if (progress == 1.0f) {
            [self popupTipText:tipText toView:toView];
        }
    }
}

+ (MBProgressHUD *)popupHUDWithMessage:(NSString *)message toView:(UIView *)toView {
    if (recordHUD) {
        [self dismissHUDToView:toView];
    }
    MBProgressHUD *hud;
    if (toView) {
        hud = [MBProgressHUD showHUDAddedTo:toView animated:NO];
        hud.label.text = message?:@"";
        hud.removeFromSuperViewOnHide = YES;
    }else{
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
        hud.label.text = message?:@"";
        hud.removeFromSuperViewOnHide = YES;
    }
    recordHUD = hud;
    return recordHUD;
}


+ (void)dismissHUDToView:(UIView *)toView {
    if (recordHUD) {
        [recordHUD hideAnimated:NO];
        recordHUD = nil;
    }
    [self removeHUDToView:toView];
}

+ (void)removeHUDToView:(UIView *)toView {
    if (toView) {
        for (UIView *v in toView.subviews) {
            if ([v isKindOfClass:[MBProgressHUD class]]) {
                [v removeFromSuperview];
            }
        }
    }else{
        for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([v isKindOfClass:[MBProgressHUD class]]) {
                [v removeFromSuperview];
            }
        }
    }
}

+ (void)popupBottomTextView:(NSString *)text {
    if (!text || text.length == 0) {
        return;
    }
    if (bottomView) {
        [bottomView removeFromSuperview];
    }
    UIView *superView = [[UIApplication sharedApplication].windows lastObject];
    bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.7;
    bottomView.layer.cornerRadius = 4;
    bottomView.layer.masksToBounds = YES;
    
    [superView addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = text?:@"";
    label.font = [UIFont systemFontOfSize:ScaleFont(14)];
    label.textColor = [UIColor whiteColor];
    [bottomView addSubview:label];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX);
        make.bottom.equalTo(superView.mas_bottom).offset(-36-44);
        make.height.mas_equalTo(36);
        make.width.mas_greaterThanOrEqualTo(90);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.mas_lessThanOrEqualTo(-ScaleW(16));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bottomView removeFromSuperview];
        
    });
    
}

@end
