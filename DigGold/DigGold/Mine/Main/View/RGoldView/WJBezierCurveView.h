//
//  WJBezierCurveView.h
//  WJCharts
//
//  Created by James on 2018/12/25.
//  Copyright © 2018年 JamesWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_kMainPrepareModel.h"
#import "RG_kMainProcessModel.h"
#import "RG_kMainCrashModel.h"
#import "RG_EscapeModel.h"
#define SpaceTimes 6.0f
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    WJBezierCurveViewType_CountDown,
    WJBezierCurveViewType_Draw,
    WJBezierCurveViewType_Crash,
} WJBezierCurveViewType;

@protocol WJBezierCurveViewDelegate <NSObject>
- (void)curveCountDownForce;
- (void)curveDrawLineForceWithPoint:(NSString *)point;
- (void)curveCrashForce;
- (void)curveChangeTimeForceWithPoint:(NSString *)point;


@end

@interface WJBezierCurveView : UIView
@property (nonatomic, weak) id <WJBezierCurveViewDelegate> delegate;

- (void)setupCountDownWithPerpareModel:(RG_kMainPrepareModel *)perpareModel isJCCoin:(BOOL)isJCCoin;
- (void)setupDrawLinWithProcessModel:(RG_kMainProcessModel *)processModel
                            isJCCoin:(BOOL)isJCCoin
                          escapeList:(NSArray *)escapeList;
- (void)setupCrashWithCrashModel:(RG_kMainCrashModel *)crashModel isJCCoin:(BOOL)isJCCoin;
@end

NS_ASSUME_NONNULL_END
