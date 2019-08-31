//
//  RG_AgencyPlanTableViewCell.h
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGAgencyModel.h"
typedef enum : NSUInteger {
    RG_AgencyPlanType_Save,//保存
    RG_AgencyPlanType_Copy,//复制
    RG_AgencyPlanType_Enter,//进入
    RG_AgencyPlanType_Contact,//联系
    RG_AgencyPlanType_Read,//阅读
    RG_AgencyPlanType_Apply//申请
} RG_AgencyPlanType;

NS_ASSUME_NONNULL_BEGIN
@protocol RG_AgencyPlanTableViewCellDelegate <NSObject>

- (void)didSelectedAgencyPlanType:(RG_AgencyPlanType)type;

@end

@interface RG_AgencyPlanTableViewCell : UITableViewCell
@property (nonatomic, weak) id<RG_AgencyPlanTableViewCellDelegate> delegate;
- (void)configureCellWithHasApply:(BOOL)hasApply model:(RGAgencyModel *)model dicNull:(BOOL)dicNull;
@end

NS_ASSUME_NONNULL_END
