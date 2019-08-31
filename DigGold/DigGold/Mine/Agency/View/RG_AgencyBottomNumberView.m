//
//  RG_AgencyBottomNumberView.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyBottomNumberView.h"

@interface RG_AgencyBottomNumberView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation RG_AgencyBottomNumberView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        
        self.titleLabel.text = title?:@"";
        self.subTitleLabel  .text = subTitle?:@"";
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method


- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.top.equalTo(self.bgView);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(45));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(5));
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(12)];
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
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method

@end
