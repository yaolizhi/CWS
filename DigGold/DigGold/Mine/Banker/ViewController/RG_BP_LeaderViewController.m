//
//  RG_BP_LeaderViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_BP_LeaderViewController.h"
#import "RG_BP_MainView.h"
#import "RG_BankMainModel.h"
@interface RG_BP_LeaderViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *widePoint;
@property (nonatomic, strong) UILabel *wideLabel;
@property (nonatomic, strong) UIView *feesPoint;
@property (nonatomic, strong) UILabel *feesLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UITextField *JCTF;
@property (nonatomic, strong) UILabel *JCLabel;
@property (nonatomic, strong) UIButton *operationButton;

@property (nonatomic, strong) UIView *middleLine;
@property (nonatomic, strong) RG_BP_MainView *dqgfView;
@property (nonatomic, strong) RG_BP_MainView *zzzjView;
@property (nonatomic, strong) RG_BP_MainView *jczjView;
@property (nonatomic, strong) RG_BP_MainView *jclrView;
@property (nonatomic, strong) RG_BP_MainView *gfxsView;
@property (nonatomic, strong) UIView *zzLine;
@property (nonatomic, strong) UIView *lrLine;

@property (nonatomic, copy) NSString *coinType;


@property (nonatomic, copy) NSString *xishi_rateS;
@property (nonatomic, strong) SSKJ_UserInfo_Model *userInfoModel;
@property (nonatomic, strong) RG_BankMainModel *bankMainModel;
@end

