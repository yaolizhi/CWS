//
//  RG_MainViewController.m
//  DigGold
//
//  Created by James on 2019/1/9.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_MainViewController.h"
#import "RG_Main_TopMenuView.h"
#import "RG_Main_GoldAmountView.h"
#import "RG_Main_RGoldView.h"
#import "RG_Main_BottomView.h"
#import "RG_SideslipView.h"
#import "RG_DownSidelipView.h"
#import "RG_LoginViewController.h"
#import "RG_RollViewController.h"
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
#import "RG_kMainPrepareModel.h"
#import "RG_kMainProcessModel.h"
#import "RG_kMainCrashModel.h"
#import "RG_PullDownView.h"
#import "RG_Mine_LotteryModel.h"
#import "RG_XiaZhuModel.h"
#import "RG_BottomPlayIntroView.h"
#import "RG_EscapeModel.h"
#import "RG_AgencyViewController.h"
#import "DG_AlertUpdateView.h"

typedef enum : NSUInteger {
    RG_DrawBezierState_CountDown,//倒计时
    RG_DrawBezierState_DrawLine,//划线
    RG_DrawBezierState_Crash,//逃跑
} RG_DrawBezierState;
@interface RG_MainViewController ()
<YNPageViewControllerDataSource,
YNPageViewControllerDelegate,
RG_Main_TopMenuViewDelegate,
RG_Main_GoldAmountViewDelegate,
RG_SideslipViewDelegate,
RG_DownSidelipViewDelegate,
RG_Main_RGoldViewDelegate,
ManagerSocketDelegate,
RG_PullDownViewDelegate,
WJBezierCurveViewDelegate,
RG_Main_BottomViewDelegat>
@property (nonatomic, strong) RG_Mine_LotteryHistoryViewController *lotteryVC;
@property (nonatomic, strong) RG_Mine_AllGuessViewController *allGuessVC;
@property (nonatomic, strong) RG_Mine_MyGuessViewController *myGuessVC;
//bottom
@property (nonatomic, strong) RG_Main_BottomView *mainBottomView;

//nav
@property (nonatomic, strong) UIView *rightBarView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *notifyImageView;
@property (nonatomic, strong) UILabel *notifyMyLabel;
@property (nonatomic, strong) UIImageView *downArrowImageView;
@property (nonatomic, strong) UIView *notifyRedView;
@property (nonatomic, strong) UIButton *loginButton;

//header
@property (nonatomic, strong) UIView *scrollHeaderView;
@property (nonatomic, strong) RG_Main_TopMenuView *topMenuView;
@property (nonatomic, strong) RG_Main_GoldAmountView *goldAmountView;
@property (nonatomic, strong) RG_Main_RGoldView *goldView;
@property (nonatomic, strong) RG_SideslipView *sideslipView;
@property (nonatomic, strong) RG_DownSidelipView *downSideslipView;
@property (nonatomic, strong) UIView *downSidesBgView;


@property (nonatomic, strong) NSArray *amountTitlesArray;
@property (nonatomic, strong) NSArray *amountIconsArray;
@property (nonatomic, strong) RG_PullDownView *pullDownView;
@property (nonatomic, copy) NSString *selectedCoinType;//选择币的类型

@property (nonatomic, assign) RG_DrawBezierState drawBezierState;//记录draw的s状态
@property (nonatomic, strong) RG_BottomPlayIntroView *bottomPlayIntroView;

//所有竞猜数据数组
@property (nonatomic, strong) NSMutableArray *allGuessDataArray;
@property (nonatomic, strong) RG_BetStatusModel *betStatusModel;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation RG_MainViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super initPageViewControllerWithControllers:[self getArrayVCs]
                                                 titles:[self getArrayTitles]
                                                 config:[self suspendCenterPageVC]];
    if (self) {
        self.allGuessDataArray = [[NSMutableArray alloc]init];
        self.betStatusModel = [[RG_BetStatusModel alloc]init];
        self.amountTitlesArray = @[@"0.000000USDT",@"0.000000USDT"];
//        self.amountIconsArray = @[@"mine_coin",@"USDT-smallicon"];
        self.amountIconsArray = @[@"USDT-smallicon",@"USDT-smallicon"];
        self.selectedCoinType = @"USDT";
        self.dataSource = self;
        self.delegate = self;
        self.headerView = self.scrollHeaderView;
        self.bottomView = self.mainBottomView;
        self.pageIndex = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.bottomPlayIntroView) {
//        self.bottomPlayIntroView.hidden = NO;
        [self fetchMessageData];
//    }
    NSDictionary *commonDic = [[SSKJ_User_Tool sharedUserTool]getCommonData];
    if (!commonDic ||
        commonDic.allKeys.count == 0) {
        [self fetchCommonData];//获取元数据
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clearCacheBetInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BSG";
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupNavbar];
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
    
    
//    UIWebView *web = [[UIWebView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ProductBaseServer]];
//    web.hidden = YES;
//    //    web.delegate = self;
//    [web loadRequest:request];
//    [[UIApplication sharedApplication].keyWindow addSubview:web];
    
    
    //获取高度
    CGFloat height = [self.scrollHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.scrollHeaderView.height = height;
    [self reloadSuspendHeaderViewFrame];
    [self scrollToTop:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:kLoginSuccessNotifition object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutSuccess) name:kLogoutSuccessNotifition object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateHeaderSuccess:) name:kUpdateHeaderSuccessNotifition object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WebConnentSuccess) name:kWebConnentSuccessNotifition object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WebConnentFailed) name:kWebSocketConnentFailedNotifition object:nil];
    
