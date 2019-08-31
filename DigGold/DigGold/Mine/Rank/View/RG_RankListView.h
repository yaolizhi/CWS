//
//  RG_RankListView.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RG_RankListViewDelegate <NSObject>

- (void)didSelectedRankWithTitle:(NSString *)title;

@end

@interface RG_RankListView : UIView
@property (nonatomic, weak) id<RG_RankListViewDelegate> delegate;
@property (nonatomic, strong) UILabel *inputLabel;
@property (nonatomic, strong,readonly) UIButton *amountButton;
@property (nonatomic, strong,readonly) UIButton *rightButton;
- (instancetype)initWithFrame:(CGRect)frame coinTitlesArray:(NSArray *)coinTitlesArray wayTitlesArray:(NSArray *)wayTitlesArray coinTitle:(NSString *)coinTitle wayTitle:(NSString *)wayTitle;
@end

NS_ASSUME_NONNULL_END
