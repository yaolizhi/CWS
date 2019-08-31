//
//  SSKJ_UserInfo_Model.h
//  SSKJ
//
//  Created by 刘小雨 on 2018/12/10.
//  Copyright © 2018年 刘小雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKJ_UserInfoItem_Model.h"
#import "WLBaseModel.h"
#import "SSKJ_Apply_infoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SSKJ_UserInfo_Model : NSObject
@property (nonatomic, copy) NSString *has_tpwd;//true有资金密码 false 没有设置资金密码
@property (nonatomic, assign) CGFloat balance_pb;
@property (nonatomic, assign) CGFloat balance_cny;
@property (nonatomic, assign) CGFloat balance_usdt;
@property (nonatomic, copy) NSString *realname;//姓名
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *upic;//头像
@property (nonatomic, copy) NSString *reg_time;//注册时间戳
@property (nonatomic, copy) NSString *userid;//用户ID
@property (nonatomic, strong) SSKJ_Apply_infoModel *apply_info;
@property (nonatomic, strong) NSMutableArray <SSKJ_UserInfoItem_Model *>*list;
@end

NS_ASSUME_NONNULL_END
