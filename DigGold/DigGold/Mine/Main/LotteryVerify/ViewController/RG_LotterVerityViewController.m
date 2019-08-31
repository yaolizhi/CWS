//
//  RG_LotterVerityViewController.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_LotterVerityViewController.h"
#import "RG_LotterVerityTableViewCell.h"
#import "RG_LotterVerityHeaderView.h"
#import "RG_VerityModel.h"
@interface RG_LotterVerityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RG_LotterVerityHeaderView *headerView;
@property (nonatomic, copy) NSString *hashS;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation RG_LotterVerityViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithHash:(NSString *)hash
{
    self = [super init];
    if (self) {
        self.hashS = hash;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self addRightNavgationItemWithImage:[UIImage imageNamed:@"cancel_image"]];
    [self addLeftNavItemWithTitle:@"开奖校验"];
    self.view.backgroundColor = kMainBackgroundColor;
    [self.view addSubview:self.tableView];
    [self setupMasnory];
    [self mvvmBinding];
    self.headerView.accountTF.text = self.hashS?:@"";
    
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self setupHeaderView];
}

- (void)mvvmBinding {
    
}

- (void)fetchVerityData {
    WS(weakSelf);
    NSDictionary *params = @{@"hash":self.hashS?:@"",
                             @"num":self.headerView.codeTF.text?:@""};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Vcerify_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            weakSelf.dataArray = [RG_VerityModel mj_objectArrayWithKeyValuesArray:netWorkModel.data[@"list"]];
            [weakSelf.tableView reloadData];
        }else{
        }
        
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}


- (void)setupHeaderView {
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.tableView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.tableView layoutIfNeeded];
}

- (void)leftBtnAction:(id)sender {
    
}

- (void)rigthBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)veritybuttonClick {
    [self fetchVerityData];
}
#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_LotterVerityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithIndexPath:indexPath];
    [cell configureCellModel:self.dataArray[indexPath.row]];
    return cell;
}
#pragma mark -- Getter Method
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[RG_LotterVerityTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (RG_LotterVerityHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[RG_LotterVerityHeaderView alloc]init];
        _headerView.backgroundColor = kMainBackgroundColor;
        [_headerView.veritybutton addTarget:self action:@selector(veritybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}
#pragma mark -- Setter Method
@end
