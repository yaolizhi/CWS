//
//  RG_AM_WCView.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_AM_WCView.h"
#import "RG_PullDownView.h"
@interface RG_AM_WCView()<RG_PullDownViewDelegate>
@property (nonatomic, strong) UILabel *usableLabel;
@property (nonatomic, strong) UIView *numberFunView;
@property (nonatomic, strong) UIView *numberLineView;
@property (nonatomic, strong) UILabel *numberRightLabel;
@property (nonatomic, strong) UILabel *payPwdLabel;
@property (nonatomic, strong) UILabel *verityLabel;
@property (nonatomic, strong) UIView *moreFunView;
@property (nonatomic, strong) UIView *moreLineView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) RG_PullDownView *pullDownView;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *carryCoinWayLabel;
@property (nonatomic, strong) UIImageView *carryCoinWayImageView;
@property (nonatomic, strong) RG_PullDownView *carryPullDownView;


@end

@implementation RG_AM_WCView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.usableLabel];
        [self addSubview:self.usableTF];
        
        [self addSubview:self.carryCoinWayLabel];
        [self addSubview:self.carryCoinWayButton];
        [self addSubview:self.carryCoinWayImageView];
        
        [self addSubview:self.typeLabel];
        [self addSubview:self.typeButton];
        [self.typeButton addSubview:self.typeImageView];
        
        
        [self addSubview:self.numberLabel];
        [self addSubview:self.numberFunView];
        
        [self.numberFunView addSubview:self.numberTF];
        [self.numberFunView addSubview:self.numberLineView];
        [self.numberFunView addSubview:self.numberButton];
        [self.numberFunView addSubview:self.numberRightLabel];
        [self addSubview:self.numberWCLabel];
        
        [self addSubview:self.addressLabel];
        [self addSubview:self.addressTF];
        
        [self addSubview:self.payPwdLabel];
        [self addSubview:self.payPwdTF];
        
        [self addSubview:self.verityLabel];
        [self addSubview:self.moreFunView];
        [self.moreFunView addSubview:self.verifyCodeTF];
        [self.moreFunView addSubview:self.moreLineView];
        [self.moreFunView addSubview:self.verifyCodeButton];
        [self addSubview:self.pullDownView];
        [self addSubview:self.carryPullDownView];
        
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.usableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self).offset(ScaleH(10));
    }];
    
    [self.usableTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.usableLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
    }];
    
    //提币方式
    [self.carryCoinWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.usableTF.mas_bottom).offset(ScaleH(30));
    }];
    [self.carryCoinWayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.carryCoinWayLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
    }];
    [self.carryCoinWayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.carryCoinWayButton);
        make.right.equalTo(self.carryCoinWayButton.mas_right).offset(-ScaleW(10));
        make.width.mas_equalTo(ScaleW(11));
        make.height.mas_equalTo(ScaleH(6));
    }];
    
    [self.carryPullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carryCoinWayButton.mas_bottom).offset(1);
        make.left.equalTo(self.carryCoinWayButton);
        make.right.equalTo(self.carryCoinWayButton);
        make.width.equalTo(self.carryCoinWayButton);
        make.height.mas_equalTo(0);
    }];
    
    //提币类型
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.carryCoinWayButton.mas_bottom).offset(ScaleH(30));
    }];
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.typeLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
    }];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeButton);
        make.right.equalTo(self.typeButton.mas_right).offset(-ScaleW(10));
        make.width.mas_equalTo(ScaleW(11));
        make.height.mas_equalTo(ScaleH(6));
    }];
    
    [self.pullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeButton.mas_bottom).offset(1);
        make.left.equalTo(self.typeButton);
        make.right.equalTo(self.typeButton);
        make.width.equalTo(self.typeButton);
        make.height.mas_equalTo(0);
    }];
    
    
    //提币数量
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.typeButton.mas_bottom).offset(ScaleH(30));
    }];
    [self.numberFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.numberLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
    }];
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberFunView.mas_right);
        make.centerY.equalTo(self.numberFunView);
        make.height.mas_equalTo(ScaleH(50));
        make.width.mas_equalTo(ScaleW(48));
    }];
    [self.numberLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numberFunView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(25));
        make.right.equalTo(self.numberButton.mas_left);
    }];
    [self.numberRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numberFunView);
        make.width.mas_equalTo(40);
        make.right.equalTo(self.numberLineView.mas_left).offset(ScaleW(-5));
    }];
    
    [self.numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberFunView);
        make.right.equalTo(self.numberRightLabel.mas_left).offset(-ScaleW(5));
        make.top.equalTo(self.numberFunView);
        make.height.mas_equalTo(ScaleH(50));
    }];
    
    [self.numberWCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.numberTF.mas_bottom).offset(ScaleH(10));
        make.right.equalTo(self).offset(-ScaleW(14));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.numberWCLabel.mas_bottom).offset(ScaleH(30));
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.addressLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(51));
    }];
    
    //支付密码
    [self.payPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.numberWCLabel.mas_bottom).offset(ScaleH(30));
    }];
    
    [self.payPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.payPwdLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(51));
    }];
    
    //验证码
    [self.verityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.payPwdTF.mas_bottom).offset(ScaleH(31));
    }];
    
    [self.moreFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.verityLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(51));
        make.bottom.equalTo(self);
    }];
    [self.verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreFunView.mas_right).offset(-ScaleW(12));
        make.centerY.equalTo(self.moreFunView);
        make.height.mas_equalTo(ScaleH(51));
        make.width.mas_equalTo(ScaleW(86));
    }];
    [self.moreLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moreFunView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(25));
        make.right.equalTo(self.verifyCodeButton.mas_left).offset(-ScaleW(12));
    }];
    
    [self.verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreFunView);
        make.right.equalTo(self.moreLineView.mas_left).offset(-ScaleW(5));
        make.top.equalTo(self.moreFunView);
        make.height.mas_equalTo(ScaleH(51));
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method

