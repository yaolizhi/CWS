//
//  RG_BP_MainView.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_BP_MainView.h"

@interface RG_BP_MainView()
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation RG_BP_MainView

- (instancetype)initWithFrame:(CGRect)frame subTitleStirng:(NSString *)subTitleString
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pointView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        self.subTitleLabel.text = subTitleString?:@"";
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(27));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(ScaleW(8));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(46));
        make.top.equalTo(self);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(46));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(6));
        make.bottom.equalTo(self);
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [[UIView alloc]init];
        _pointView.backgroundColor = kMainTitleColor;
        _pointView.layer.cornerRadius = ScaleW(4);
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = Localized(@"0 USDT", nil);
        _titleLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(10)];
        _titleLabel.textColor = kMainGaryWhiteColor;
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(10)];
        _subTitleLabel.textColor = kMainGaryWhiteColor;
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method

@end
