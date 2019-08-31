//
//  RG_AgencyBottomTitleView.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyBottomTitleView.h"

@interface RG_AgencyBottomTitleView() 
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation RG_AgencyBottomTitleView

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
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(ScaleH(35));
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(10));
        make.bottom.equalTo(self.bgView);
    }];
}

- (void)configureView {
    
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kMainTitleColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(16)];
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
