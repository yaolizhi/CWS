//
//  RG_RegisterViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_RegisterViewController.h"
typedef void(^currentTitleBlock)(NSString *title);
@interface RG_RegisterViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameWarmLabel;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UIView *moreFunView;
@property (nonatomic, strong) UITextField *verifyCodeTF;
@property (nonatomic, strong) UIView *moreLineView;
@property (nonatomic, strong) UIButton *verifyCodeButton;

@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *pwdAgainTF;
@property (nonatomic, strong) UITextField *recommendTF;

@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UILabel *agreeLabel;


@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic , strong) dispatch_source_t timer;
@property (nonatomic , copy) currentTitleBlock block;


@end

@implementation RG_RegisterViewController

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
    self.title = Localized(@"注册", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}


- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (void)agreeButtonClick {
    self.agreeButton.selected = !self.agreeButton.selected;
}
- (void)registerButtonClick {
    self.nameTF.text =  [self.nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.nameTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入昵称" toView:nil];
        return;
    }
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
    if (![self.pwdTF.text isEqualToString:self.pwdAgainTF.text]) {
        [RCHUDPop popupTipText:@"两次密码输入不一致" toView:nil];
        return;
    }
    if (self.recommendTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入邀请码" toView:nil];
        return;
    }
    if (!self.agreeButton.selected) {
        [RCHUDPop popupTipText:@"请先阅读并同意注册协议" toView:nil];
        return;
    }
    [self registerFetchData];
    
    
}

- (void)registerFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"mobile":self.phoneTF.text?:@"",
                             @"opwd":self.pwdTF.text?:@"",
                             @"opwd1":self.pwdAgainTF.text?:@"",
                             @"code":self.verifyCodeTF.text?:@"",
                             @"tjuser":self.recommendTF.text?:@"",
                             @"realname":self.nameTF.text?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Register_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
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
//短信验证码按钮
- (void)verifyButtonClick {
    [self.phoneTF resignFirstResponder];

    if (self.phoneTF.text.length == 0 ||
        ![RegularExpression validateMobile:self.phoneTF.text]) {
        [RCHUDPop popupTipText:@"请输入正确的手机号" toView:nil];
    }else{

        WS(weakSelf);
        NSDictionary *params = @{@"mobile":self.phoneTF.text?:@"",
                                 @"type":@"1"};
        [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_SendSMS_URL RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject) {
            if ([responseObject[@"status"] integerValue] == 200) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                weakSelf.verifyCodeButton.enabled = NO;
                WS(weakSelf);
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
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.nameWarmLabel];
    [self.contentView addSubview:self.nameTF];
    [self.contentView addSubview:self.phoneTF];
    
    [self.contentView addSubview:self.moreFunView];
    [self.moreFunView addSubview:self.verifyCodeTF];
    [self.moreFunView addSubview:self.moreLineView];
    [self.moreFunView addSubview:self.verifyCodeButton];
    
    [self.contentView addSubview:self.pwdTF];
    [self.contentView addSubview:self.pwdAgainTF];
    [self.contentView addSubview:self.recommendTF];
    
    [self.contentView addSubview:self.agreeButton];
    [self.contentView addSubview:self.agreeLabel];
    
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
        make.top.equalTo(self.contentView).offset(ScaleH(26));
//        make.width.mas_equalTo(ScaleW(123));
//        make.height.mas_equalTo(ScaleW(51));
    }];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.logoImageView.mas_bottom).offset(ScaleH(33));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.nameWarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.nameTF.mas_bottom).offset(ScaleH(6));
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.nameTF.mas_bottom).offset(ScaleH(33));
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    [self.moreFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.phoneTF.mas_bottom).offset(ScaleH(24));
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
        make.height.mas_equalTo(ScaleH(26));
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
        make.top.equalTo(self.moreFunView.mas_bottom).offset(ScaleH(24));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    [self.pwdAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdTF.mas_bottom).offset(ScaleH(24));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.recommendTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdAgainTF.mas_bottom).offset(ScaleH(24));
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.recommendTF.mas_bottom).offset(ScaleH(36));
        make.height.mas_equalTo(ScaleH(15));
        make.width.mas_equalTo(ScaleW(14));
    }];
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendTF.mas_bottom).offset(ScaleH(36));
        make.left.equalTo(self.agreeButton.mas_right).offset(ScaleW(5));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.agreeLabel.mas_bottom).offset(ScaleH(22));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.registerButton.mas_bottom).offset(ScaleH(20));
        make.bottom.equalTo(self.contentView).offset(-ScaleH(25));
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

