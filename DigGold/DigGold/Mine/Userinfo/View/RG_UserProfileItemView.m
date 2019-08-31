//
//  RG_UserProfileItemView.m
//  DigGold
//
//  Created by James on 2018/12/31.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_UserProfileItemView.h"

@interface RG_UserProfileItemView()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation RG_UserProfileItemView

- (instancetype)initWithFrame:(CGRect)frame iconImageS:(NSString *)iconImageS titleS:(NSString *)titleS subTitleS:(NSString *)subTitleS
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        self.iconImageView.image = [UIImage imageNamed:iconImageS];
        self.titleLabel.text = titleS?:@"";
        self.subTitleLabel.text = subTitleS?:@"";
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(12));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(ScaleW(24));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScaleW(11));
        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(11));
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleW(8));
        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(11));
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _subTitleLabel.textColor = [UIColor whiteColor];
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method

@end
