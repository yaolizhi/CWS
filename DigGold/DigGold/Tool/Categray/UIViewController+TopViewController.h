//
//  UIViewController+TopViewController.h
//  RedChat
//
//  Created by James on 2018/8/8.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopViewController)
+ (UIViewController*)topViewController;
- (UINavigationController*)topNavigationController;
@end
