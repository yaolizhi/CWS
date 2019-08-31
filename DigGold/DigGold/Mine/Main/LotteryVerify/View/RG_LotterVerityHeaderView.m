//
//  RG_LotterVerityHeaderView.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_LotterVerityHeaderView.h"

@interface RG_LotterVerityHeaderView()
@property (nonatomic, strong) UILabel *gameLabel;
@property (nonatomic, strong) UILabel *gameSubLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *accountView;
@property (nonatomic, strong) UIImageView *accountIcon;


@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIImageView *codeIcon;




@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation RG_LotterVerityHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.gameLabel];
        [self addSubview:self.gameSubLabel];
        
        [self addSubview:self.lineView];
        [self addSubview:self.accountView];
        [self.accountView addSubview:self.accountIcon];
        [self.accountView addSubview:self.accountTF];
        
        [self addSubview:self.codeView];
        [self.codeView addSubview:self.codeIcon];
        [self.codeView addSubview:self.codeTF];
        
        [self addSubview:self.veritybutton];
        [self addSubview:self.bottomLineView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(26));
        make.right.equalTo(self).offset(-ScaleW(26));
        make.top.equalTo(self).offset(ScaleW(41));
    }];
    [self.gameSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(26));
        make.right.equalTo(self).offset(-ScaleW(26));
        make.top.equalTo(self.gameLabel.mas_bottom).offset(ScaleW(7));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(15));
        make.right.equalTo(self).offset(-ScaleW(15));
        make.top.equalTo(self.gameSubLabel.mas_bottom).offset(ScaleW(25));
        make.height.mas_equalTo(1);
    }];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(15));
        make.right.equalTo(self).offset(-ScaleW(15));
        make.top.equalTo(self.lineView.mas_bottom).offset(ScaleW(25));
        make.height.mas_equalTo(ScaleH(51));
    }];
    
    [self.accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountView).offset(ScaleW(10));
        make.centerY.equalTo(self.accountView);
        make.width.height.mas_equalTo(ScaleH(17));
    }];
    
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountIcon.mas_right).offset(ScaleW(10));
        make.right.equalTo(self.accountView.mas_right).offset(-ScaleW(10));
        make.top.equalTo(self.accountView);
        make.height.mas_equalTo(ScaleH(51));
    }];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(15));
        make.right.equalTo(self).offset(-ScaleW(15));
        make.top.equalTo(self.accountView.mas_bottom).offset(ScaleW(10));
        make.height.mas_equalTo(ScaleH(51));
    }];
    
    [self.codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeView).offset(ScaleW(10));
        make.centerY.equalTo(self.codeView);
        make.width.height.mas_equalTo(ScaleH(17));
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeIcon.mas_right).offset(ScaleW(10));
        make.right.equalTo(self.codeView.mas_right).offset(-ScaleW(10));
        make.top.equalTo(self.codeView);
        make.height.mas_equalTo(ScaleH(51));
    }];
    
    [self.veritybutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(15));
        make.top.equalTo(self.codeView.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
        make.width.mas_equalTo(ScaleH(90));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(15));
        make.right.equalTo(self).offset(-ScaleW(15));
        make.top.equalTo(self.veritybutton.mas_bottom).offset(ScaleW(30));
        make.height.mas_equalTo(1);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(15));
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(ScaleW(31));
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-ScaleW(15));
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(ScaleW(31));
        make.bottom.equalTo(self).offset(-ScaleH(12));
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method
- (void)verityButtonClick {
    
}
#pragma mark -- Getter Method
- (UILabel *)gameLabel {
    if (!_gameLabel) {
        _gameLabel = [[UILabel alloc]init];
        _gameLabel.textColor = kMainTitleColor;
        _gameLabel.font = [UIFont systemFontOfSize:ScaleFont(29)];
//        _gameLabel.adjustsFontSizeToFitWidth = YES;
        _gameLabel.numberOfLines = 0;
        _gameLabel.text = @"BSG.game Crash-Game Verification Script";
    }
    return _gameLabel;
}

