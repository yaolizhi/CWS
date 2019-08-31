//
//  RG_Mine_AllGuessTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_XiaZhuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_Mine_AllGuessTableViewCell : UITableViewCell
- (void)initWithIndexPath:(NSIndexPath *)indexpath;
- (void)configureCellWithModel:(RG_XiaZhuModel *)model;
@end

NS_ASSUME_NONNULL_END
