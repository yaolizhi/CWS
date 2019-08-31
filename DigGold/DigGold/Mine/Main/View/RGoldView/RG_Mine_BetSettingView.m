//
//  RG_Mine_BetSettingView.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mine_BetSettingView.h"
#import "RG_BuyInfoMode.h"
#import "RG_PB_InfoModel.h"
#import "RG_USDT_InfoModel.h"
@interface RG_Mine_BetSettingView()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *betLabel;
@property (nonatomic, strong) UIView *runAwayView;
@property (nonatomic, strong) UILabel *runAwayLabel;
@property (nonatomic, strong) UIButton *runAwayButton;
@property (nonatomic, strong) UIButton *maxButton;
@property (nonatomic, strong) UIButton *minButton;
@property (nonatomic, strong) UIButton *c2Button;
@property (nonatomic, strong) UIButton *x2Button;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *oddsLabel;

@property (nonatomic, copy) NSString *buy_min_money;
@property (nonatomic, copy) NSString *buy_max_money;
@property (nonatomic, copy) NSString *escape_beishu;
@property (nonatomic, strong) NSDictionary *commonDic;
@end

@implementation RG_Mine_BetSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.betLabel];
        [self addSubview:self.betTextField];
        [self addSubview:self.runAwayView];
        [self addSubview:self.runAwayLabel];
        [self.runAwayView addSubview:self.runAwayButton];
        [self.runAwayView addSubview:self.runAwayTextField];
        [self addSubview:self.maxButton];
        [self addSubview:self.minButton];
        [self addSubview:self.c2Button];
        [self addSubview:self.x2Button];
        [self addSubview:self.incomeLabel];
        [self addSubview:self.oddsLabel];
        
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.betLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(42));
        make.top.equalTo(self);
        
    }];
    [self.betTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(25));
        make.top.equalTo(self.betLabel.mas_bottom).offset(ScaleH(10));
        make.width.mas_equalTo(ScaleW(145));
        make.height.mas_equalTo(ScaleH(42));
    }];
    
    [self.runAwayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.x2Button.mas_right);
        make.top.equalTo(self.betLabel.mas_bottom).offset(ScaleH(10));
        make.width.mas_equalTo(ScaleW(145));
        make.height.mas_equalTo(ScaleH(42));
    }];
    
    [self.runAwayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runAwayView.mas_left).offset(ScaleW(16));
        make.top.equalTo(self);
    }];
    
    [self.runAwayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.runAwayView.mas_right).offset(-ScaleW(1));
        make.top.equalTo(self.runAwayView.mas_top).offset(ScaleW(1));
        make.width.mas_equalTo(ScaleW(40));
        make.height.mas_equalTo(ScaleH(40));
    }];
    
    [self.runAwayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runAwayView).offset(ScaleW(10));
        make.top.equalTo(self.runAwayView);
        make.width.mas_equalTo(ScaleW(100));
        make.height.mas_equalTo(ScaleH(42));
    }];
    
    [self.maxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.betTextField);
        make.top.equalTo(self.betTextField.mas_bottom).offset(ScaleH(8));
        make.width.mas_equalTo(ScaleW(75));
        make.height.mas_equalTo(ScaleH(30));
    }];
    [self.minButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maxButton.mas_right).offset(ScaleW(5));
        make.top.equalTo(self.betTextField.mas_bottom).offset(ScaleH(8));
        make.width.mas_equalTo(ScaleW(75));
        make.height.mas_equalTo(ScaleH(30));
    }];
    [self.c2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minButton.mas_right).offset(ScaleW(5));
        make.top.equalTo(self.betTextField.mas_bottom).offset(ScaleH(8));
        make.width.mas_equalTo(ScaleW(75));
        make.height.mas_equalTo(ScaleH(30));
    }];
    [self.x2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.c2Button.mas_right).offset(ScaleW(5));
        make.top.equalTo(self.betTextField.mas_bottom).offset(ScaleH(8));
        make.width.mas_equalTo(ScaleW(75));
        make.height.mas_equalTo(ScaleH(30));
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(110));
        make.top.equalTo(self.x2Button.mas_bottom).offset(ScaleH(13));
    }];
    [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeLabel.mas_right).offset(ScaleW(25));

        make.centerY.equalTo(self.incomeLabel);
        make.height.mas_equalTo(ScaleH(13));
        make.bottom.equalTo(self).offset(-ScaleH(25));
    }];
}

