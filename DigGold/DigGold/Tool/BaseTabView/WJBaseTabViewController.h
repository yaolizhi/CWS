//
//  WJBaseTabViewController.h
//  SSKJ
//
//  Created by James on 2018/12/21.
//  Copyright © 2018年 刘小雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigGold_Base_ViewController.h"
NS_ASSUME_NONNULL_BEGIN

#define KWJBaseTabHeight 40
/**
    使用该baseTab请先继承WJBaseTabViewController 实现DataSource 代理
 */
@class WJBaseTabViewController;
@protocol WJBaseTabViewControllerDataSource <NSObject>
//@required
//返回Titles
- (NSArray *)titlesOfTabViewController:(WJBaseTabViewController *)tabViewController;

//返回View
- (UIView *)tabViewController:(WJBaseTabViewController *)tabViewController didScrollToPageIndx:(NSInteger)index;

@end

@protocol WJBaseTabViewControllerDelegate <NSObject>
//点击方法
- (void)tabViewController:(WJBaseTabViewController *)tabViewController didSelectedPageIndex:(NSInteger)index;

@end

@interface WJBaseTabViewController : DigGold_Base_ViewController
<WJBaseTabViewControllerDataSource,
WJBaseTabViewControllerDelegate>
@property (nonatomic, weak) id <WJBaseTabViewControllerDataSource> dataSource;
@property (nonatomic, weak) id <WJBaseTabViewControllerDelegate> delegate;
- (void)triggerActionWithIndex:(NSUInteger)tabIndex;
@end

NS_ASSUME_NONNULL_END
