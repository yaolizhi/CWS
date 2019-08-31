//
//  WJRollClashView.m
//  WJRollNumber
//
//  Created by James on 2019/1/3.
//  Copyright © 2019年 JamesWu. All rights reserved.
//

#import "WJRollClashView.h"
#import "WJRollNumberView.h"
@interface WJRollClashView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) WJRollNumberView *leftRollView;
@property (nonatomic, strong) WJRollNumberView *middleRollView;
@property (nonatomic, strong) WJRollNumberView *rightRollView;

@property (nonatomic, assign) NSInteger leftRollNumber;
@property (nonatomic, assign) NSInteger middleRollNumber;
@property (nonatomic, assign) NSInteger rightRollNumber;
@property (nonatomic, assign) BOOL leftRollFinish;
@property (nonatomic, assign) BOOL middleRollFinish;
@property (nonatomic, assign) BOOL rightRollFinish;
@end

@implementation WJRollClashView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftRollNumber = 0;
        self.middleRollNumber = 0;
        self.rightRollNumber = 0;
        self.leftRollFinish = NO;
        self.middleRollFinish = NO;
        self.rightRollFinish = NO;
        
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.leftRollView];
        [self.bgView addSubview:self.middleRollView];
        [self.bgView addSubview:self.rightRollView];
        [self setupMasonry];
    }
    return self;
}

- (void)setupMasonry {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(110);
        make.bottom.equalTo(self);
    }];
    [self.leftRollView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat left = (ScreenWidth-(WJRollNumberViewWidth*3))/4;
        make.left.equalTo(self).offset(left);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(WJRollNumberViewWidth);
        make.height.mas_equalTo(WJRollNumberViewHeight);
    }];
    [self.middleRollView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat left = (ScreenWidth-(WJRollNumberViewWidth*3))/4;
        make.left.equalTo(self.leftRollView.mas_right).offset(left);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(WJRollNumberViewWidth);
        make.height.mas_equalTo(WJRollNumberViewHeight);
    }];
    [self.rightRollView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat left = (ScreenWidth-(WJRollNumberViewWidth*3))/4;
        make.left.equalTo(self.middleRollView.mas_right).offset(left);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(WJRollNumberViewWidth);
        make.height.mas_equalTo(WJRollNumberViewHeight);
    }];
}

- (void)startRollWithLeftRollNumber:(NSInteger)leftRollNumber middleRollNumber:(NSInteger)middleRollNumber rightRollNumber:(NSInteger)rightRollNumber {
    self.leftRollNumber = 0;
    self.middleRollNumber = 0;
    self.rightRollNumber = 0;
    self.leftRollFinish = NO;
    self.middleRollFinish = NO;
    self.rightRollFinish = NO;
    [self.leftRollView startRollScrollWithRollNumber:leftRollNumber rollLength:36 intervalTime:5.6];
    [self.middleRollView startRollScrollWithRollNumber:middleRollNumber rollLength:36 intervalTime:5.3];
    [self.rightRollView startRollScrollWithRollNumber:rightRollNumber rollLength:36 intervalTime:5.0];
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}

- (WJRollNumberView *)leftRollView {
    if (!_leftRollView) {
        WS(weakSelf);
        _leftRollView = [[WJRollNumberView alloc]initWithFrame:CGRectZero rollBlock:^(NSInteger rollNumber) {
            weakSelf.leftRollFinish = YES;
            weakSelf.leftRollNumber = rollNumber;
            if (self.delegate && [self.delegate respondsToSelector:@selector(rollHasFinished)]) {
                if (weakSelf.leftRollFinish && weakSelf.middleRollFinish && weakSelf.rightRollFinish) {
                    [self.delegate rollHasFinished];
                }
            }
        }];
    }
    return _leftRollView;
}

- (WJRollNumberView *)middleRollView {
    if (!_middleRollView) {
        WS(weakSelf);
        _middleRollView = [[WJRollNumberView alloc]initWithFrame:CGRectZero rollBlock:^(NSInteger rollNumber) {
            weakSelf.middleRollFinish = YES;
            weakSelf.middleRollNumber = rollNumber;
            if (self.delegate && [self.delegate respondsToSelector:@selector(rollHasFinished)]) {
                if (weakSelf.leftRollFinish && weakSelf.middleRollFinish && weakSelf.rightRollFinish) {
                    [self.delegate rollHasFinished];
                }
            }
        }];
    }
    return _middleRollView;
}

- (WJRollNumberView *)rightRollView {
    if (!_rightRollView) {
        WS(weakSelf);
        _rightRollView = [[WJRollNumberView alloc]initWithFrame:CGRectZero rollBlock:^(NSInteger rollNumber) {
            weakSelf.rightRollFinish = YES;
            weakSelf.rightRollNumber = rollNumber;
            if (self.delegate && [self.delegate respondsToSelector:@selector(rollHasFinished)]) {
                if (weakSelf.leftRollFinish && weakSelf.middleRollFinish && weakSelf.rightRollFinish) {
                    [self.delegate rollHasFinished];
                }
            }
        }];
    }
    return _rightRollView;
}

@end
