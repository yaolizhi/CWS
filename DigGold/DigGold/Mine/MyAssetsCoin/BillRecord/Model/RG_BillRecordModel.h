//
//  RG_BillRecordModel.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_BillRecordModel : NSObject
@property (nonatomic, copy) NSString *nprice;//变动后金额
@property (nonatomic, copy) NSString *price;//变动金额
@property (nonatomic, copy) NSString *memo;//变动类型
@property (nonatomic, copy) NSString *addtime;//变动后金额
@end

NS_ASSUME_NONNULL_END
