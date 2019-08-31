//
//  RG_ForgetPwdViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_ForgetPwdViewController.h"
typedef void(^currentTitleBlock)(NSString *title);
@interface RG_ForgetPwdViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *pwdAgainTF;

@property (nonatomic, strong) UIView *moreFunView;
@property (nonatomic, strong) UITextField *verifyCodeTF;
@property (nonatomic, strong) UIView *moreLineView;
@property (nonatomic, strong) UIButton *verifyCodeButton;

//按钮
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic , strong) dispatch_source_t timer;
@property (nonatomic , copy) currentTitleBlock block;
@end

@implementation RG_ForgetPwdViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"忘记密码", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (void)sureButtonClick {
    if (self.phoneTF.text.length == 0 ||
        ![RegularExpression validateMobile:self.phoneTF.text]) {
        [RCHUDPop popupTipText:@"请输入正确的手机号" toView:nil];
        
        return;
    }
    if (self.verifyCodeTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入验证码" toView:nil];
        return;
    }
    if (self.pwdTF.text.length == 0 ||
        ![RegularExpression validatePassword:self.pwdTF.text]) {
        [RCHUDPop popupTipText:@"密码格式错误" toView:nil];
        
        return;
    }
    if (![self.pwdAgainTF.text isEqualToString:self.pwdTF.text]) {
        [RCHUDPop popupTipText:@"两次密码输入不一致" toView:nil];
        return;
    }
    [self forgetButtonFetchData];
}

- (void)forgetButtonFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"mobile":self.phoneTF.text?:@"",
                             @"opwd":self.pwdTF.text?:@"",
                             @"code":self.verifyCodeTF.text?:@"",
                             @"opwd1":self.pwdAgainTF.text?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Reset_Opwd_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}
- (void)loginButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)verifyButtonClick {
    [self.phoneTF resignFirstResponder];
    
    if (self.phoneTF.text.length == 0 ||
        ![RegularExpression validateMobile:self.phoneTF.text]) {
        [RCHUDPop popupTipText:@"请输入正确的手机号" toView:nil];
    }else{

        WS(weakSelf);
        NSDictionary *params = @{@"mobile":self.phoneTF.text?:@"",
                                 @"type":@"2"};
        [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_SendSMS_URL RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject) {
            if ([responseObject[@"status"] integerValue] == 200) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                weakSelf.verifyCodeButton.enabled = NO;
                [weakSelf getTimer:^(NSString *title) {
                    [weakSelf.verifyCodeButton setTitle:title forState:UIControlStateNormal];
                }];
            }else{
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            }
        } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        }];
    }
}

// 获取验证码时间
- (void)getTimer:(currentTitleBlock)block {
    self.block = block;
    [self startTimer];
}

// 开始计时
- (void)startTimer {
    __block int duration = 59; // 倒计时时长
    WS(weakSelf);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (duration <= 0) {
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.verifyCodeButton.enabled = YES;
                // 设置界面的按钮显示
                self.block(@"重新获取验证码");
            });
        }else{
            int seconds = duration % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds后重新发送",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示
                self.block(strTime);
            });
            duration --;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.phoneTF];
    [self.contentView addSubview:self.pwdTF];
    [self.contentView addSubview:self.pwdAgainTF];
    
    [self.contentView addSubview:self.moreFunView];
    [self.moreFunView addSubview:self.verifyCodeTF];
    [self.moreFunView addSubview:self.moreLineView];
    [self.moreFunView addSubview:self.verifyCodeButton];
    
    [self.contentView addSubview:self.loginButton];
    [self.contentView addSubview:self.sureButton];
}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.contentView).offset(ScaleH(20));
        make.height.mas_equalTo(ScaleH(45));
    }];

    [self.moreFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.phoneTF.mas_bottom).offset(ScaleH(25));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreFunView.mas_right).offset(-ScaleW(12));
        make.centerY.equalTo(self.moreFunView);
        make.height.mas_equalTo(ScaleH(30));
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
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.moreFunView.mas_bottom).offset(ScaleH(25));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    [self.pwdAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdTF.mas_bottom).offset(ScaleH(25));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdAgainTF.mas_bottom).offset(ScaleH(35));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.sureButton.mas_bottom).offset(ScaleH(20));
        make.bottom.equalTo(self.contentView);
    }];
}


#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = kMainBackgroundColor;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = kMainBackgroundColor;
    }
    return _contentView;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc]init];
        _phoneTF.backgroundColor = kMainSubBackgroundColor;
        _phoneTF.layer.cornerRadius = ScaleW(5);
        _phoneTF.layer.masksToBounds = YES;
        _phoneTF.layer.borderColor = kLightLineColor.CGColor;
        _phoneTF.layer.borderWidth = 1;
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTF.placeholder = Localized(@"请输入手机号", nil);
        _phoneTF.textColor = kMainGaryWhiteColor;
        _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_phoneTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _phoneTF;
}


- (UITextField *)pwdTF {
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc]init];
        _pwdTF.backgroundColor = kMainSubBackgroundColor;
        _pwdTF.layer.cornerRadius = ScaleW(5);
        _pwdTF.layer.masksToBounds = YES;
        _pwdTF.layer.borderColor = kLightLineColor.CGColor;
        _pwdTF.layer.borderWidth = 1;
        _pwdTF.keyboardType = UIKeyboardTypeEmailAddress;
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.placeholder = Localized(@"8-12位字母数字组合密码", nil);
        _pwdTF.textColor = kMainGaryWhiteColor;
        _pwdTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _pwdTF.leftViewMode = UITextFieldViewModeAlways;
        _pwdTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_pwdTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        _pwdTF.secureTextEntry = YES;
    }
    return _pwdTF;
}

- (UITextField *)pwdAgainTF {
    if (!_pwdAgainTF) {
        _pwdAgainTF = [[UITextField alloc]init];
        _pwdAgainTF.backgroundColor = kMainSubBackgroundColor;
        _pwdAgainTF.layer.cornerRadius = ScaleW(5);
        _pwdAgainTF.layer.masksToBounds = YES;
        _pwdAgainTF.layer.borderColor = kLightLineColor.CGColor;
        _pwdAgainTF.layer.borderWidth = 1;
        _pwdAgainTF.keyboardType = UIKeyboardTypeEmailAddress;
        _pwdAgainTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdAgainTF.placeholder = Localized(@"请再次输入新密码", nil);
        _pwdAgainTF.textColor = kMainGaryWhiteColor;
        _pwdAgainTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _pwdAgainTF.leftViewMode = UITextFieldViewModeAlways;
        _pwdAgainTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_pwdAgainTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        _pwdAgainTF.secureTextEntry = YES;
    }
    return _pwdAgainTF;
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
        [_verifyCodeButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _verifyCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _verifyCodeButton;
}


- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        [_sureButton setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = ScaleW(5);
        _sureButton.layer.masksToBounds = YES;
        _sureButton.backgroundColor = kMainTitleColor;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:Localized(@"登录", nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
#pragma mark -- Setter Method
@end
