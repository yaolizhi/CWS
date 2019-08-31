//
//  RG_DownSidelipView.h
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RG_DownSidelipViewDelegate <NSObject>

- (void)didSelectedDownSideslipWithIndex:(NSInteger)index;

@end
@interface RG_DownSidelipView : UIView
@property (nonatomic, weak) id <RG_DownSidelipViewDelegate> delegate;
//- (void)showSideslipView;
//- (void)dismissSideslipView;
@end

NS_ASSUME_NONNULL_END
