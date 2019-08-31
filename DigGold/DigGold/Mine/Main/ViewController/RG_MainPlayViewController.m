//
//  RG_MainPlayViewController.m
//  DigGold
//
//  Created by James on 2019/1/13.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_MainPlayViewController.h"
#import "RG_QuestionHeaderView.h"
#import "RG_QuestionTableViewCell.h"
#import "RG_QuestionSectionView.h"
#import "RG_CommonModel.h"
@interface RG_MainPlayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *subTitlesArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RG_MainPlayViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc]init];
        self.subTitlesArray = @[];
 
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kMainBackgroundColor;
    [self.view addSubview:self.tableView];
    self.title = @"";
    [self addRightNavgationItemWithImage:[UIImage imageNamed:@"cancel_image"]];
    [self addLeftNavItemWithTitle:@"玩法介绍"];
    [self setupMasnory];
    [self mvvmBinding];
    NSDictionary *dic= [[SSKJ_User_Tool sharedUserTool]getCommonData];
    if (dic && dic.allKeys.count > 0) {
        NSDictionary *playInfo = dic[@"play_info"];
        NSArray *gameArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"game"]];
        
        self.subTitlesArray = gameArray.count==0?@[]:gameArray;
        [self.tableView reloadData];
    }
}

- (void)rigthBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBtnAction:(id)sender {
    
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)mvvmBinding {
    [self fetchCommonData];
}

- (void)fetchCommonData {
    NSDictionary *params = @{};
    WS(weakSelf);
    [self.dataArray removeAllObjects];
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Common_data_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            [[SSKJ_User_Tool sharedUserTool]saveCommonDataWithDic:(NSDictionary *)netWorkModel.data];
            NSDictionary *playInfo = netWorkModel.data[@"play_info"];
            NSArray *gameArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"game"]];
            
            weakSelf.subTitlesArray = gameArray.count==0?@[]:gameArray;
            [weakSelf.tableView reloadData];
            
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
    }];
}




#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.subTitlesArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithModel:self.subTitlesArray[indexPath.row]];
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
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 44;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[RG_QuestionTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}
#pragma mark -- Setter Method
@end
