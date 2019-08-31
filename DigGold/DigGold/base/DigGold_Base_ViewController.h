//
//  DigGold_Base_ViewController.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DigGold_Base_ViewController : UIViewController

/*
 * 修改导航栏字体颜色
 */
-(void)setTitleColor:(UIColor *)titleColor;

/*
 * 修改导航栏字体
 */
-(void)setTitleFont:(UIFont *)font;

/*
 * 修改导航栏背景色
 */
-(void)setNavgationBackgroundColor:(UIColor *)navigationBackgroundColor;

/*
 * 修改导航栏左侧按钮
 */
- (void)addLeftNavItemWithImage:(UIImage*)image;

/*
 * 修改导航栏左侧按钮
 */
- (void)addLeftNavItemWithTitle:(NSString*)title;

/*
 * 返回按钮点击事件
 */
- (void)leftBtnAction:(id)sender;

/*
 * 添加导航栏右侧按钮
 */
- (void)addRightNavItemWithTitle:(NSString*)title;

/*
 * 添加导航栏右侧按钮
 */
- (void)addRightNavgationItemWithImage:(UIImage*)image;

/*
 * 导航栏右侧按钮点击事件
 */
- (void)rigthBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
