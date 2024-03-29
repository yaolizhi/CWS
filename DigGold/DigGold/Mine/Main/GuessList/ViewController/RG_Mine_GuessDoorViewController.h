//
//  RG_Mine_GuessDoorViewController.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBaseTabViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RG_Mine_GuessDoorViewController : WJBaseTabViewController
- (instancetype)initWithSelectedIndexBlock:(void (^)(NSInteger index))selectedBlock;
- (CGFloat)acquireCurrentVCHeightWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
