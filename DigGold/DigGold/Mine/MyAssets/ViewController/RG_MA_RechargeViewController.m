//
//  RG_MA_RechargeViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_MA_RechargeViewController.h"
#import "RG_MA_RechargeTableViewCell.h"
#import "RG_RechargeModel.h"
@interface RG_MA_RechargeViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RG_MA_RechargeViewController

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
    
    [self setupMasnory];
    [self mvvmBinding];
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
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_ChongzhiList_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
//                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                [weakSelf endRefresh];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar-ScaleH(44))];
                return;
            }
            
            weakSelf.totalPage = [netWorkModel.data[@"count_page"] integerValue];
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *newArray = [RG_RechargeModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
            [weakSelf.dataArray addObjectsFromArray:newArray];
            [weakSelf.tableView reloadData];
            [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar-ScaleH(44))];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        [weakSelf endRefresh];
        [RCHUDPop dismissHUDToView:nil];
    
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

- (void)setupMasnory {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.equalTo(self.view);
    }];
}


#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_MA_RechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithModel:self.dataArray[indexPath.row]];
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
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[RG_MA_RechargeTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}
#pragma mark -- Setter Method
@end
