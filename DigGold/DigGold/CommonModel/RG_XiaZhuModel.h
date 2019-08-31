//
//  RG_XiaZhuModel.h
//  DigGold
//
//  Created by James on 2019/1/11.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_XiaZhuModel : NSObject
@property (nonatomic, copy) NSString *qs;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *buy_money;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *escape_beishu;
@property (nonatomic, copy) NSString *ordername;
@property (nonatomic, assign) NSInteger create_time;
@property (nonatomic, assign) NSInteger edition;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, assign) NSInteger escape_time;
@property (nonatomic, assign) NSInteger escape_xiangdui_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) CGFloat final_beishu;
@property (nonatomic, copy) NSString *escape_want_time;
@property (nonatomic, copy) NSString *upic;
@end

NS_ASSUME_NONNULL_END
