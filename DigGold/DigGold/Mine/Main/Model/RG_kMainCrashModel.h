//
//  RG_kMainCrashModel.h
//  DigGold
//
//  Created by James on 2019/1/10.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_kMainCrashModel : NSObject
@property (nonatomic, assign) NSInteger gid;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, assign) CGFloat boomValue;
@property (nonatomic, copy) NSString *start_cny_pool_money;
@property (nonatomic, copy) NSString *start_pb_pool_money;

@end

NS_ASSUME_NONNULL_END
