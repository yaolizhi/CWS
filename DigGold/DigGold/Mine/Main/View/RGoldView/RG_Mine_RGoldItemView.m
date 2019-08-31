//
//  RG_Mine_RGoldItemView.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mine_RGoldItemView.h"

@interface RG_Mine_RGoldItemView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation RG_Mine_RGoldItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.rightLineView];
        
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(10));
        make.top.equalTo(self).offset(ScaleW(10));
        make.width.height.mas_equalTo(ScaleW(12));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(6));
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self.rightLineView.mas_left);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(6));
        make.right.equalTo(self.rightLineView.mas_left);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(ScaleH(8));
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(30));
        make.bottom.equalTo(self);
    }];
}

- (void)configureViewTitleString:(NSString *)titleString subTitleString:(NSString *)subTitleString subTitleColor:(UIColor *)subTitleColor {
    self.titleLabel.text = titleString?:@"";
    self.subTitleLabel.text = subTitleString?:@"";
    self.subTitleLabel.textColor = subTitleColor;
    [self layoutIfNeeded];
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"white_yinghua"];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = kMainTitleColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _subTitleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _subTitleLabel;
}
- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc]init];
        _rightLineView.backgroundColor = kLineColor;
    }
    return _rightLineView;
}
#pragma mark -- Setter Method

@end
