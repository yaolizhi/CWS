//
//  RG_AgencyMiddleItemView.h
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AgencyMiddleItemHeight ScaleH(230)
#define AgencyMiddleItemWidth ScaleW(140)
NS_ASSUME_NONNULL_BEGIN

@interface RG_AgencyMiddleItemView : UIView
- (instancetype)initWithFrame:(CGRect)frame icon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle;
@end

NS_ASSUME_NONNULL_END
