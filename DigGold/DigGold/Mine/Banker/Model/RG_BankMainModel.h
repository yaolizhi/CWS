//
//  RG_BankMainModel.h
//  DigGold
//
//  Created by James on 2019/1/8.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "WLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RG_BankMainModel : NSObject
@property (nonatomic, assign) CGFloat bank_money;
@property (nonatomic, assign) CGFloat bank_money_lirun;
@property (nonatomic, assign) CGFloat bank_money_total;
@property (nonatomic, assign) CGFloat bank_money_lirun_total;
@property (nonatomic, assign) double jc_bank_money_total;
@property (nonatomic, copy) NSString *scale;
@end

NS_ASSUME_NONNULL_END
