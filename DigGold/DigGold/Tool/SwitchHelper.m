//
//  SwitchHelper.m
//  DigGold
//
//  Created by 姚立志 on 2019/9/1.
//  Copyright © 2019 MingShao. All rights reserved.
//

#import "SwitchHelper.h"
#import "DigGold_BaseTabBarViewController.h"
#import "RG_LoginViewController.h"


@implementation SwitchHelper



+(void)switchRootViewController:(BOOL)digGoldSwitch
{
    if (digGoldSwitch)
    {
        DigGold_BaseTabBarViewController *tabbarController = [[DigGold_BaseTabBarViewController alloc]init];
        [AppWindow setRootViewController:tabbarController];
    }
}



+(void)switchLoginViewController:(UIViewController*)tagert
{
    [SSKJ_User_Tool clearUserInfo];
    RG_LoginViewController *login = [[RG_LoginViewController alloc]init];
    DigGold_BaseNavigationController *nav = [[DigGold_BaseNavigationController alloc]initWithRootViewController:login];
    [tagert presentViewController:nav animated:YES completion:^{}];
}
@end