@implementation RG_BP_LeaderViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithCoinType:(NSString *)coinType
{
    self = [super init];
    if (self) {
        self.coinType = coinType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.view.backgroundColor = kMainBackgroundColor;
    
    self.balanceLabel.text = F(@"您的钱包余额：0 %@", self.coinType?:@"");
    self.JCLabel.text = F(@"%@", self.coinType?:@"");
    [self setupMasnory];
    [self mvvmBinding];
}

- (void)mvvmBinding {
    
    [self fetchCommonData];
    [self fetchUserInfoData];
    [self fetchInfoData];
}

#pragma mark -- Public Method
- (void)operationButtonClick {
    [self FetchData];
    
}

- (void)updateData {
    
    [self fetchInfoData];
}

- (void)FetchData {
    WS(weakSelf);
    NSString *value = [self.coinType isEqualToString:@"JC"]?@"pb":@"cny";
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"type":value,
                             @"money":self.JCTF.text?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Bank_op_post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            [weakSelf.JCTF setText:@""];
            [weakSelf mvvmBinding];
            [weakSelf textContentChanged:weakSelf.JCTF];
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
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
            weakSelf.xishi_rateS = netWorkModel.data[@"buy_info"][@"xishi_rate"][@"xishi_rate"];
            NSString *s = F(@"注入金额的%@%%将作为不可退还的股份稀释费扣除（其他庄家瓜分稀释费）， 此费用将从您的资金中扣除。", weakSelf.xishi_rateS?:@"");
            weakSelf.feesLabel.text = s;
            
            [[SSKJ_User_Tool sharedUserTool]saveCommonDataWithDic:(NSDictionary *)netWorkModel.data];
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
            BOOL isJCCoin = [weakSelf.coinType isEqualToString:@"JC"]?YES:NO;
            weakSelf.balanceLabel.text = F(@"您的钱包余额：%f %@", isJCCoin?model.balance_pb:model.balance_cny,weakSelf.coinType?:@"");
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}


- (void)fetchInfoData {
    WS(weakSelf);
    NSString *value = [self.coinType isEqualToString:@"JC"]?@"pb":@"cny";
    NSDictionary *params = @{@"money_type":value};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Banker_Pool_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            weakSelf.bankMainModel = [RG_BankMainModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf configureModel];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

- (void)configureModel {
    self.dqgfView.titleLabel.text = F(@"%.2f%%", [self.bankMainModel.scale floatValue]*100.0);
    self.zzzjView.titleLabel.text = F(@"%f %@", self.bankMainModel.bank_money,self.coinType?:@"");
    
}


- (void)textContentChanged:(UITextField*)textFiled {
    
    CGFloat selfGF = [self.JCTF.text floatValue] + self.bankMainModel.bank_money;
    CGFloat allGF = [self.JCTF.text floatValue] + self.bankMainModel.bank_money_total;
    CGFloat gf = selfGF/allGF*100.0;
    //（加上新注入金额后的坐庄资金）除以（奖池+现在扣去股份稀释费的注入金额）
//    double jiangchiAndZhuruPrice = self.bankMainModel.jc_bank_money_total + ([self.JCTF.text doubleValue] - [self.JCTF.text doubleValue]*([self.xishi_rateS doubleValue]/100));
//    CGFloat gf = selfGF/jiangchiAndZhuruPrice*100.0;
    
    if (self.JCTF.text.length == 0) {
        self.jczjView.titleLabel.text = @"0.00%";
    }else{
        self.jczjView.titleLabel.text = F(@"%.2f%%", gf);
    }

    
    double dedaoF = [self.JCTF.text doubleValue] - [self.JCTF.text doubleValue]*([self.xishi_rateS doubleValue]/100.0);
    double zhuruF = self.bankMainModel.bank_money + dedaoF;
    if (self.JCTF.text.length == 0) {
        self.jclrView.titleLabel.text = F(@"0.00 %@",self.coinType?:@"JC");
    }else{
        self.jclrView.titleLabel.text = F(@"%f %@", zhuruF,self.coinType?:@"JC");
    }
    
    //股份稀释费
    CGFloat xishiF = fabsf([self.JCTF.text floatValue]) * ([self.xishi_rateS floatValue]/100.0);
    if (self.JCTF.text.length == 0) {
        self.gfxsView.titleLabel.text = F(@"0.00 %@",self.coinType?:@"JC");
    }else{
        self.gfxsView.titleLabel.text = F(@"%f %@", xishiF,self.coinType?:@"JC");
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([RegularExpression deptNumInputShouldNumber:string] ||
        ([string isEqualToString:@"-"] && textField.text.length==0)||
        [string isEqualToString:@""]||
        ([string isEqualToString:@"."] &&![textField.text containsString:@"."] && textField.text.length>0)) {
        return YES;
    }else{
        return NO;
    }
}


#pragma mark -- Private Method

- (void)setupMasnory {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.widePoint];
    [self.contentView addSubview:self.wideLabel];
    [self.contentView addSubview:self.feesPoint];
    [self.contentView addSubview:self.feesLabel];
    [self.contentView addSubview:self.balanceLabel];
    [self.contentView addSubview:self.JCTF];
    [self.contentView addSubview:self.JCLabel];
    [self.contentView addSubview:self.operationButton];
    
    [self.contentView addSubview:self.middleLine];
    [self.contentView addSubview:self.dqgfView];
    [self.contentView addSubview:self.zzzjView];
    [self.contentView addSubview:self.jczjView];
    [self.contentView addSubview:self.jclrView];
    [self.contentView addSubview:self.gfxsView];
    
    
    [self.contentView addSubview:self.zzLine];
    [self.contentView addSubview:self.lrLine];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.widePoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(17));
        make.top.equalTo(self.contentView).offset(ScaleH(35));
        make.width.height.mas_equalTo(ScaleW(8));
    }];
    [self.wideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.widePoint.mas_right).offset(ScaleW(5));
        make.right.equalTo(self.contentView).offset(ScaleW(-12));
        make.top.equalTo(self.widePoint).offset(ScaleH(-2));
    }];
    [self.feesPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(17));
        make.top.equalTo(self.wideLabel.mas_bottom).offset(ScaleH(10));
        make.width.height.mas_equalTo(ScaleW(8));
    }];
    [self.feesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.feesPoint.mas_right).offset(ScaleW(5));
        make.right.equalTo(self.contentView).offset(ScaleW(-12));
        make.top.equalTo(self.feesPoint).offset(ScaleH(-2));
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(17));
        make.top.equalTo(self.feesLabel.mas_bottom).offset(ScaleH(40));
    }];
    [self.JCTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(17));
        make.top.equalTo(self.balanceLabel.mas_bottom).offset(ScaleH(16));
        make.right.equalTo(self.JCLabel.mas_left).offset(ScaleW(-12));
        make.height.mas_equalTo(ScaleH(40));
    }];
    [self.JCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(ScaleW(-12));
        make.centerY.equalTo(self.JCTF);
        make.width.mas_equalTo(ScaleW(36));
    }];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.JCTF.mas_bottom).offset(ScaleH(20));
        make.height.mas_equalTo(ScaleH(40));
        make.width.mas_equalTo(ScaleW(200));
    }];
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(17));
        make.right.equalTo(self.contentView).offset(-ScaleW(17));
        make.height.mas_offset(1);
        make.top.equalTo(self.operationButton.mas_bottom).offset(ScaleH(28));
    }];
    
    [self.dqgfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.middleLine.mas_bottom).offset(ScaleH(26));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.jczjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dqgfView.mas_right);
        make.top.equalTo(self.middleLine.mas_bottom).offset(ScaleH(26));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.zzzjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.dqgfView.mas_bottom).offset(ScaleH(20));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.jclrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zzzjView.mas_right);
        make.top.equalTo(self.jczjView.mas_bottom).offset(ScaleH(20));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.gfxsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.zzzjView.mas_bottom).offset(ScaleH(20));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    
    
    [self.zzLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.dqgfView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(30));
    }];
    [self.lrLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.zzzjView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(30));
        make.bottom.equalTo(self.contentView).offset(-ScaleH(30));
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

