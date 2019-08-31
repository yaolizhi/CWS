//
//  RG_Message_Cell.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_MessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_Message_Cell : UITableViewCell
- (void)configureCellWith:(RG_MessageModel *)model;
@end

NS_ASSUME_NONNULL_END
