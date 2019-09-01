//
//  RG_ModifiedPhoneViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_ModifiedPhoneViewController.h"
#import "RG_LoginViewController.h"
typedef void(^currentTitleBlock)(NSString *title);
@interface RG_ModifiedPhoneViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *verifyCodeLabel;

@property (nonatomic, strong) UILabel *pwdLabel;
@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) UIView *moreFunView;
@property (nonatomic, strong) UITextField *verifyCodeTF;
@property (nonatomic, strong) UIView *moreLineView;
@property (nonatomic, strong) UIButton *verifyCodeButton;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic , strong) dispatch_source_t timer;
@property (nonatomic , copy) currentTitleBlock block;
@end

@implementation RG_ModifiedPhoneViewController

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
    self.title = @"";
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (void)saveButtonClick {
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
    [self saveFetchData];
}

- (void)saveFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"new_mobile":self.phoneTF.text?:@"",
                             @"code":self.verifyCodeTF.text?:@"",
                             @"tpwd":self.pwdTF.text?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_UpdateMyMobilePost_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            [SSKJ_User_Tool clearUserInfo];
            RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            //移除
            NSMutableArray *m = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"RG_SafeCenterViewController")]) {
                    [m removeObject:vc];
                }
            }
            weakSelf.navigationController.viewControllers = m;
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
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.phoneTF];
    [self.contentView addSubview:self.saveButton];
    [self.contentView addSubview:self.verifyCodeLabel];
    
    [self.contentView addSubview:self.moreFunView];
    [self.moreFunView addSubview:self.verifyCodeTF];
    [self.moreFunView addSubview:self.moreLineView];
    [self.moreFunView addSubview:self.verifyCodeButton];
    
    [self.contentView addSubview:self.pwdLabel];
    [self.contentView addSubview:self.pwdTF];
    
    
}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.contentView).offset(ScaleH(32));
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
    }];
    [self.verifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.phoneTF.mas_bottom).offset(ScaleH(32));
    }];
    
    [self.moreFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.verifyCodeLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
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
        make.height.mas_equalTo(ScaleH(41));
    }];
    
    [self.pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.moreFunView.mas_bottom).offset(ScaleH(32));
    }];
    
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdTF.mas_bottom).offset(ScaleH(44));
        make.height.mas_equalTo(ScaleW(45));
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

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = Localized(@"新手机号", nil);
        _phoneLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _phoneLabel.textColor = kMainGaryWhiteColor;
    }
    return _phoneLabel;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc]init];
        _phoneTF.backgroundColor = kMainSubBackgroundColor;
        _phoneTF.layer.cornerRadius = ScaleW(5);
        _phoneTF.layer.masksToBounds = YES;
        _phoneTF.layer.borderWidth = 1;
        _phoneTF.layer.borderColor = kLightLineColor.CGColor;
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

- (UILabel *)verifyCodeLabel {
    if (!_verifyCodeLabel) {
        _verifyCodeLabel = [[UILabel alloc]init];
        _verifyCodeLabel.text = Localized(@"验证码", nil);
        _verifyCodeLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _verifyCodeLabel.textColor = kMainGaryWhiteColor;
    }
    return _verifyCodeLabel;
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


- (UILabel *)pwdLabel {
    if (!_pwdLabel) {
        _pwdLabel = [[UILabel alloc]init];
        _pwdLabel.text = Localized(@"支付密码", nil);
        _pwdLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _pwdLabel.textColor = kMainGaryWhiteColor;
    }
    return _pwdLabel;
}

- (UITextField *)pwdTF {
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc]init];
        _pwdTF.backgroundColor = kMainSubBackgroundColor;
        _pwdTF.layer.cornerRadius = ScaleW(5);
        _pwdTF.layer.masksToBounds = YES;
        _pwdTF.layer.borderWidth = 1;
        _pwdTF.layer.borderColor = kLightLineColor.CGColor;
        _pwdTF.keyboardType = UIKeyboardTypeDefault;
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.placeholder = Localized(@"请输入支付密码", nil);
        _pwdTF.secureTextEntry = YES;
        _pwdTF.textColor = kMainGaryWhiteColor;
        _pwdTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _pwdTF.leftViewMode = UITextFieldViewModeAlways;
        _pwdTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_pwdTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _pwdTF;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc]init];
        [_saveButton setTitle:Localized(@"保存", nil) forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setCornerRadius:ScaleW(45.0/2)];
        _saveButton.backgroundColor = kMainTitleColor;
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
#pragma mark -- Setter Method
@end
