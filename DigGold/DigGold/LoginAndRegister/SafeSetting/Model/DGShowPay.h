//
//  DGShowPay.h
//  DigGold
//
//  Created by James on 2019/2/19.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGShowPay : NSObject

@property (nonatomic, copy) NSString *wxcard;
@property (nonatomic, copy) NSString *alicard;
@property (nonatomic, copy) NSString *bankcard;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *bankCode;

@end

NS_ASSUME_NONNULL_END
