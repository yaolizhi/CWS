//
//  RG_AddWAddressViewController.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_AddWAddressViewController.h"

@interface RG_AddWAddressViewController ()
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UITextField *remarkTF;
@property (nonatomic, strong) UIButton *addCoinAddressButton;

@end

@implementation RG_AddWAddressViewController

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
    self.title = Localized(@"添加钱包地址", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupMasnory];
    [self mvvmBinding];
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressTF];
    [self.view addSubview:self.remarkLabel];
    [self.view addSubview:self.remarkTF];
    [self.view addSubview:self.addCoinAddressButton];
    
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScaleW(14));
        make.top.equalTo(self.view).offset(ScaleH(28));
    }];
    
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScaleW(14));
        make.right.equalTo(self.view).offset(-ScaleW(14));
        make.top.equalTo(self.addressLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScaleW(14));
        make.top.equalTo(self.addressTF.mas_bottom).offset(ScaleH(15));
    }];
    
    [self.remarkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScaleW(14));
        make.right.equalTo(self.view).offset(-ScaleW(14));
        make.top.equalTo(self.remarkLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
    }];
    [self.addCoinAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScaleW(14));
        make.right.equalTo(self.view).offset(-ScaleW(14));
        make.height.mas_equalTo(ScaleH(45));
        make.bottom.equalTo(self.view.mas_bottom).offset(-ScaleH(35));
        
    }];
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (void)addCoinAddressButtonClick {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"address":self.addressTF.text?:@"",
                             @"remark":self.remarkTF.text?:@""};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Wallet_Address_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kAddCoinAdressSuccess" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}
#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = Localized(@"地址", nil);
        _addressLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _addressLabel.textColor = kMainGaryWhiteColor;
    }
    return _addressLabel;
}

- (UITextField *)addressTF {
    if (!_addressTF) {
        _addressTF = [[UITextField alloc]init];
        _addressTF.backgroundColor = kMainSubBackgroundColor;
        _addressTF.layer.cornerRadius = ScaleW(5);
        _addressTF.layer.masksToBounds = YES;
        _addressTF.textColor = kMainGaryWhiteColor;
        _addressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _addressTF.leftViewMode = UITextFieldViewModeAlways;
        _addressTF.keyboardType = UIKeyboardTypeEmailAddress;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _addressTF.placeholder = Localized(@"输入或长按粘贴钱包地址", nil);
        [_addressTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _addressTF;
}

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.text = Localized(@"备注", nil);
        _remarkLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _remarkLabel.textColor = kMainGaryWhiteColor;
    }
    return _remarkLabel;
}

- (UITextField *)remarkTF {
    if (!_remarkTF) {
        _remarkTF = [[UITextField alloc]init];
        _remarkTF.backgroundColor = kMainSubBackgroundColor;
        _remarkTF.layer.cornerRadius = ScaleW(5);
        _remarkTF.layer.masksToBounds = YES;
        _remarkTF.textColor = kMainGaryWhiteColor;
        _remarkTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _remarkTF.leftViewMode = UITextFieldViewModeAlways;
        _remarkTF.keyboardType = UIKeyboardTypeEmailAddress;
        _remarkTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _remarkTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _remarkTF.placeholder = Localized(@"请输入备注", nil);
        [_remarkTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _remarkTF;
}
- (UIButton *)addCoinAddressButton {
    if (!_addCoinAddressButton) {
        _addCoinAddressButton = [[UIButton alloc]init];
        [_addCoinAddressButton setTitle:Localized(@"确认", nil) forState:UIControlStateNormal];
        [_addCoinAddressButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _addCoinAddressButton.layer.cornerRadius = ScaleW(5);
        _addCoinAddressButton.layer.masksToBounds = YES;
        _addCoinAddressButton.backgroundColor = kMainTitleColor;
        _addCoinAddressButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_addCoinAddressButton addTarget:self action:@selector(addCoinAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCoinAddressButton;
}
#pragma mark -- Setter Method
@end