//    [self.view addSubview:self.bottomPlayIntroView];
    [self openGCDTimer];
    [self fetchVersionUpdateDataWithLaunch:YES];
}

#pragma mark -- Private Method


- (void)WebConnentSuccess {
    [RCHUDPop popupTipText:@"网络异常" toView:self.view];
    [[ManagerSocket sharedManager]closeConnectSocket];
    if (![[ManagerSocket sharedManager]socketIsConnected]) {
        [self socrktDrawLine];
    }
}
- (void)WebConnentFailed {
//    [RCHUDPop popupTipText:@"游戏连接失败" toView:self.view];
    [[ManagerSocket sharedManager]closeConnectSocket];
    if (![[ManagerSocket sharedManager]socketIsConnected]) {
        [self socrktDrawLine];
    }
}

- (void)updateHeaderSuccess:(NSNotification *)notification {
    [self fetchUserInfoData];
}

- (void)loginSuccess {
    self.notifyImageView.hidden = NO;
    self.notifyRedView.hidden = NO;
    self.headerImageView.hidden = NO;
    self.downArrowImageView.hidden = NO;
    self.loginButton.hidden = YES;
    self.notifyMyLabel.hidden = NO;
    [self fetchUserInfoData];
    
}
- (void)logoutSuccess {
    self.notifyImageView.hidden = YES;
    self.notifyRedView.hidden = YES;
    self.headerImageView.hidden = YES;
    self.downArrowImageView.hidden = YES;
    self.loginButton.hidden = NO;
    self.downSidesBgView.hidden = YES;
    self.notifyMyLabel.hidden = YES;
    
    //归零
    self.amountTitlesArray = @[@"0.000000USDT",@"0.000000USDT"];
    self.selectedCoinType = @"USDT";
    self.pullDownView.titlesArray = self.amountTitlesArray;
    [self.goldAmountView.amountButton setTitle:self.amountTitlesArray[0] forState:UIControlStateNormal];
    [self.goldAmountView.amountButton setImage:[UIImage imageNamed:self.amountIconsArray[0]] forState:UIControlStateNormal];
    [self.goldView.betSettingView configureViewSelectedCoinType:self.selectedCoinType];//获取币类型，判断是哪种最大值
    self.headerImageView.image = [UIImage imageNamed:@"headerProfile"];
}

- (void)mvvmBinding {
//    [self socrktDrawLine];
    [RCHUDPop popupMessage:@"" toView:self.view];
    [ManagerSocket sharedManager].delegate = self;
    [self fetchUserInfoData];
    [self fetchEveryOpenAwardsData];
    [self.goldView.betSettingView configureViewSelectedCoinType:self.selectedCoinType];//获取币类型，判断是哪种最大值
}

