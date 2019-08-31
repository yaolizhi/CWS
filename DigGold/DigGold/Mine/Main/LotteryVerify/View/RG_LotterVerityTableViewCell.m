//
//  RG_LotterVerityTableViewCell.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_LotterVerityTableViewCell.h"

@interface RG_LotterVerityTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation RG_LotterVerityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(ScaleW(10));
        make.right.equalTo(self).offset(-ScaleW(10));
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(232));
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-ScaleW(10));
        make.centerY.equalTo(self.bgView);
    }];
}

- (void)configureCellModel:(RG_VerityModel *)model {
    self.titleLabel.text = model.boomHash?:@"";
    self.subTitleLabel.text = model.boomValue?:@"";
    [self layoutIfNeeded];
}

#pragma mark -- Public Method
- (void)initWithIndexPath:(NSIndexPath *)indexpath
{
    if (indexpath.row % 2 == 1)
    {
        self.bgView.backgroundColor = kMainBackgroundColor;
    }
    else
    {
        self.bgView.backgroundColor = kMainSubBackgroundColor;
    }
}
#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = ScaleW(3);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kMainGaryWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
//        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = kMainGaryWhiteColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        _subTitleLabel.adjustsFontSizeToFitWidth = YES;
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method

@end
