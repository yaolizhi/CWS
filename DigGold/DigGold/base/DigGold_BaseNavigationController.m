//
//  DigGold_BaseNavigationController.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "DigGold_BaseNavigationController.h"

@interface DigGold_BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation DigGold_BaseNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.navigationBar.translucent = NO;
    
    self.navigationBar.barTintColor = kMainNavbarColor;
    self.navigationBar.tintColor = kMainNavbarColor;
    
    // 去除navigationbar下面的线
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.delegate = self;
    
    WS(weakSelf);
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

#pragma mark - 设置侧滑返回功能
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count != 0 )
    {
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.backBarButtonItem = nil;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.viewControllers.count > 1;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    //使navigationcontroller中第一个控制器不响应右滑pop手势
    if (navigationController.viewControllers.count == 1) {
        
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
