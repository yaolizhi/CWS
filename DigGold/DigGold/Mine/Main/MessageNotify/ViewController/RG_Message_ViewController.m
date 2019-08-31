//
//  RG_Message_ViewController.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_Message_ViewController.h"

#import "RG_MessageDetail_ViewController.h"

#import "RG_Message_Cell.h"
#import "RG_MessageModel.h"
static NSString * cellID = @"messageCell";

@interface RG_Message_ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RG_Message_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kMainBackgroundColor;
    
    self.title = @"通知中心";
    
    [self tableView];
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
    NSDictionary *params = @{@"page":@(self.currentPage),
                             @"account":[[SSKJ_User_Tool sharedUserTool]getAccount]};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Notice_list_Post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
//                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                [weakSelf endRefresh];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar)];
                return;
            }
            
            weakSelf.totalPage = [netWorkModel.data[@"count_page"] integerValue];
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *newArray = [RG_MessageModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
            [weakSelf.dataArray addObjectsFromArray:newArray];
            [weakSelf.tableView reloadData];
            [SSKJ_NoDataView showNoData:weakSelf.dataArray toView:weakSelf.tableView frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar)];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RG_Message_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    RG_MessageModel *model = self.dataArray[indexPath.row];
    [cell configureCellWith:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RG_MessageModel *model = self.dataArray[indexPath.row];
    model.is_read = YES;
    RG_MessageDetail_ViewController *vc = [[RG_MessageDetail_ViewController alloc]initWithID:model.id?:@""];
    
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView reloadData];
}



#pragma mark -- 懒加载 --
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
        _tableView.estimatedRowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[RG_Message_Cell class] forCellReuseIdentifier:cellID];
        
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
