//
//  RG_MA_RechargeTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_RechargeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_MA_RechargeTableViewCell : UITableViewCell
- (void)configureCellWithModel:(RG_RechargeModel *)model;
@end

NS_ASSUME_NONNULL_END
