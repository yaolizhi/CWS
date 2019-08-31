//
//  RG_BillRecord_ViewController.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_BillRecord_ViewController.h"

#import "RG_BillRecord_Cell.h"

#import "RG_BillRecord_TopView.h"
#import "DatePickerView.h"
#import "RG_BillRecordModel.h"
static NSString * cellID = @"billRecordCell";

@interface RG_BillRecord_ViewController ()<UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) RG_BillRecord_TopView *topView;
@property (nonatomic, copy) NSString *startDataString;
@property (nonatomic, copy) NSString *endDataString;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, assign) RG_BillRecordType type;
@end

@implementation RG_BillRecord_ViewController

- (instancetype)initWithCoinType:(RG_BillRecordType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"账单流水", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self tableView];
    self.tableView.tableHeaderView = self.topView;
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

- (NSString *)fetchCurnData {
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    return dateStr;
}

- (void)fetchData {
    WS(weakSelf);

//    [RCHUDPop popupMessage:@"" toView:nil];
    NSString *type = (self.type ==RG_BillRecordType_JC)?@"pb":@"cny";
    NSDictionary *params = @{@"money_type":type,
                             @"start_time":self.startDataString.length==0?[self fetchCurnData]:self.startDataString,
                             @"end_time":self.endDataString.length==0?[self fetchCurnData]:self.endDataString,
                             @"page":@(self.currentPage)};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_BillList_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop dismissHUDToView:nil];
          
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf endRefresh];
                [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 100, ScreenWidth, ScreenHeight-Height_NavBar-ScaleH(44)-100)];
                return;
            }
            
            
            weakSelf.totalPage = [netWorkModel.data[@"count_page"] integerValue];
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *newArray = [RG_BillRecordModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
            [weakSelf.dataArray addObjectsFromArray:newArray];
            [weakSelf.tableView reloadData];
            [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 100, ScreenWidth, ScreenHeight-Height_NavBar-ScaleH(44)-100)];
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
- (void)startButtonClick {
    DatePickerView *picker = [[DatePickerView alloc]initWithFrame:CGRectZero type:DateTypeOfStart dataString:nil];
    picker.delegate = self;
    [picker showDataPickView];
}

- (void)endButtonClick {
    if (self.startDataString.length == 0) {
        [RCHUDPop popupTipText:@"请先选择开始日期" toView:nil];
        return;
    }
    DatePickerView *picker = [[DatePickerView alloc]initWithFrame:CGRectZero type:DateTypeOfEnd dataString:self.startDataString];
    picker.delegate = self;
    [picker showDataPickView];
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    if (type == DateTypeOfStart) {
        self.startDataString = date;
        [self.topView.startbtn setTitle:self.startDataString?:@"" forState:UIControlStateNormal];
    }
    if (type == DateTypeOfEnd) {
        self.endDataString = date;
        [self.topView.endbtn setTitle:self.endDataString?:@"" forState:UIControlStateNormal];
    }
}

- (void)searchButtonClick {
    if (self.startDataString.length ==0 ||
        self.endDataString.length == 0) {
        [RCHUDPop popupTipText:@"请选择搜索日期范围" toView:nil];
        return;
    }
    [self fetchData];
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return 60;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return 100;
//    }
//    return 10;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [UIView new];
//
//    view.backgroundColor = kMainBackgroundColor;
//
//    if (section == 0)
//    {
//
//        return self.topView;
//    }
//
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RG_BillRecord_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    [cell configureWithModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma mark -- 懒加载 --
- (RG_BillRecord_TopView *)topView {
    if (!_topView) {
        _topView = [[RG_BillRecord_TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        [_topView.startbtn addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView.endbtn addTarget:self action:@selector(endButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView.searchBtn addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}
#pragma mark -- 创建表 --
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = kMainBackgroundColor;
        
        _tableView.tableFooterView = [UIView new];
//        _tableView.rowHeight = 60;
        _tableView.estimatedRowHeight = 60;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[RG_BillRecord_Cell class] forCellReuseIdentifier:cellID];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@(0));
            
            make.left.equalTo(@0);
            
            make.width.equalTo(@(ScreenWidth));
            
            make.height.equalTo(@(ScreenHeight - Height_NavBar));
        }];
        
    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
