//
//  RG_AgencyMiddleItemView.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyMiddleItemView.h"

@interface RG_AgencyMiddleItemView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation RG_AgencyMiddleItemView

- (instancetype)initWithFrame:(CGRect)frame icon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.iconImageView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        
        self.iconImageView.image = [UIImage imageNamed:icon];
        self.titleLabel.text = title?:@"";
        self.subTitleLabel.text = subTitle?:@"";
        
        [UILabel changeLineSpaceForLabel:self.subTitleLabel WithSpace:4];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.width.mas_equalTo(AgencyMiddleItemWidth);
        make.height.mas_equalTo(AgencyMiddleItemHeight);
        make.bottom.equalTo(self);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(ScaleH(37));
        make.width.mas_equalTo(ScaleW(65));
        make.height.mas_equalTo(ScaleH(50));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(ScaleH(24));
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(13));
        make.right.equalTo(self.bgView).offset(-ScaleW(13));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(29));
    }];
}

- (void)configureView {
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainSubBackgroundColor;
    }
    return _bgView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kMainGaryWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = kMainGaryWhiteColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method

@end
