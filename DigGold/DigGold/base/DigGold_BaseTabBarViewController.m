//
//  DigGold_BaseTabBarViewController.m
//  DigGold
//
//  Created by 姚立志 on 2019/9/1.
//  Copyright © 2019 MingShao. All rights reserved.
//



#pragma mark 视图控制器名字
#define kControllerNameArray @[@"RG_MainViewController",@"RG_RankListViewController",@"RG_FAQViewController",@"RG_MyCoinViewController"]

#pragma mark tabbar标题

#define kControllerTitleArray @[@"竞猜",@"排行榜",@"FQA",@"资产"]

#pragma mark tabbar 图标
#define kImageNameArray @[@"shouye",@"mubiao",@"zhouqi",@"ganggan"]


#pragma mark 选中图标
#define kSelectedImageNameArray @[@"shouye_hover",@"mubiao_hover",@"zhouqi_hover",@"ganggan_hover"]




#import "DigGold_BaseTabBarViewController.h"


@interface DigGold_BaseTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation DigGold_BaseTabBarViewController




-(void)setcommentColor
{
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, systemFont(11), NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], NSForegroundColorAttributeName, systemFont(11), NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    UITabBar *tabBar = [UITabBar appearance];
    
    
    [tabBar setBarTintColor:kMainBackgroundColor];
    
    tabBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加所有子控制器
    [self addAllChildViewController];
    
    self.delegate = self;
    
    [self setcommentColor];
}

#pragma mark - 加载所有的子控制器
- (void)addAllChildViewController
{
    for (int i = 0; i < kControllerNameArray.count; i++)
    {
        NSString *title = kControllerTitleArray[i];
        NSString *image = kImageNameArray[i];
        NSString *selectedImage = kSelectedImageNameArray[i];
        UIViewController *controller = nil;
        switch (i)
        {
            case 2:
            {
                controller = [[RG_FAQViewController alloc]initWithSelectedType:RG_FAQType_GP];
            }
                break;
            default:
            {
                NSString *controllerStr = kControllerNameArray[i];
                controller = [[NSClassFromString(controllerStr) alloc] init] ;
            }
                break;
        }
        [self addChildVC:controller title:title image:image selectedImage:selectedImage];
    }
    
}

/**
 *  添加子控制器
 *
 *  @param childVC      子控制器
 *  @param title        标题
 *  @param image        正常状态图片
 *  @param seletedImage 选中时的图片
 */
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)seletedImage
{
    DigGold_BaseNavigationController *naviVC = [[DigGold_BaseNavigationController alloc] initWithRootViewController:childVC];
    
    childVC.tabBarItem.image = [UIImage imageWithOriginalName:image];
    
    childVC.tabBarItem.selectedImage = [UIImage imageWithOriginalName:seletedImage];
    
    naviVC.tabBarItem.title = title;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor], NSForegroundColorAttributeName, systemFont(11), NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor purpleColor], NSForegroundColorAttributeName, systemFont(11), NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    
    [self addChildViewController:naviVC];
    
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ((viewController != [tabBarController.viewControllers lastObject]))
    {
        if (!kLogined)
        {
            [SwitchHelper switchLoginViewController:viewController];
            return NO;
        }
    }
    return YES;
}

@end
