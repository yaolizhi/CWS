//
//  RG_AgencyBottomView.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyBottomView.h"
#import "RG_AgencyBottomTitleView.h"
#import "RG_AgencyBottomNumberView.h"
@interface RG_AgencyBottomView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) RG_AgencyBottomTitleView *ATitleView;
@property (nonatomic, strong) RG_AgencyBottomTitleView *BTitleView;
@property (nonatomic, strong) RG_AgencyBottomTitleView *CTitleView;
@property (nonatomic, strong) UILabel *exampleLabel;
@property (nonatomic, strong) RG_AgencyBottomNumberView *ANumberView;
@property (nonatomic, strong) RG_AgencyBottomNumberView *BNumberView;
@property (nonatomic, strong) RG_AgencyBottomNumberView *CNumberView;

@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation RG_AgencyBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.iconImageView];
        [self.bgView addSubview:self.ATitleView];
        [self.bgView addSubview:self.BTitleView];
        [self.bgView addSubview:self.CTitleView];
        [self.bgView addSubview:self.exampleLabel];
        [self.bgView addSubview:self.ANumberView];
        [self.bgView addSubview:self.BNumberView];
        [self.bgView addSubview:self.CNumberView];
        
        [self.bgView addSubview:self.amountLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(31));
        make.width.mas_equalTo(ScaleW(180));
        make.height.mas_equalTo(ScaleH(151));
    }];
    [self.ATitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(30));
        make.top.equalTo(self.bgView).offset(ScaleH(71));
        make.width.mas_equalTo(ScaleW(96));
    }];
    [self.BTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-ScaleW(30));
        make.top.equalTo(self.bgView).offset(ScaleH(71));
        make.width.mas_equalTo(ScaleW(96));
    }];
    [self.CTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(170));
        
    }];
    [self.exampleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(ScaleW(38));
        make.top.equalTo(self.CTitleView.mas_bottom).offset(ScaleH(34));
        
    }];
    [self.ANumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.exampleLabel.mas_bottom).offset(ScaleH(20));
    }];
    [self.BNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.ANumberView.mas_bottom).offset(ScaleH(5));
    }];
    [self.CNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.BNumberView.mas_bottom).offset(ScaleH(5));
        
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.CNumberView.mas_bottom).offset(ScaleH(19));
        make.bottom.equalTo(self.bgView);
    }];

}

- (void)configureView {
    
}

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
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"icon_sanjiao"];
    }
    return _iconImageView;
}

- (RG_AgencyBottomTitleView *)ATitleView {
    if (!_ATitleView) {
        _ATitleView = [[RG_AgencyBottomTitleView alloc]initWithFrame:CGRectZero title:@"一级 A" subTitle:@"一级指您自己推荐的玩家"];
    }
    return _ATitleView;
}
- (RG_AgencyBottomTitleView *)BTitleView {
    if (!_BTitleView) {
        _BTitleView = [[RG_AgencyBottomTitleView alloc]initWithFrame:CGRectZero title:@"二级 B" subTitle:@"二级指一级玩家推荐的玩家"];
    }
    return _BTitleView;
}
- (RG_AgencyBottomTitleView *)CTitleView {
    if (!_CTitleView) {
        _CTitleView = [[RG_AgencyBottomTitleView alloc]initWithFrame:CGRectZero title:@"三级 C" subTitle:@"三级指二级玩家推荐的玩家"];
    }
    return _CTitleView;
}

- (RG_AgencyBottomNumberView *)ANumberView {
    if (!_ANumberView) {
        _ANumberView = [[RG_AgencyBottomNumberView alloc]initWithFrame:CGRectZero title:@"一级A：用户数量=100" subTitle:@"收益=100*1%*25%*25%=0.0625 USDT"];
    }
    return _ANumberView;
}
- (RG_AgencyBottomNumberView *)BNumberView {
    if (!_BNumberView) {
        _BNumberView = [[RG_AgencyBottomNumberView alloc]initWithFrame:CGRectZero title:@"二级B：用户数量=10000" subTitle:@"收益=10000*1%*25%*10%=2.5 USDT"];
    }
    return _BNumberView;
}
- (RG_AgencyBottomNumberView *)CNumberView {
    if (!_CNumberView) {
        _CNumberView = [[RG_AgencyBottomNumberView alloc]initWithFrame:CGRectZero title:@"三级C：用户数量=1000000" subTitle:@"收益=1000000*1%*25%*5%=125 USDT"];
    }
    return _CNumberView;
}

- (UILabel *)exampleLabel {
    if (!_exampleLabel) {
        _exampleLabel = [[UILabel alloc]init];
        _exampleLabel.textColor = kMainGaryWhiteColor;
        _exampleLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _exampleLabel.text = @"举例：每级每人邀请100个用户，每个用户每天投注流水1USDT，您的用户和收益如下：";
        _exampleLabel.numberOfLines = 0;
    }
    return _exampleLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.textColor = kMainGaryWhiteColor;
        _amountLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _amountLabel.text = @"您的总收益=0.0625+2.5+125=127.5625 USDT\n\n如果每人投注流水是5USDT、10USDT，在算算？而且这种收益零风险，非常稳定";
        _amountLabel.numberOfLines = 0;
    }
    return _amountLabel;
}
#pragma mark -- Setter Method

@end