- (void)setupDataCoinType:(NSString *)coinType {
    
    self.commonDic = [[SSKJ_User_Tool sharedUserTool]getCommonData];
    if (self.commonDic.allKeys.count > 0) {
        if ([coinType containsString:@"JC"]) {
            RG_PB_InfoModel *model = [RG_PB_InfoModel
                                      mj_objectWithKeyValues:self.commonDic[@"buy_info"][@"pb_info"]];
            self.buy_max_money = model.pb_buy_max_money?:@"";
            self.buy_min_money = model.pb_buy_min_money?:@"";
            self.escape_beishu = model.pb_escape_beishu?:@"";
        }
        if ([coinType containsString:@"USDT"]) {
            RG_USDT_InfoModel *model = [RG_USDT_InfoModel
                                        mj_objectWithKeyValues:self.commonDic[@"buy_info"][@"cny_info"]];
            self.buy_max_money = model.cny_buy_max_money?:@"";
            self.buy_min_money = model.cny_buy_min_money?:@"";
            self.escape_beishu = model.cny_escape_beishu?:@"";
        }
        
        NSString *pS = F(@"投注范围 %@-%@", self.buy_min_money?:@"",self.buy_max_money?:@"");
        self.betTextField.placeholder = pS;
        [self.betTextField setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        [self.betTextField setValue:[UIFont systemFontOfSize:ScaleFont(11)] forKeyPath:@"_placeholderLabel.font"];

        [self setupDefaultcalculateIncome];
    }
}

- (void)setupDefaultcalculateIncome {
    self.betTextField.text = self.buy_min_money?:@"";
    self.runAwayTextField.text = self.escape_beishu?:@"";
    
    CGFloat incomeF = [self.betTextField.text floatValue] * [self.runAwayTextField.text floatValue];
    self.incomeLabel.text = F(@"%@%.2f",@"收益：", incomeF);
    CGFloat runF = (100.0/[self.runAwayTextField.text floatValue]);
    self.oddsLabel.text = F(@"%@%.2f%%",@"机会：", runF);
}
- (void)setupcalculateIncome {
    CGFloat incomeF = [self.betTextField.text floatValue] * [self.runAwayTextField.text floatValue];
    self.incomeLabel.text = F(@"%@%.2f",@"收益：", incomeF);
    CGFloat runF = (100.0/[self.runAwayTextField.text floatValue]);
    self.oddsLabel.text = F(@"%@%.2f%%",@"机会：", runF);
}

- (void)configureViewSelectedCoinType:(NSString *)coinType {
    [self setupDataCoinType:coinType];
}

#pragma mark -- Public Method
- (void)runAwayButtonClick {
//    self.runAwayTextField.text = @"";
}
- (void)buttonClick:(UIButton *)sender {
    if (sender.tag == 100) {//NSLog(@"Max");
        self.betTextField.text = self.buy_max_money?:@"";
    }
    if (sender.tag == 101) {//NSLog(@"Min");
        self.betTextField.text = self.buy_min_money?:@"";
    }
    if (sender.tag == 102) {//NSLog(@"/2");
        NSInteger value = [self.betTextField.text integerValue]/2;
        if (value <= [self.buy_min_money integerValue]) {
            value = [self.buy_min_money integerValue];
        }
        self.betTextField.text = F(@"%ld", (long)value);
    }
    if (sender.tag == 103) {//NSLog(@"X2");
        NSInteger value = [self.betTextField.text integerValue]*2;
        if (value >= [self.buy_max_money integerValue]) {
            value = [self.buy_max_money integerValue];
        }
        self.betTextField.text = F(@"%ld", (long)value);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bettingMethod)]) {
        [self.delegate bettingMethod];
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.betTextField]) {
        if (!self.commonDic ||
            self.commonDic.allKeys == 0||
            self.buy_max_money.length == 0 ||
            self.buy_min_money.length == 0) {
            return YES;
        }
        
        NSInteger currentValue = [self.betTextField.text integerValue];
        NSInteger maxValue = [self.buy_max_money integerValue];
        NSInteger minValue = [self.buy_min_money integerValue];
        if (currentValue >= maxValue) {
            self.betTextField.text = self.buy_max_money?:@"";
        }
        if (currentValue <= minValue) {
            self.betTextField.text = self.buy_min_money?:@"";
        }
    
    }
    if ([textField isEqual:self.runAwayTextField]) {
        
        CGFloat currentValue = [self.runAwayTextField.text floatValue];
        if (currentValue <= 1.1f) {
            self.runAwayTextField.text = @"1.1";
        }
    
    }
    [self setupcalculateIncome];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.runAwayTextField]) {
        NSString *recordS = F(@"%@%@", textField.text,string);
        if ([textField.text containsString:@"."]) {
            if ([string isEqualToString:@"."]) {
                return NO;
            }
            NSArray *arrfg = [recordS componentsSeparatedByString:@"."];
            NSString *lastString = [arrfg lastObject];
            if (lastString.length >= 2) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark -- Getter Method
- (UILabel *)betLabel {
    if (!_betLabel) {
        _betLabel = [[UILabel alloc]init];
        _betLabel.text = Localized(@"投注", nil);
        _betLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _betLabel.textColor = kMainGaryWhiteColor;
    }
    return _betLabel;
}

- (UITextField *)betTextField {
    if (!_betTextField) {
        _betTextField = [[UITextField alloc]init];
        _betTextField.backgroundColor = kMainBackgroundColor;
        _betTextField.layer.cornerRadius = ScaleW(5);
        _betTextField.layer.masksToBounds = YES;
        _betTextField.keyboardType = UIKeyboardTypeNumberPad;
        _betTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _betTextField.text = @"100";
        _betTextField.textColor = kMainGaryWhiteColor;
        _betTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _betTextField.leftViewMode = UITextFieldViewModeAlways;
        _betTextField.delegate = self;
        _betTextField.adjustsFontSizeToFitWidth = YES;

    }
    return _betTextField;
}

- (UIView *)runAwayView {
    if (!_runAwayView) {
        _runAwayView = [[UIView alloc]init];
        _runAwayView.backgroundColor = kMainBackgroundColor;
        _runAwayView.layer.cornerRadius = ScaleW(5);
        _runAwayView.layer.masksToBounds = YES;
    }
    return _runAwayView;
}

- (UITextField *)runAwayTextField {
    if (!_runAwayTextField) {
        _runAwayTextField = [[UITextField alloc]init];
        _runAwayTextField.keyboardType = UIKeyboardTypeDecimalPad;
//        _runAwayTextField.text = @"100";
        _runAwayTextField.textColor = kMainGaryWhiteColor;
        _runAwayTextField.delegate = self;
    }
    return _runAwayTextField;
}

- (UIButton *)runAwayButton {
    if (!_runAwayButton) {
        _runAwayButton = [[UIButton alloc]init];
        _runAwayButton.backgroundColor = kMainSubBackgroundColor;
        _runAwayButton.layer.cornerRadius = ScaleW(5);
        _runAwayButton.layer.masksToBounds = YES;
        [_runAwayButton setImage:[UIImage imageNamed:@"cancel_image"] forState:UIControlStateNormal];
        [_runAwayButton addTarget:self action:@selector(runAwayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runAwayButton;
}

- (UILabel *)runAwayLabel {
    if (!_runAwayLabel) {
        _runAwayLabel = [[UILabel alloc]init];
        _runAwayLabel.text = Localized(@"自动逃跑", nil);
        _runAwayLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _runAwayLabel.textColor = kMainGaryWhiteColor;
    }
    return _runAwayLabel;
}

- (UIButton *)maxButton {
    if (!_maxButton) {
        _maxButton = [[UIButton alloc]init];
        [_maxButton setTitle:Localized(@"Max", nil) forState:UIControlStateNormal];
        [_maxButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _maxButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _maxButton.backgroundColor = kMainBackgroundColor;
        _maxButton.layer.cornerRadius = ScaleW(5);
        _maxButton.layer.masksToBounds = YES;
        _maxButton.tag = 100;
        [_maxButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maxButton;
}
- (UIButton *)minButton {
    if (!_minButton) {
        _minButton = [[UIButton alloc]init];
        [_minButton setTitle:Localized(@"Min", nil) forState:UIControlStateNormal];
        [_minButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _minButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _minButton.backgroundColor = kMainBackgroundColor;
        _minButton.layer.cornerRadius = ScaleW(5);
        _minButton.layer.masksToBounds = YES;
        _minButton.tag = 101;
        [_minButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minButton;
}
- (UIButton *)c2Button {
    if (!_c2Button) {
        _c2Button = [[UIButton alloc]init];
        [_c2Button setTitle:Localized(@"/2", nil) forState:UIControlStateNormal];
        [_c2Button setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _c2Button.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _c2Button.backgroundColor = kMainBackgroundColor;
        _c2Button.layer.cornerRadius = ScaleW(5);
        _c2Button.layer.masksToBounds = YES;
        _c2Button.tag = 102;
        [_c2Button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _c2Button;
}
- (UIButton *)x2Button {
    if (!_x2Button) {
        _x2Button = [[UIButton alloc]init];
        [_x2Button setTitle:Localized(@"X2", nil) forState:UIControlStateNormal];
        [_x2Button setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _x2Button.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _x2Button.backgroundColor = kMainBackgroundColor;
        _x2Button.layer.cornerRadius = ScaleW(5);
        _x2Button.layer.masksToBounds = YES;
        _x2Button.tag = 103;
        [_x2Button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _x2Button;
}

- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
//        _incomeLabel.text = Localized(@"收益 100", nil);
        _incomeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _incomeLabel.textColor = kMainGaryWhiteColor;
    }
    return _incomeLabel;
}

- (UILabel *)oddsLabel {
    if (!_oddsLabel) {
        _oddsLabel = [[UILabel alloc]init];
//        _oddsLabel.text = Localized(@"机会 0.99%", nil);
        _oddsLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _oddsLabel.textColor = kMainGaryWhiteColor;
    }
    return _oddsLabel;
}
#pragma mark -- Setter Method

@end