- (void)typeButtonClick {
    if (self.typeButton.selected) {
        [self dismissSideslipView];
    }else{
        [self showSideslipView];
    }
    self.typeButton.selected = !self.typeButton.selected;
    [self dismissCarryCoinSideslipView];
//    self.carryCoinWayButton.selected = !self.carryCoinWayButton.selected;
}

- (void)carryCoinWayButtonClick {
    if (self.carryCoinWayButton.selected) {
        [self dismissCarryCoinSideslipView];
    }else{
        [self showCarryCoinSideslipView];
    }
    self.carryCoinWayButton.selected = !self.carryCoinWayButton.selected;
    [self dismissSideslipView];
//    self.typeButton.selected = !self.typeButton.selected;
}

- (void)didSelectedPullDownTitle:(NSString *)title {
    
    if ([title isEqualToString:@"USDT"] || [title isEqualToString:@"CNY"]) {
        [self dismissSideslipView];
        [self.typeButton setTitle:title forState:UIControlStateNormal];
        self.typeButton.selected = !self.typeButton.selected;
        if ([title isEqualToString:@"USDT"]) {
            [self updateUSDT];
        }else{
            [self updateCNY];
        }
//        [self updateCNY];
    }
    if ([title isEqualToString:@"提币通道一"] || [title isEqualToString:@"提币通道二"]) {
        [self dismissCarryCoinSideslipView];
        [self.carryCoinWayButton setTitle:title forState:UIControlStateNormal];
        self.carryCoinWayButton.selected = !self.carryCoinWayButton.selected;
//        if ([title isEqualToString:@"提币通道二"]) {
//            [self.typeButton setTitle:@"USDT" forState:UIControlStateNormal];
//            [self updateTDEUSDT];
////            self.typeButton.enabled = NO;
////            self.typeImageView.hidden = YES;
//        }else{
////            self.typeButton.enabled = YES;
////            self.typeImageView.hidden = NO;
//        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTypeTitle:)]) {
        if ([title isEqualToString:@"提币通道二"]) {
            self.typeButton.enabled = NO;
            self.typeImageView.hidden = YES;
        }else{
            self.typeButton.enabled = YES;
            self.typeImageView.hidden = NO;

        }
        [self.delegate didSelectedTypeTitle:title?:@""];
    }
}

