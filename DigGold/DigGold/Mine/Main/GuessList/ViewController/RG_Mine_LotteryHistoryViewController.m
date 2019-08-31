//
//  RG_Mine_LotteryHistoryViewController.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mine_LotteryHistoryViewController.h"
#import "RG_Mine_LotteryHistoryTableViewCell.h"
#import "RG_Mine_LotteryHistoryHeaderView.h"
#import "RG_LotterVerityViewController.h"
#import "RG_Mine_LotteryModel.h"
@interface RG_Mine_LotteryHistoryViewController ()
<UITableViewDelegate,UITableViewDataSource,RG_Mine_LHTableViewCellDelegate>

@property (nonatomic, strong) RG_Mine_LotteryHistoryHeaderView *headerView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RG_Mine_LotteryHistoryViewController

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
    self.title = @"";
    self.view.backgroundColor = kMainBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
    [self setupMasnory];
    [self mvvmBinding];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tableView.mj_header &&
        self.tableView.mj_footer) {
        self.currentPage = 1;
        [self fetchData];
    }
}

- (void)updateTableView {
    [self fetchData];
}

- (void)mvvmBinding {
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
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        if (weakSelf.currentPage > weakSelf.totalPage) {
            weakSelf.currentPage = weakSelf.totalPage;
            [self.tableView.mj_footer endRefreshing];
        }else{
            [weakSelf fetchData];
        }
    }];
    [self fetchData];
}

- (void)fetchData {
    WS(weakSelf);
    NSDictionary *params = @{@"page":@(self.currentPage)};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Lottery_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
//                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            weakSelf.totalPage = [netWorkModel.data[@"count_page"] integerValue];
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *newArray = [RG_Mine_LotteryModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
            [weakSelf.dataArray addObjectsFromArray:newArray];
            [weakSelf.tableView reloadData];
        }else{
//            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        [weakSelf endRefresh];
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
//        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        [weakSelf endRefresh];
    }];
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark -- Private Method

- (void)setupMasnory {

}


#pragma mark -- Public Method

#pragma mark -- OtherDelegate
- (void)didSelectedCheckButtonClickWithHash:(NSString *)hash {
    RG_LotterVerityViewController *vc = [[RG_LotterVerityViewController alloc]initWithHash:hash];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_Mine_LotteryHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RG_Mine_LotteryModel *model = self.dataArray[indexPath.row];
    [cell initWithIndexPath:indexPath];
    [cell configureCell:model];
    return cell;
}
#pragma mark -- Getter Method
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = ScaleW(48);
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[RG_Mine_LotteryHistoryTableViewCell class] forCellReuseIdentifier:@"cell"];

    }
    return _tableView;
}

- (RG_Mine_LotteryHistoryHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[RG_Mine_LotteryHistoryHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScaleH(48))];
        _headerView.backgroundColor = kMainBackgroundColor;
    }
    return _headerView;
}


#pragma mark -- Setter Method
@end
