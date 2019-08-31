//
//  RG_kMainModel.h
//  DigGold
//
//  Created by James on 2019/1/10.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_kMainPrepareModel : NSObject
//倒计时数组
@property (nonatomic, assign) NSInteger gid;//期数
@property (nonatomic, assign) NSInteger pt;//倒计时开始时间(毫秒)
@property (nonatomic, assign) NSInteger st;//倒计时结束时间(毫秒)
@property (nonatomic, copy) NSString *start_cny_pool_money;
@property (nonatomic, copy) NSString *start_pb_pool_money;
@end

NS_ASSUME_NONNULL_END
