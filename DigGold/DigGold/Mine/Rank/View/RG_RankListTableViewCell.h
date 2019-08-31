//
//  RG_RankListTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_RankListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_RankListTableViewCell : UITableViewCell
- (void)configureCellWithIndex:(NSInteger)index model:(RG_RankListModel *)model type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
