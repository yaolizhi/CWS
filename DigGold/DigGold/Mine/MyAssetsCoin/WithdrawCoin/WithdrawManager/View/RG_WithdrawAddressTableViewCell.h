//
//  RG_WithdrawAddressTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_WithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol RG_WithdrawAddressTableViewCellDelegate <NSObject>

- (void)didDeleteAddressWithIndex:(NSInteger)index;

@end

@interface RG_WithdrawAddressTableViewCell : UITableViewCell
@property (nonatomic, weak) id<RG_WithdrawAddressTableViewCellDelegate> delegate;

- (void)configureCell:(RG_WithdrawModel *)model index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
