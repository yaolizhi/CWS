//
//  RG_Mian_ViewController.m
//  DigGold
//
//  Created by James on 2018/12/26.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mian_ViewController.h"
#import "RG_Main_TopMenuView.h"
#import "RG_Main_GoldAmountView.h"
#import "RG_Main_RGoldView.h"
#import "RG_Main_BottomView.h"
#import "RG_SideslipView.h"
#import "RG_DownSidelipView.h"
#import "RG_LoginViewController.h"
#import "RG_RollViewController.h"
#import "WJTabView.h"
#import "RG_Mine_LotteryHistoryViewController.h"
#import "RG_Mine_AllGuessViewController.h"
#import "RG_Mine_MyGuessViewController.h"
#import "RG_MyPromote_ViewController.h"
#import "RG_HelpCenterViewController.h"
#import "RG_APPDown_ViewController.h"
#import "RG_UserProfileViewController.h"
#import "RG_SafeCenterViewController.h"
#import "RG_PayPwdViewController.h"
#import "RG_WithdrawAddressViewController.h"
#import "RG_BankePoorDoorViewController.h"
#import "RG_MyCoinViewController.h"
#import "RG_OpenLotteryViewController.h"
#import "RG_Message_ViewController.h"
#import "RG_MyAssetsDoorViewController.h"
#import "RG_RankListViewController.h"
#import "RG_FAQViewController.h"

@interface RG_Mian_ViewController ()
<RG_Main_TopMenuViewDelegate,
RG_Main_GoldAmountViewDelegate,
RG_SideslipViewDelegate,
RG_DownSidelipViewDelegate,
WJTabViewDatsSource,
RG_Main_RGoldViewDelegate,
WJTabViewDelegate>
@property (nonatomic, strong) UIView *rightBarView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *notifyImageView;
@property (nonatomic, strong) UIImageView *downArrowImageView;
@property (nonatomic, strong) UIView *notifyRedView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) RG_Main_TopMenuView *topMenuView;
@property (nonatomic, strong) RG_Main_GoldAmountView *goldAmountView;
@property (nonatomic, strong) RG_Main_RGoldView *goldView;
@property (nonatomic, strong) RG_Main_BottomView *bottomView;
@property (nonatomic, strong) RG_SideslipView *sideslipView;
@property (nonatomic, strong) RG_DownSidelipView *downSideslipView;


@property (nonatomic, strong) RG_Mine_LotteryHistoryViewController *lotteryHistoryVC;
@property (nonatomic, strong) RG_Mine_MyGuessViewController *myGuessVC;
@property (nonatomic, strong) RG_Mine_AllGuessViewController *allGuessVC;
@property (nonatomic, strong) WJTabView *tabView;

@end

@implementation RG_Mian_ViewController

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
    self.title = Localized(@"抢金", nil);
    self.view.backgroundColor = kMainBackgroundColor;

    [self setupNavbar];
    [self setupUI];
    [self setupMasnory];
    
    [self mvvmBinding];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:kLoginSuccessNotifition object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutSuccess) name:kLogoutSuccessNotifition object:nil];
}
- (void)loginSuccess {
    self.notifyImageView.hidden = NO;
    self.notifyRedView.hidden = NO;
}

- (void)logoutSuccess {
    self.notifyImageView.hidden = YES;
    self.notifyRedView.hidden = YES;
}
#pragma mark -- Private Method