- (void)updateUSDT {
    self.addressTF.hidden = NO;
    self.addressLabel.hidden = NO;
    self.numberFunView.hidden = NO;
    self.numberLabel.hidden = NO;
    self.numberWCLabel.hidden = NO;
    [self.payPwdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.addressTF.mas_bottom).offset(ScaleH(30));
    }];
    [self layoutIfNeeded];
}

- (void)updateTDEUSDT {
    self.addressTF.hidden = YES;
    self.addressLabel.hidden = YES;
    self.numberFunView.hidden = YES;
    self.numberLabel.hidden = YES;
    self.numberWCLabel.hidden = YES;
    [self.payPwdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.typeButton.mas_bottom).offset(ScaleH(30));
    }];
    [self layoutIfNeeded];
}

- (void)updateCNY {
    self.addressTF.hidden = YES;
    self.addressLabel.hidden = YES;
    self.numberFunView.hidden = NO;
    self.numberLabel.hidden = NO;
    self.numberWCLabel.hidden = NO;
    [self.payPwdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self.numberWCLabel.mas_bottom).offset(ScaleH(30));
    }];
    [self layoutIfNeeded];
}

- (void)showSideslipView {
    self.pullDownView.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PullDownViewCellHeight*2);
        }];
        [self.pullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissSideslipView {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.pullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showCarryCoinSideslipView {
    self.carryPullDownView.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.carryPullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PullDownViewCellHeight*2);
        }];
        [self.carryPullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissCarryCoinSideslipView {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.carryPullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.carryPullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -- Getter Method
- (UILabel *)usableLabel {
    if (!_usableLabel) {
        _usableLabel = [[UILabel alloc]init];
        _usableLabel.text = Localized(@"可用", nil);
        _usableLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _usableLabel.textColor = kMainGaryWhiteColor;
    }
    return _usableLabel;
}

- (UITextField *)usableTF {
    if (!_usableTF) {
        _usableTF = [[UITextField alloc]init];
        _usableTF.backgroundColor = kMainSubBackgroundColor;
        _usableTF.layer.cornerRadius = ScaleW(5);
        _usableTF.layer.masksToBounds = YES;
        _usableTF.layer.borderColor = kLightLineColor.CGColor;
        _usableTF.layer.borderWidth = 1;
        _usableTF.textColor = kMainGaryWhiteColor;
        _usableTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _usableTF.leftViewMode = UITextFieldViewModeAlways;
        _usableTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _usableTF.enabled = NO;
        _usableTF.text = @"0.0000000 USDT";
        [_usableTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _usableTF;
}


- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.text = Localized(@"提币数量", nil);
        _numberLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _numberLabel.textColor = kMainGaryWhiteColor;
    }
    return _numberLabel;
}
- (UILabel *)numberRightLabel {
    if (!_numberRightLabel) {
        _numberRightLabel = [[UILabel alloc]init];
        _numberRightLabel.text = Localized(@"", nil);
        _numberRightLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _numberRightLabel.textColor = kMainGaryWhiteColor;
    }
    return _numberRightLabel;
}

- (UIView *)numberFunView {
    if (!_numberFunView) {
        _numberFunView = [[UIView alloc]init];
        _numberFunView.backgroundColor = kMainSubBackgroundColor;
        _numberFunView.layer.cornerRadius = ScaleW(5);
        _numberFunView.layer.masksToBounds = YES;
        _numberFunView.layer.borderColor = kLightLineColor.CGColor;
        _numberFunView.layer.borderWidth = 1;
    }
    return _numberFunView;
}

- (UIView *)numberLineView{
    if (!_numberLineView) {
        _numberLineView = [[UIView alloc]init];
        _numberLineView.backgroundColor = kLightLineColor;
        
    }
    return _numberLineView;
}

- (UITextField *)numberTF {
    if (!_numberTF) {
        _numberTF = [[UITextField alloc]init];
        _numberTF.backgroundColor = kMainSubBackgroundColor;
        _numberTF.keyboardType = UIKeyboardTypeDecimalPad;
        _numberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberTF.placeholder = Localized(@"最小提币数量", nil);
        _numberTF.textColor = kMainGaryWhiteColor;
        _numberTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _numberTF.leftViewMode = UITextFieldViewModeAlways;
        _numberTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_numberTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _numberTF;
}

- (UIButton *)numberButton {
    if (!_numberButton) {
        _numberButton = [[UIButton alloc]init];
        [_numberButton setTitle:Localized(@"全部", nil) forState:UIControlStateNormal];
        [_numberButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        _numberButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
    }
    return _numberButton;
}

- (UILabel *)numberWCLabel {
    if (!_numberWCLabel) {
        _numberWCLabel = [[UILabel alloc]init];
        _numberWCLabel.text = Localized(@"可提币数量0.000000 USDT", nil);
        _numberWCLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _numberWCLabel.textColor = kMainTitleColor;
        _numberWCLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _numberWCLabel;
}

- (UILabel *)payPwdLabel {
    if (!_payPwdLabel) {
        _payPwdLabel = [[UILabel alloc]init];
        _payPwdLabel.text = Localized(@"支付密码", nil);
        _payPwdLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _payPwdLabel.textColor = kMainGaryWhiteColor;
    }
    return _payPwdLabel;
}

- (UITextField *)payPwdTF {
    if (!_payPwdTF) {
        _payPwdTF = [[UITextField alloc]init];
        _payPwdTF.backgroundColor = kMainSubBackgroundColor;
        _payPwdTF.layer.cornerRadius = ScaleW(5);
        _payPwdTF.layer.masksToBounds = YES;
        _payPwdTF.layer.borderColor = kLightLineColor.CGColor;
        _payPwdTF.layer.borderWidth = 1;
        _payPwdTF.textColor = kMainGaryWhiteColor;
        _payPwdTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _payPwdTF.leftViewMode = UITextFieldViewModeAlways;
        _payPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _payPwdTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _payPwdTF.placeholder = Localized(@"请输入支付密码", nil);
        [_payPwdTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        _payPwdTF.secureTextEntry = YES;
    }
    return _payPwdTF;
}
- (UILabel *)verityLabel {
    if (!_verityLabel) {
        _verityLabel = [[UILabel alloc]init];
        _verityLabel.text = Localized(@"手机验证码", nil);
        _verityLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _verityLabel.textColor = kMainGaryWhiteColor;
    }
    return _verityLabel;
}

- (UIView *)moreFunView {
    if (!_moreFunView) {
        _moreFunView = [[UIView alloc]init];
        _moreFunView.backgroundColor = kMainSubBackgroundColor;
        _moreFunView.layer.cornerRadius = ScaleW(5);
        _moreFunView.layer.masksToBounds = YES;
        _moreFunView.layer.borderColor = kLightLineColor.CGColor;
        _moreFunView.layer.borderWidth = 1;
    }
    return _moreFunView;
}

- (UIView *)moreLineView {
    if (!_moreLineView) {
        _moreLineView = [[UIView alloc]init];
        _moreLineView.backgroundColor = kLightLineColor;
        
    }
    return _moreLineView;
}

- (UITextField *)verifyCodeTF {
    if (!_verifyCodeTF) {
        _verifyCodeTF = [[UITextField alloc]init];
        _verifyCodeTF.backgroundColor = kMainSubBackgroundColor;
        _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        _verifyCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verifyCodeTF.placeholder = Localized(@"请输入短信验证码", nil);
        _verifyCodeTF.textColor = kMainGaryWhiteColor;
        _verifyCodeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _verifyCodeTF.leftViewMode = UITextFieldViewModeAlways;
        _verifyCodeTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_verifyCodeTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _verifyCodeTF;
}

- (UIButton *)verifyCodeButton {
    if (!_verifyCodeButton) {
        _verifyCodeButton = [[UIButton alloc]init];
        [_verifyCodeButton setTitle:Localized(@"获取验证码", nil) forState:UIControlStateNormal];
        [_verifyCodeButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        _verifyCodeButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _verifyCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        
    }
    return _verifyCodeButton;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.text = Localized(@"提币类型", nil);
        _typeLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _typeLabel.textColor = kMainGaryWhiteColor;
    }
    return _typeLabel;
}

- (UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [[UIButton alloc]init];
        _typeButton.backgroundColor = kMainSubBackgroundColor;
        _typeButton.layer.cornerRadius = ScaleW(5);
        _typeButton.layer.masksToBounds = YES;
        _typeButton.layer.borderColor = kLightLineColor.CGColor;
        _typeButton.layer.borderWidth = 1;
        [_typeButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, ScaleW(10), 0, 0);
        _typeButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_typeButton setTitle:@"CNY" forState:UIControlStateNormal];
        _typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_typeButton addTarget:self action:@selector(typeButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _typeButton.enabled = NO;
    }
    return _typeButton;
}

- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc]init];
        _typeImageView.image = [UIImage imageNamed:@"rank_down"];
//        _typeImageView.hidden = YES;
    }
    return _typeImageView;
}

- (RG_PullDownView *)pullDownView {
    if (!_pullDownView) {
        _pullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:@[@"CNY",@"USDT"]];
        _pullDownView.hidden = YES;
        _pullDownView.delegate = self;
        _pullDownView.backgroundColor = kMainBackgroundColor;
    }
    return _pullDownView;
}

- (RG_PullDownView *)carryPullDownView {
    if (!_carryPullDownView) {
        _carryPullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:@[@"提币通道一",@"提币通道二"]];
        _carryPullDownView.hidden = YES;
        _carryPullDownView.delegate = self;
        _carryPullDownView.backgroundColor = kMainBackgroundColor;
    }
    return _carryPullDownView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = Localized(@"收款钱包地址", nil);
        _addressLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _addressLabel.textColor = kMainGaryWhiteColor;
        _addressLabel.hidden = YES;
    }
    return _addressLabel;
}