//长连接划线
- (void)socrktDrawLine {
    [RCHUDPop popupMessage:@"" toView:self.view];
//    NSLog(@"开始链接链接开始链接链接开始链接链接开始链接链接");
    NSString *type = [WLTools wlDictionaryToJson:@{@"op":@"look"}];
    [[ManagerSocket sharedManager]openConnectSocketWithConnectSuccess:^{
//        NSLog(@"已经链接已经链接已经链接已经链接已经链接已经链接已经链接");
//        if (!self.timer) {
//            [self openGCDTimer];
//        }
        [[ManagerSocket sharedManager]socketSendMsg:type];
    }];
    [ManagerSocket sharedManager].delegate = self;
}
- (void)socketDidReciveData:(id)data {
    [RCHUDPop dismissHUDToView:self.view];
    NSDictionary *dicData = (NSDictionary *)data;
    WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:dicData];
    NSArray *dataArray = netWorkModel.data;
    if (![dataArray isKindOfClass:[NSArray class]] || dataArray.count == 0) {
        return;
    }
    
    if ([netWorkModel.status integerValue] == 0) {//展示
        
    }
    if ([netWorkModel.status integerValue] == 1) {//倒计时
        self.timeInterval = [self dateTimeDifference];
//        NSLog(@"倒计时倒计时倒计时倒计时倒计时倒计时倒计时倒计时倒计时");
        
        self.drawBezierState = RG_DrawBezierState_CountDown;
        NSDictionary *prepareDic = dataArray[0];
        RG_kMainPrepareModel *model = [RG_kMainPrepareModel mj_objectWithKeyValues:prepareDic[@"prepare"]];
        BOOL isJC = [self.selectedCoinType isEqualToString:@"JC"]?YES:NO;
        [self.goldView.curveView setupCountDownWithPerpareModel:model isJCCoin:isJC];
        
        NSDictionary *xiazhuDic = dataArray[1];
        NSArray *xiazhuArray = [RG_XiaZhuModel mj_objectArrayWithKeyValuesArray:xiazhuDic[@"xiazhu_list"]];
        [self.allGuessVC updateTableViewDataWithDataArray:xiazhuArray];
    }
    if ([netWorkModel.status integerValue] == 2) {//划线中
        self.timeInterval = [self dateTimeDifference];
//        NSLog(@"划线中划线中划线中划线中划线中划线中划线中划线中划线中");
        self.drawBezierState = RG_DrawBezierState_DrawLine;
        NSDictionary *prepareDic = dataArray[0];
        RG_kMainProcessModel *model = [RG_kMainProcessModel mj_objectWithKeyValues:prepareDic[@"process"]];
        
        NSDictionary *xiazhuDic = dataArray[1];
        NSArray *xiazhuArray = [RG_XiaZhuModel mj_objectArrayWithKeyValuesArray:xiazhuDic[@"xiazhu_list"]];
        [self.allGuessVC updateTableViewDataWithDataArray:xiazhuArray];
        
        NSDictionary *escapeDic = dataArray[2];
        NSArray *escape_list = [RG_EscapeModel mj_objectArrayWithKeyValuesArray:escapeDic[@"escape_list"]];
        BOOL isJC = [self.selectedCoinType isEqualToString:@"JC"]?YES:NO;
        [self.goldView.curveView setupDrawLinWithProcessModel:model isJCCoin:isJC escapeList:escape_list];
        
        
    }
    if ([netWorkModel.status integerValue] == 3) {//爆炸了
        self.timeInterval = [self dateTimeDifference];
//        NSLog(@"爆炸了爆炸了爆炸了爆炸了爆炸了爆炸了爆炸了爆炸了爆炸了");
        self.drawBezierState = RG_DrawBezierState_Crash;
        NSDictionary *prepareDic = dataArray[0];
        RG_kMainCrashModel *model = [RG_kMainCrashModel mj_objectWithKeyValues:prepareDic[@"crash"]];
        BOOL isJC = [self.selectedCoinType isEqualToString:@"JC"]?YES:NO;
        [self.goldView.curveView setupCrashWithCrashModel:model isJCCoin:isJC];
        
        NSDictionary *xiazhuDic = dataArray[1];
        NSArray *xiazhuArray = [RG_XiaZhuModel mj_objectArrayWithKeyValuesArray:xiazhuDic[@"xiazhu_list"]];
        [self.allGuessVC updateTableViewDataWithDataArray:xiazhuArray];
    }
}

