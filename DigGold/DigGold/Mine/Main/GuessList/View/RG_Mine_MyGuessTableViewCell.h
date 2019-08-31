//
//  RG_Mine_MyGuessTableViewCell.h
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_MyGuessModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_Mine_MyGuessTableViewCell : UITableViewCell
- (void)configureCellWithModel:(RG_MyGuessModel *)model;
- (void)initWithIndexPath:(NSIndexPath *)indexpath;
@end

NS_ASSUME_NONNULL_END