- (UITextField *)addressTF {
    if (!_addressTF) {
        _addressTF = [[UITextField alloc]init];
        _addressTF.backgroundColor = kMainSubBackgroundColor;
        _addressTF.layer.cornerRadius = ScaleW(5);
        _addressTF.layer.masksToBounds = YES;
        _addressTF.layer.borderWidth = 1;
        _addressTF.layer.borderColor = kLightLineColor.CGColor;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.placeholder = Localized(@"请输入钱包地址", nil);
        _addressTF.textColor = kMainGaryWhiteColor;
        _addressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _addressTF.leftViewMode = UITextFieldViewModeAlways;
        _addressTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _addressTF.keyboardType = UIKeyboardTypeASCIICapable;
        _addressTF.hidden = YES;
        [_addressTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _addressTF;
}

- (UILabel *)carryCoinWayLabel {
    if (!_carryCoinWayLabel) {
        _carryCoinWayLabel = [[UILabel alloc]init];
        _carryCoinWayLabel.text = Localized(@"提币方式", nil);
        _carryCoinWayLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _carryCoinWayLabel.textColor = kMainGaryWhiteColor;
    }
    return _carryCoinWayLabel;
}

- (UIButton *)carryCoinWayButton {
    if (!_carryCoinWayButton) {
        _carryCoinWayButton = [[UIButton alloc]init];
        _carryCoinWayButton.backgroundColor = kMainSubBackgroundColor;
        _carryCoinWayButton.layer.cornerRadius = ScaleW(5);
        _carryCoinWayButton.layer.masksToBounds = YES;
        _carryCoinWayButton.layer.borderColor = kLightLineColor.CGColor;
        _carryCoinWayButton.layer.borderWidth = 1;
        [_carryCoinWayButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _carryCoinWayButton.titleEdgeInsets = UIEdgeInsetsMake(0, ScaleW(10), 0, 0);
        _carryCoinWayButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_carryCoinWayButton setTitle:@"提币通道一" forState:UIControlStateNormal];
        _carryCoinWayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_carryCoinWayButton addTarget:self action:@selector(carryCoinWayButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _carryCoinWayButton.enabled = NO;
    }
    return _carryCoinWayButton;
}

- (UIImageView *)carryCoinWayImageView {
    if (!_carryCoinWayImageView) {
        _carryCoinWayImageView = [[UIImageView alloc]init];
        _carryCoinWayImageView.image = [UIImage imageNamed:@"rank_down"];
        _carryCoinWayImageView.hidden = YES;
        
    }
    return _carryCoinWayImageView;
}
#pragma mark -- Setter Method

@end
