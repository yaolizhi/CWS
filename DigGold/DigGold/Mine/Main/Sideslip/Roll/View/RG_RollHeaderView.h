//
//  RG_RollHeaderView.h
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_RollModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol RG_RollHeaderViewDelegate <NSObject>

- (void)rollFinished;
- (void)startRollButtonClick;

@end

@interface RG_RollHeaderView : UIView
@property (nonatomic, strong) UIButton *rollButton;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, weak) id<RG_RollHeaderViewDelegate> delegate;

- (void)configureViewWithModel:(RG_RollModel *)model;
- (void)startRollWithLeftRollNumber:(NSInteger)left
                             middle:(NSInteger)middle
                              right:(NSInteger)right;
@end

NS_ASSUME_NONNULL_END
