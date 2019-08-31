//
//  RG_AgencyTopTitleView.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyTopTitleView.h"

@interface RG_AgencyTopTitleView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *playTitleLabel;
@property (nonatomic, strong) UILabel *playSubTitleLabel;
@end

@implementation RG_AgencyTopTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        [self.bgView addSubview:self.playTitleLabel];
        [self.bgView addSubview:self.playSubTitleLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(ScaleH(35));
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(16));
    }];
    [self.playTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(ScaleH(50));
    }];
    [self.playSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(31));
        make.right.equalTo(self.bgView).offset(-ScaleW(31));
        make.top.equalTo(self.playTitleLabel.mas_bottom).offset(ScaleH(16));
        make.bottom.equalTo(self.bgView);
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kMainGaryWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(21)];
        _titleLabel.text = @"全民代理千万计划";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = kMainGaryWhiteColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _subTitleLabel.text = @"申请成为平台代理，推广其他玩家来玩游戏";
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UILabel *)playTitleLabel {
    if (!_playTitleLabel) {
        _playTitleLabel = [[UILabel alloc]init];
        _playTitleLabel.textColor = kMainGaryWhiteColor;
        _playTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(21)];
        _playTitleLabel.text = @"无论玩家输赢，均可获得高额佣金";
        _playTitleLabel.numberOfLines = 0;
    }
    return _playTitleLabel;
}

- (UILabel *)playSubTitleLabel {
    if (!_playSubTitleLabel) {
        _playSubTitleLabel = [[UILabel alloc]init];
        _playSubTitleLabel.textColor = kMainGaryWhiteColor;
        _playSubTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _playSubTitleLabel.text = @"基于区块链的竞猜游戏，希望与值得信赖的伙伴开展合作，凭借高达40%左右的收益分成，这将是您获得稳定流量收益的最佳工具";
        [UILabel changeLineSpaceForLabel:_playSubTitleLabel WithSpace:4];
        _playSubTitleLabel.numberOfLines = 0;
    }
    return _playSubTitleLabel;
}
#pragma mark -- Setter Method

@end