#pragma mark -- Method Method
- (void)headerTapClick {
    if ([[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        self.downSidesBgView.hidden = !self.downSidesBgView.hidden;
        if (!self.downSidesBgView.hidden) {
            [self.sideslipView dismissSideslipView];
        }
    }else{
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)notifyImageTapClick {
    self.downSidesBgView.hidden = YES;
    [self.sideslipView dismissSideslipView];
    RG_Message_ViewController *vc = [[RG_Message_ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)menuButtonClick {
    
    if (self.sideslipView.hidden) {
        self.downSidesBgView.hidden = YES;
        [self.sideslipView showSideslipView];
    }else{
        [self.sideslipView dismissSideslipView];
    }
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
//        RG_FAQViewController *vc = [[RG_FAQViewController alloc]initWithSelectedType:RG_FAQType_QJ];
//        [self.navigationController pushViewController:vc animated:YES];
        
        RG_RankListViewController *vc = [[RG_RankListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    if (menuType == RG_Main_TopMenuSelectedType_Lottery) {//开奖
//        RG_OpenLotteryViewController *vc = [[RG_OpenLotteryViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if (menuType == RG_Main_TopMenuSelectedType_Fair) {//公平
        RG_FAQViewController *vc = [[RG_FAQViewController alloc]initWithSelectedType:RG_FAQType_GP];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (menuType == RG_Main_TopMenuSelectedType_AppDown) {//app下载
        RG_APPDown_ViewController *vc = [[RG_APPDown_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//RG_Main_GoldAmountViewDelegate
- (void)didSelectedWallet {
    if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //我的资产
    RG_MyCoinViewController *vc = [[RG_MyCoinViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//RG_PullDownViewDelegate
- (void)didSelectedPullDownTitle:(nonnull NSString *)title {
    NSString *iconS = @"";
    if ([title containsString:@"JC"]) {
        self.selectedCoinType = @"JC";
        iconS = self.amountIconsArray[0];
    }
    if ([title containsString:@"USDT"]) {
        self.selectedCoinType = @"USDT";
        iconS = self.amountIconsArray[1];
    }
    self.goldAmountView.amountButton.selected = !self.goldAmountView.amountButton.selected;
    [self dismissSideslipView];
    [self.goldAmountView.amountButton setTitle:title forState:UIControlStateNormal];
    [self.goldAmountView.amountButton setImage:[UIImage imageNamed:iconS] forState:UIControlStateNormal];
    [self.goldView.betSettingView configureViewSelectedCoinType:title];
}

- (void)didSelectedAmountButton {
    [self fetchUserInfoData];
    if (self.goldAmountView.amountButton.selected) {
        [self dismissSideslipView];
    }else{
        [self showSideslipView];
    }
    self.goldAmountView.amountButton.selected = !self.goldAmountView.amountButton.selected;
}

//RG_SideslipViewDelegate
- (void)didSelectedSideslipWithIndex:(NSInteger)index {
    if (index == 0) {
        
    }
//    if (index == 1) {//全民代理
//        if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
//            RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//        RG_AgencyViewController *vc = [[RG_AgencyViewController alloc]initWithSelectedType:RG_AgencyViewType_DLJH];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
    if (index == 1) {//我的推广
        if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
            RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        RG_MyPromote_ViewController *vc = [[RG_MyPromote_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 2) {//帮助中心
        RG_HelpCenterViewController *vc = [[RG_HelpCenterViewController alloc]initWithSelectedType:RG_HelpCenterType_YYXY];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 3) {//app下载
        RG_APPDown_ViewController *vc = [[RG_APPDown_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 4) {//版本升级
        [self fetchVersionUpdateDataWithLaunch:NO];
    }
}

//RG_DownSidelipViewDelegate
- (void)didSelectedDownSideslipWithIndex:(NSInteger)index {
    self.downSidesBgView.hidden = !self.downSidesBgView.hidden;
    
    if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
//    if (index == 0) {//战绩
//        RG_UserProfileViewController *vc = [[RG_UserProfileViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if (index == 0) {//我的资产
        RG_MyCoinViewController *vc = [[RG_MyCoinViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 1) {//安全设置
        RG_SafeCenterViewController *vc = [[RG_SafeCenterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 2) {//通知中心
        RG_Message_ViewController *vc = [[RG_Message_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 3) {//支付密码
        RG_PayPwdViewController *vc = [[RG_PayPwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 4) {//退出
        [[NSNotificationCenter defaultCenter]postNotificationName:kLogoutSuccessNotifition object:nil];
        [SSKJ_User_Tool clearUserInfo];
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//RG_Main_BottomViewDelegat
- (void)didSelectedBottomViewWithTitle:(NSString *)title {
    if ([title isEqualToString:@"用户协议"]) {
        RG_HelpCenterViewController *vc = [[RG_HelpCenterViewController alloc]initWithSelectedType:RG_HelpCenterType_YYXY];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([title isEqualToString:@"隐私协议"]) {
        RG_HelpCenterViewController *vc = [[RG_HelpCenterViewController alloc]initWithSelectedType:RG_HelpCenterType_YSZC];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([title isEqualToString:@"帮助中心"]) {
        RG_HelpCenterViewController *vc = [[RG_HelpCenterViewController alloc]initWithSelectedType:RG_HelpCenterType_JSWT];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([title isEqualToString:@"APP下载"]) {
        RG_APPDown_ViewController *vc = [[RG_APPDown_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//RG_Main_RGoldViewDelegate
- (void)didSelectedPickMeClick {
    if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    RG_BankePoorDoorViewController *vc = [[RG_BankePoorDoorViewController alloc]initWithCoinType:self.selectedCoinType];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 点击按钮方法
- (void)didSelectedBetWithPrice:(NSString *)price beishu:(NSString *)beishu {
    
    if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        RG_LoginViewController *vc = [[RG_LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (self.drawBezierState == RG_DrawBezierState_CountDown) {
        if (!self.betStatusModel.hasBet && !self.betStatusModel.isWaiting) {//还没有投注，并且不是等待中
            self.betStatusModel.recordCoinType = self.selectedCoinType;
            [self fetchTouzhuDataWithPrice:price
                                    beishu:beishu];
        }
    }
    if (self.drawBezierState == RG_DrawBezierState_DrawLine) {
        if (self.betStatusModel.hasBet) {
            [self fetchEscapeDataWithPrice:self.betStatusModel.recordBetNumber
                                    beishu:self.betStatusModel.recordEscapeNumber];
        }else{
            if (self.betStatusModel.cacheHasBet) {
                [self clearCacheBetInfo];
            }else{
                self.betStatusModel.cacheBetNumber = price?:@"";
                self.betStatusModel.cacheEscapeNumber = beishu?:@"";
                self.betStatusModel.cacheCoinType = self.selectedCoinType;
                self.betStatusModel.cacheHasBet = YES;
            }
    
        }
    }
}

- (void)clearCacheBetInfo {
    self.betStatusModel.cacheHasRequest = NO;
    self.betStatusModel.cacheBetNumber = @"";
    self.betStatusModel.cacheEscapeNumber = @"";
    self.betStatusModel.cacheCoinType = @"";
    self.betStatusModel.cacheHasBet = NO;
}

- (void)fetchAppointNextBet {
    if (self.betStatusModel.cacheHasBet && !self.betStatusModel.cacheHasRequest) {
        self.betStatusModel.cacheHasRequest = YES;
        self.betStatusModel.recordCoinType = self.betStatusModel.cacheCoinType;
        [self fetchTouzhuDataWithPrice:self.betStatusModel.cacheBetNumber
                                beishu:self.betStatusModel.cacheEscapeNumber];
    }
}

//WJBezierCurveViewDelegate
#pragma mark -- 倒计时回调方法
- (void)curveCountDownForce {//倒计时回调
    [self fetchAppointNextBet];//自动下注下一局
    [self.goldView setupBetButtonCountdownWithModel:self.betStatusModel];
    
}

#pragma mark -- 划线回调方法
- (void)curveDrawLineForceWithPoint:(NSString *)point {//划线回调
    
}

#pragma mark -- 时间变化回调方法
- (void)curveChangeTimeForceWithPoint:(NSString *)point {
    
    NSString *newPoint = F(@"%.2f", [point floatValue] * [self.betStatusModel.recordBetNumber floatValue]);
    self.betStatusModel.changeTimes = F(@"%@ %@", newPoint,self.betStatusModel.recordCoinType?:@"");
    if (self.betStatusModel.hasBet) {
        if ([point floatValue] >= [self.betStatusModel.recordEscapeNumber floatValue]) {
            self.betStatusModel.hasBet = NO;
            self.betStatusModel.hasEscape = YES;
        }
    }
    [self.goldView setupBetButtonDrawLineWithModel:self.betStatusModel];
}
#pragma mark -- 爆炸回调方法
- (void)curveCrashForce {//爆炸回调
    self.betStatusModel.hasBet = NO;
    [self.goldView setupBetButtonBombWithModel:self.betStatusModel];
    
    //延迟更新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fetchEveryOpenAwardsData];//爆炸更新每期开奖
        [self fetchUserInfoData];//爆炸后更新
    });
}

#pragma mark -- FetchData

- (void)fetchTouzhuDataWithPrice:(NSString *)price beishu:(NSString *)beishu {
    //    下注类型 pb,usdt
    WS(weakSelf);
    NSString *type = @"pb";
    if ([self.betStatusModel.recordCoinType isEqualToString:@"JC"]) {
        type = @"pb";
    }
    if ([self.betStatusModel.recordCoinType isEqualToString:@"USDT"]) {
        type = @"cny";
    }
    NSDictionary *params = @{@"type":type,
                             @"money":@([price floatValue]),
                             @"escape_beishu":@([beishu floatValue])};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Order_add_post_post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            if (weakSelf.betStatusModel.cacheHasBet) {
                weakSelf.betStatusModel.hasBet = weakSelf.betStatusModel.cacheHasBet;
                weakSelf.betStatusModel.recordBetNumber = weakSelf.betStatusModel.cacheBetNumber;
                weakSelf.betStatusModel.recordEscapeNumber = weakSelf.betStatusModel.cacheEscapeNumber;
                weakSelf.betStatusModel.recordCoinType = weakSelf.betStatusModel.cacheCoinType;
            }else{
                weakSelf.betStatusModel.hasBet = YES;
                weakSelf.betStatusModel.recordBetNumber = price?:@"";
                weakSelf.betStatusModel.recordEscapeNumber = beishu?:@"";
                weakSelf.betStatusModel.recordCoinType = weakSelf.selectedCoinType;
            }
            [self clearCacheBetInfo];
            
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }else{
            [self clearCacheBetInfo];
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [self clearCacheBetInfo];
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}
- (void)fetchEscapeDataWithPrice:(NSString *)price beishu:(NSString *)beishu {
    //    下注类型 cny，pb,usdt
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Order_escape_post_post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            weakSelf.betStatusModel.hasBet = NO;
            weakSelf.betStatusModel.hasEscape = YES;
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
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
            
            WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
            SSKJ_UserInfo_Model *model = [SSKJ_UserInfo_Model mj_objectWithKeyValues:netWorkModel.data];
            [[SSKJ_User_Tool sharedUserTool]saveUserInfoWithModel:model];
            NSString *url = model.upic.length>0?F(@"%@%@",ProductBaseServer, model.upic):@"headerProfile";
            if ([url containsString:@"http"]) {
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:url]];
            }else{
                self.headerImageView.image = [UIImage imageNamed:url];
            }
    
            weakSelf.amountTitlesArray = @[F(@"%fJC", model.balance_pb),F(@"%fUSDT", model.balance_cny)];
            weakSelf.pullDownView.titlesArray = weakSelf.amountTitlesArray;
            if ([weakSelf.selectedCoinType isEqualToString:@"JC"]) {
                [weakSelf.goldAmountView.amountButton setTitle:F(@"%@", weakSelf.amountTitlesArray[0]) forState:UIControlStateNormal];
                [weakSelf.goldAmountView.amountButton setImage:[UIImage imageNamed:self.amountIconsArray[0]] forState:UIControlStateNormal];
            }
            if ([weakSelf.selectedCoinType isEqualToString:@"USDT"]) {
                [weakSelf.goldAmountView.amountButton setTitle:F(@"%@ (1USDT = $1)", weakSelf.amountTitlesArray[1]) forState:UIControlStateNormal];
                [weakSelf.goldAmountView.amountButton setImage:[UIImage imageNamed:self.amountIconsArray[1]] forState:UIControlStateNormal];
            }
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}

- (void)fetchEveryOpenAwardsData {
    WS(weakSelf);
    NSDictionary *params = @{@"page":@(1),
                             @"size":@(5)};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Lottery_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            NSArray *newArray = [RG_Mine_LotteryModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
            [weakSelf.goldView configureViewWithArray:newArray];
        }else{
        }
        
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}

- (void)fetchMessageData {
    WS(weakSelf);
    NSDictionary *params = @{@"account":[[SSKJ_User_Tool sharedUserTool]getAccount]?:@""};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Notice_list_Post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
//                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                weakSelf.notifyRedView.hidden = YES;
                return;
            }
            
            NSInteger isRed = [netWorkModel.data[@"out_show_red"] integerValue];
            
            if ([[SSKJ_User_Tool sharedUserTool]isLogingState]) {
                weakSelf.notifyRedView.hidden = !isRed;
            }else{
                weakSelf.notifyRedView.hidden = YES;
            }
        }else{
            
        }
        
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
        
    }];
}

- (void)fetchVersionUpdateDataWithLaunch:(BOOL)isLaunch {
//    WS(weakSelf);
    NSDictionary *params = @{@"version":AppVersion,
                             @"type":@(2)};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_CheckVersion_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 0) {
            if (isLaunch) {
                
            }else{
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            }
        }
        if ([netWorkModel.status integerValue] == 200) {
            
            NSString *version = netWorkModel.data[@"version"];
            NSString *title = netWorkModel.data[@"title"];
            NSString *content = netWorkModel.data[@"content"];
            NSString *addr = netWorkModel.data[@"addr"];
            NSInteger uptype = [netWorkModel.data[@"uptype"] integerValue];
            DG_AlertUpdateStyle style = uptype == 1?DG_AlertUpdateStyle_Force:DG_AlertUpdateStyle_Optional;
            DG_AlertUpdateView *alertUpdate = [[DG_AlertUpdateView alloc]initWithStyle:style
                                                                                 title:title
                                                                               version:version
                                                                               content:content clickBlock:^{
                if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:addr]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:addr]];
                }else{
                    [RCHUDPop popupTipText:@"无效链接" toView:self.view];
                }
            }];
            [alertUpdate showAlertUpdateView];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
        
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
            [[SSKJ_User_Tool sharedUserTool]saveCommonDataWithDic:(NSDictionary *)netWorkModel.data];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.goldView.betSettingView configureViewSelectedCoinType:weakSelf.selectedCoinType];//获取币类型，判断是哪种最大值
            });
            
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
    }];
}





























































































#pragma mark -- Private Method
- (void)setupNavbar {
    
    if ([[SSKJ_User_Tool sharedUserTool] isLogingState]) {
        self.notifyImageView.hidden = NO;
        self.notifyRedView.hidden = NO;
        self.headerImageView.hidden = NO;
        self.downArrowImageView.hidden = NO;
        self.loginButton.hidden = YES;
        self.notifyMyLabel.hidden = NO;
    }else{
        self.notifyImageView.hidden = YES;
        self.notifyRedView.hidden = YES;
        self.headerImageView.hidden = YES;
        self.downArrowImageView.hidden = YES;
        self.loginButton.hidden = NO;
        self.notifyMyLabel.hidden = YES;
    }
    [self.rightBarView addSubview:self.headerImageView];
    [self.rightBarView addSubview:self.downArrowImageView];
    [self.rightBarView addSubview:self.notifyImageView];
    [self.rightBarView addSubview:self.notifyRedView];
    [self.rightBarView addSubview:self.loginButton];
    [self.rightBarView addSubview:self.notifyMyLabel];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScaleW(150), Height_NavBar-Height_StatusBar)];
    UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScaleW(60), Height_NavBar-Height_StatusBar)];
    [menuButton setImage:[UIImage imageNamed:@"mine_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:menuButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    
    
    UIBarButtonItem *rightView = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarView];
    self.navigationItem.rightBarButtonItem = rightView;
    
    //登录
    self.loginButton.width = ScaleW(40);
    self.loginButton.height = ScaleW(40);
    self.loginButton.centerY = self.rightBarView.centerY;
    self.loginButton.left = ScaleW(150)-ScaleW(40);
    
    //头像
    self.headerImageView.width = ScaleW(30);
    self.headerImageView.height = ScaleW(30);
    self.headerImageView.centerY = self.rightBarView.centerY;
    self.headerImageView.left = ScaleW(150)-ScaleW(30);
    
    self.downArrowImageView.width = ScaleW(6);
    self.downArrowImageView.height = ScaleW(6);
    self.downArrowImageView.top = self.headerImageView.bottom-ScaleW(5);
    self.downArrowImageView.left = ScaleW(150)-ScaleW(6)-1;

    //通知
    self.notifyMyLabel.width = ScaleW(30);
    self.notifyMyLabel.height = ScaleW(30);
    self.notifyMyLabel.left = self.headerImageView.left-ScaleW(30)-ScaleW(10);
    self.notifyMyLabel.centerY = self.rightBarView.centerY;

    //通知Image
    self.notifyImageView.width = ScaleW(15);
    self.notifyImageView.height = ScaleH(18);
    self.notifyImageView.left = self.headerImageView.left-ScaleW(58)-ScaleW(15);
    self.notifyImageView.centerY = self.rightBarView.centerY;
    
    //通知红点
    self.notifyRedView.width = ScaleW(7);
    self.notifyRedView.height = ScaleW(7);
    self.notifyRedView.left = self.notifyImageView.right+ScaleW(2);
    self.notifyRedView.top = self.notifyImageView.top-ScaleW(4);

}

- (void)setupUI {
    [self.scrollHeaderView addSubview:self.topMenuView];
    [self.scrollHeaderView addSubview:self.goldAmountView];
    [self.scrollHeaderView addSubview:self.goldView];
    [self.scrollHeaderView addSubview:self.pullDownView];
    
    [self.view addSubview:self.sideslipView];
    [self.view addSubview:self.downSidesBgView];
    [self.downSidesBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.downSidesBgView addSubview:self.downSideslipView];
    [self.downSideslipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.downSidesBgView);
        make.top.equalTo(self.downSidesBgView);
    }];
    
}
- (void)setupMasnory {
    [self.topMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollHeaderView);
        make.height.mas_equalTo(ScaleH(48));
        make.width.mas_equalTo(ScreenWidth);
        
    }];
    [self.goldAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMenuView.mas_bottom).offset(ScaleH(13));
        make.left.equalTo(self.scrollHeaderView).offset(ScaleW(10));
        make.right.equalTo(self.scrollHeaderView).offset(-ScaleW(10));
        make.height.mas_equalTo(ScaleH(55));
    }];
    
    [self.pullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldAmountView.mas_bottom).offset(-ScaleH(6));
        make.left.equalTo(self.goldAmountView).offset(ScaleW(12));
        make.right.equalTo(self.goldAmountView).offset(-ScaleW(52));
//        make.width.equalTo(self.goldAmountView);
        make.height.mas_equalTo(0);
    }];
    
    [self.goldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldAmountView.mas_bottom).offset(ScaleH(10));
        make.left.equalTo(self.scrollHeaderView);
        make.right.equalTo(self.scrollHeaderView);
        make.bottom.equalTo(self.scrollHeaderView);
    }];
    
}

- (YNPageConfigration *)suspendCenterPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.lineWidthEqualFontWidth = NO;
    configration.scrollViewBackgroundColor = kMainBackgroundColor;
    configration.selectedItemColor = kMainTitleColor;
    configration.normalItemColor = kMainGaryWhiteColor;
    configration.lineColor = kMainTitleColor;
    configration.bottomLineBgColor = kLineColor;
    configration.showBottomView = YES;
    
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.showBottomLine = YES;
    configration.itemFont = [UIFont systemFontOfSize:ScaleW(14)];
    configration.selectedItemFont = [UIFont systemFontOfSize:ScaleW(14)];
    configration.lineHeight = ScaleW(2);
    configration.bottomLineHeight = ScaleW(2);
    configration.menuHeight = ScaleH(44);
    configration.bottomLineLeftAndRightMargin = ScaleW(15);
    configration.lineLeftAndRightMargin = ScaleW(15);
    
    
    
    CGFloat height = [self.mainBottomView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.mainBottomView.height = height;
    configration.bottomViewHeight = height;
    
    return configration;
}


- (NSArray *)getArrayVCs {
    
    return @[self.allGuessVC, self.myGuessVC,self.lotteryVC];
}

- (NSArray *)getArrayTitles {
    return @[@"我的竞猜", @"我的订单",@"开奖历史"];
}
#pragma mark -- OtherDelegate

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[RG_Mine_AllGuessViewController class]]) {
        return ((RG_Mine_AllGuessViewController *)vc).tableView;
    }
    if ([vc isKindOfClass:[RG_Mine_MyGuessViewController class]]) {
        return ((RG_Mine_MyGuessViewController *)vc).tableView;
    }
    if ([vc isKindOfClass:[RG_Mine_LotteryHistoryViewController class]]) {
        return ((RG_Mine_LotteryHistoryViewController *)vc).tableView;
    }
    return nil;
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    
}

#pragma mark -- Getter Method

- (RG_Mine_AllGuessViewController *)allGuessVC {
    if (!_allGuessVC) {
        _allGuessVC = [[RG_Mine_AllGuessViewController alloc]init];
    }
    return _allGuessVC;
}
- (RG_Mine_MyGuessViewController *)myGuessVC {
    if (!_myGuessVC) {
        _myGuessVC = [[RG_Mine_MyGuessViewController alloc]init];
    }
    return _myGuessVC;
}
- (RG_Mine_LotteryHistoryViewController *)lotteryVC {
    if (!_lotteryVC) {
        _lotteryVC = [[RG_Mine_LotteryHistoryViewController alloc]init];
    }
    return _lotteryVC;
}


#pragma makr --Nav
- (UIView *)rightBarView {
    if (!_rightBarView) {
        _rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScaleW(150), Height_NavBar-Height_StatusBar)];
        _rightBarView.backgroundColor = kMainNavbarColor;
        _rightBarView.userInteractionEnabled = YES;
        
    }
    return _rightBarView;
}
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.layer.cornerRadius = ScaleW(15);
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.image = [UIImage imageNamed:@"headerProfile"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapClick)];
        [_headerImageView addGestureRecognizer:tap];
        _headerImageView.hidden = YES;
    }
    return _headerImageView;
}
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_loginButton addTarget:self action:@selector(headerTapClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UILabel *)notifyMyLabel {
    if (!_notifyMyLabel) {
        _notifyMyLabel = [[UILabel alloc]init];
        _notifyMyLabel.text = @"我的";
        _notifyMyLabel.textColor = kMainGaryWhiteColor;
        _notifyMyLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        _notifyMyLabel.hidden = YES;
        _notifyMyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _notifyMyLabel;
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
        _downArrowImageView.hidden = YES;
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


#pragma mark --BottomView
- (RG_Main_BottomView *)mainBottomView {
    if (!_mainBottomView) {
        _mainBottomView = [[RG_Main_BottomView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScaleH(100))];
        _mainBottomView.delegate = self;
    }
    return _mainBottomView;
}

#pragma mark --HeaderView
- (UIView *)scrollHeaderView {
    if (!_scrollHeaderView) {
        _scrollHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScaleH(590))];
    }
    return _scrollHeaderView;
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
        _goldAmountView = [[RG_Main_GoldAmountView alloc]initWithFrame:CGRectZero titlesArray:self.amountTitlesArray];
        _goldAmountView.delegate = self;
    }
    return _goldAmountView;
}
- (RG_Main_RGoldView *)goldView {
    if (!_goldView) {
        _goldView = [[RG_Main_RGoldView alloc]init];
        _goldView.delegate = self;
        _goldView.curveView.delegate = self;
    }
    return _goldView;
}

