//
//  RG_MyGuessModel.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_MyGuessModel : NSObject
@property (nonatomic, copy) NSString *qs;
@property (nonatomic, copy) NSString *boomValue;
@property (nonatomic, copy) NSString *buy_money;
@property (nonatomic, copy) NSString *escape_beishu;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *back_money;
@property (nonatomic, copy) NSString *final_beishu;

@property (nonatomic, assign) CGFloat income;
@end


NS_ASSUME_NONNULL_END
