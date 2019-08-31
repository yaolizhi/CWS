//
//  RG_PullDownView.h
//  DigGold
//
//  Created by James on 2019/1/8.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PullDownViewCellHeight 44
NS_ASSUME_NONNULL_BEGIN

@protocol RG_PullDownViewDelegate <NSObject>

- (void)didSelectedPullDownTitle:(NSString *)title;

@end

@interface RG_PullDownView : UIView
@property (nonatomic, assign) BOOL canSlide;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *iconsArray;
@property (nonatomic, assign) BOOL showIntro;
@property (nonatomic, weak) id<RG_PullDownViewDelegate> delegate;
@property (nonatomic, strong) UIColor *bgColor;
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray;
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray canSlide:(BOOL)canSlide;
@end

NS_ASSUME_NONNULL_END
