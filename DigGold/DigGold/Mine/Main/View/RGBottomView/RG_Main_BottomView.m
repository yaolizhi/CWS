//
//  RG_Main_BottomView.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Main_BottomView.h"

@interface RG_Main_BottomView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *userProtocolButton;
@property (nonatomic, strong) UIButton *privacyProtocolButton;
@property (nonatomic, strong) UIButton *helpCenterButton;
@property (nonatomic, strong) UIButton *appDownButton;
@property (nonatomic, strong) UILabel *warmLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation RG_Main_BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.userProtocolButton];
        [self.bgView addSubview:self.privacyProtocolButton];
        [self.bgView addSubview:self.helpCenterButton];
        [self.bgView addSubview:self.appDownButton];
//        [self.bgView addSubview:self.warmLabel];
        [self addSubview:self.bottomLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    CGFloat padding = (ScreenWidth-ScaleW(60)*4)/5;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
//        make.height.mas_equalTo(ScaleH(90));
        
    }];
    [self.userProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(ScaleH(16));
        make.left.equalTo(self.bgView).offset(padding);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.privacyProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(ScaleH(16));
        make.left.equalTo(self.userProtocolButton.mas_right).offset(padding);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.helpCenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(ScaleH(16));
        make.left.equalTo(self.privacyProtocolButton.mas_right).offset(padding);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.appDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(ScaleH(16));
        make.left.equalTo(self.helpCenterButton.mas_right).offset(padding);
        make.width.mas_equalTo(ScaleW(60));
        make.bottom.equalTo(self.bgView).offset(-ScaleH(12));
    }];
//    [self.warmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(ScaleW(19));
//        make.right.equalTo(self.bgView).offset(ScaleW(-19));
//        make.top.equalTo(self.appDownButton.mas_bottom).offset(ScaleH(12));
//        make.bottom.equalTo(self.bgView).offset(-ScaleH(12));
//    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bgView.mas_bottom).offset(ScaleH(11));
        make.bottom.equalTo(self).offset(-ScaleH(12));
    }];
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.height = height;
}

- (void)configureView {
    
}

#pragma mark -- Public Method
- (void)buttonClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedBottomViewWithTitle:)]) {
        [self.delegate didSelectedBottomViewWithTitle:sender.titleLabel.text?:@""];
    }
}
#pragma mark -- Getter Method

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainSubBackgroundColor;
    }
    return _bgView;
}

- (UIButton *)userProtocolButton {
    if (!_userProtocolButton) {
        _userProtocolButton = [[UIButton alloc]init];
        [_userProtocolButton setTitle:Localized(@"用户协议", nil) forState:UIControlStateNormal];
        [_userProtocolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _userProtocolButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _userProtocolButton.tag = 100;
        [_userProtocolButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userProtocolButton;
}

- (UIButton *)privacyProtocolButton {
    if (!_privacyProtocolButton) {
        _privacyProtocolButton = [[UIButton alloc]init];
        [_privacyProtocolButton setTitle:Localized(@"隐私协议", nil) forState:UIControlStateNormal];
        [_privacyProtocolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _privacyProtocolButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _privacyProtocolButton.tag = 101;
        [_privacyProtocolButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacyProtocolButton;
}

- (UIButton *)helpCenterButton {
    if (!_helpCenterButton) {
        _helpCenterButton = [[UIButton alloc]init];
        [_helpCenterButton setTitle:Localized(@"帮助中心", nil) forState:UIControlStateNormal];
        [_helpCenterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _helpCenterButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _helpCenterButton.tag = 102;
        [_helpCenterButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpCenterButton;
}

- (UIButton *)appDownButton {
    if (!_appDownButton) {
        _appDownButton = [[UIButton alloc]init];
        [_appDownButton setTitle:Localized(@"APP下载", nil) forState:UIControlStateNormal];
        [_appDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _appDownButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _appDownButton.tag = 103;
        [_appDownButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appDownButton;
}
- (UILabel *)warmLabel {
    if (!_warmLabel) {
        _warmLabel = [[UILabel alloc]init];
        _warmLabel.text = Localized(@"该网站由BSG竞猜平台提供技术支持，并允许玩家使用USDT进行游戏", nil);
        _warmLabel.numberOfLines = 0;
        _warmLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _warmLabel.textColor = kMainGaryWhiteColor;
        [UILabel changeLineSpaceForLabel:_warmLabel WithSpace:3];
    }
    return _warmLabel;
}
- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.text = Localized(@"Copyright©2019 BSG ALL Rights Reserved.", nil);
        _bottomLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _bottomLabel.textColor = kMainGaryWhiteColor;
    }
    return _bottomLabel;
}
#pragma mark -- Setter Method

@end
