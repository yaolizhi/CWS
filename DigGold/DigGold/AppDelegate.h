//
//  AppDelegate.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/24.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZYNetworkTypeWiFi,//无线
    ZYNetworkTypeOffline,//关闭网络
    ZYNetworkTypeCellularData,//移动数据
    ZYNetworkTypeUnknown,//未知网络
} ZYNetworkType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


-(void)gotoMain;
-(void)startNetWorkClick;


@end

