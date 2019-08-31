//
//  RG_ ModifiedPwdViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_ModifiedPwdViewController.h"
#import "RG_LoginViewController.h"
@interface RG_ModifiedPwdViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *pwdNewTF;
@property (nonatomic, strong) UITextField *pwdAgainTF;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UILabel *pwdLabel;
@property (nonatomic, strong) UILabel *pwdNewLabel;
@property (nonatomic, strong) UILabel *pwdAgainLabel;
@end

@implementation RG_ModifiedPwdViewController

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

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.pwdTF];
    [self.contentView addSubview:self.pwdLabel];
    [self.contentView addSubview:self.pwdNewTF];
    [self.contentView addSubview:self.pwdNewLabel];
    [self.contentView addSubview:self.pwdAgainTF];
    [self.contentView addSubview:self.pwdAgainLabel];
    [self.contentView addSubview:self.saveButton];
    
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (void)saveButtonClick {
    if (self.pwdTF.text.length == 0 ||
        ![RegularExpression validatePassword:self.pwdTF.text]) {
        [RCHUDPop popupTipText:@"旧密码格式错误" toView:nil];
        return;
    }
    if (self.pwdNewTF.text.length == 0 ||
        ![RegularExpression validatePassword:self.pwdTF.text]) {
        [RCHUDPop popupTipText:@"新密码格式错误" toView:nil];
        return;
    }
    if (![self.pwdNewTF.text isEqualToString:self.pwdAgainTF.text]) {
        [RCHUDPop popupTipText:@"两次密码输入不一致" toView:nil];
        return;
    }
    [self modifyButtonFetchData];
}

- (void)modifyButtonFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"oldpwd":self.pwdTF.text?:@"",
                             @"opwd":self.pwdNewTF.text?:@"",
                             @"opwd1":self.pwdAgainTF.text?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Edit_Pwd_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            [SSKJ_User_Tool clearUserInfo];
            [[NSNotificationCenter defaultCenter]postNotificationName:kLogoutSuccessNotifition object:nil];
            RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        
            //移除
            NSMutableArray *m = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"RG_SafeCenterViewController")]) {
                    [m removeObject:vc];
                }
            }
            self.navigationController.viewControllers = m;
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.contentView).offset(ScaleH(32));
    }];
    
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.contentView).offset(ScaleH(64));
        make.height.mas_equalTo(ScaleH(41));
    }];
    
    [self.pwdNewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.pwdLabel.mas_bottom).offset(ScaleH(73));
    }];
    
    [self.pwdNewTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdTF.mas_bottom).offset(ScaleH(48));
        make.height.mas_equalTo(ScaleH(41));
    }];

    [self.pwdAgainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.pwdNewLabel .mas_bottom).offset(ScaleH(73));
    }];

    [self.pwdAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdNewTF.mas_bottom).offset(ScaleH(48));
        make.height.mas_equalTo(ScaleH(41));
    }];

    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.pwdAgainTF.mas_bottom).offset(ScaleH(25));
        make.height.mas_equalTo(ScaleH(45));
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

- (UILabel *)pwdLabel {
    if (!_pwdLabel) {
        _pwdLabel = [[UILabel alloc]init];
        _pwdLabel.text = Localized(@"旧密码", nil);
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
        _pwdTF.layer.borderColor = kLightLineColor.CGColor;
        _pwdTF.layer.borderWidth = 1;
        _pwdTF.keyboardType = UIKeyboardTypeEmailAddress;
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.secureTextEntry = YES;
        _pwdTF.placeholder = Localized(@"请输入旧密码", nil);
        _pwdTF.textColor = kMainGaryWhiteColor;
        _pwdTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _pwdTF.leftViewMode = UITextFieldViewModeAlways;
        _pwdTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_pwdTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _pwdTF;
}

- (UILabel *)pwdNewLabel {
    if (!_pwdNewLabel) {
        _pwdNewLabel = [[UILabel alloc]init];
        _pwdNewLabel.text = Localized(@"新密码", nil);
        _pwdNewLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _pwdNewLabel.textColor = kMainGaryWhiteColor;
    }
    return _pwdNewLabel;
}

- (UITextField *)pwdNewTF {
    if (!_pwdNewTF) {
        _pwdNewTF = [[UITextField alloc]init];
        _pwdNewTF.backgroundColor = kMainSubBackgroundColor;
        _pwdNewTF.layer.cornerRadius = ScaleW(5);
        _pwdNewTF.layer.masksToBounds = YES;
        _pwdNewTF.secureTextEntry = YES;
        _pwdNewTF.layer.borderColor = kLightLineColor.CGColor;
        _pwdNewTF.layer.borderWidth = 1;
        _pwdNewTF.keyboardType = UIKeyboardTypeEmailAddress;
        _pwdNewTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdNewTF.placeholder = Localized(@"8-12位字母数字组合密码", nil);
        _pwdNewTF.textColor = kMainGaryWhiteColor;
        _pwdNewTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _pwdNewTF.leftViewMode = UITextFieldViewModeAlways;
        _pwdNewTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_pwdNewTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _pwdNewTF;
}

- (UILabel *)pwdAgainLabel {
    if (!_pwdAgainLabel) {
        _pwdAgainLabel = [[UILabel alloc]init];
        _pwdAgainLabel.text = Localized(@"重复新密码", nil);
        _pwdAgainLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _pwdAgainLabel.textColor = kMainGaryWhiteColor;
    }
    return _pwdAgainLabel;
}

- (UITextField *)pwdAgainTF {
    if (!_pwdAgainTF) {
        _pwdAgainTF = [[UITextField alloc]init];
        _pwdAgainTF.backgroundColor = kMainSubBackgroundColor;
        _pwdAgainTF.layer.cornerRadius = ScaleW(5);
        _pwdAgainTF.layer.masksToBounds = YES;
        _pwdAgainTF.layer.borderColor = kLightLineColor.CGColor;
        _pwdAgainTF.layer.borderWidth = 1;
        _pwdAgainTF.secureTextEntry = YES;
        _pwdAgainTF.keyboardType = UIKeyboardTypeEmailAddress;
        _pwdAgainTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdAgainTF.placeholder = Localized(@"重复新密码", nil);
        _pwdAgainTF.textColor = kMainGaryWhiteColor;
        _pwdAgainTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _pwdAgainTF.leftViewMode = UITextFieldViewModeAlways;
        _pwdAgainTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_pwdAgainTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _pwdAgainTF;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc]init];
        [_saveButton setTitle:Localized(@"保存", nil) forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = ScaleW(5);
        _saveButton.layer.masksToBounds = YES;
        _saveButton.backgroundColor = kMainTitleColor;
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
#pragma mark -- Setter Method
@end
