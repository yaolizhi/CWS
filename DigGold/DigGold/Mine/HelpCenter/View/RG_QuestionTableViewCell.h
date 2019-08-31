//
//  RG_HelpCenterTableViewCell.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RG_CommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_QuestionTableViewCell : UITableViewCell
- (void)configureCellWithContent:(NSString *)content;
- (void)configureCellWithModel:(RG_CommonModel *)model;
@end

NS_ASSUME_NONNULL_END
