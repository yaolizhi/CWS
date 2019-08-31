//
//  RG_SideslipView.h
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RG_SideslipViewDelegate <NSObject>

- (void)didSelectedSideslipWithIndex:(NSInteger)index;

@end

@interface RG_SideslipView : UIView
@property (nonatomic, weak) id <RG_SideslipViewDelegate> delegate;

- (void)showSideslipView;
- (void)dismissSideslipView;
@end

NS_ASSUME_NONNULL_END
