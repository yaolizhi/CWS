//
//  RG_RankListModel.h
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_RankListModel : NSObject
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *upic;
@property (nonatomic, copy) NSString *zuigao;
@property (nonatomic, copy) NSString *leiji;
@property (nonatomic, assign) NSInteger current;

@end

NS_ASSUME_NONNULL_END
