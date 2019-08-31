//
//  RG_AMJJCZViewController.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AMJQCZViewController.h"
#import "RG_ServiceViewController.h"
#import "RG_PullDownView.h"

#define AMJQTDY @"充值通道一"
#define AMJQTDR @"充值通道二"

@interface RG_AMJQCZViewController ()<RG_PullDownViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *rechargeLabel;
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIImageView *coinImageView;

@property (nonatomic, copy) NSString *qianshu;
@property (nonatomic, copy) NSString *beishu;
@property (nonatomic, strong) RG_PullDownView *rechargePullDownView;
@property (nonatomic, strong) NSArray *rechargeArray;
@property (nonatomic, copy) NSString *rechargeKey;
@property (nonatomic, copy) NSString *bibao_min;
@end

@implementation RG_AMJQCZViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rechargeArray = @[AMJQTDY,AMJQTDR];
        self.rechargeKey = AMJQTDY;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.view.backgroundColor = kMainBackgroundColor;
    self.beishu = @"1";
    self.qianshu = @"50";
    self.bibao_min = @"15";
    
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.rechargeLabel];
    [self.contentView addSubview:self.rechargeButton];
    [self.rechargeButton addSubview:self.coinImageView];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.phoneTF];
    [self.contentView addSubview:self.registerButton];
    [self.contentView addSubview:self.bottomLabel];
    [self.contentView addSubview:self.rechargePullDownView];
    
}

- (void)registerButtonClick {
    [self dismissCoinSideslipView];
    self.rechargeButton.selected = !self.rechargeButton.selected;
    if (self.phoneTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入充值数量" toView:nil];
        return;
    }
    
    if ([self.rechargeKey isEqualToString:AMJQTDY]) {
        if ([self.phoneTF.text floatValue] < [self.qianshu floatValue]) {
            [RCHUDPop popupTipText:F(@"充值数量不可小于%@", self.qianshu?:@"50") toView:nil];
            return;
        }
        NSString *floatS = F(@"%f", [self.phoneTF.text floatValue]/[self.beishu floatValue]);
        if (![RegularExpression isSeparatedPureInt:floatS]) {
            [RCHUDPop popupTipText:F(@"充值数量为%@的倍数", self.beishu?:@"50") toView:nil];
            return;
        }
    }else{
        if ([self.phoneTF.text floatValue] < [self.bibao_min floatValue]) {
            [RCHUDPop popupTipText:F(@"充值数量不可小于%@", self.bibao_min?:@"15") toView:nil];
            return;
        }
    }


    [self resetPayButtonFetchData];
}

- (void)resetPayButtonFetchData {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{};
    NSString *port = Port_OceanChongZhi_URL;
    if ([self.rechargeKey isEqualToString:AMJQTDY]) {
        params = @{@"pay_type":@"1",
                   @"price":self.phoneTF.text?:@""};
        port = Port_OceanChongZhi_URL;
    }else{
        params = @{@"price":self.phoneTF.text?:@""};
        port = Port_WuCaiChongZhi_URL;
    }
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:port RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            NSString *url = responseObject[@"data"][@"url"];
            RG_ServiceViewController *vc = [[RG_ServiceViewController alloc]initWithTitle:@"充值" url:url];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)mvvmBinding {
    [self fetchCommonData];
}

- (void)fetchCommonData {
    NSDictionary *params = @{};
    WS(weakSelf);
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Common_data_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            [[SSKJ_User_Tool sharedUserTool]saveCommonDataWithDic:(NSDictionary *)netWorkModel.data];
            NSString *recharge = netWorkModel.data[@"buy_info"][@"recharge"][@"recharge"];
            weakSelf.qianshu = netWorkModel.data[@"buy_info"][@"recharge"][@"qianshu1"];
            weakSelf.beishu = netWorkModel.data[@"buy_info"][@"recharge"][@"beishu1"];
            weakSelf.bibao_min = netWorkModel.data[@"buy_info"][@"recharge"][@"bibao_min"];
            weakSelf.phoneTF.placeholder = F(@"请输入充值数量，不可小于%@，且为%@的倍数", weakSelf.qianshu?:@"",weakSelf.beishu?:@"");
            weakSelf.bottomLabel.text = recharge?:@"";
            [UILabel changeLineSpaceForLabel:weakSelf.bottomLabel WithSpace:4];
            
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
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
    [self.rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.contentView).offset(ScaleH(32));
    }];
    
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.rechargeLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    [self.rechargePullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rechargeButton);
        make.right.equalTo(self.rechargeButton);
        make.top.equalTo(self.rechargeButton.mas_bottom).offset(1);
    }];
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rechargeButton).offset(-ScaleW(12));
        make.centerY.equalTo(self.rechargeButton);
        make.width.mas_equalTo(ScaleW(11));
        make.height.mas_equalTo(ScaleH(6));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.rechargeButton.mas_bottom).offset(ScaleH(14));
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.phoneTF.mas_bottom).offset(ScaleH(25));
        make.height.mas_equalTo(ScaleH(45));
        
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.registerButton.mas_bottom).offset(ScaleH(25));
        make.bottom.equalTo(self.contentView);
    }];
}


