//
//  RG_PayMethodViewController.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_PayMethodViewController.h"
#import "DGShowPay.h"
#import "RG_PullDownView.h"
#import "RG_BankModel.h"
@interface RG_PayMethodViewController ()<UITextFieldDelegate,RG_PullDownViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UITextField *bankCardTF;
@property (nonatomic, strong) UITextField *bankNameTF;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UITextField *bankAddressTF;
@property (nonatomic, strong) UILabel *bankAddressLabel;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextField *addressTF;

@property (nonatomic, strong) UIImageView *downArrowIM;
@property (nonatomic, strong) RG_PullDownView *pullDownView;
@property (nonatomic, strong) NSArray *bankModelArray;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, assign) BOOL isOpen;

@end

@implementation RG_PayMethodViewController

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
//    [self.contentView addSubview:self.phoneLabel];
//    [self.contentView addSubview:self.phoneTF];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.nameTF];
    [self.contentView addSubview:self.bankLabel];
    [self.contentView addSubview:self.bankCardTF];
    [self.contentView addSubview:self.bankNameTF];
    [self.contentView addSubview:self.bankNameLabel];
    
    [self.contentView addSubview:self.bankAddressTF];
    [self.contentView addSubview:self.bankAddressLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.addressTF];
    
    [self.contentView addSubview:self.saveButton];
    [self.bankNameTF addSubview:self.downArrowIM];
    [self.contentView addSubview:self.pullDownView];
    
}


- (void)saveButtonClick {
//    if (self.phoneTF.text.length == 0) {
//        [RCHUDPop popupTipText:@"请输入支付宝账号" toView:nil];
//        return;
//    }
    if (self.nameTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入真实姓名" toView:nil];
        return;
    }
    if (self.bankCardTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入银行卡号" toView:nil];
        return;
    }
    if (self.bankNameTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入银行卡开户行名称" toView:nil];
        return;
    }
    if (self.bankAddressTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入银行卡开户行支行名称" toView:nil];
        return;
    }
//    if (self.addressTF.text.length == 0) {
//        [RCHUDPop popupTipText:@"请输入钱包地址" toView:nil];
//        return;
//    }
    [self resetPayButtonFetchData];
}

- (void)resetPayButtonFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"address":self.addressTF.text?:@"",
                             @"realname":self.nameTF.text?:@"",
                             @"bankcard":self.bankCardTF.text?:@"",
                             @"branch":self.bankNameTF.text?:@"",
                             @"bank_code":self.bankCode?:@"",
                             @"bank":self.bankAddressTF.text?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_SetPay_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
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

