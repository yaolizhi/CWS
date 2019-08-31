//
//  RG_Mine_LotteryModel.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_Mine_LotteryModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *boomHash;
@property (nonatomic, copy) NSString *boomValue;
@property (nonatomic, assign) NSInteger buy_money;
@property (nonatomic, assign) NSInteger income;
@property (nonatomic, copy) NSString *periodID;//基数
@property (nonatomic, assign) NSInteger status;//状态
@property (nonatomic, assign) NSInteger add_time;//添加时间
@property (nonatomic, copy) NSString *process_time;//执行加倍的运行时间长度

@property (nonatomic, copy) NSString *pb_pool_money;
@property (nonatomic, copy) NSString *cny_pool_money;
@property (nonatomic, copy) NSString *edition;
@property (nonatomic, assign) NSInteger escape_beishu;
@property (nonatomic, assign) NSInteger final_beishu;


@end

NS_ASSUME_NONNULL_END
