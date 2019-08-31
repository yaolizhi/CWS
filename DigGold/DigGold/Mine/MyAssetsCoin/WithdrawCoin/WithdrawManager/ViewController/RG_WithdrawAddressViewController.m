//
//  RG_WithdrawAddressViewController.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_WithdrawAddressViewController.h"
#import "RG_WithdrawAddressTableViewCell.h"
#import "RG_AddWAddressViewController.h"
#import "RG_WithdrawModel.h"
@interface RG_WithdrawAddressViewController ()<RG_WithdrawAddressTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addCoinAddressButton;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RG_WithdrawAddressViewController

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
    self.title = Localized(@"钱包地址管理", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupMasnory];
    [self mvvmBinding];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyClick) name:@"kAddCoinAdressSuccess" object:nil];
}

- (void)notifyClick {
    [self reloadLoadMoreData];
}
- (void)mvvmBinding {
    [self reloadLoadMoreData];
}
- (void)reloadLoadMoreData {

    [self fetchData];
}
- (void)fetchData {
    WS(weakSelf);
    NSDictionary *params = @{@"page":@(self.currentPage)};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Show_Address_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
//                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                [weakSelf endRefresh];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar-ScaleH(66))];
                return;
            }
            
            if (((NSArray *)netWorkModel.data).count>0) {
                if (weakSelf.currentPage == 1) {
                    [weakSelf.dataArray removeAllObjects];
                }
                NSArray *newArray = [RG_WithdrawModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
                weakSelf.dataArray = [NSMutableArray arrayWithArray:newArray];
                [weakSelf.tableView reloadData];
            }
             [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar-ScaleH(66))];
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

- (void)setupMasnory {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addCoinAddressButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.equalTo(self.addCoinAddressButton.mas_top).offset(-ScaleH(30));
    }];
    [self.addCoinAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScaleW(14));
        make.right.equalTo(self.view).offset(-ScaleW(14));
        make.height.mas_equalTo(ScaleH(45));
        make.bottom.equalTo(self.view.mas_bottom).offset(-ScaleH(35));

    }];
}


#pragma mark -- Public Method
- (void)addCoinAddressButtonClick {
    RG_AddWAddressViewController *vc = [[RG_AddWAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- OtherDelegate

- (void)didDeleteAddressWithIndex:(NSInteger)index {
    RG_WithdrawModel *model = self.dataArray[index];
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"id":@([model.id integerValue])};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Del_Address_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            [weakSelf reloadLoadMoreData];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}
#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_WithdrawAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell configureCell:self.dataArray[indexPath.row] index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
        [_tableView registerClass:[RG_WithdrawAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (UIButton *)addCoinAddressButton {
    if (!_addCoinAddressButton) {
        _addCoinAddressButton = [[UIButton alloc]init];
        [_addCoinAddressButton setTitle:Localized(@"添加提币地址", nil) forState:UIControlStateNormal];
        [_addCoinAddressButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _addCoinAddressButton.layer.cornerRadius = ScaleW(5);
        _addCoinAddressButton.layer.masksToBounds = YES;
        _addCoinAddressButton.backgroundColor = kMainTitleColor;
        _addCoinAddressButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_addCoinAddressButton addTarget:self action:@selector(addCoinAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCoinAddressButton;
}
#pragma mark -- Setter Method
@end
