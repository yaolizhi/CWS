//
//  RG_RollHeaderView.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_RollHeaderView.h"
#import "WJRollClashView.h"
@interface RG_RollHeaderView()<WJRollClashViewDelegate>
@property (nonatomic, strong) UILabel *qsLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *inputLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *topWarmLabel;
@property (nonatomic, strong) UILabel *residueNumberLabel;


@property (nonatomic, strong) UILabel *awardLabel;


@property (nonatomic, strong) WJRollClashView *rollClashView;
@end

@implementation RG_RollHeaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.topWarmLabel];
        [self addSubview:self.residueNumberLabel];
        [self addSubview:self.rollClashView];
        [self addSubview:self.rollButton];
        [self addSubview:self.countDownLabel];
        [self addSubview:self.awardLabel];
        
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.qsLabel];
        [self.bottomView addSubview:self.resultLabel];
        [self.bottomView addSubview:self.inputLabel];
        [self.bottomView addSubview:self.incomeLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.topWarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(ScaleW(40));
    }];
    [self.residueNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.topWarmLabel.mas_bottom).offset(ScaleH(20));
    }];
    
    [self.rollClashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.residueNumberLabel.mas_bottom).offset(ScaleH(44));
        make.right.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.rollButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.rollClashView.mas_bottom).offset(ScaleH(50));
        make.width.mas_equalTo(ScaleW(100));
        make.height.mas_equalTo(ScaleH(40));
    }];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.rollButton.mas_bottom).offset(ScaleH(18));
    }];
    
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(17));
        make.top.equalTo(self.countDownLabel.mas_bottom).offset(ScaleH(46));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardLabel.mas_bottom).offset(ScaleH(25));
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ScaleH(48));
    }];
    [self.qsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_left).offset(ScaleW(50));
        make.centerY.equalTo(self.bottomView);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_left).offset(ScaleW(140));
        make.centerY.equalTo(self.bottomView);
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_left).offset(ScaleW(228));
        make.centerY.equalTo(self.bottomView);
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_left).offset(ScaleW(316));
        make.centerY.equalTo(self.bottomView);
    }];
}

- (void)configureViewWithModel:(RG_RollModel *)model {
    self.awardLabel.text = F(@"今日奖励：%@", model.user_award?:@"");
    self.residueNumberLabel.text = F(@"剩余次数：%@", model.times?:@"");
    
    [self layoutIfNeeded];
    
}


#pragma mark -- WJRollClashViewDelegate
- (void)rollHasFinished {
    self.rollButton.enabled = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rollFinished)]) {
        [self.delegate rollFinished];
    }
}

#pragma mark -- Public Method
- (void)rollButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRollButtonClick)]) {
        [self.delegate startRollButtonClick];
    }

    
}


- (void)startRollWithLeftRollNumber:(NSInteger)left middle:(NSInteger)middle right:(NSInteger)right {
    [self.rollClashView startRollWithLeftRollNumber:left
                                   middleRollNumber:middle
                                    rightRollNumber:right];
}

#pragma mark -- Getter Method

- (UILabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[UILabel alloc]init];
        _awardLabel.textColor = kMainGaryWhiteColor;
        _awardLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _awardLabel.text = Localized(@"", nil);
        self.awardLabel.text = F(@"今日奖励：%@", @"0 JC");
    }
    return _awardLabel;
}

- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc]init];
        _countDownLabel.textColor = kMainGaryWhiteColor;
        _countDownLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _countDownLabel.text = Localized(@"倒计时 00:00:00", nil);
    }
    return _countDownLabel;
}
- (UIButton *)rollButton {
    if (!_rollButton) {
        _rollButton = [[UIButton alloc]init];
        [_rollButton setTitle:@"ROLL" forState:UIControlStateNormal];
        [_rollButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        [_rollButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateHighlighted];

        [_rollButton setBackgroundColor:kMainSubBackgroundColor];
        _rollButton.layer.cornerRadius = ScaleW(3);
        _rollButton.layer.masksToBounds = YES;
        [_rollButton addTarget:self action:@selector(rollButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rollButton;
}

- (WJRollClashView *)rollClashView {
    if (!_rollClashView) {
        _rollClashView = [[WJRollClashView alloc]init];
        _rollClashView.delegate = self;
        _rollClashView.backgroundColor = kMainBackgroundColor;
    }
    return _rollClashView;
}

- (UILabel *)topWarmLabel {
    if (!_topWarmLabel) {
        _topWarmLabel = [[UILabel alloc]init];
        _topWarmLabel.textColor = kMainGaryWhiteColor;
        _topWarmLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _topWarmLabel.text = Localized(@"每天参与游戏的玩家有一次机会", nil);
    }
    return _topWarmLabel;
}

- (UILabel *)residueNumberLabel {
    if (!_residueNumberLabel) {
        _residueNumberLabel = [[UILabel alloc]init];
        _residueNumberLabel.textColor = kMainTitleColor;
        _residueNumberLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _residueNumberLabel.text = Localized(@"剩余次数：0", nil);
    }
    return _residueNumberLabel;
}

-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = kMainBackgroundColor;
    }
    return _bottomView;
}
- (UILabel *)qsLabel {
    if (!_qsLabel) {
        _qsLabel = [[UILabel alloc]init];
        _qsLabel.textColor = kMainGaryWhiteColor;
        _qsLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _qsLabel.adjustsFontSizeToFitWidth = YES;
        _qsLabel.text = Localized(@"名次", nil);
    }
    return _qsLabel;
}
- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.textColor = kMainGaryWhiteColor;
        _resultLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _resultLabel.adjustsFontSizeToFitWidth = YES;
        _resultLabel.text = Localized(@"玩家", nil);
    }
    return _resultLabel;
}
- (UILabel *)inputLabel {
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc]init];
        _inputLabel.textColor = kMainGaryWhiteColor;
        _inputLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _inputLabel.adjustsFontSizeToFitWidth = YES;
        _inputLabel.text = Localized(@"点数", nil);
    }
    return _inputLabel;
}
- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
        _incomeLabel.textColor = kMainGaryWhiteColor;
        _incomeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _incomeLabel.adjustsFontSizeToFitWidth = YES;
        _incomeLabel.text = Localized(@"奖金", nil);
    }
    return _incomeLabel;
}
#pragma mark -- Setter Method


@end
