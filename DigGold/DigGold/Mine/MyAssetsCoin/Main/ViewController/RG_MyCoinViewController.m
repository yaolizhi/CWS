//
//  RG_MyCoinViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_MyCoinViewController.h"
#import "RG_MyCoinTableViewCell.h"
#import "RG_MyAssetsDoorViewController.h"
#import "RG_BillRecord_ViewController.h"
#import "RG_AM_RCViewController.h"
#import "RG_AM_WCViewController.h"
#import "RG_AMJQCZViewController.h"
@interface RG_MyCoinViewController ()
<UITableViewDelegate,
UITableViewDataSource,
RG_MyCoinTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *moneyArray;

@end

@implementation RG_MyCoinViewController

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
    self.title = Localized(@"我的资产",nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
//    self.titlesArray = @[@"JC",@"USDT"];
//    self.moneyArray = @[@"0.00",@"0.00"];
    self.titlesArray = @[@"USDT"];
    self.moneyArray = @[@"0.00"];
    
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(carrayCoin) name:kCarrayCoinSuccessNotifition object:nil];
}

- (void)carrayCoin {
    [self fetchUserInfoData];
}

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.tableView];
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf fetchUserInfoData];
    }];
    
}

- (void)setupMasnory {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.equalTo(self.view);
    }];
}

- (void)mvvmBinding {
    [self fetchUserInfoData];
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
                [weakSelf endRefresh];
                return;
            }
            
            WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
            SSKJ_UserInfo_Model *model = [SSKJ_UserInfo_Model mj_objectWithKeyValues:netWorkModel.data];
            [[SSKJ_User_Tool sharedUserTool]saveUserInfoWithModel:model];
            weakSelf.moneyArray = @[F(@"%f", model.balance_cny)];
            [weakSelf.tableView reloadData];
            [weakSelf endRefresh];
        }else{
            [weakSelf endRefresh];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [weakSelf endRefresh];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate
- (void)clickButtonWithType:(RGMyCoinCellClickType)type isJCCoin:(BOOL)isJCCoin{
    if (type == RGMyCoinCellClickType_Trade) {
        if (isJCCoin) {
            return;
        }
        RG_MyAssetsDoorViewController *vc = [[RG_MyAssetsDoorViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (type == RGMyCoinCellClickType_Account) {
        if (isJCCoin) {
            RG_BillRecord_ViewController *vc = [[RG_BillRecord_ViewController alloc]initWithCoinType:RG_BillRecordType_JC];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            RG_BillRecord_ViewController *vc = [[RG_BillRecord_ViewController alloc]initWithCoinType:RG_BillRecordType_USDT];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    if (type == RGMyCoinCellClickType_RechargeCoin) {
        if (isJCCoin) {
            return;
        }
        RG_AMJQCZViewController *vc = [[RG_AMJQCZViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (type == RGMyCoinCellClickType_CrrayCoin) {
        if (isJCCoin) {
            return;
        }
        RG_AM_WCViewController *vc = [[RG_AM_WCViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_MyCoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell configureCellWithTitle:self.titlesArray[indexPath.row]
                           money:self.moneyArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark -- Getter Method
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
//                _tableView.estimatedSectionHeaderHeight = 44;
//                _tableView.estimatedSectionFooterHeight = 44;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[RG_MyCoinTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}
#pragma mark -- Setter Method
@end
