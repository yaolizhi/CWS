//
//  SSKJ_Login_Model.h
//  SSKJ
//
//  Created by 刘小雨 on 2018/12/10.
//  Copyright © 2018年 刘小雨. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSKJ_Login_Model : NSObject
// 手机号
@property (nonatomic, copy) NSString *mobile;

// token
@property (nonatomic, copy) NSString *token;

// account
@property (nonatomic, copy) NSString *account;

// uid
@property (nonatomic, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
