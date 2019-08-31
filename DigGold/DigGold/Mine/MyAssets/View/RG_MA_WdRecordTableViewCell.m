//
//  RG_MA_WdRecordTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_MA_WdRecordTableViewCell.h"

@interface RG_MA_WdRecordTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *chargeAddressLabel;
@property (nonatomic, strong) UILabel *chargeAddressContentLabel;
@property (nonatomic, strong) UILabel *chargeNumberLabel;
@property (nonatomic, strong) UILabel *chargeNumberContentLabel;
@property (nonatomic, strong) UILabel *chargeTimeLabel;
@property (nonatomic, strong) UILabel *chargeTimeContentLabel;
@property (nonatomic, strong) UILabel *chargeShenheTimeLabel;
@property (nonatomic, strong) UILabel *chargeShenheTimeContentLabel;
@property (nonatomic, strong) UILabel *chargeStateLabel;
@property (nonatomic, strong) UILabel *chargeStateContentLabel;


@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *refusedLabel;
@end

@implementation RG_MA_WdRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;

        
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.chargeAddressLabel];
        [self.bgView addSubview:self.chargeAddressContentLabel];
        [self.bgView addSubview:self.chargeNumberLabel];
        [self.bgView addSubview:self.chargeNumberContentLabel];
        [self.bgView addSubview:self.chargeTimeLabel];
        [self.bgView addSubview:self.chargeTimeContentLabel];
        [self.bgView addSubview:self.chargeShenheTimeLabel];
        [self.bgView addSubview:self.chargeShenheTimeContentLabel];
        [self.bgView addSubview:self.chargeStateLabel];
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
    [self.chargeAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.bgView).offset(ScaleH(14));
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.chargeAddressContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeAddressLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeAddressLabel);
        make.right.equalTo(self.bgView).offset(-ScaleW(12));
    }];
    [self.chargeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeAddressLabel.mas_bottom).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.chargeNumberContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeNumberLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeNumberLabel);
        make.right.equalTo(self.bgView).offset(-ScaleW(12));
    }];
    
    
    [self.chargeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeNumberLabel.mas_bottom).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(60));
        
        
    }];
    [self.chargeTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeTimeLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeTimeLabel);
        make.right.equalTo(self.bgView).offset(-ScaleW(12));
    }];
    
    [self.chargeShenheTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeTimeLabel.mas_bottom).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(60));
        
    }];
    [self.chargeShenheTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeShenheTimeLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeShenheTimeLabel);
        make.right.equalTo(self.bgView).offset(-ScaleW(12));
    }];
    
    
    [self.chargeStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeShenheTimeLabel.mas_bottom).offset(ScaleH(15));
        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
    }];
    
    [self.chargeStateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeStateLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeStateLabel);
    }];

}

- (void)configureCellWithModel:(RG_MAWithdrawModel *)model {
    self.chargeAddressContentLabel.text = model.ordername?:@"";
    NSString *type = @"";
    NSString *price = model.price?:@"";
    if ([model.pay_type isEqualToString:@"2"]) {
        type = @"USDT";
    }else{
        type = @"CNY";
        price = F(@"%f", [model.price floatValue] * [model.usdt_rate floatValue]);
    }
    self.chargeNumberContentLabel.text = F(@"%@ %@", price,type);
    self.chargeTimeContentLabel.text = model.create_time?:@"";
    self.chargeShenheTimeContentLabel.text = model.shenhe_time?:@"";
    
    
  
    if ([model.status isEqualToString:@"0"]) {
        self.chargeStateContentLabel.text = @"待审核";
        self.refusedLabel.hidden = YES;
        self.iconImageView.hidden = YES;
        [self normal];
    }
    if ([model.status isEqualToString:@"1"]) {
        self.chargeStateContentLabel.text = @"已同意";
        self.refusedLabel.hidden = YES;
        self.iconImageView.hidden = YES;
        [self normal];
    }
    if ([model.status isEqualToString:@"2"]) {
        self.chargeStateContentLabel.text = @"已拒绝";
        self.refusedLabel.hidden = NO;
        self.iconImageView.hidden = NO;
        self.refusedLabel.text = model.reason?:@"";
        [self refused];
    }
    

    
    [self layoutIfNeeded];
}

- (void)normal {
    [self.chargeStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeShenheTimeLabel.mas_bottom).offset(ScaleH(12));
        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
    }];
    [self.chargeStateContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeStateLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeStateLabel);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(16));
        make.top.equalTo(self.chargeStateLabel.mas_bottom).offset(ScaleH(15));
        make.width.height.mas_equalTo(0);
    }];
    [self.refusedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(4));
        make.centerY.equalTo(self.iconImageView);
        make.height.mas_equalTo(0);
    }];
}

- (void)refused {
    [self.chargeStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeShenheTimeLabel.mas_bottom).offset(ScaleH(12));
    }];
    [self.chargeStateContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chargeStateLabel.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.chargeStateLabel);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.top.equalTo(self.chargeStateLabel.mas_bottom).offset(ScaleH(15));
        make.width.height.mas_equalTo(16);
    }];
    [self.refusedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(4));
        make.centerY.equalTo(self.iconImageView);
        make.bottom.equalTo(self.bgView).offset(-ScaleH(14));
    }];
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
        _chargeAddressLabel.text = Localized(@"订单号", nil);
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
        _chargeNumberLabel.text = Localized(@"提币数量", nil);
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
        _chargeTimeLabel.text = Localized(@"提币时间", nil);
    }
    return _chargeTimeLabel;
}
- (UILabel *)chargeTimeContentLabel {
    if (!_chargeTimeContentLabel) {
        _chargeTimeContentLabel = [[UILabel alloc]init];
        _chargeTimeContentLabel.textColor = kMainGaryWhiteColor;
        _chargeTimeContentLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
    }
    return _chargeTimeContentLabel;
}

- (UILabel *)chargeShenheTimeLabel {
    if (!_chargeShenheTimeLabel) {
        _chargeShenheTimeLabel = [[UILabel alloc]init];
        _chargeShenheTimeLabel.textColor = kMainGaryWhiteColor;
        _chargeShenheTimeLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _chargeShenheTimeLabel.text = Localized(@"审核时间", nil);
    }
    return _chargeShenheTimeLabel;
}
- (UILabel *)chargeShenheTimeContentLabel {
    if (!_chargeShenheTimeContentLabel) {
        _chargeShenheTimeContentLabel = [[UILabel alloc]init];
        _chargeShenheTimeContentLabel.textColor = kMainGaryWhiteColor;
        _chargeShenheTimeContentLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
    }
    return _chargeShenheTimeContentLabel;
}
- (UILabel *)chargeStateLabel {
    if (!_chargeStateLabel) {
        _chargeStateLabel = [[UILabel alloc]init];
        _chargeStateLabel.textColor = kMainGaryWhiteColor;
        _chargeStateLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _chargeStateLabel.text = Localized(@"提币状态", nil);
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