- (void)showPayWay {
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Show_Pay_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            DGShowPay *model = [DGShowPay mj_objectWithKeyValues:netWorkModel.data];
            weakSelf.nameTF.text = model.realname?:@"";
            weakSelf.bankCardTF.text = model.bankcard?:@"";
            weakSelf.bankNameTF.text = model.branch?:@"";
            weakSelf.bankAddressTF.text = model.bank?:@"";
            weakSelf.addressTF.text = model.address?:@"";
            weakSelf.bankCode = model.bankCode?:@"";
        }else{
            
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)resetBankList {
    WS(weakSelf);
    NSDictionary *params = @{};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_BankList_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            
            weakSelf.bankModelArray = [RG_BankModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSArray *titlesArray = [weakSelf.bankModelArray valueForKeyPath:@"bank_name"];
            
            weakSelf.pullDownView.titlesArray = titlesArray;
        }else{
            
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)tapBankNameClick {
    
    if (self.bankModelArray.count == 0) {
        [self resetBankList];
        return;
    }
    if (self.pullDownView.hidden) {
        [self showCoinSideslipView];
    }else{
        [self dismissCoinSideslipView];
    }

}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
//    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(ScaleW(14));
//        make.top.equalTo(self.contentView).offset(ScaleH(32));
//    }];
//
//    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(ScaleW(14));
//        make.right.equalTo(self.contentView).offset(-ScaleW(14));
//        make.top.equalTo(self.phoneLabel.mas_bottom).offset(ScaleH(15));
//        make.height.mas_equalTo(ScaleH(41));
//    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.contentView).offset(ScaleH(32));
    }];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
    }];
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.nameTF.mas_bottom).offset(ScaleH(30));
    }];
    
    [self.bankCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.bankLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
    }];
    [self.bankNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.bankCardTF.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(41));
    }];
    [self.pullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameTF.mas_bottom);
        make.left.right.equalTo(self.bankNameTF);
        make.width.equalTo(self.bankNameTF);
        make.height.mas_equalTo(0);
    }];
    
    [self.downArrowIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankNameTF);
        make.right.equalTo(self.bankNameTF).offset(-ScaleW(20));
    }];
    
    
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
//        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.bankNameTF.mas_bottom).offset(ScaleH(5));
    }];
    [self.bankAddressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.bankNameLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(41));
    }];
    
    [self.bankAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
//        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.bankAddressTF.mas_bottom).offset(ScaleH(5));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.bankAddressLabel.mas_bottom).offset(ScaleH(30));
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.addressLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.addressTF.mas_bottom).offset(ScaleH(30));
        make.height.mas_equalTo(ScaleH(45));
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)mvvmBinding {
    [self showPayWay];
    [self resetBankList];
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate
- (void)didSelectedPullDownTitle:(NSString *)title {
    NSArray *titles = [self.bankModelArray valueForKeyPath:@"bank_name"];
    NSInteger index = [titles indexOfObject:title];
    RG_BankModel *model = self.bankModelArray[index];
    self.bankCode = model.bank_code?:@"";
    self.bankNameTF.text = title;
    [self dismissCoinSideslipView];
}
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

- (UIImageView *)downArrowIM {
    if (!_downArrowIM) {
        _downArrowIM = [[UIImageView alloc]init];
        _downArrowIM.image = [UIImage imageNamed:@"rank_down"];
    }
    return _downArrowIM;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = Localized(@"支付宝账号", nil);
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
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTF.placeholder = Localized(@"请输入支付宝账号", nil);
        _phoneTF.textColor = kMainGaryWhiteColor;
        _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_phoneTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _phoneTF;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = Localized(@"真实姓名*", nil);
        _nameLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _nameLabel.textColor = kMainGaryWhiteColor;
        [_nameLabel text:@"*" color:[UIColor redColor] font:[UIFont systemFontOfSize:ScaleFont(14)]];
        
    }
    return _nameLabel;
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
        _nameTF.placeholder = Localized(@"请输入真实姓名", nil);
        _nameTF.textColor = kMainGaryWhiteColor;
        _nameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
        _nameTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_nameTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _nameTF;
}
- (UILabel *)bankLabel {
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc]init];
        _bankLabel.text = Localized(@"银行卡号*", nil);
        _bankLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _bankLabel.textColor = kMainGaryWhiteColor;
        [_bankLabel text:@"*" color:[UIColor redColor] font:[UIFont systemFontOfSize:ScaleFont(14)]];
    }
    return _bankLabel;
}

