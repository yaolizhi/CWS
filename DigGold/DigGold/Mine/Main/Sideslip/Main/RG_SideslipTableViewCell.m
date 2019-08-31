//
//  RG_SideslipTableViewCell.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_SideslipTableViewCell.h"

@interface RG_SideslipTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation RG_SideslipTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.bottomLineView];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(ScaleW(35));
        make.width.height.mas_equalTo(ScaleW(19));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(17));
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)configureCellWithIcon:(NSString *)iconString titleString:(NSString *)titleString {
    self.iconImageView.image = [UIImage imageNamed:iconString];
    self.titleLabel.text = titleString?:@"";
    [self layoutIfNeeded];
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
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
    }
    return _titleLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = kMainBackgroundColor;
    }
    return _bottomLineView;
}
#pragma mark -- Setter Method

@end
