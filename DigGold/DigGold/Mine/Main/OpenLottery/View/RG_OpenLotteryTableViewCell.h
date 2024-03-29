//
//  RG_OpenLotteryTableViewCell.h
//  DigGold
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_Mine_LotteryModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol RG_Mine_OLTableViewCellDelegate <NSObject>

- (void)didSelectedCheckButtonClickWithHash:(NSString *)hash;

@end
@interface RG_OpenLotteryTableViewCell : UITableViewCell
@property (nonatomic, weak) id <RG_Mine_OLTableViewCellDelegate> delegate;
- (void)configureCell:(RG_Mine_LotteryModel *)model;
- (void)initWithIndexPath:(NSIndexPath *)indexpath;
@end

NS_ASSUME_NONNULL_END