- (UILabel *)gameSubLabel {
    if (!_gameSubLabel) {
        _gameSubLabel = [[UILabel alloc]init];
        _gameSubLabel.textColor = kMainGaryWhiteColor;
        _gameSubLabel.font = [UIFont systemFontOfSize:ScaleFont(18)];
        //        _gameLabel.adjustsFontSizeToFitWidth = YES;
        _gameSubLabel.numberOfLines = 0;
        _gameSubLabel.text = @"Third party script used to cerify games on crash game.";
    }
    return _gameSubLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = kLineColor;
        _lineView.alpha = 0.4;
    }
    return _lineView;
}

- (UIView *)accountView {
    if (!_accountView) {
        _accountView = [[UIView alloc]init];
        _accountView.backgroundColor = kMainSubBackgroundColor;
        _accountView.layer.masksToBounds = YES;
        _accountView.layer.cornerRadius = ScaleW(3);
        _accountView.layer.borderWidth = 1;
        _accountView.layer.borderColor = kLightLineColor.CGColor;
        
    }
    return _accountView;
}

- (UIImageView *)accountIcon {
    if (!_accountIcon) {
        _accountIcon = [[UIImageView alloc]init];
        _accountIcon.image = [UIImage imageNamed:@"mine_yaochi"];
    }
    return _accountIcon;
}

- (UITextField *)accountTF {
    if (!_accountTF) {
        _accountTF = [[UITextField alloc]init];
        _accountTF.backgroundColor = kMainSubBackgroundColor;
        _accountTF.layer.cornerRadius = ScaleW(5);
        _accountTF.layer.masksToBounds = YES;

        _accountTF.keyboardType = UIKeyboardTypeEmailAddress;
        _accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _accountTF.placeholder = Localized(@"请输入手机号", nil);
        _accountTF.textColor = kMainGaryWhiteColor;
//        _accountTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
//        _accountTF.leftViewMode = UITextFieldViewModeAlways;
//        _accountTF.text = @"67c45a789acda69e89fg0114c5478";
        _accountTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_accountTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _accountTF;
}


- (UIView *)codeView {
    if (!_codeView) {
        _codeView = [[UIView alloc]init];
        _codeView.backgroundColor = kMainSubBackgroundColor;
        _codeView.layer.masksToBounds = YES;
        _codeView.layer.cornerRadius = ScaleW(3);
        _codeView.layer.borderWidth = 1;
        _codeView.layer.borderColor = kLightLineColor.CGColor;
    }
    return _codeView;
}

- (UIImageView *)codeIcon {
    if (!_codeIcon) {
        _codeIcon = [[UIImageView alloc]init];
        _codeIcon.image = [UIImage imageNamed:@"mine_###"];
    }
    return _codeIcon;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [[UITextField alloc]init];
        _codeTF.backgroundColor = kMainSubBackgroundColor;
        _codeTF.layer.cornerRadius = ScaleW(5);
        _codeTF.layer.masksToBounds = YES;

        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        _accountTF.placeholder = Localized(@"请输入手机号", nil);
        _codeTF.textColor = kMainGaryWhiteColor;
        //        _accountTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        //        _accountTF.leftViewMode = UITextFieldViewModeAlways;
        _codeTF.text = @"";
        _codeTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_codeTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _codeTF;
}



- (UIButton *)veritybutton {
    if (!_veritybutton) {
        _veritybutton = [[UIButton alloc]init];
        [_veritybutton setTitle:Localized(@"Verify", nil) forState:UIControlStateNormal];
        [_veritybutton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _veritybutton.layer.cornerRadius = ScaleW(5);
        _veritybutton.layer.masksToBounds = YES;
        _veritybutton.backgroundColor = kMainTitleColor;
        _veritybutton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        [_veritybutton addTarget:self action:@selector(verityButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _veritybutton;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = kLineColor;
        _bottomLineView.alpha = 0.4;
    }
    return _bottomLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kMainTitleColor;
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(18)];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.text = @"Game‘s hash";
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = kMainTitleColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(18)];
        _subTitleLabel.adjustsFontSizeToFitWidth = YES;
        _subTitleLabel.text = @"Bust";
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method

@end
