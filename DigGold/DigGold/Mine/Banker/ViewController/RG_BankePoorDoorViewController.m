//
//  RG_BankePoorDoorViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_BankePoorDoorViewController.h"
#import "RG_BP_MainViewController.h"
#import "RG_BP_LeaderViewController.h"
#import "RG_BP_HistoryViewController.h"
#import "WJTabView.h"
@interface RG_BankePoorDoorViewController ()<WJTabViewDatsSource,WJTabViewDelegate>
@property (nonatomic, strong) RG_BP_MainViewController *bpMainVC;
@property (nonatomic, strong) RG_BP_LeaderViewController *leaderVC;
@property (nonatomic, strong) RG_BP_HistoryViewController *historyVC;

@property (nonatomic, strong) WJTabView *tabView;
@end

@implementation RG_BankePoorDoorViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithCoinType:(NSString *)coinType
{
    self = [super init];
    if (self) {
        self.selectedCoinS = coinType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"庄家奖池", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self.view addSubview:self.tabView];
    [self setupMasnory];
    [self mvvmBinding];
    [self.tabView triggerActionWithIndex:0];
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight-Height_NavBar);
    }];
}

- (NSArray *)titlesOfTabView:(WJTabView *)tabView {
    return @[Localized(@"主页", nil),
             Localized(@"坐庄", nil),
             Localized(@"历史", nil)];
}

- (UIView *)tabView:(WJTabView *)tabView didScrollToPageIndx:(NSInteger)index {
    
    switch (index) {
        case 0:
            return self.bpMainVC.view;
            break;
        case 1:
            return self.leaderVC.view;
            break;
        case 2:
            return self.historyVC.view;
            break;
        default:
            break;
    }
    return nil;
}

- (void)tabView:(WJTabView *)tabView didSelectedPageIndex:(NSInteger)index {
    if (index == 0 && self.bpMainVC) {
        [self.bpMainVC updateData];
    }
    if (index == 1 && self.leaderVC) {
        [self.leaderVC updateData];
    }
    if (index == 2 && self.historyVC) {
        [self.historyVC updateData];
    }
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate


- (void)setSelectedCoinS:(NSString *)selectedCoinS {
    _selectedCoinS = selectedCoinS;
    self.bpMainVC.selectedCoinS = _selectedCoinS;
}
#pragma mark -- Getter Method
- (RG_BP_MainViewController *)bpMainVC {
    if (!_bpMainVC) {
        _bpMainVC = [[RG_BP_MainViewController alloc]initWithCoinType:self.selectedCoinS];
        [self addChildViewController:_bpMainVC];
    }
    return _bpMainVC;
}
- (RG_BP_LeaderViewController *)leaderVC {
    if (!_leaderVC) {
        _leaderVC = [[RG_BP_LeaderViewController alloc]initWithCoinType:self.selectedCoinS];
        [self addChildViewController:_leaderVC];
    }
    return _leaderVC;
}
- (RG_BP_HistoryViewController *)historyVC {
    if (!_historyVC) {
        _historyVC = [[RG_BP_HistoryViewController alloc]initWithCoinType:self.selectedCoinS];
        [self addChildViewController:_historyVC];
    }
    return _historyVC;
}

- (WJTabView *)tabView {
    if (!_tabView) {
        _tabView = [[WJTabView alloc]init];
        _tabView.dataSource = self;
        _tabView.delegate = self;
        
    }
    return _tabView;
}
#pragma mark -- Setter Method
@end
