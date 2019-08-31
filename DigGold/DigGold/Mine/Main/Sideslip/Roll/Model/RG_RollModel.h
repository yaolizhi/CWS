//
//  RG_RollModel.h
//  DigGold
//
//  Created by James on 2019/1/11.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RG_RollItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_RollModel : NSObject
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *times;
@property (nonatomic, copy) NSString *sy_sec;
@property (nonatomic, copy) NSString *user_award;
@property (nonatomic, strong) NSArray<RG_RollItemModel*> *rank;

@end

NS_ASSUME_NONNULL_END