- (UIView *)widePoint {
    if (!_widePoint) {
        _widePoint = [[UIView alloc]init];
        _widePoint.backgroundColor = kMainTitleColor;
        _widePoint.layer.cornerRadius = ScaleW(4);
        _widePoint.layer.masksToBounds = YES;
    }
    return _widePoint;
}
- (UILabel *)wideLabel {
    if (!_wideLabel) {
        _wideLabel = [[UILabel alloc]init];
        _wideLabel.text = Localized(@"注入请填写正值，抽取请填写负值，请保证额度在您的承受范围内。", nil);
        _wideLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _wideLabel.textColor = kMainGaryWhiteColor;
        _wideLabel.numberOfLines = 0;
        
        [_wideLabel text:@"正值" color:kMainTitleColor font:_wideLabel.font];
        [_wideLabel text:@"负值" color:kMainTitleColor font:_wideLabel.font];
        [UILabel changeLineSpaceForLabel:_wideLabel WithSpace:ScaleW(6)];
    }
    return _wideLabel;
}

- (UIView *)feesPoint {
    if (!_feesPoint) {
        _feesPoint = [[UIView alloc]init];
        _feesPoint.backgroundColor = kMainTitleColor;
        _feesPoint.layer.cornerRadius = ScaleW(4);
        _feesPoint.layer.masksToBounds = YES;
    }
    return _feesPoint;
}
- (UILabel *)feesLabel {
    if (!_feesLabel) {
        _feesLabel = [[UILabel alloc]init];
        _feesLabel.text = Localized(@"注入金额的2%将作为不可退还的股份稀释费扣除（其他庄家瓜分稀释费）， 此费用将从您的资金中扣除。", nil);
        _feesLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _feesLabel.textColor = kMainGaryWhiteColor;
        _feesLabel.numberOfLines = 0;
        
        [_feesLabel text:@"2%" color:kMainTitleColor font:_feesLabel.font];
        [UILabel changeLineSpaceForLabel:_feesLabel WithSpace:ScaleW(6)];
    }
    return _feesLabel;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.text = Localized(@"您钱包余额：0 JC", nil);
        _balanceLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _balanceLabel.textColor = kMainTitleColor;
        [_balanceLabel text:@"您钱包余额：" color:kMainGaryWhiteColor font:_balanceLabel.font];
    }
    return _balanceLabel;
}

