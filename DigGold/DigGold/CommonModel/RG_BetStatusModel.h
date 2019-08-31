//
//  RG_BetStatusModel.h
//  DigGold
//
//  Created by James on 2019/1/17.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_BetStatusModel : NSObject
@property (nonatomic, assign) BOOL hasBet;//已经投注
@property (nonatomic, assign) BOOL hasEscape;//已经逃跑
@property (nonatomic, assign) BOOL isWaiting;//等待过程中

@property (nonatomic, copy) NSString *changeTimes;//变化的倍数
@property (nonatomic, copy) NSString *changeCoinType;//变化的币种
@property (nonatomic, copy) NSString *changeBetNumber;//变化的投注数
@property (nonatomic, copy) NSString *changeEscapeNumber;//变化的逃跑倍数

@property (nonatomic, copy) NSString *recordCoinType;//当前期的币种
@property (nonatomic, copy) NSString *recordBetNumber;//当前期投注数
@property (nonatomic, copy) NSString *recordEscapeNumber;//当前期逃跑倍数

@property (nonatomic, assign) BOOL cacheHasRequest;//预约投注
@property (nonatomic, assign) BOOL cacheHasBet;//预约投注
@property (nonatomic, copy) NSString *cacheCoinType;//预约的币种
@property (nonatomic, copy) NSString *cacheBetNumber;//预约的投注数
@property (nonatomic, copy) NSString *cacheEscapeNumber;//预约逃跑倍数



@end

NS_ASSUME_NONNULL_END
