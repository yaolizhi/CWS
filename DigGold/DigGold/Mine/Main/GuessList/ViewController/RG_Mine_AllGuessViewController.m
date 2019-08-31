//
//  RG_Mine_AllGuessViewController.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mine_AllGuessViewController.h"
#import "RG_Mine_AllGuessTableViewCell.h"
#import "RG_Mine_AllGuessHeaderView.h"
@interface RG_Mine_AllGuessViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) RG_Mine_AllGuessHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation RG_Mine_AllGuessViewController

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

#pragma mark -- Private Method

- (void)setupMasnory {

}

- (void)mvvmBinding {
    
}

- (void)updateTableViewDataWithDataArray:(NSArray *)dataArray {
    NSMutableArray *newArray = [[NSMutableArray alloc]init];

    for (RG_XiaZhuModel *model in dataArray) {
        if ([model.uid isEqualToString:[[SSKJ_User_Tool sharedUserTool]getUID]]) {

            [newArray addObject:model];
            break;
        }
    }
    self.dataArray = newArray;
    [self.tableView reloadData];
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RG_Mine_AllGuessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithIndexPath:indexPath];
    RG_XiaZhuModel *model = self.dataArray[indexPath.row];
    [cell configureCellWithModel:model];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}


#pragma mark -- Getter Method
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[RG_Mine_AllGuessTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}


- (RG_Mine_AllGuessHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[RG_Mine_AllGuessHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScaleH(48))];
        _headerView.backgroundColor = kMainBackgroundColor;
    }
    return _headerView;
}


@end
