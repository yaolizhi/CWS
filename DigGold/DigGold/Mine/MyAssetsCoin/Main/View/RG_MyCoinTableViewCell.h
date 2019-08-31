//
//  RG_MyCoinTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RGMyCoinCellClickType_Trade,
    RGMyCoinCellClickType_Account,
    RGMyCoinCellClickType_RechargeCoin,
    RGMyCoinCellClickType_CrrayCoin,
} RGMyCoinCellClickType;

@protocol RG_MyCoinTableViewCellDelegate <NSObject>

- (void)clickButtonWithType:(RGMyCoinCellClickType)type isJCCoin:(BOOL)isJCCoin;

@end

@interface RG_MyCoinTableViewCell : UITableViewCell
@property (nonatomic, weak) id <RG_MyCoinTableViewCellDelegate> delegate;

- (void)configureCellWithTitle:(NSString *)title money:(NSString *)money;
@end

NS_ASSUME_NONNULL_END
