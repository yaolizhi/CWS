//
//  RG_Main_GoldAmountView.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RG_Main_GoldAmountViewDelegate <NSObject>

- (void)didSelectedWallet;
- (void)didSelectedAmountButton;
@end

@interface RG_Main_GoldAmountView : UIView
@property (nonatomic, strong) UIButton *amountButton;
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray;
@property (nonatomic, weak) id <RG_Main_GoldAmountViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
