//
//  RG_BP_MainViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_BP_MainViewController.h"
#import "RG_BP_MainView.h"
#import "RGCycleProgressView.h"
#import "RG_BankMainModel.h"
#import "RG_FAQViewController.h"
@interface RG_BP_MainViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) RGCycleProgressView *cycleProgressView;
@property (nonatomic, strong) UIButton *moreInfoButton;
@property (nonatomic, strong) UIView *moreInfoLineView;


@property (nonatomic, strong) RG_BP_MainView *zzzjView;
@property (nonatomic, strong) RG_BP_MainView *jczjView;
@property (nonatomic, strong) RG_BP_MainView *zzlrView;
@property (nonatomic, strong) RG_BP_MainView *jclrView;
@property (nonatomic, strong) UIView *zzLine;
@property (nonatomic, strong) UIView *lrLine;
@property (nonatomic, strong) RG_BankMainModel *bankMainModel;

@end

@implementation RG_BP_MainViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithCoinType:(NSString *)coinType
{
    self = [super init];
    if (self) {
        self.selectedCoinS = @"USDT";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupMasnory];
    [self mvvmBinding];
    
    
}

- (void)updateData {
    self.cycleProgressView.progress = 0.0;
    [self fetchInfoData];
}



- (void)mvvmBinding {
    [self fetchInfoData];
}

- (void)setSelectedCoinS:(NSString *)selectedCoinS {
    _selectedCoinS = selectedCoinS;

}

- (void)fetchInfoData {
    WS(weakSelf);
    NSString *value = [self.selectedCoinS isEqualToString:@"JC"]?@"pb":@"cny";
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
    self.zzzjView.titleLabel.text = F(@"%f %@", self.bankMainModel.bank_money,self.selectedCoinS?:@"");
    self.zzlrView.titleLabel.text = F(@"%f %@", self.bankMainModel.bank_money_lirun,self.selectedCoinS?:@"");
    self.jczjView.titleLabel.text = F(@"%f %@", self.bankMainModel.bank_money_total,self.selectedCoinS?:@"");
    self.jclrView.titleLabel.text = F(@"%f %@", self.bankMainModel.bank_money_lirun_total,self.selectedCoinS?:@"");
    self.cycleProgressView.progress = [self.bankMainModel.scale floatValue];
}

#pragma mark -- Public Method
- (void)moreInfoButtonClicksss {
    RG_FAQViewController *vc = [[RG_FAQViewController alloc]initWithSelectedType:RG_FAQType_JS];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.cycleProgressView];
    
    [self.contentView addSubview:self.zzzjView];
    [self.contentView addSubview:self.jczjView];
    [self.contentView addSubview:self.zzlrView];
    [self.contentView addSubview:self.jclrView];
    [self.contentView addSubview:self.moreInfoButton];
    [self.contentView addSubview:self.moreInfoLineView];
    
    [self.contentView addSubview:self.zzLine];
    [self.contentView addSubview:self.lrLine];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.cycleProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(ScaleH(66));
        make.height.mas_equalTo(WJCycleProgressViewHeight);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.zzzjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.cycleProgressView.mas_bottom).offset(ScaleH(80));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.jczjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zzzjView.mas_right);
        make.top.equalTo(self.cycleProgressView.mas_bottom).offset(ScaleH(80));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.zzlrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.zzzjView.mas_bottom).offset(ScaleH(20));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.jclrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zzlrView.mas_right);
        make.top.equalTo(self.jczjView.mas_bottom).offset(ScaleH(20));
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    
    
    [self.moreInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.zzlrView.mas_bottom).offset(ScaleH(60));
        make.width.mas_equalTo(ScaleW(160));
        make.height.mas_equalTo(ScaleH(20));
        make.bottom.equalTo(self.contentView).offset(ScaleH(-36));
    }];
    [self.moreInfoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreInfoButton.mas_bottom).offset(ScaleH(1));
        make.left.equalTo(self.moreInfoButton).offset(ScaleW(5));
        make.right.equalTo(self.moreInfoButton).offset(-ScaleW(5));
        make.height.mas_equalTo(1);
    }];
    
    [self.zzLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.zzzjView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(30));
    }];
    [self.lrLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.zzlrView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ScaleH(30));
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
- (RGCycleProgressView *)cycleProgressView {
    if (!_cycleProgressView) {
        _cycleProgressView = [[RGCycleProgressView alloc]init];
        _cycleProgressView.backgroundColor = kMainBackgroundColor;
        
    }
    return _cycleProgressView;
}

- (UIButton *)moreInfoButton {
    if (!_moreInfoButton) {
        _moreInfoButton = [[UIButton alloc]init];
        [_moreInfoButton setTitle:Localized(@"更多奖池的信息，请点击这里！", nil) forState:UIControlStateNormal];
        [_moreInfoButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        [_moreInfoButton setImage:[UIImage imageNamed:@"zj_ywicon"] forState:UIControlStateNormal];
        _moreInfoButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        [_moreInfoButton addTarget:self action:@selector(moreInfoButtonClicksss) forControlEvents:UIControlEventTouchUpInside];
        _moreInfoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    return _moreInfoButton;
}

- (UIView *)moreInfoLineView {
    if (!_moreInfoLineView) {
        _moreInfoLineView = [[UIView alloc]init];
        _moreInfoLineView.backgroundColor = kMainTitleColor;
    }
    return _moreInfoLineView;
}

- (RG_BP_MainView *)zzzjView {
    if (!_zzzjView) {
        _zzzjView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"您的坐庄资金", nil)];
    }
    return _zzzjView;
}
- (RG_BP_MainView *)jczjView {
    if (!_jczjView) {
        _jczjView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"庄家奖池资金", nil)];
    }
    return _jczjView;
}
- (RG_BP_MainView *)zzlrView {
    if (!_zzlrView) {
        _zzlrView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"您的坐庄利润", nil)];
    }
    return _zzlrView;
}
- (RG_BP_MainView *)jclrView {
    if (!_jclrView) {
        _jclrView = [[RG_BP_MainView alloc]initWithFrame:CGRectZero subTitleStirng:Localized(@"庄家奖池利润", nil)];
    }
    return _jclrView;
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