- (void)setupNavbar {
    
    if ([[SSKJ_User_Tool sharedUserTool] isLogingState]) {
        self.notifyImageView.hidden = NO;
        self.notifyRedView.hidden = NO;
    }else{
        self.notifyImageView.hidden = YES;
        self.notifyRedView.hidden = YES;
    }
    [self addLeftNavItemWithImage:[UIImage imageNamed:@"mine_menu"]];
    [self.rightBarView addSubview:self.headerImageView];
    [self.rightBarView addSubview:self.downArrowImageView];
    [self.rightBarView addSubview:self.notifyImageView];
    [self.rightBarView addSubview:self.notifyRedView];
    
    
    UIBarButtonItem *rightView = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarView];
    self.navigationItem.rightBarButtonItem = rightView;

    
    [self.rightBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScaleW(80));
        make.height.mas_equalTo(ScaleH(44));
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBarView);
        make.width.height.mas_equalTo(ScaleW(23));
        make.centerY.equalTo(self.rightBarView);
    }];
    [self.downArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView);
        make.bottom.equalTo(self.headerImageView);
        make.width.height.mas_equalTo(ScaleW(6));
    }];
    [self.notifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView.mas_left).offset(-ScaleW(12));
        make.center.equalTo(self.rightBarView);
        make.width.mas_equalTo(ScaleW(12));
        make.height.mas_equalTo(ScaleH(15));
    }];
    [self.notifyRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.notifyImageView).offset(ScaleW(4));
        make.top.equalTo(self.notifyImageView).offset(-ScaleW(4));
        make.width.height.mas_equalTo(ScaleW(7));
    }];

}

- (void)leftBtnAction:(id)sender {
    if (self.sideslipView.hidden) {
        [self.sideslipView showSideslipView];
    }else{
        [self.sideslipView dismissSideslipView];
    }
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.topMenuView];
    [self.contentView addSubview:self.goldAmountView];
    [self.contentView addSubview:self.goldView];
    [self.contentView addSubview:self.tabView];
    [self.contentView addSubview:self.bottomView];
    
    
    [self.view addSubview:self.sideslipView];
    [self.view addSubview:self.downSideslipView];
}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.topMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(ScaleH(48));
        make.width.mas_equalTo(ScreenWidth);
        
    }];
    [self.goldAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMenuView.mas_bottom).offset(ScaleH(13));
        make.left.equalTo(self.contentView).offset(ScaleW(10));
        make.right.equalTo(self.contentView).offset(-ScaleW(10));
        make.height.mas_equalTo(ScaleH(55));
    }];
    [self.goldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldAmountView.mas_bottom).offset(ScaleH(10));
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldView.mas_bottom).offset(ScaleH(10));
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(KWJTabViewItemHeight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabView.mas_bottom).offset(ScaleH(10));
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self updateTabViewLayoutWithIndex:0];
}

- (void)mvvmBinding {

}

#pragma mark -- Public Method