#pragma mark -- Public Method
- (void)rechargeButtonClick {
    if (self.rechargeButton.selected) {
        [self dismissCoinSideslipView];
    }else{
        [self showCoinSideslipView];
    }
    self.rechargeButton.selected = !self.rechargeButton.selected;
}

- (void)showCoinSideslipView {
    self.rechargePullDownView.hidden = NO;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.rechargePullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PullDownViewCellHeight*self.rechargeArray.count);
        }];
        [self.rechargePullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissCoinSideslipView {
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.rechargePullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.rechargePullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.rechargePullDownView.hidden = YES;
    }];
}
#pragma mark -- OtherDelegate
- (void)didSelectedPullDownTitle:(NSString *)title {
    self.rechargeKey = title?:@"";
    if ([self.rechargeKey isEqualToString:AMJQTDY]) {
        self.phoneTF.placeholder = F(@"请输入充值数量，不可小于%@，且为%@的倍数", self.qianshu?:@"",self.beishu?:@"");
    }else{
        self.phoneTF.placeholder = F(@"请输入充值数量，不可小于%@", self.bibao_min?:@"");
    }
    
    
    self.rechargeButton.selected = !self.rechargeButton.selected;
    [self.rechargeButton setTitle:title forState:UIControlStateNormal];
    [self dismissCoinSideslipView];
}
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
        _phoneLabel.text = Localized(@"充值数量", nil);
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
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.layer.borderColor = kLightLineColor.CGColor;
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTF.placeholder = Localized(@"请输入充值数量，不可小于50，且为50的倍数", nil);
        _phoneTF.textColor = kMainGaryWhiteColor;
        _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_phoneTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _phoneTF;
}

- (UILabel *)rechargeLabel {
    if (!_rechargeLabel) {
        _rechargeLabel = [[UILabel alloc]init];
        _rechargeLabel.text = Localized(@"充值方式", nil);
        _rechargeLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _rechargeLabel.textColor = kMainGaryWhiteColor;
    }
    return _rechargeLabel;
}

- (UIButton *)rechargeButton {
    if (!_rechargeButton) {
        _rechargeButton = [[UIButton alloc]init];
        _rechargeButton.backgroundColor = kMainSubBackgroundColor;
        _rechargeButton.layer.cornerRadius = ScaleW(5);
        _rechargeButton.layer.masksToBounds = YES;
        _rechargeButton.layer.borderWidth = 1;
        _rechargeButton.layer.borderColor = kLightLineColor.CGColor;
        [_rechargeButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _rechargeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _rechargeButton.titleEdgeInsets = UIEdgeInsetsMake(0, ScaleW(10), 0, 0);
        [_rechargeButton setTitle:AMJQTDY forState:UIControlStateNormal];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _rechargeButton.enabled = NO;
        
    }
    return _rechargeButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc]init];
        [_registerButton setTitle:Localized(@"充值", nil) forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerButton.layer.cornerRadius = ScaleW(5);
        _registerButton.layer.masksToBounds = YES;
        _registerButton.backgroundColor = kMainTitleColor;
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.text = @"";
        [UILabel changeLineSpaceForLabel:_bottomLabel WithSpace:4];
        _bottomLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        _bottomLabel.textColor = kMainGaryWhiteColor;
        _bottomLabel.numberOfLines = 0;
    }
    return _bottomLabel;
}

- (UIImageView *)coinImageView {
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc]init];
        _coinImageView.image = [UIImage imageNamed:@"rank_down"];
        _coinImageView.hidden = YES;
    }
    return _coinImageView;
}

- (RG_PullDownView *)rechargePullDownView {
    if (!_rechargePullDownView) {
        _rechargePullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:self.rechargeArray];
        _rechargePullDownView.hidden = YES;
        _rechargePullDownView.delegate = self;
    }
    return _rechargePullDownView;
}
#pragma mark -- Setter Method

@end
