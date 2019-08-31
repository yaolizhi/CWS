//
//  RG_Main_TopMenuView.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RG_Main_TopMenuSelectedType_Guess,
    RG_Main_TopMenuSelectedType_Rank,
    RG_Main_TopMenuSelectedType_FAQ,
    RG_Main_TopMenuSelectedType_Lottery,
    RG_Main_TopMenuSelectedType_Fair,
    RG_Main_TopMenuSelectedType_AppDown
} RG_Main_TopMenuSelectedType;

@protocol RG_Main_TopMenuViewDelegate <NSObject>

- (void)topMenuSelectedWithType:(RG_Main_TopMenuSelectedType)menuType;

@end

@interface RG_Main_TopMenuView : UIView
@property (nonatomic, weak) id <RG_Main_TopMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
