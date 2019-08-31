//
//  RG_MA_WdRecordTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_MAWithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_MA_WdRecordTableViewCell : UITableViewCell
- (void)configureCellWithModel:(RG_MAWithdrawModel *)model;
@end

NS_ASSUME_NONNULL_END
