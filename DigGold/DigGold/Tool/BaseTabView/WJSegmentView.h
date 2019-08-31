//
//  WJSegmentView.h
//  SSKJ
//
//  Created by James on 2018/12/21.
//  Copyright © 2018年 刘小雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KWJTabViewItemHeight 40
NS_ASSUME_NONNULL_BEGIN

@interface WJSegmentView : UIView
@property (nonatomic, copy) void (^clickSegmentButton)(NSInteger index);

- (instancetype)initWithSegmentWithTitleArray:(NSArray *)segementTitleArray;

//滑动到当前选中的segment
- (void)movieToCurrentSelectedSegment:(NSInteger)index animate:(BOOL)animate;
@end

NS_ASSUME_NONNULL_END
