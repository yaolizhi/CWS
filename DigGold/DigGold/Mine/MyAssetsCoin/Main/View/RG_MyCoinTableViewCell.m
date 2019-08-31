//
//  RG_MyCoinTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_MyCoinTableViewCell.h"

@interface RG_MyCoinTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *tradeButton;
@property (nonatomic, strong) UIButton *accountButton;
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) UIButton *carryButton;
@property (nonatomic, copy) NSString *recodeCoinS;
@end

@implementation RG_MyCoinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.headerImageView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.priceLabel];
        [self.bgView addSubview:self.tradeButton];
        [self.bgView addSubview:self.accountButton];
        [self.bgView addSubview:self.rechargeButton];
        [self.bgView addSubview:self.carryButton];
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
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView).offset(ScaleW(15));
        make.width.height.mas_equalTo(ScaleW(30));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(ScaleW(12));
        make.centerY.equalTo(self.headerImageView);
        
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.centerY.equalTo(self.headerImageView);
    }];
    [self.tradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.top.equalTo(self.headerImageView.mas_bottom).offset(ScaleH(19));
    }];
    [self.accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tradeButton.mas_right).offset(ScaleW(15));
        make.top.equalTo(self.headerImageView.mas_bottom).offset(ScaleH(19));
    }];
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.carryButton.mas_left).offset(-ScaleW(15));
        make.top.equalTo(self.priceLabel.mas_bottom).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(65));
        make.height.mas_equalTo(ScaleW(35));
    }];
    [self.carryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.priceLabel.mas_bottom).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(65));
        make.height.mas_equalTo(ScaleW(35));
        make.bottom.equalTo(self.bgView).offset(-ScaleH(17));
    }];

}

- (void)configureCellWithTitle:(NSString *)title money:(NSString *)money  {
    self.recodeCoinS = title;
    self.priceLabel.text = money?:@"";
    self.titleLabel.text = title?:@"";
    if ([title isEqualToString:@"JC"]) {
        self.rechargeButton.hidden = YES;
        self.carryButton.hidden = YES;
        self.tradeButton.hidden = YES;
        self.headerImageView.image = [UIImage imageNamed:@"mine_coin"];
        [self.accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(ScaleW(15));
            make.top.equalTo(self.headerImageView.mas_bottom).offset(ScaleH(19));
        }];
    }else{
        self.rechargeButton.hidden = NO;
        self.carryButton.hidden = NO;
        self.tradeButton.hidden = NO;
        self.headerImageView.image = [UIImage imageNamed:@"usdt_icon"];
        [self.accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tradeButton.mas_right).offset(ScaleW(15));
            make.top.equalTo(self.headerImageView.mas_bottom).offset(ScaleH(19));
        }];
    }
    [self layoutIfNeeded];
    
}


#pragma mark -- Public Method
- (void)tradeButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonWithType:isJCCoin:)]) {
        BOOL isJCCoin = [self.recodeCoinS isEqualToString:@"JC"]?YES:NO;
        [self.delegate clickButtonWithType:RGMyCoinCellClickType_Trade isJCCoin:isJCCoin];
    }
}

- (void)accountButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonWithType:isJCCoin:)]) {
        BOOL isJCCoin = [self.recodeCoinS isEqualToString:@"JC"]?YES:NO;
        [self.delegate clickButtonWithType:RGMyCoinCellClickType_Account isJCCoin:isJCCoin];
    }
}
- (void)rechargeButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonWithType:isJCCoin:)]) {
        BOOL isJCCoin = [self.recodeCoinS isEqualToString:@"JC"]?YES:NO;
        [self.delegate clickButtonWithType:RGMyCoinCellClickType_RechargeCoin isJCCoin:isJCCoin];
    }
}

- (void)carryButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonWithType:isJCCoin:)]) {
        BOOL isJCCoin = [self.recodeCoinS isEqualToString:@"JC"]?YES:NO;
        [self.delegate clickButtonWithType:RGMyCoinCellClickType_CrrayCoin isJCCoin:isJCCoin];
    }
}
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
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.layer.cornerRadius = ScaleW(15);
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _titleLabel.textColor = kMainGaryWhiteColor;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(18)];
        _priceLabel.textColor = [UIColor whiteColor];
    }
    return _priceLabel;
}

- (UIButton *)tradeButton {
    if (!_tradeButton) {
        _tradeButton = [[UIButton alloc]init];
        [_tradeButton setTitle:Localized(@"交易记录", nil) forState:UIControlStateNormal];
        [_tradeButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        _tradeButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        [_tradeButton addTarget:self action:@selector(tradeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradeButton;
}

- (UIButton *)accountButton {
    if (!_accountButton) {
        _accountButton = [[UIButton alloc]init];
        [_accountButton setTitle:Localized(@"账户流水", nil) forState:UIControlStateNormal];
        [_accountButton setTitleColor:kMainYellowColor forState:UIControlStateNormal];
        _accountButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        [_accountButton addTarget:self action:@selector(accountButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountButton;
}

- (UIButton *)rechargeButton {
    if (!_rechargeButton) {
        _rechargeButton = [[UIButton alloc]init];
        [_rechargeButton setTitle:Localized(@"充值", nil) forState:UIControlStateNormal];
        [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rechargeButton.layer.cornerRadius = ScaleW(5);
        _rechargeButton.layer.masksToBounds = YES;
        _rechargeButton.backgroundColor = kMainTitleColor;
        _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeButton;
}

- (UIButton *)carryButton {
    if (!_carryButton) {
        _carryButton = [[UIButton alloc]init];
        [_carryButton setTitle:Localized(@"提币", nil) forState:UIControlStateNormal];
        [_carryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _carryButton.layer.cornerRadius = ScaleW(5);
        _carryButton.layer.masksToBounds = YES;
        _carryButton.backgroundColor = kMainTitleColor;
        _carryButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        [_carryButton addTarget:self action:@selector(carryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carryButton;
}
#pragma mark -- Setter Method

@end
