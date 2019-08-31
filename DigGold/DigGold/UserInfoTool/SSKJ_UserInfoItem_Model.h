//
//  SSKJ_UserInfoItem_Model.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SSKJ_UserInfoItem_Model :NSObject
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *zuigao;//最高盈利
@property (nonatomic, copy) NSString *leiji;//最高累计
@property (nonatomic, copy) NSString *income;//当前收益
@property (nonatomic, copy) NSString *loss;//最高亏损
@property (nonatomic, assign) NSInteger ranking;//排名
@property (nonatomic, copy) NSString *num;//投注次数
@property (nonatomic, copy) NSString *balance;//账户余额



@end

NS_ASSUME_NONNULL_END
