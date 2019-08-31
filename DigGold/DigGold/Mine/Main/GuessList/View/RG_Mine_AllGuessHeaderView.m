//
//  RG_Mine_AllGuessHeaderView.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_Mine_AllGuessHeaderView.h"

@interface RG_Mine_AllGuessHeaderView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *qsLabel;
@property (nonatomic, strong) UILabel *runLabel;
@property (nonatomic, strong) UILabel *inputLabel;
@property (nonatomic, strong) UILabel *incomeLabel;

@end

@implementation RG_Mine_AllGuessHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.qsLabel];
        [self addSubview:self.runLabel];
        [self addSubview:self.inputLabel];
        [self addSubview:self.incomeLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(56));
        make.centerY.equalTo(self);
    }];
    [self.qsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(110));
        make.centerY.equalTo(self);
    }];
    [self.runLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(170));
        make.centerY.equalTo(self);
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(235));
        make.centerY.equalTo(self);
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(316));
        make.centerY.equalTo(self);
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = kMainGaryWhiteColor;
        _nameLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.text = Localized(@"玩家", nil);
    }
    return _nameLabel;
}
    
- (UILabel *)qsLabel {
    if (!_qsLabel) {
        _qsLabel = [[UILabel alloc]init];
        _qsLabel.textColor = kMainGaryWhiteColor;
        _qsLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _qsLabel.adjustsFontSizeToFitWidth = YES;
        _qsLabel.text = Localized(@"期数", nil);
    }
    return _qsLabel;
}
- (UILabel *)runLabel {
    if (!_runLabel) {
        _runLabel = [[UILabel alloc]init];
        _runLabel.textColor = kMainGaryWhiteColor;
        _runLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _runLabel.adjustsFontSizeToFitWidth = YES;
        _runLabel.text = Localized(@"手/自逃跑", nil);
    }
    return _runLabel;
}
- (UILabel *)inputLabel {
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc]init];
        _inputLabel.textColor = kMainGaryWhiteColor;
        _inputLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _inputLabel.adjustsFontSizeToFitWidth = YES;
        _inputLabel.text = Localized(@"投入", nil);
    }
    return _inputLabel;
}
- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
        _incomeLabel.textColor = kMainGaryWhiteColor;
        _incomeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _incomeLabel.adjustsFontSizeToFitWidth = YES;
        _incomeLabel.text = Localized(@"收益", nil);
    }
    return _incomeLabel;
}
#pragma mark -- Setter Method

@end
