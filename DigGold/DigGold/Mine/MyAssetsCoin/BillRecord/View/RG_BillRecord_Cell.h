//
//  RG_BillRecord_Cell.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_BillRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_BillRecord_Cell : UITableViewCell
- (void)configureWithModel:(RG_BillRecordModel *)model;
@end

NS_ASSUME_NONNULL_END
