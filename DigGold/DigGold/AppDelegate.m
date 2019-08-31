//
//  AppDelegate.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/24.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "AppDelegate.h"
#import "RG_MainViewController.h"
#import "DigGold_BaseNavigationController.h"
#import "RG_Launch_ViewController.h"
//设置语言
#import "Localized.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [[SSKJ_User_Tool sharedUserTool]fetchCommonData];//获取元数据
    [[SSKJ_User_Tool sharedUserTool]fetchUserInfoData];//获取个人信息
    //点击屏幕 消失键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder=YES;
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    NSString *type = [WLTools wlDictionaryToJson:@{@"op":@"look"}];
//    NSLog(@"开始链接哈哈哈哈");
    [[ManagerSocket sharedManager]openConnectSocketWithConnectSuccess:^{
//        NSLog(@"已经链接已经链接已经链接已经链接已经链接已经链接已经链接");
        [[ManagerSocket sharedManager]socketSendMsg:type];
    
    }];
    
    //初始化语言  要在设置跟试图之前设置
    [[Localized sharedInstance]initLanguage];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    RG_Launch_ViewController *vc = [[RG_Launch_ViewController alloc]init];
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    [self startNetWorkClick];
    return YES;
}

- (void)gotoMain {
    RG_MainViewController *rgMainVC = [[RG_MainViewController alloc]initWithMain];
    DigGold_BaseNavigationController *navVC = [[DigGold_BaseNavigationController alloc]initWithRootViewController:rgMainVC];
    self.window.rootViewController = navVC;
}

- (void)startNetWorkClick {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                  [[NSNotificationCenter defaultCenter]postNotificationName:kWebConnentSuccessNotifition object:nil];
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                   [[NSNotificationCenter defaultCenter]postNotificationName:kWebConnentSuccessNotifition object:nil];
                NSLog(@"WIFI");
                break;
        }
    }];
    //开始监控
    [manager startMonitoring];

}




@end
