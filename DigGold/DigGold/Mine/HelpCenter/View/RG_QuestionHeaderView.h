//
//  RG_QuestionHeaderView.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_QuestionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *titleLabel;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle;
- (void)configureWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
@end

NS_ASSUME_NONNULL_END
