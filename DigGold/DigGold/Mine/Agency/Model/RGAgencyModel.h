//
//  RGAgencyModel.h
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGAgencyModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *card1;
@property (nonatomic, copy) NSString *card2;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
