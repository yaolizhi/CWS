//
//  RG_UserProfileHeaderView.h
//  DigGold
//
//  Created by James on 2018/12/31.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RG_UserProfileHeaderViewDelegate <NSObject>

- (void)didSelectedChooseButtonClickType:(NSString *)type;

@end

@interface RG_UserProfileHeaderView : UIView
@property (nonatomic, weak) id<RG_UserProfileHeaderViewDelegate> delegate;

@property (nonatomic, strong,readonly) UIButton *chooseButton;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles title:(NSString *)title;
- (void)configureViewWithHeader:(NSString *)imageString name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
