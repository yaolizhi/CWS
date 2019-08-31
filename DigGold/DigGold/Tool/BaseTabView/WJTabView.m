//
//  WJTabView.m
//  DigGold
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "WJTabView.h"

@interface WJTabView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;/**<控制器容器*/
@property (nonatomic, strong) WJSegmentView *segment;
@property (nonatomic, strong) NSArray *titlesArray;
@end

@implementation WJTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainScrollView];
        [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(KWJTabViewItemHeight);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    
}

- (void)configureView {
    
}

- (void)triggerActionWithIndex:(NSUInteger)tabIndex {
    [self loadViewWithIndex:tabIndex];
    [self.mainScrollView setContentOffset:CGPointMake(tabIndex*ScreenWidth, 0)
                                     animated:NO];
    [self.segment movieToCurrentSelectedSegment:tabIndex animate:NO];
}

#pragma mark -- UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
    [self.segment movieToCurrentSelectedSegment:index animate:YES];
}
#pragma mark -- Public Method
- (void)loadViewWithIndex:(NSInteger)index {
    if (index>self.titlesArray.count-1 || index<0) {
        return;
    }
    UIView *view = [self.dataSource tabView:self didScrollToPageIndx:index];
    if (!view) {
        return;
    }
    BOOL enableAddSubView = YES;
    for (UIView *v in self.mainScrollView.subviews) {
        if (v == view) {
            enableAddSubView = NO;
            break;
        }
    }
    view.left = index*ScreenWidth;
    view.top = 0;
    view.width = ScreenWidth;
    view.height = self.mainScrollView.height;
    if (enableAddSubView) {
        [self.mainScrollView addSubview:view];
        [self layoutIfNeeded];
    }
    
    
}
#pragma mark -- Getter Method

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KWJTabViewItemHeight, ScreenWidth, 0)];
        _mainScrollView.backgroundColor= kMainBackgroundColor;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

- (WJSegmentView *)segment
{
    if (!_segment) {
        _segment = [[WJSegmentView alloc] initWithSegmentWithTitleArray:self.titlesArray];
        WS(weakSelf);
        _segment.clickSegmentButton = ^(NSInteger index) {
            [weakSelf loadViewWithIndex:index];
            [weakSelf.mainScrollView setContentOffset:CGPointMake(index*ScreenWidth, 0)
                                            animated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectedPageIndex:)]) {
                [weakSelf.delegate tabView:weakSelf didSelectedPageIndex:index];
            }
        };
        self.mainScrollView.contentSize = CGSizeMake(self.titlesArray.count*ScreenWidth, self.mainScrollView.height);
    }
    return _segment;
}
#pragma mark -- Setter Method
- (void)setDataSource:(id<WJTabViewDatsSource>)dataSource {
    _dataSource = dataSource;
    if (self.dataSource && [self.dataSource titlesOfTabView:self]) {
        self.titlesArray = [self.dataSource titlesOfTabView:self];
        [self addSubview:self.segment];
        [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, KWJTabViewItemHeight));
        }];
        [self triggerActionWithIndex:0];
        [self layoutIfNeeded];
    }
    
}
@end
