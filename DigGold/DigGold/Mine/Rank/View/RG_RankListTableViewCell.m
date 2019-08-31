//
//  RG_RankListTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_RankListTableViewCell.h"

@interface RG_RankListTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@end

@implementation RG_RankListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.rankButton];
        [self.bgView addSubview:self.userImageView];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.amountLabel];
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
        make.height.mas_equalTo(ScaleW(50));
        make.bottom.equalTo(self);
    }];
    [self.rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(ScaleW(11));
        make.width.height.mas_equalTo(ScaleW(20));
    }];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.rankButton.mas_right).offset(ScaleW(20));
        make.width.height.mas_equalTo(ScaleW(30));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.userImageView.mas_right).offset(ScaleW(17));
        make.width.mas_equalTo(ScaleW(200));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).offset(-ScaleW(12));
    }];
}

- (void)configureCellWithIndex:(NSInteger)index model:(RG_RankListModel *)model type:(NSString *)type {
    if (index == 0) {
        [self.rankButton setBackgroundImage:[UIImage imageNamed:@"rank_1"] forState:UIControlStateNormal];
    }else
    if (index == 1) {
        [self.rankButton setBackgroundImage:[UIImage imageNamed:@"rank_2"] forState:UIControlStateNormal];
    }else
    if (index == 2) {
        [self.rankButton setBackgroundImage:[UIImage imageNamed:@"rank_3"] forState:UIControlStateNormal];
    }else {
        [self.rankButton setTitle:F(@"%ld", index+1) forState:UIControlStateNormal];
    }
    
    NSString *realName = model.realname?:@"";
    if ([RegularExpression validateMobile:realName]) {
        realName = [realName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    self.nameLabel.text = realName;
    self.amountLabel.text = [type isEqualToString:@"zuigao"]?model.zuigao:model.leiji;
    
    
    NSString *url = model.upic.length>0?F(@"%@%@",ProductBaseServer, model.upic):@"headerProfile";
    if ([url containsString:@"http"]) {
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }else{
        self.userImageView.image = [UIImage imageNamed:url];
    }
    [self layoutIfNeeded];
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainSubBackgroundColor;
        _bgView.layer.cornerRadius = ScaleW(3);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)rankButton {
    if (!_rankButton) {
        _rankButton = [[UIButton alloc]init];
        [_rankButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _rankButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
    }
    return _rankButton;
}
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.backgroundColor = [UIColor lightGrayColor];
        _userImageView.layer.cornerRadius = ScaleW(15);
        _userImageView.layer.masksToBounds = YES;
    }
    return _userImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _nameLabel.textColor = kMainGaryWhiteColor;
    }
    return _nameLabel;
}
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _amountLabel.textColor = kMainTitleColor;
    }
    return _amountLabel;
}

#pragma mark -- Setter Method

@end
