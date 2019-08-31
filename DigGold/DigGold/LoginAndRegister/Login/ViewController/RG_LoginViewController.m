//
//  RG_LoginViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_LoginViewController.h"
#import "RG_ForgetPwdViewController.h"
#import "RG_RegisterViewController.h"
#import "WJValidationView.h"
@interface RG_LoginViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) UIView *moreFunView;
@property (nonatomic, strong) UITextField *verifyCodeTF;
@property (nonatomic, strong) UIView *moreLineView;
//@property (nonatomic, strong) UIButton *verifyCodeButton;

//按钮
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UIView *forgetLineView;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) WJValidationView *validationView;
@end

@implementation RG_LoginViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"登录", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}
- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (void)forgetButtonClick {
    RG_ForgetPwdViewController *vc = [[RG_ForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loginButtonClick {
    if (self.phoneTF.text.length == 0 ||
        ![RegularExpression validateMobile:self.phoneTF.text]) {
        [RCHUDPop popupTipText:@"请输入正确的手机号" toView:nil];
        return;
    }
    if (self.pwdTF.text.length == 0 ||
        ![RegularExpression validatePassword:self.pwdTF.text]) {
        [RCHUDPop popupTipText:@"密码格式错误" toView:nil];
        return;
    }
    if (![self.verifyCodeTF.text isEqualToString:self.validationView.charString]) {
        [RCHUDPop popupTipText:@"请输入正确的验证码" toView:nil];
        return;
    }
    [self loginFetchData];
}

- (void)loginFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"mobile":self.phoneTF.text?:@"",
                             @"opwd":self.pwdTF.text?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Login_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([responseObject[@"status"] integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            [[SSKJ_User_Tool sharedUserTool]saveLoginInfoWithToken:responseObject[@"data"][@"token"]];
            [[SSKJ_User_Tool sharedUserTool]saveLoginInfoWithAccount:responseObject[@"data"][@"account"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccessNotifition object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)registerButtonClick {
    RG_RegisterViewController *vc = [[RG_RegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.phoneTF];
    [self.contentView addSubview:self.pwdTF];
    
    [self.contentView addSubview:self.moreFunView];
    [self.moreFunView addSubview:self.verifyCodeTF];
    [self.moreFunView addSubview:self.moreLineView];
//    [self.moreFunView addSubview:self.verifyCodeButton];
    [self.moreFunView addSubview:self.validationView];
    
    [self.contentView addSubview:self.forgetButton];
    [self.contentView addSubview:self.forgetLineView];
    
    [self.contentView addSubview:self.loginButton];
    [self.contentView addSubview:self.registerButton];
}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];

    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(ScaleH(42));
//        make.width.mas_equalTo(ScaleW(123));
//        make.height.mas_equalTo(ScaleW(51));
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.logoImageView.mas_bottom).offset(ScaleH(42));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.phoneTF.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    [self.moreFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdTF.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.validationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreFunView.mas_right).offset(-ScaleW(12));
        make.centerY.equalTo(self.moreFunView);
        make.height.mas_equalTo(ScaleH(30));
        make.width.mas_equalTo(ScaleW(86));
    }];
    [self.moreLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moreFunView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(25));
        make.right.equalTo(self.validationView.mas_left).offset(-ScaleW(12));
    }];
    
    [self.verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreFunView);
        make.right.equalTo(self.moreLineView.mas_left).offset(-ScaleW(5));
        make.top.equalTo(self.moreFunView);
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.moreFunView.mas_bottom).offset(ScaleH(34));
    }];
    [self.forgetLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetButton.mas_bottom).offset(ScaleH(2));
        make.left.equalTo(self.forgetButton);
        make.right.equalTo(self.forgetButton);
        make.height.mas_equalTo(1);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.forgetButton.mas_bottom).offset(ScaleH(23));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.loginButton.mas_bottom).offset(ScaleH(26));
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

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.image = [UIImage imageNamed:@"mine_biglogo"];
    }
    return _logoImageView;
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
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.placeholder = Localized(@"请输入密码", nil);
        _pwdTF.textColor = kMainGaryWhiteColor;
        _pwdTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _pwdTF.leftViewMode = UITextFieldViewModeAlways;
        _pwdTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_pwdTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        _pwdTF.secureTextEntry = YES;
    }
    return _pwdTF;
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
        _moreLineView.backgroundColor = kLineColor;
    }
    return _moreLineView;
}

- (UITextField *)verifyCodeTF {
    if (!_verifyCodeTF) {
        _verifyCodeTF = [[UITextField alloc]init];
        _verifyCodeTF.backgroundColor = kMainSubBackgroundColor;
        _verifyCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verifyCodeTF.placeholder = Localized(@"验证码", nil);
        _verifyCodeTF.textColor = kMainGaryWhiteColor;
        _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        _verifyCodeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _verifyCodeTF.leftViewMode = UITextFieldViewModeAlways;
        _verifyCodeTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_verifyCodeTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _verifyCodeTF;
}


- (WJValidationView *)validationView {
    if (!_validationView) {
        _validationView = [[WJValidationView alloc]initWithFrame:CGRectMake(0, 0, ScaleW(86),ScaleH(30)) andCharCount:4 andLineCount:4];
        _validationView.changeValidationCodeBlock = ^(void){
            
        };
    }
    return _validationView;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc]init];
        [_forgetButton setTitle:Localized(@"*忘记密码？", nil) forState:UIControlStateNormal];
        [_forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        [_forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (UIView *)forgetLineView {
    if (!_forgetLineView) {
        _forgetLineView = [[UIView alloc]init];
        _forgetLineView.backgroundColor = kLine9Color;
    }
    return _forgetLineView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:Localized(@"登录", nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = ScaleW(5);
        _loginButton.layer.masksToBounds = YES;
        _loginButton.backgroundColor = kMainTitleColor;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc]init];
        [_registerButton setTitle:Localized(@"注册", nil) forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}
#pragma mark -- Setter Method
@end
