//
//  RG_AgencyViewController.h
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigGold_Base_ViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RG_AgencyViewType_DLJH,//代理计划
    RG_AgencyViewType_DLTK,//代理条款
    RG_AgencyViewType_YJGZ,//佣金规则
} RG_AgencyViewType;
@interface RG_AgencyViewController : DigGold_Base_ViewController
- (instancetype)initWithSelectedType:(RG_AgencyViewType)type;
@end

NS_ASSUME_NONNULL_END
