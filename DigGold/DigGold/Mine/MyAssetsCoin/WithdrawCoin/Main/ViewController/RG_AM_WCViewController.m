//
//  RG_AM_WCViewController.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_AM_WCViewController.h"
#import "RG_AM_WCView.h"
#import "RG_WithdrawAddressViewController.h"
#import "RG_AM_WCModel.h"
#import "SSKJ_UserInfo_Model.h"
#import "RG_ServiceViewController.h"
typedef void(^currentTitleBlock)(NSString *title);
@interface RG_AM_WCViewController ()<RG_AM_WCViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) RG_AM_WCView *wcView;
@property (nonatomic, strong) UIButton *carryCoinButton;
@property (nonatomic, strong) RG_AM_WCModel *model;
@property (nonatomic, strong) SSKJ_UserInfo_Model *userInfoModel;
@property (nonatomic , strong) dispatch_source_t timer;
@property (nonatomic , copy) currentTitleBlock block;
@property (nonatomic, copy) NSString *beishu_usdt;
@property (nonatomic, copy) NSString *tixian_usdt;

@property (nonatomic, copy) NSString *usdt_rate;
@property (nonatomic, copy) NSString *usdt_addr;
@property (nonatomic, assign) CGFloat balance_cny;
@property (nonatomic, copy) NSString *recordCoin;
@end

@implementation RG_AM_WCViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.usdt_addr = @"";
        self.usdt_rate = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"提币", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupMasnory];
    [self mvvmBinding];
    [self didSelectedTypeTitle:@"CNY"];
    
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.wcView];
    [self.contentView addSubview:self.carryCoinButton];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.wcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    [self.carryCoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.wcView.mas_bottom).offset(ScaleH(53));
        make.height.mas_equalTo(ScaleH(45));
        make.bottom.equalTo(self.contentView).offset(-ScaleH(32));
    }];
}

- (void)mvvmBinding {
    [self carrayFetchDataNeed];
    [self fetchUserInfoData];
    [self getUSDTRateFetchData];
}

#pragma mark -- Public Method


- (void)carryButtonClick {
//    if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道一"]) {
        if (self.wcView.numberTF.text.length == 0) {
            [RCHUDPop popupTipText:@"请输入提币数量" toView:nil];
            return;
        }
//    }

    if ([self.wcView.typeButton.titleLabel.text isEqualToString:@"USDT"]) {
//        if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道一"]) {
            if ([self.wcView.numberTF.text doubleValue] < [self.tixian_usdt doubleValue]) {
                [RCHUDPop popupTipText:F(@"最小提币数量%@ USDT", self.tixian_usdt?:@"") toView:nil];
                return;
            }
//        }

    }else{
        if ([self.wcView.numberTF.text doubleValue] < ([self.tixian_usdt doubleValue] * [self.usdt_rate doubleValue])) {
            [RCHUDPop popupTipText:F(@"最小提现金额%f CNY", [self.tixian_usdt doubleValue] * [self.usdt_rate doubleValue]) toView:nil];
            return;
        }
    }
    if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道一"]) {
        if ([self.wcView.typeButton.titleLabel.text isEqualToString:@"USDT"]) {
            if (self.wcView.addressTF.text.length == 0) {
                [RCHUDPop popupTipText:@"请输入钱包地址" toView:nil];
                return;
            }
        }
    }


//    NSString *floatS = F(@"%f", [self.wcView.numberTF.text floatValue]/[self.beishu_usdt floatValue]);
//    if (![RegularExpression isSeparatedPureInt:floatS]) {
//        [RCHUDPop popupTipText:F(@"提币数量必须是%@的倍数", self.beishu_usdt?:@"") toView:nil];
//        return;
//    }
//
    
    if (self.wcView.payPwdTF.text.length == 0 ||
        ![RegularExpression validatePassword:self.wcView.payPwdTF.text]) {
        [RCHUDPop popupTipText:@"密码格式错误" toView:nil];
        return;
    }
    if (self.wcView.verifyCodeTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入验证码" toView:nil];
        return;
    }

    [self carrayFetchData];
    
}

- (void)numberButtonClick {
    if ([self.wcView.typeButton.titleLabel.text isEqualToString:@"USDT"]) {
        self.wcView.numberTF.text = F(@"%f",self.userInfoModel.balance_cny);
    }else{
        self.wcView.numberTF.text = F(@"%f",self.userInfoModel.balance_cny * [self.usdt_rate doubleValue]);
    }
    
}

- (void)carrayFetchDataNeed {
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Ct_Data_URL RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            weakSelf.model = [RG_AM_WCModel mj_objectWithKeyValues:netWorkModel.data];
            
//            weakSelf.wcView.numberTF.placeholder = F(@"最小提币数量%@ USDT", weakSelf.model.qianshu2_usdt?:@"");
//            weakSelf.beishu_usdt = weakSelf.model.beishu2_usdt?:@"0";
            weakSelf.tixian_usdt =  weakSelf.model.qianshu2_usdt?:@"0";
            [weakSelf configureChargeValue];
        }else{
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}

