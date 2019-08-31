//
//  WJSegmentView.m
//  SSKJ
//
//  Created by James on 2018/12/21.
//  Copyright © 2018年 刘小雨. All rights reserved.
//

#import "WJSegmentView.h"
#define kCanSliderLineWidth  (ScreenWidth - 15 *2)/self.segementTitleArray.count
@interface WJSegmentView()
@property (nonatomic, strong)NSArray *segementTitleArray;/**<按钮标题数组*/
@property (nonatomic, strong)NSMutableArray *segementButtonArray;/**<按钮数组 */
@property (nonatomic, strong)UIView *segementContainer;/**<按钮容器*/
@property (nonatomic, strong)UIView *canSliderLine; /**<底部可滑动的线*/
@property (nonatomic, strong)UIView *bottomLine; /**<底部分割线*/
@end

@implementation WJSegmentView

- (instancetype)initWithSegmentWithTitleArray:(NSArray *)segementTitleArray{
    self = [super init];
    if (self) {
        self.segementTitleArray = segementTitleArray;
        self.backgroundColor = kMainBackgroundColor;
        [self createSegments];
        [self setUpViews];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.segementContainer.top = 0;
    self.segementContainer.left = 15;
    self.segementContainer.width = self.width - 15*2;
    self.segementContainer.height = self.height;
    
    self.bottomLine.frame = CGRectMake(15, KWJTabViewItemHeight-2, self.width-15*2, 2);
    //每个子segment的宽度
    CGFloat segmentWith = (self.width-15*2) / self.segementTitleArray.count;
    for (int i=0; i<self.segementButtonArray.count; i++) {
        UIButton *button = (UIButton *)self.segementButtonArray[i];
        button.top = 0;
        button.left = i * segmentWith;
        button.width = segmentWith;
        button.height = KWJTabViewItemHeight;
    }
    //设置底部滑动线条的位置
    self.canSliderLine.bottom = self.bottomLine.bottom;
    self.canSliderLine.left = self.segementContainer.left;
    self.canSliderLine.width = segmentWith;
    self.canSliderLine.height = 2.0f;
}

- (void)setUpViews
{
    [self addSubview:self.segementContainer];
    //添加segement到view
    for (UIButton *button in self.segementButtonArray) {
        [self.segementContainer addSubview:button];
    }
    
    [self addSubview:self.bottomLine];
    [self addSubview:self.canSliderLine];
}

- (void)createSegments
{
    self.segementButtonArray = [NSMutableArray array];
    for (int i=0; i<self.segementTitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button setTitle:self.segementTitleArray[i] forState:UIControlStateNormal];
        [button setTitle:self.segementTitleArray[i] forState:UIControlStateSelected];
        [button setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        [button setTitleColor:kMainTitleColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.backgroundColor = kMainBackgroundColor;
        if (i==0) {
            button.selected = YES;
        }else
        {
            button.selected = NO;
        }
        button.tag = i+10;
        
        [button addTarget:self action:@selector(clickSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.segementButtonArray addObject:button];
    }
}

- (void)clickSegmentButton:(UIButton *)segmentButton
{
    [self selectSegmentButton:segmentButton animate:YES];
    //回调给控制器
    if (self.clickSegmentButton) {
        self.clickSegmentButton(segmentButton.tag-10);
    }
}


- (void)selectSegmentButton:(UIButton *)segmentButton animate:(BOOL)animate
{
    segmentButton.selected = YES;
    [self changeSelectedWithSelectedButton:segmentButton animate:animate];
}
- (void)changeSelectedWithSelectedButton:(UIButton *)selectedButton animate:(BOOL)animate
{
    for (UIButton *button in self.segementButtonArray) {
        if (![button isEqual:selectedButton]) {
            button.selected = NO;
        }
    }
    //设置可滑动线条的位置
    [self setCanSliderLinePositionWithAnimate:animate];
}

- (void)setCanSliderLinePositionWithAnimate:(BOOL)animate
{
    UIButton *button = [self selectedButton];
    if (animate) {
        [UIView animateWithDuration:0.3f animations:^{
            self.canSliderLine.left = 15+(button.tag-10) * kCanSliderLineWidth;
        }];
    }else{
        self.canSliderLine.left = 15+(button.tag-10) * kCanSliderLineWidth;
    }

}

- (UIButton *)selectedButton
{
    NSInteger selectedIndex = [self selectedIndex];
    if (selectedIndex == -1 || self.segementButtonArray.count <= selectedIndex) {
        return nil;
    }
    return self.segementButtonArray[selectedIndex];
}

- (void)movieToCurrentSelectedSegment:(NSInteger)index animate:(BOOL)animate
{
    UIButton *button = self.segementButtonArray[index];
    
    [self selectSegmentButton:button animate:animate];
    //回调给控制器
    if (self.clickSegmentButton) {
        self.clickSegmentButton(button.tag-10);
    }
}

- (NSInteger)selectedIndex
{
    for(int i = 0; i < self.segementButtonArray.count; i++) {
        UIButton *button = (UIButton *)self.segementButtonArray[i];
        
        if (button.selected) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 懒加载
- (UIView *)segementContainer
{
    if (!_segementContainer) {
        _segementContainer = [[UIView alloc] init];
        _segementContainer.backgroundColor = kMainBackgroundColor;
    }
    return _segementContainer;
}

-(UIView *)canSliderLine
{
    if (!_canSliderLine) {
        _canSliderLine = [[UIView alloc] init];
        _canSliderLine.backgroundColor = kMainTitleColor;
    }
    return _canSliderLine;
}

-(UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kMainGaryWhiteColor;
    }
    return _bottomLine;
}

#pragma mark -- Setter Method

@end
