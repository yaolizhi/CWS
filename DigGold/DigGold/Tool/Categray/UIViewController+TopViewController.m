//
//  UIViewController+TopViewController.m
//  RedChat
//
//  Created by James on 2018/8/8.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import "UIViewController+TopViewController.h"

@implementation UIViewController (TopViewController)

+ (UIViewController*)topViewController {

    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:[UIWindow class]] &&
            ([window.rootViewController isKindOfClass:NSClassFromString(@"RG_MianViewController")] ||
             [window.rootViewController isKindOfClass:[UINavigationController class]])) {
                return [self topViewControllerWithRootViewController:window.rootViewController];
            }
    }
    return nil;
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (UINavigationController*)topNavigationController
{
    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = ((UITabBarController*)self).selectedViewController.topNavigationController;
        }
        else {
            nav = self.navigationController;
        }
    }
    return nav;
}

@end
