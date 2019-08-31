//
//  RG_MA_RechargeTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_MA_RechargeTableViewCell.h"

@interface RG_MA_RechargeTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *chargeAddressLabel;
@property (nonatomic, strong) UILabel *chargeAddressContentLabel;
@property (nonatomic, strong) UILabel *chargeNumberLabel;
@property (nonatomic, strong) UILabel *chargeNumberContentLabel;
@property (nonatomic, strong) UILabel *chargeTimeLabel;
@property (nonatomic, strong) UILabel *chargeTimeContentLabel;
@property (nonatomic, strong) UILabel *chargeStateLabel;
@property (nonatomic, strong) UILabel *chargeStateContentLabel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *refusedLabel;

@end

@implementation RG_MA_RechargeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
//        [self.bgView addSubview:self.chargeAddressLabel];
//        [self.bgView addSubview:self.chargeAddressContentLabel];
        [self.bgView addSubview:self.chargeNumberLabel];
        [self.bgView addSubview:self.chargeNumberContentLabel];
        [self.bgView addSubview:self.chargeTimeLabel];
        [self.bgView addSubview:self.chargeTimeContentLabel];
//        [self.bgView addSubview:self.chargeStateLabel];
        [self.bgView addSubview:self.chargeStateContentLabel];
        [self.bgView addSubview:self.iconImageView];
        [self.bgView addSubview:self.refusedLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(15));
        make.right.equalTo(self).offset(-ScaleW(15));
        make.top.equalTo(self).offset(ScaleH(10));
        make.bottom.equalTo(self);
    }];
//    [self.chargeAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(11));
//        make.top.equalTo(self.bgView).offset(ScaleH(14));
//        make.width.mas_equalTo(ScaleW(60));
//    }];
//    [self.chargeAddressContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.chargeAddressLabel.mas_right).offset(ScaleW(12));
//        make.centerY.equalTo(self.chargeAddressLabel);
//        make.right.equalTo(self.bgView).offset(-ScaleW(12));
//    }];
    [self.chargeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.bgView).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.chargeNumberContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeNumberLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeNumberLabel);
        make.right.equalTo(self.chargeStateContentLabel.mas_left).offset(-ScaleW(12));
    }];
    
    
    [self.chargeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeNumberLabel.mas_bottom).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(60));
        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
        
    }];
    [self.chargeTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeTimeLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeTimeLabel);
    }];
    
//    [self.chargeStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(11));
//        make.top.equalTo(self.chargeTimeLabel.mas_bottom).offset(ScaleH(15));
//        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
//    }];

    [self.chargeStateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chargeNumberLabel);
        make.right.equalTo(self.bgView).offset(-ScaleW(12));
        make.width.mas_equalTo(ScaleW(60));
    }];
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(16));
//        make.top.equalTo(self.chargeTimeLabel.mas_bottom).offset(ScaleH(15));
//        make.width.height.mas_equalTo(16);
//        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
//    }];
//    [self.refusedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(4));
//        make.centerY.equalTo(self.iconImageView);
//
//    }];
    
}

- (void)configureCellWithModel:(RG_RechargeModel *)model {

//    self.chargeAddressContentLabel.text = model.chongzhi_url?:@"";
    self.chargeNumberContentLabel.text = F(@"%@USDT", model.price?:@"");
    self.chargeTimeContentLabel.text = model.addtime?:@"";
    self.refusedLabel.hidden = YES;
    self.iconImageView.hidden = YES;
    if ([model.state isEqualToString:@"1"]) {
        self.chargeStateContentLabel.text = @"充币中";
    }
    if ([model.state isEqualToString:@"2"]) {
        self.chargeStateContentLabel.text = @"已到账";
    }
    
    [self layoutIfNeeded];
}