- (UILabel *)nameWarmLabel {
    if (!_nameWarmLabel) {
        _nameWarmLabel = [[UILabel alloc]init];
        _nameWarmLabel.text = Localized(@"*一旦注册不能修改", nil);
        _nameWarmLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _nameWarmLabel.textColor = [UIColor whiteColor];
    }
    return _nameWarmLabel;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc]init];
        _nameTF.backgroundColor = kMainSubBackgroundColor;
        _nameTF.layer.cornerRadius = ScaleW(5);
        _nameTF.layer.masksToBounds = YES;
        _nameTF.layer.borderWidth = 1;
        _nameTF.layer.borderColor = kLightLineColor.CGColor;
        _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTF.placeholder = Localized(@"请输入昵称", nil);
        _nameTF.textColor = kMainGaryWhiteColor;
        _nameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
        _nameTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_nameTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];

//        _nameTF.text = [self randomCreatChinese:4];
        
    }
    return _nameTF;
}

- (NSMutableString*)randomCreatChinese:(NSInteger)count {
    NSMutableString*randomChineseString = [[NSMutableString alloc]init];
    for(NSInteger i =0; i < count; i++){
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSInteger randomH =0xA1+arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL =0xB0+arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8)+randomL;
        NSData*data = [NSData dataWithBytes:&number length:2];
        NSString*string = [[NSString alloc]initWithData:data encoding:gbkEncoding];
        [randomChineseString appendString:string];
    }
    return randomChineseString;
}
- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc]init];
        _phoneTF.backgroundColor = kMainSubBackgroundColor;
        _phoneTF.layer.cornerRadius = ScaleW(5);
        _phoneTF.layer.masksToBounds = YES;
        _phoneTF.layer.borderWidth = 1;
        _phoneTF.layer.borderColor = kLightLineColor.CGColor;
        _phoneTF.keyboardType = UIKeyboardTypeDecimalPad;
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

- (UIView *)moreFunView {
    if (!_moreFunView) {
        _moreFunView = [[UIView alloc]init];
        _moreFunView.backgroundColor = kMainSubBackgroundColor;
        _moreFunView.layer.cornerRadius = ScaleW(5);
        _moreFunView.layer.masksToBounds = YES;
        _moreFunView.layer.borderWidth = 1;
        _moreFunView.layer.borderColor = kLightLineColor.CGColor;
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

- (UITextField *)pwdTF {
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc]init];
        _pwdTF.backgroundColor = kMainSubBackgroundColor;
        _pwdTF.layer.cornerRadius = ScaleW(5);
        _pwdTF.layer.masksToBounds = YES;
        _pwdTF.layer.borderWidth = 1;
        _pwdTF.layer.borderColor = kLightLineColor.CGColor;
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
        _pwdAgainTF.layer.borderWidth = 1;
        _pwdAgainTF.layer.borderColor = kLightLineColor.CGColor;
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

- (UITextField *)recommendTF {
    if (!_recommendTF) {
        _recommendTF = [[UITextField alloc]init];
        _recommendTF.backgroundColor = kMainSubBackgroundColor;
        _recommendTF.layer.cornerRadius = ScaleW(5);
        _recommendTF.layer.masksToBounds = YES;
        _recommendTF.layer.borderWidth = 1;
        _recommendTF.layer.borderColor = kLightLineColor.CGColor;
        _recommendTF.keyboardType = UIKeyboardTypeEmailAddress;
        _recommendTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _recommendTF.placeholder = Localized(@"推荐码（必填）", nil);
        _recommendTF.textColor = kMainGaryWhiteColor;
        _recommendTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _recommendTF.leftViewMode = UITextFieldViewModeAlways;
        _recommendTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_recommendTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _recommendTF;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc]init];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"register_noagree"] forState:UIControlStateNormal];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"register_agree"] forState:UIControlStateSelected];
        [_agreeButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _agreeButton.selected = YES;
    }
    return _agreeButton;
}

- (UILabel *)agreeLabel {
    if (!_agreeLabel) {
        _agreeLabel = [[UILabel alloc]init];
        _agreeLabel.text = Localized(@"我同意收集BSG中的信息，我同意用户协议和隐私政策，并确认我至少18岁或达到我所在管辖区内规定的法定年龄，且对我适用的法律允许我参加与网站上提供的游戏", nil);
        _agreeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _agreeLabel.textColor = kMainGaryWhiteColor;
        _agreeLabel.numberOfLines = 0;
        
    }
    return _agreeLabel;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc]init];
        [_registerButton setTitle:Localized(@"注册", nil) forState:UIControlStateNormal];
        [_registerButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _registerButton.layer.cornerRadius = ScaleW(5);
        _registerButton.layer.masksToBounds = YES;
        _registerButton.backgroundColor = kMainTitleColor;
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:Localized(@"登录", nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
#pragma mark -- Setter Method
@end
