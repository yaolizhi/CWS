//
//  WJTabView.h
//  DigGold
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJSegmentView.h"
@class WJTabView;
NS_ASSUME_NONNULL_BEGIN


@protocol WJTabViewDatsSource <NSObject>
- (NSArray *)titlesOfTabView:(WJTabView *)tabView;
- (UIView *)tabView:(WJTabView *)tabView didScrollToPageIndx:(NSInteger)index;
@end

@protocol WJTabViewDelegate <NSObject>
//点击方法
- (void)tabView:(WJTabView *)tabView didSelectedPageIndex:(NSInteger)index;

@end

@interface WJTabView : UIView
@property(nonatomic,weak)id <WJTabViewDatsSource>dataSource;
@property(nonatomic,weak)id <WJTabViewDelegate>delegate;
- (void)triggerActionWithIndex:(NSUInteger)tabIndex;
@end

NS_ASSUME_NONNULL_END