- (UITextField *)bankCardTF {
    if (!_bankCardTF) {
        _bankCardTF = [[UITextField alloc]init];
        _bankCardTF.backgroundColor = kMainSubBackgroundColor;
        _bankCardTF.layer.cornerRadius = ScaleW(5);
        _bankCardTF.layer.masksToBounds = YES;
        _bankCardTF.layer.borderWidth = 1;
        _bankCardTF.keyboardType = UIKeyboardTypePhonePad;
        _bankCardTF.layer.borderColor = kLightLineColor.CGColor;
        _bankCardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankCardTF.placeholder = Localized(@"请输入银行卡号", nil);
        _bankCardTF.textColor = kMainGaryWhiteColor;
        _bankCardTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _bankCardTF.leftViewMode = UITextFieldViewModeAlways;
        _bankCardTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_bankCardTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _bankCardTF;
}

- (UITextField *)bankNameTF {
    if (!_bankNameTF) {
        _bankNameTF = [[UITextField alloc]init];
        _bankNameTF.backgroundColor = kMainSubBackgroundColor;
        _bankNameTF.layer.cornerRadius = ScaleW(5);
        _bankNameTF.layer.masksToBounds = YES;
        _bankNameTF.layer.borderWidth = 1;
        _bankNameTF.layer.borderColor = kLightLineColor.CGColor;
        _bankNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankNameTF.placeholder = Localized(@"请输入银行卡开户行名称", nil);
        _bankNameTF.textColor = kMainGaryWhiteColor;
        _bankNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _bankNameTF.leftViewMode = UITextFieldViewModeAlways;
        _bankNameTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_bankNameTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        _bankNameTF.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBankNameClick)];
        [_bankNameTF addGestureRecognizer:tap];
    }
    return _bankNameTF;
}

- (UILabel *)bankNameLabel {
    if (!_bankNameLabel) {
        _bankNameLabel = [[UILabel alloc]init];
        _bankNameLabel.text = @"示例格式：中国建设银行";
        _bankNameLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _bankNameLabel.textColor = kMainGaryWhiteColor;
    }
    return _bankNameLabel;
}
- (UILabel *)bankAddressLabel {
    if (!_bankAddressLabel) {
        _bankAddressLabel = [[UILabel alloc]init];
        _bankAddressLabel.text = @"示例格式：广东省广州市花园路支行";
        _bankAddressLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _bankAddressLabel.textColor = kMainGaryWhiteColor;
    }
    return _bankAddressLabel;
}

- (UITextField *)bankAddressTF {
    if (!_bankAddressTF) {
        _bankAddressTF = [[UITextField alloc]init];
        _bankAddressTF.backgroundColor = kMainSubBackgroundColor;
        _bankAddressTF.layer.cornerRadius = ScaleW(5);
        _bankAddressTF.layer.masksToBounds = YES;
        _bankAddressTF.layer.borderWidth = 1;
        _bankAddressTF.layer.borderColor = kLightLineColor.CGColor;
        _bankAddressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankAddressTF.placeholder = Localized(@"请选择银行卡开户行支行名称", nil);
        _bankAddressTF.textColor = kMainGaryWhiteColor;
        _bankAddressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _bankAddressTF.leftViewMode = UITextFieldViewModeAlways;
        _bankAddressTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_bankAddressTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    return _bankAddressTF;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.bankNameTF) {
        return NO;
    }
    
    return YES;
    
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = Localized(@"USDT钱包地址", nil);
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
        _addressTF.layer.borderWidth = 1;
        _addressTF.layer.borderColor = kLightLineColor.CGColor;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.placeholder = Localized(@"请输入USDT钱包地址", nil);
        _addressTF.textColor = kMainGaryWhiteColor;
        _addressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _addressTF.leftViewMode = UITextFieldViewModeAlways;
        _addressTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _addressTF.keyboardType = UIKeyboardTypeASCIICapable;
        [_addressTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _addressTF;
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

- (void)showCoinSideslipView {
    self.pullDownView.hidden = NO;
    [self.contentView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(PullDownViewCellHeight*self.bankModelArray.count);
            make.height.mas_equalTo(ScaleH(180));
        }];
        [self.pullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissCoinSideslipView {
    [self.contentView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.pullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.pullDownView.hidden = YES;
    }];
}

- (RG_PullDownView *)pullDownView {
    if (!_pullDownView) {
        _pullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:@[] canSlide:YES];
//        _pullDownView.canSlide = YES;
        _pullDownView.hidden = YES;
        _pullDownView.delegate = self;
    }
    return _pullDownView;
}
#pragma mark -- Setter Method
@end

