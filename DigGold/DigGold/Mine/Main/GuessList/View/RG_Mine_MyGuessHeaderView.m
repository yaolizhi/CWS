//
//  RG_Mine_MyGuessHeaderView.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_Mine_MyGuessHeaderView.h"

@interface RG_Mine_MyGuessHeaderView()
@property (nonatomic, strong) UILabel *qsLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *inputLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *escapeLabel;
@end

@implementation RG_Mine_MyGuessHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.qsLabel];
        [self addSubview:self.resultLabel];
        [self addSubview:self.inputLabel];
        [self addSubview:self.incomeLabel];
        [self addSubview:self.escapeLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.qsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(70));
        make.centerY.equalTo(self);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(125));
        make.centerY.equalTo(self);
    }];
    [self.escapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(180));
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
- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.textColor = kMainGaryWhiteColor;
        _resultLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _resultLabel.adjustsFontSizeToFitWidth = YES;
        _resultLabel.text = Localized(@"爆炸倍数", nil);
    }
    return _resultLabel;
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
- (UILabel *)escapeLabel {
    if (!_escapeLabel) {
        _escapeLabel = [[UILabel alloc]init];
        _escapeLabel.textColor = kMainGaryWhiteColor;
        _escapeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _escapeLabel.adjustsFontSizeToFitWidth = YES;
        _escapeLabel.text = Localized(@"手/自逃跑", nil);
    }
    return _escapeLabel;
}
#pragma mark -- Setter Method

@end
