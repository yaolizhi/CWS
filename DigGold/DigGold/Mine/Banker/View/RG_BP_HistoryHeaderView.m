//
//  RG_BP_HistoryHeaderView.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_BP_HistoryHeaderView.h"

@interface RG_BP_HistoryHeaderView()
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation RG_BP_HistoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.stateLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.timeLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(19));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(100));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScaleW(80));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(ScaleW(-10));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScaleW(125));
    }];
}

- (void)configureView {
    
    
    
    
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _stateLabel.textColor = kMainGaryWhiteColor;
        _stateLabel.adjustsFontSizeToFitWidth = YES;
        _stateLabel.text = Localized(@"状态", nil);
    }
    return _stateLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _priceLabel.textColor = kMainGaryWhiteColor;
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.text = Localized(@"金额", nil);
    }
    return _priceLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _timeLabel.textColor = kMainGaryWhiteColor;
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = Localized(@"时间", nil);
    }
    return _timeLabel;
}
#pragma mark -- Setter Method

@end