- (void)fetchUserInfoData {
    NSDictionary *params = @{};
    WS(weakSelf);
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_UserInfo_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            SSKJ_UserInfo_Model *model = [SSKJ_UserInfo_Model mj_objectWithKeyValues:netWorkModel.data];
            weakSelf.userInfoModel = model;
            weakSelf.balance_cny = [[WLTools noroundingStringWith:model.balance_cny afterPointNumber:6] doubleValue];
            [weakSelf configureChargeValue];
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}

- (void)carrayFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{};

    NSString *port = Port_Tixian_post_URL;
    if ([self.wcView.typeButton.titleLabel.text isEqualToString:@"USDT"]) {
        if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道一"]) {
            params = @{@"price":self.wcView.numberTF.text?:@"",
                       @"code":self.wcView.verifyCodeTF.text?:@"",
                       @"tpwd":self.wcView.payPwdTF.text?:@"",
                       @"address":self.wcView.addressTF.text?:@"",
                       @"pay_type":@"2",
                       @"type":@"1"};
            port = Port_Tixian_post_URL;
        }
//        if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道二"]) {
//            params = @{@"price":self.wcView.numberTF.text?:@"",
//                       @"code":self.wcView.verifyCodeTF.text?:@"",
//                       @"tpwd":self.wcView.payPwdTF.text?:@"",
//                       @"pay_type":@"2",
//                       @"type":@"2"};
//            port = Port_Tixian_post_URL;
////            params = @{@"code":self.wcView.verifyCodeTF.text?:@"",
////                       @"tpwd":self.wcView.payPwdTF.text?:@""};
////            port = Port_WuCaiOffer_URL;
//        }
  
    }else{
//        NSString *numberS = F(@"%@", [WLTools noroundingStringWith:[self.wcView.numberTF.text doubleValue]/[self.usdt_rate doubleValue] afterPointNumber:4]);
        NSString *numberS = F(@"%.4f", [self.wcView.numberTF.text doubleValue]/[self.usdt_rate doubleValue]);
        if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道一"]) {
            params = @{@"price":numberS,
                       @"code":self.wcView.verifyCodeTF.text?:@"",
                       @"tpwd":self.wcView.payPwdTF.text?:@"",
                       @"pay_type":@"1",
                       @"type":@"1"
                       };
            port = Port_Tixian_post_URL;
        }
        if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道二"]) {
            params = @{@"price":numberS,
                       @"code":self.wcView.verifyCodeTF.text?:@"",
                       @"tpwd":self.wcView.payPwdTF.text?:@"",
                       @"pay_type":@"1",
                       @"type":@"2"
                       };
            port = Port_Tixian_post_URL;
        }

    }
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:port RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
//            if ([weakSelf.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道二"]) {
//                NSString *url = responseObject[@"data"][@"url"];
//                RG_ServiceViewController *vc = [[RG_ServiceViewController alloc]initWithTitle:@"提币" url:url];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:kCarrayCoinSuccessNotifition object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)getUSDTRateFetchData {
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_USDTRate_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            if ([netWorkModel.data[@"usdt_addr"] isKindOfClass:[NSNull class]]) {
                weakSelf.usdt_addr = @"";
            }else{
                weakSelf.usdt_addr = netWorkModel.data[@"usdt_addr"];
            }
            weakSelf.usdt_rate = netWorkModel.data[@"usdt_rate"] ;
            [weakSelf configureChargeValue];
        }else{
            
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)configureChargeValue {
    CGFloat cnyF = self.balance_cny * [self.usdt_rate doubleValue];
    if ([self.wcView.typeButton.titleLabel.text isEqualToString:@"USDT"]) {
        self.wcView.numberTF.placeholder = F(@"最小提币数量%@ USDT", self.tixian_usdt?:@"");
    }else{
        self.wcView.numberTF.placeholder = F(@"最小提现金额%f CNY",  [self.tixian_usdt doubleValue]*[self.usdt_rate doubleValue]);
    }
    self.wcView.numberWCLabel.text = F(@"可提币数量 %fUSDT ≈ %fCNY", self.balance_cny,cnyF);
    self.wcView.addressTF.text = self.usdt_addr?:@"";
    
//    if ([self.wcView.carryCoinWayButton.titleLabel.text isEqualToString:@"提币通道二"]) {
//        self.wcView.numberTF.placeholder = F(@"最小提币数量%@ USDT", self.tixian_usdt?:@"");
//        self.wcView.usableTF.text = F(@"%fUSDT", self.balance_cny);
//        self.wcView.numberWCLabel.text = F(@"可提币数量 %fUSDT", self.balance_cny);
//    }else{
        self.wcView.usableTF.text = F(@"%fUSDT ≈ %fCNY", self.balance_cny,cnyF);
        self.wcView.numberWCLabel.text = F(@"可提币数量 %fUSDT ≈ %fCNY", self.balance_cny,cnyF);
//    }
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
                weakSelf.wcView.verifyCodeButton.enabled = YES;
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

//短信验证码按钮
- (void)verifyButtonClick {
    
    self.wcView.verifyCodeButton.enabled = NO;
    WS(weakSelf);
    [self getTimer:^(NSString *title) {
        [weakSelf.wcView.verifyCodeButton setTitle:title forState:UIControlStateNormal];
    }];
    NSArray *array = self.userInfoModel.list;
    NSString *mobile = @"";
    if (array.count > 0) {
        SSKJ_UserInfoItem_Model *model = array[0];
        mobile = model.mobile?:@"";
    }
    NSDictionary *params = @{@"mobile":mobile,
                             @"type":@"3"};
    NSString *requestUrlString = F(@"%@%@", ProductBaseServer,@"/Home/Users/send_sms");
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:requestUrlString RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}

- (void)didSelectedTypeTitle:(NSString *)title {
    CGFloat cny = [self.model.qianshu2_usdt doubleValue] * [self.usdt_rate doubleValue];
    if ([title isEqualToString:@"USDT"] || [title isEqualToString:@"CNY"]) {
        if ([title isEqualToString:@"USDT"]) {
            self.wcView.numberLabel.text = @"提币数量";
            self.wcView.numberTF.placeholder = F(@"最小提币数量%@ USDT", self.model.qianshu2_usdt?:@"");
        }else{
            self.wcView.numberLabel.text = @"提现金额";
            self.wcView.numberTF.placeholder = F(@"最小提现金额%f CNY", cny);
        }
        self.recordCoin = title;
    }
    if ([title isEqualToString:@"提币通道一"] || [title isEqualToString:@"提币通道二"]) {
        
        if ([title isEqualToString:@"提币通道二"]) {
//            self.wcView.numberLabel.text = @"提币数量";
//            self.wcView.numberTF.placeholder = F(@"最小提币数量%@ USDT", self.tixian_usdt?:@"");
//            self.wcView.usableTF.text = F(@"%fUSDT", self.balance_cny);
//            self.wcView.numberWCLabel.text = F(@"可提币数量 %fUSDT", self.balance_cny);
            self.recordCoin = @"CNY";
            [self.wcView updateCNY];
            self.wcView.numberLabel.text = @"提现金额";
            self.wcView.numberTF.placeholder = F(@"最小提现金额%f CNY", cny);
            [self.wcView.typeButton setTitle:self.recordCoin forState:UIControlStateNormal];
            CGFloat cnyF = self.balance_cny * [self.usdt_rate doubleValue];
            self.wcView.usableTF.text = F(@"%fUSDT ≈ %fCNY", self.balance_cny,cnyF);
            self.wcView.numberWCLabel.text = F(@"可提币数量 %fUSDT ≈ %fCNY", self.balance_cny,cnyF);
        }else{
            if ([self.recordCoin isEqualToString:@"USDT"]) {
                [self.wcView updateUSDT];
//                [self.wcView updateCNY];
                self.wcView.numberLabel.text = @"提币数量";
                self.wcView.numberTF.placeholder = F(@"最小提币数量%@ USDT", self.model.qianshu2_usdt?:@"");
            }else{
                [self.wcView updateCNY];
                self.wcView.numberLabel.text = @"提现金额";
                self.wcView.numberTF.placeholder = F(@"最小提现金额%f CNY", cny);
            }
            [self.wcView.typeButton setTitle:self.recordCoin forState:UIControlStateNormal];
            CGFloat cnyF = self.balance_cny * [self.usdt_rate doubleValue];
            self.wcView.usableTF.text = F(@"%fUSDT ≈ %fCNY", self.balance_cny,cnyF);
            self.wcView.numberWCLabel.text = F(@"可提币数量 %fUSDT ≈ %fCNY", self.balance_cny,cnyF);
        }
    }
    

    self.wcView.numberTF.text = @"";
    
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
- (RG_AM_WCView *)wcView {
    if (!_wcView) {
        _wcView = [[RG_AM_WCView alloc]init];
        _wcView.backgroundColor = kMainBackgroundColor;
        _wcView.delegate = self;
        [_wcView.numberButton addTarget:self action:@selector(numberButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_wcView.verifyCodeButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wcView;
}

- (UIButton *)carryCoinButton {
    if (!_carryCoinButton) {
        _carryCoinButton = [[UIButton alloc]init];
        [_carryCoinButton setTitle:Localized(@"提币", nil) forState:UIControlStateNormal];
        [_carryCoinButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _carryCoinButton.layer.cornerRadius = ScaleW(5);
        _carryCoinButton.layer.masksToBounds = YES;
        _carryCoinButton.backgroundColor = kMainTitleColor;
        _carryCoinButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_carryCoinButton addTarget:self action:@selector(carryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carryCoinButton;
}
#pragma mark -- Setter Method
@end