- (UITextField *)JCTF {
    if (!_JCTF) {
        _JCTF = [[UITextField alloc]init];
        _JCTF.backgroundColor = kMainSubBackgroundColor;
        _JCTF.layer.cornerRadius = ScaleW(5);
        _JCTF.layer.masksToBounds = YES;
        _JCTF.layer.borderWidth = 1;
        _JCTF.layer.borderColor = kLightLineColor.CGColor;
        _JCTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _JCTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _JCTF.textColor = kMainGaryWhiteColor;
        _JCTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _JCTF.leftViewMode = UITextFieldViewModeAlways;
        _JCTF.delegate = self;
        _JCTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_JCTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        [_JCTF addTarget:self action:@selector(textContentChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _JCTF;
}

- (UILabel *)JCLabel {
    if (!_JCLabel) {
        _JCLabel = [[UILabel alloc]init];
        _JCLabel.text = Localized(@"JC", nil);
        _JCLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _JCLabel.textColor = kMainTitleColor;
        _JCLabel.textAlignment = NSTextAlignmentCenter;
        _JCLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _JCLabel;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [[UIButton alloc]init];
        [_operationButton setTitle:Localized(@"注入/抽取", nil) forState:UIControlStateNormal];
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _operationButton.layer.cornerRadius = ScaleW(5);
        _operationButton.layer.masksToBounds = YES;
        _operationButton.backgroundColor = kMainTitleColor;
        _operationButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_operationButton addTarget:self action:@selector(operationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

- (UIView *)middleLine {
    if (!_middleLine) {
        _middleLine = [[UIView alloc]init];
        _middleLine.backgroundColor = kLineColor;
        _middleLine.alpha = 0.2;
    }
    return _middleLine;
}

- (RG_BP_MainView *)dqgfView {
    if (!_dqgfView) {
        _dqgfView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"您的当前股份", nil)];
        _dqgfView.titleLabel.text = @"0.00%";
    }
    return _dqgfView;
}
- (RG_BP_MainView *)jczjView {
    if (!_jczjView) {
        _jczjView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"预计注入/抽取后您的股份", nil)];
        _jczjView.titleLabel.text = @"0%";
    }
    return _jczjView;
}
- (RG_BP_MainView *)zzzjView {
    if (!_zzzjView) {
        _zzzjView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"您的当前坐庄资金", nil)];
        _zzzjView.titleLabel.text = F(@"0 %@", self.coinType);
    }
    return _zzzjView;
}
- (RG_BP_MainView *)jclrView {
    if (!_jclrView) {
        _jclrView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"预计注入/抽取后您的坐庄资金", nil)];
        _jclrView.titleLabel.text = F(@"0 %@", self.coinType);
    }
    return _jclrView;
}
- (RG_BP_MainView *)gfxsView {
    if (!_gfxsView) {
        _gfxsView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"股份稀释费", nil)];
        _gfxsView.titleLabel.text = F(@"0 %@", self.coinType);
    }
    return _gfxsView;
}
- (UIView *)zzLine {
    if (!_zzLine) {
        _zzLine = [[UIView alloc]init];
        _zzLine.backgroundColor = kLineColor;
        _zzLine.alpha = 0.2;
    }
    return _zzLine;
}
- (UIView *)lrLine {
    if (!_lrLine) {
        _lrLine = [[UIView alloc]init];
        _lrLine.backgroundColor = kLineColor;
        _lrLine.alpha = 0.2;
    }
    return _lrLine;
}
#pragma mark -- Setter Method
@end
