//
//  RG_QuestionSectionView.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RG_QuestionSectionViewDelegate <NSObject>

- (void)didSelectedWithSection:(NSInteger)section;

@end

@interface RG_QuestionSectionView : UITableViewHeaderFooterView
@property (nonatomic, weak) id<RG_QuestionSectionViewDelegate> delegate;

- (void)configureViewWithTitle:(NSString *)titleString section:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
