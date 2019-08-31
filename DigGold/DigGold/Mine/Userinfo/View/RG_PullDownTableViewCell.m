//
//  RG_PullDownTableViewCell.m
//  DigGold
//
//  Created by James on 2019/1/12.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_PullDownTableViewCell.h"

@interface RG_PullDownTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation RG_PullDownTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    
}

- (void)configureCellWithIcon:(NSString *)icon title:(NSString *)title {
    self.titleLabel.text = title?:@"";
    self.iconImageView.image = [UIImage imageNamed:icon];
    if (icon.length > 0) {
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScaleW(10));
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(ScaleW(14));
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(7));
            make.right.equalTo(self).offset(-ScaleW(10));
            make.centerY.equalTo(self);
        }];
        self.iconImageView.hidden = NO;
        self.titleLabel.hidden = NO;
    }else{
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScaleW(10));
            make.right.equalTo(self).offset(-ScaleW(10));
            make.centerY.equalTo(self);
        }];
        self.iconImageView.hidden = YES;
        self.titleLabel.hidden = NO;
    }
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
        _titleLabel.textColor = kMainGaryWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

#pragma mark -- Setter Method

@end
