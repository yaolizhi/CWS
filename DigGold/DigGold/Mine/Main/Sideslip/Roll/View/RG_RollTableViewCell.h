//
//  RG_RollTableViewCell.h
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_RollItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_RollTableViewCell : UITableViewCell
- (void)configureCellWithModel:(RG_RollItemModel *)model;
- (void)initWithIndexPath:(NSIndexPath *)indexpath;
@end

NS_ASSUME_NONNULL_END
