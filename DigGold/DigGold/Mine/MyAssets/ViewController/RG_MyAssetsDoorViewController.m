//
//  RG_MyAssetsDoorViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_MyAssetsDoorViewController.h"
#import "RG_MA_WithdrawViewController.h"
#import "RG_MA_RechargeViewController.h"
#import "WJTabView.h"
@interface RG_MyAssetsDoorViewController ()<WJTabViewDatsSource>
@property (nonatomic, strong) RG_MA_WithdrawViewController *withdrawVC;
@property (nonatomic, strong) RG_MA_RechargeViewController *rechargeVC;
@property (nonatomic, strong) WJTabView *tabView;
@end

@implementation RG_MyAssetsDoorViewController

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
    self.title = Localized(@"我的资产", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    
    [self.view addSubview:self.tabView];
    [self setupMasnory];
    [self mvvmBinding];

}



#pragma mark -- Private Method

- (void)setupMasnory {
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (NSArray *)titlesOfTabView:(WJTabView *)tabView {
    return @[Localized(@"充币记录", nil),
             Localized(@"提币记录", nil)];
}

- (UIView *)tabView:(WJTabView *)tabView didScrollToPageIndx:(NSInteger)index {
    
    switch (index) {
        case 0:
            return self.rechargeVC.view;
            break;
        case 1:
            return self.withdrawVC.view;
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (RG_MA_WithdrawViewController *)withdrawVC {
    if (!_withdrawVC) {
        _withdrawVC = [[RG_MA_WithdrawViewController alloc]init];
        [self addChildViewController:_withdrawVC];
    }
    return _withdrawVC;
}
- (RG_MA_RechargeViewController *)rechargeVC {
    if (!_rechargeVC) {
        _rechargeVC = [[RG_MA_RechargeViewController alloc]init];
        [self addChildViewController:_rechargeVC];
    }
    return _rechargeVC;
}
- (WJTabView *)tabView {
    if (!_tabView) {
        _tabView = [[WJTabView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar)];
        _tabView.dataSource = self;
    }
    return _tabView;
}
#pragma mark -- Setter Method
@end
