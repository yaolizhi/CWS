//
//  RG_MessageModel.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_MessageModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) BOOL is_read;

//详情
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *show_status;
@property (nonatomic, copy) NSString *delete_status;
@property (nonatomic, copy) NSString *link;
@end

NS_ASSUME_NONNULL_END
