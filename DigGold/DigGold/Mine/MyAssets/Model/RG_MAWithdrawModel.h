//
//  RG_WithdrawModel.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_MAWithdrawModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *tixian_type;
@property (nonatomic, copy) NSString *ordername;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *shenhe_time;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *pay_type;//1 CNY 2USDT
@property (nonatomic, copy) NSString *usdt_rate;//汇率


@end

NS_ASSUME_NONNULL_END
