//
//  RG_Mine_BetSettingView.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RG_Mine_BetSettingViewDelegate <NSObject>

- (void)bettingMethod;

@end

@interface RG_Mine_BetSettingView : UIView

@property (nonatomic, strong) UITextField *betTextField;
@property (nonatomic, strong) UITextField *runAwayTextField;
@property (nonatomic, weak) id<RG_Mine_BetSettingViewDelegate> delegate;
- (void)configureViewSelectedCoinType:(NSString *)coinType;

@end

NS_ASSUME_NONNULL_END
