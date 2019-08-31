//
//  RG_Main_RGoldView.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBezierCurveView.h"
#import "RG_Mine_LotteryModel.h"
#import "RG_Mine_BetSettingView.h"
#import "RG_BetStatusModel.h"
NS_ASSUME_NONNULL_BEGIN


@protocol RG_Main_RGoldViewDelegate <NSObject>

- (void)didSelectedPickMeClick;
- (void)didSelectedBetWithPrice:(NSString *)price beishu:(NSString *)beishu;

@end
@interface RG_Main_RGoldView : UIView
@property (nonatomic, strong) UIButton *betButton;
@property (nonatomic, strong) WJBezierCurveView *curveView;
@property (nonatomic, strong) RG_Mine_BetSettingView *betSettingView;
@property (nonatomic, weak) id<RG_Main_RGoldViewDelegate> delegate;

- (void)configureViewWithArray:(NSArray *)modelsArray;

/* 倒计时 */
- (void)setupBetButtonCountdownWithModel:(RG_BetStatusModel *)model;
/* 划线 */
- (void)setupBetButtonDrawLineWithModel:(RG_BetStatusModel *)model;
/* 爆炸 */
- (void)setupBetButtonBombWithModel:(RG_BetStatusModel *)model;

@end

NS_ASSUME_NONNULL_END
