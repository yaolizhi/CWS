//
//  RG_BP_HistoryViewController.h
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "DigGold_Base_ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RG_BP_HistoryViewController : DigGold_Base_ViewController
- (instancetype)initWithCoinType:(NSString *)coinType;
- (void)updateData;
@end

NS_ASSUME_NONNULL_END