#pragma mark -- Method Method
- (void)headerTapClick {
    if ([[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        self.downSideslipView.hidden = !self.downSideslipView.hidden;
    }else{
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)notifyImageTapClick {
    RG_Message_ViewController *vc = [[RG_Message_ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- OtherDelegate
//RG_Main_TopMenuViewDelegate
- (void)topMenuSelectedWithType:(RG_Main_TopMenuSelectedType)menuType {
    if (menuType == RG_Main_TopMenuSelectedType_Guess) {//竞猜
    }
    if (menuType == RG_Main_TopMenuSelectedType_Rank) {//排行榜
        RG_RankListViewController *vc = [[RG_RankListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (menuType == RG_Main_TopMenuSelectedType_FAQ) {//FAQ
        RG_FAQViewController *vc = [[RG_FAQViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (menuType == RG_Main_TopMenuSelectedType_Lottery) {//开奖
        RG_OpenLotteryViewController *vc = [[RG_OpenLotteryViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//RG_Main_GoldAmountViewDelegate
- (void)didSelectedWallet {
    //我的资产
    RG_MyCoinViewController *vc = [[RG_MyCoinViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectedAmountButton {
    
}


//RG_SideslipViewDelegate
- (void)didSelectedSideslipWithIndex:(NSInteger)index {
    if (index == 0) {//抢金
        
    }
    if (index == 1) {//我的推广
        RG_MyPromote_ViewController *vc = [[RG_MyPromote_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 2) {//Roll点比大小
        RG_RollViewController *vc = [[RG_RollViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 3) {//帮助中心
        RG_HelpCenterViewController *vc = [[RG_HelpCenterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 4) {//app下载
        RG_APPDown_ViewController *vc = [[RG_APPDown_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//RG_DownSidelipViewDelegate
- (void)didSelectedDownSideslipWithIndex:(NSInteger)index {
    if (index == 0) {//用户信息
        RG_UserProfileViewController *vc = [[RG_UserProfileViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 1) {//我的资产
        RG_MyCoinViewController *vc = [[RG_MyCoinViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 2) {//安全设置
        RG_SafeCenterViewController *vc = [[RG_SafeCenterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 3) {//支付密码
        RG_PayPwdViewController *vc = [[RG_PayPwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 4) {//钱包地址
        RG_WithdrawAddressViewController *vc = [[RG_WithdrawAddressViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 5) {//退出
        [[NSNotificationCenter defaultCenter]postNotificationName:kLogoutSuccessNotifition object:nil];
        [SSKJ_User_Tool clearUserInfo];
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//RG_Main_RGoldViewDelegate
- (void)didSelectedPickMeClick {
    RG_BankePoorDoorViewController *vc = [[RG_BankePoorDoorViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didSelectedBetWithPrice:(NSString *)price beishu:(NSString *)beishu {
    if (self.goldView.betButton.selected) {
        [self fetchTouzhuDataWithPrice:price beishu:beishu];
    }else{
        [self fetchEscapeDataWithPrice:price beishu:beishu];
    }
}
#pragma mark -- FetchData

- (void)fetchTouzhuDataWithPrice:(NSString *)price beishu:(NSString *)beishu {
    WS(weakSelf);
    //    下注类型 cny，pb,usdt
    NSDictionary *params = @{@"type":@"",
                             @"money":price?:@"",
                             @"escape_beishu":beishu?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Order_add_post_post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}
- (void)fetchEscapeDataWithPrice:(NSString *)price beishu:(NSString *)beishu {
    WS(weakSelf);
    //    下注类型 cny，pb,usdt
    NSDictionary *params = @{@"type":@"",
                             @"money":price?:@"",
                             @"escape_beishu":beishu?:@""};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Order_escape_post_post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}
#pragma mark -- Getter Method
- (UIView *)rightBarView {
    if (!_rightBarView) {
        _rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        _rightBarView.backgroundColor = kMainNavbarColor;
        _rightBarView.userInteractionEnabled = YES;
    }
    return _rightBarView;
}
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.layer.cornerRadius = ScaleW(23/2);
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.image = [UIImage imageNamed:@"headerProfile"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapClick)];
        [_headerImageView addGestureRecognizer:tap];
    }
    return _headerImageView;
}
- (UIImageView *)notifyImageView {
    if (!_notifyImageView) {
        _notifyImageView = [[UIImageView alloc]init];
        _notifyImageView.image = [UIImage imageNamed:@"mine_notify"];
        _notifyImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notifyImageTapClick)];
        [_notifyImageView addGestureRecognizer:tap];
    }
    return _notifyImageView;
}
- (UIImageView *)downArrowImageView {
    if (!_downArrowImageView) {
        _downArrowImageView = [[UIImageView alloc]init];
        _downArrowImageView.image = [UIImage imageNamed:@"mine_downArrow"];
    }
    return _downArrowImageView;
}

- (UIView *)notifyRedView {
    if (!_notifyRedView) {
        _notifyRedView = [[UIView alloc]init];
        _notifyRedView.layer.cornerRadius = ScaleW(7/2);
        _notifyRedView.layer.masksToBounds = YES;
        _notifyRedView.backgroundColor = [UIColor redColor];
    }
    return _notifyRedView;
}

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
- (RG_Main_TopMenuView *)topMenuView {
    if (!_topMenuView) {
        _topMenuView = [[RG_Main_TopMenuView alloc]init];
        _topMenuView.backgroundColor = kMainSubBackgroundColor;
        _topMenuView.delegate = self;
    }
    return _topMenuView;
}
- (RG_Main_GoldAmountView *)goldAmountView {
    if (!_goldAmountView) {
        _goldAmountView = [[RG_Main_GoldAmountView alloc]init];
        _goldAmountView.delegate = self;
    }
    return _goldAmountView;
}
- (RG_Main_RGoldView *)goldView {
    if (!_goldView) {
        _goldView = [[RG_Main_RGoldView alloc]init];
        _goldView.delegate = self;
    }
    return _goldView;
}
- (RG_Main_BottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[RG_Main_BottomView alloc]init];
    }
    return _bottomView;
}


- (RG_SideslipView *)sideslipView {
    if (!_sideslipView) {
        _sideslipView = [[RG_SideslipView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar)];
        _sideslipView.hidden = YES;
        _sideslipView.delegate = self;
    }
    return _sideslipView;
}
- (RG_DownSidelipView *)downSideslipView {
    if (!_downSideslipView) {
        _downSideslipView = [[RG_DownSidelipView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleW(100), 0, ScaleW(100), ScaleH(250))];
        _downSideslipView.hidden = YES;
        _downSideslipView.delegate = self;
    }
    return _downSideslipView;
}

- (WJTabView *)tabView {
    if (!_tabView) {
        _tabView = [[WJTabView alloc]init];
        _tabView.dataSource = self;
        _tabView.delegate = self;
        
    }
    return _tabView;
}

- (void)updateTabViewLayoutWithIndex:(NSInteger)index {
    
    [self.tabView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldView.mas_bottom).offset(ScaleH(10));
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.mas_equalTo(ScreenWidth);
        if (index == 0) {
            make.height.mas_equalTo(self.allGuessVC.tableView.contentSize.height+KWJTabViewItemHeight);
        }
        if (index == 1) {
            make.height.mas_equalTo(self.myGuessVC.tableView.contentSize.height+KWJTabViewItemHeight);
        }
        if (index == 2) {
            make.height.mas_equalTo(self.lotteryHistoryVC.tableView.contentSize.height+KWJTabViewItemHeight);
        }
    }];
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabView.mas_bottom).offset(ScaleH(10));
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [self.tabView layoutIfNeeded];
}

#pragma mark -- WJTabViewDatsSource
- (NSArray *)titlesOfTabView:(WJTabView *)tabView {
    return @[Localized(@"所有竞猜", nil),
             Localized(@"我的竞猜", nil),
             Localized(@"开奖历史", nil)];
}
- (UIView *)tabView:(WJTabView *)tabView didScrollToPageIndx:(NSInteger)index {
    switch (index) {
            case 0:
            return self.allGuessVC.view;
            break;
            case 1:
            return self.myGuessVC.view;
            break;
            case 2:
            return self.lotteryHistoryVC.view;
            break;
        default:
            break;
    }
    return nil;
}

- (void)tabView:(WJTabView *)tabView didSelectedPageIndex:(NSInteger)index {
    [self updateTabViewLayoutWithIndex:index];
}
- (RG_Mine_LotteryHistoryViewController *)lotteryHistoryVC {
    if (!_lotteryHistoryVC) {
        _lotteryHistoryVC = [[RG_Mine_LotteryHistoryViewController alloc]init];
        [self addChildViewController:_lotteryHistoryVC];
    }
    return _lotteryHistoryVC;
}
- (RG_Mine_MyGuessViewController *)myGuessVC {
    if (!_myGuessVC) {
        _myGuessVC = [[RG_Mine_MyGuessViewController alloc]init];
        [self addChildViewController:_myGuessVC];
    }
    return _myGuessVC;
}
- (RG_Mine_AllGuessViewController *)allGuessVC {
    if (!_allGuessVC) {
        _allGuessVC = [[RG_Mine_AllGuessViewController alloc]init];
        [self addChildViewController:_allGuessVC];
    }
    return _allGuessVC;
}

@end
