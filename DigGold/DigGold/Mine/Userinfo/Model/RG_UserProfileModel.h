//
//  RG_UserProfileModel.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RC_UserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_UserProfileModel : NSObject
@property (nonatomic, assign) BOOL has_tpwd;//true有资金密码 false 没有设置资金密码
@property (nonatomic, copy) NSString *balance_pb;
@property (nonatomic, assign) CGFloat balance_cny;
@property (nonatomic, assign) CGFloat balance_usdt;
@property (nonatomic, copy) NSString *realname;//姓名
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *upic;//头像
@property (nonatomic, copy) NSString *reg_time;//注册时间戳
@property (nonatomic, copy) NSString *apply_info;//注册时间戳
@property (nonatomic, strong) NSArray <RC_UserInfoModel *>*list;








@end

NS_ASSUME_NONNULL_END