#pragma makr sides
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
        _downSideslipView = [[RG_DownSidelipView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleW(100), 0, ScaleW(100), ScaleH(35)*6+ScaleH(16))];
//        _downSideslipView.hidden = YES;
        _downSideslipView.delegate = self;
    }
    return _downSideslipView;
}

- (UIView *)downSidesBgView {
    if (!_downSidesBgView) {
        _downSidesBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar)];
        _downSidesBgView.backgroundColor = [UIColor clearColor];
        _downSidesBgView.hidden = YES;
    }
    return _downSidesBgView;
}


- (RG_PullDownView *)pullDownView {
    if (!_pullDownView) {
        _pullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:self.amountTitlesArray];
        _pullDownView.delegate = self;
        _pullDownView.bgColor = kMainBackgroundColor;
        _pullDownView.hidden = YES;
//        _pullDownView.iconsArray = @[@"mine_coin",@"USDT-smallicon"];
        _pullDownView.iconsArray = @[@"USDT-smallicon",@"USDT-smallicon"];
        _pullDownView.showIntro = YES;
    }
    return _pullDownView;
}

- (void)showSideslipView {
    self.pullDownView.hidden = NO;
    [self.pullDownView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PullDownViewCellHeight*self.amountTitlesArray.count);
        }];
        [self.pullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissSideslipView {
    [self.pullDownView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.pullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


//- (RG_BottomPlayIntroView *)bottomPlayIntroView {
//    if (!_bottomPlayIntroView) {
//        _bottomPlayIntroView = [[RG_BottomPlayIntroView alloc]initWithFrame:CGRectZero];
//    }
//    return _bottomPlayIntroView;
//}


//处理点击触碰点
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [self.sideslipView.layer convertPoint:point fromLayer:self.view.layer];
    if ([self.sideslipView.layer containsPoint:point]) {
        [self.sideslipView dismissSideslipView];
    }
    
    CGPoint downpoint = [[touches anyObject] locationInView:self.view];
    downpoint = [self.downSidesBgView.layer convertPoint:downpoint fromLayer:self.view.layer];
    if ([self.downSidesBgView.layer containsPoint:downpoint]) {
        self.downSidesBgView.hidden = YES;
    }
}

- (NSTimeInterval)dateTimeDifference{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    NSDate *endD = [formatter dateFromString:currentDateString];
    NSTimeInterval start = [endD timeIntervalSince1970]*1;
    return start;
}

- (void)monitorDrawLineStopWithInterval:(NSTimeInterval)timeInterval {
    NSTimeInterval endTimeInt = [self dateTimeDifference];
    NSTimeInterval startTimeInt = timeInterval;
    NSInteger space = endTimeInt - startTimeInt;
    if (space > SpaceTimes) {
//        NSLog(@"链接停了链接停了链接停了链接停了链接停了链接停了链接停了链接停了");
        [[NSNotificationCenter defaultCenter]postNotificationName:kWebSocketConnentFailedNotifition object:nil];
    }
}

//开启倒计时定时器
- (void)openGCDTimer {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(SpaceTimes*NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf timerAction];
    });
    dispatch_resume(self.timer);
}

- (void)timerAction {
    if (![[ManagerSocket sharedManager]socketIsConnected]) {
        [self monitorDrawLineStopWithInterval:self.timeInterval];
    }
    
}
@end