- (void)process {
//    [self.chargeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(11));
//        make.top.equalTo(self.chargeNumberLabel.mas_bottom).offset(ScaleH(15));
//        make.width.mas_equalTo(ScaleW(60));
//        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
//    }];

//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(16));
//        make.top.equalTo(self.chargeTimeLabel.mas_bottom).offset(ScaleH(15));
//        make.width.height.mas_equalTo(0);
//    }];
//    [self.refusedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(4));
//        make.centerY.equalTo(self.iconImageView);
//        make.height.mas_equalTo(0);
//    }];
}
- (void)result {
//    [self.chargeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(11));
//        make.top.equalTo(self.chargeNumberLabel.mas_bottom).offset(ScaleH(15));
//        make.width.mas_equalTo(ScaleW(60));
//
//    }];
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(16));
//        make.top.equalTo(self.chargeTimeLabel.mas_bottom).offset(ScaleH(15));
//        make.width.height.mas_equalTo(16);
//        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
//    }];
//    [self.refusedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(4));
//        make.centerY.equalTo(self.iconImageView);
//
//    }];
}

#pragma mark -- Public Method

#pragma mark -- Getter Method

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainSubBackgroundColor;
        _bgView.layer.cornerRadius = ScaleW(5);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)chargeAddressLabel {
    if (!_chargeAddressLabel) {
        _chargeAddressLabel = [[UILabel alloc]init];
        _chargeAddressLabel.textColor = kMainGaryWhiteColor;
        _chargeAddressLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _chargeAddressLabel.text = Localized(@"充币地址", nil);
    }
    return _chargeAddressLabel;
}
- (UILabel *)chargeAddressContentLabel {
    if (!_chargeAddressContentLabel) {
        _chargeAddressContentLabel = [[UILabel alloc]init];
        _chargeAddressContentLabel.textColor = kMainGaryWhiteColor;
        _chargeAddressContentLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
    }
    return _chargeAddressContentLabel;
}
- (UILabel *)chargeNumberLabel {
    if (!_chargeNumberLabel) {
        _chargeNumberLabel = [[UILabel alloc]init];
        _chargeNumberLabel.textColor = kMainGaryWhiteColor;
        _chargeNumberLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _chargeNumberLabel.text = Localized(@"充币数量", nil);
    }
    return _chargeNumberLabel;
}
- (UILabel *)chargeNumberContentLabel {
    if (!_chargeNumberContentLabel) {
        _chargeNumberContentLabel = [[UILabel alloc]init];
        _chargeNumberContentLabel.textColor = kMainGaryWhiteColor;
        _chargeNumberContentLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
    }
    return _chargeNumberContentLabel;
}
- (UILabel *)chargeTimeLabel {
    if (!_chargeTimeLabel) {
        _chargeTimeLabel = [[UILabel alloc]init];
        _chargeTimeLabel.textColor = kMainGaryWhiteColor;
        _chargeTimeLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _chargeTimeLabel.text = Localized(@"充币时间", nil);
    }
    return _chargeTimeLabel;
}
- (UILabel *)chargeTimeContentLabel {
    if (!_chargeTimeContentLabel) {
        _chargeTimeContentLabel = [[UILabel alloc]init];
        _chargeTimeContentLabel.textColor = kMainGaryWhiteColor;
        _chargeTimeContentLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _chargeTimeContentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _chargeTimeContentLabel;
}
- (UILabel *)chargeStateLabel {
    if (!_chargeStateLabel) {
        _chargeStateLabel = [[UILabel alloc]init];
        _chargeStateLabel.textColor = kMainGaryWhiteColor;
        _chargeStateLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _chargeStateLabel.text = Localized(@"充币状态", nil);
    }
    return _chargeStateLabel;
}

- (UILabel *)chargeStateContentLabel {
    if (!_chargeStateContentLabel) {
        _chargeStateContentLabel = [[UILabel alloc]init];
        _chargeStateContentLabel.textColor = kMainTitleColor;
        _chargeStateContentLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
    }
    return _chargeStateContentLabel;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"ma_refused"];
    }
    return _iconImageView;
}

- (UILabel *)refusedLabel {
    if (!_refusedLabel) {
        _refusedLabel = [[UILabel alloc]init];
        _refusedLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _refusedLabel.textColor = kMainTitleColor;
    }
    return _refusedLabel;
}
#pragma mark -- Setter Method

@end
