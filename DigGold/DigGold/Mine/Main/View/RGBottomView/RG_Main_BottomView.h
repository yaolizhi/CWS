//
//  RG_Main_BottomView.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RG_Main_BottomViewDelegat <NSObject>

- (void)didSelectedBottomViewWithTitle:(NSString *)title;

@end
@interface RG_Main_BottomView : UIView
@property (nonatomic, weak) id<RG_Main_BottomViewDelegat> delegate;

@end

NS_ASSUME_NONNULL_END
