//
//  RG_RankListViewController.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_RankListViewController.h"
#import "RG_RankListTableViewCell.h"
#import "RG_RankListView.h"
#import "RG_RankListModel.h"
@interface RG_RankListViewController ()<UITableViewDelegate,UITableViewDataSource,RG_RankListViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RG_RankListView *headerView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *coinTitlesArray;
@property (nonatomic, strong) NSArray *coinDataTitlesArray;
@property (nonatomic, strong) NSArray *wayTitlesArray;

@property (nonatomic, strong) NSString *coinTitle;
@property (nonatomic, strong) NSString *wayTitle;
@end

@implementation RG_RankListViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.coinTitlesArray = @[@"USDT"];
        self.wayTitlesArray = @[@"最高盈利",@"投注总额"];
//        self.coinTitle = @"pb";//cny
        self.coinTitle = @"cny";//cny
        self.wayTitle = @"zuigao";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"排行榜", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupUI];
    [self setupMasnory];
    [self reloadLoadMoreData];
}


- (void)reloadLoadMoreData {
    self.currentPage = 1;
    WS(weakSelf);
    self.dataArray = [[NSMutableArray alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf fetchData];
    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.currentPage ++;
//        if (weakSelf.currentPage > weakSelf.totalPage) {
//            weakSelf.currentPage = weakSelf.totalPage;
//            [self.tableView.mj_footer endRefreshing];
//        }else{
//            [weakSelf fetchData];
//        }
//    }];
    [self fetchData];
}

- (void)fetchData {
    WS(weakSelf);
    NSDictionary *params = @{@"money_type":self.coinTitle?:@"",
                             @"type":self.wayTitle?:@"",
                             @"page":@(self.currentPage),
                             @"size":@(10)};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Leaderboard_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf endRefresh];
                return;
            }
            
            
            weakSelf.totalPage = [netWorkModel.data[@"count_page"] integerValue];
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *newArray = [RG_RankListModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
            [weakSelf.dataArray addObjectsFromArray:newArray];
            [weakSelf.tableView reloadData];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        [weakSelf endRefresh];
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        [weakSelf endRefresh];
    }];
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupMasnory {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.equalTo(self.view);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.tableView);
    }];
    [self.tableView layoutIfNeeded];
}


#pragma mark -- Public Method

#pragma mark -- OtherDelegate
- (void)didSelectedRankWithTitle:(NSString *)title {
    if ([title isEqualToString:@"JC"]) {
        self.coinTitle = @"pb";
    }
    if ([title isEqualToString:@"USDT"]) {
        self.coinTitle = @"cny";
    }
    if ([title isEqualToString:@"最高盈利"]) {
        self.headerView.inputLabel.text = title;
        self.wayTitle = @"zuigao";
    }
    if ([title isEqualToString:@"投注总额"]) {
        self.headerView.inputLabel.text = title;
        self.wayTitle = @"leiji";
    }
    [self.dataArray removeAllObjects];
    self.currentPage = 1;
    [self fetchData];
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_RankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RG_RankListModel *model = self.dataArray[indexPath.row];
    [cell configureCellWithIndex:indexPath.row model:model type:self.wayTitle];
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
        _tableView.estimatedSectionHeaderHeight = 44;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[RG_RankListTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (RG_RankListView *)headerView {
    if (!_headerView) {
        _headerView = [[RG_RankListView alloc]initWithFrame:CGRectZero
                                            coinTitlesArray:self.coinTitlesArray
                                             wayTitlesArray:self.wayTitlesArray
                                                  coinTitle:self.coinTitlesArray[0]
                                                   wayTitle:self.wayTitlesArray[0]];
        _headerView.backgroundColor = kMainBackgroundColor;
        _headerView.delegate = self;
    }
    return _headerView;
}
#pragma mark -- Setter Method
@end
