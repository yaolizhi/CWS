//
//  RG_BillRecord_ViewController.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "DigGold_Base_ViewController.h"

typedef enum : NSUInteger {
    RG_BillRecordType_JC,
    RG_BillRecordType_USDT,
} RG_BillRecordType;
NS_ASSUME_NONNULL_BEGIN
@interface RG_BillRecord_ViewController : DigGold_Base_ViewController
- (instancetype)initWithCoinType:(RG_BillRecordType)type;
@end

NS_ASSUME_NONNULL_END
