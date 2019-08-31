//
//  RG_BP_HistoryTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_BPHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_BP_HistoryTableViewCell : UITableViewCell
- (void)initWithIndexPath:(NSIndexPath *)indexpath;
- (void)configureCellWithModel:(RG_BPHistoryModel *)model coin:(NSString *)coin;


@end

NS_ASSUME_NONNULL_END
