//
//  RG_CommonModel.h
//  DigGold
//
//  Created by James on 2019/1/10.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_CommonModel : NSObject
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, copy) NSString *create_time;//时间
@property (nonatomic, copy) NSString *pic;//图片
@property (nonatomic, copy) NSString *update_time;//更新时间
@property (nonatomic, copy) NSString *delete_status;//删除状态
@end

NS_ASSUME_NONNULL_END
