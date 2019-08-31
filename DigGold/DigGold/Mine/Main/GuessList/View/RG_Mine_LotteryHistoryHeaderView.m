//
//  RG_Mine_LotteryHistoryHeaderView.m
//  DigGold
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_Mine_LotteryHistoryHeaderView.h"

@interface RG_Mine_LotteryHistoryHeaderView()
@property (nonatomic, strong) UILabel *qsLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *inputLabel;
@end

@implementation RG_Mine_LotteryHistoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.qsLabel];
        [self addSubview:self.resultLabel];
        [self addSubview:self.inputLabel];
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
        make.centerX.equalTo(self.mas_left).offset(ScaleW(140));
        make.centerY.equalTo(self);
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(ScaleW(240));
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
        _qsLabel.text = @"期数";
    }
    return _qsLabel;
}
- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.textColor = kMainGaryWhiteColor;
        _resultLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _resultLabel.adjustsFontSizeToFitWidth = YES;
        _resultLabel.text = @"结果";
    }
    return _resultLabel;
}
- (UILabel *)inputLabel {
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc]init];
        _inputLabel.textColor = kMainGaryWhiteColor;
        _inputLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _inputLabel.adjustsFontSizeToFitWidth = YES;
        _inputLabel.text = @"校验值";
    }
    return _inputLabel;
}
#pragma mark -- Setter Method

@end
