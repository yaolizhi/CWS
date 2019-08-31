//
//  RG_BP_MainView.h
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_BP_MainView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
- (instancetype)initWithFrame:(CGRect)frame subTitleStirng:(NSString *)subTitleString;
@end

NS_ASSUME_NONNULL_END
