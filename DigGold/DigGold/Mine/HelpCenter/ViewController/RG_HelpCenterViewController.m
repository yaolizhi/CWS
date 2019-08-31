//
//  RG_HelpCenterViewController.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_HelpCenterViewController.h"
#import "RG_QuestionHeaderView.h"
#import "RG_QuestionTableViewCell.h"
#import "RG_QuestionSectionView.h"
#import "RG_CommonModel.h"
@interface RG_HelpCenterViewController ()<UITableViewDelegate,UITableViewDataSource,RG_QuestionSectionViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RG_QuestionHeaderView *headerView;

@property (nonatomic, strong) NSArray *secondTitlesArray;
@property (nonatomic, strong) NSArray *subTitlesArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, assign) RG_HelpCenterType type;
@end

@implementation RG_HelpCenterViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithSelectedType:(RG_HelpCenterType)type
{
    self = [super init];
    if (self) {
        self.type = type;
        self.secondTitlesArray = @[@"",
                                   Localized(@"用户协议", nil),
                                   Localized(@"隐私政策", nil),
                                   Localized(@"常见问题", nil),
                                   Localized(@"手续费", nil),
                                   Localized(@"忘记密码", nil),
                                   Localized(@"注册和登录", nil),
                                   Localized(@"技术问题", nil),
                                   Localized(@"联系我们", nil)];
        self.subTitlesArray = @[@[],
                                @[],
                                @[],
                                @[],
                                @[],
                                @[],
                                @[],
                                @[],
                                @[]];
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"1",@"0",@"0",@"0",@"0",@"0",@"0",@"0",]];

        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"帮助中心", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self.view addSubview:self.tableView];
    
    
    if (self.type == RG_HelpCenterType_YYXY) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"1",@"0",@"0",@"0",@"0",@"0",@"0",@"0",]];

    }
    if (self.type == RG_HelpCenterType_YSZC) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"1",@"0",@"0",@"0",@"0",@"0",@"0",]];

    }
    if (self.type == RG_HelpCenterType_CJWT) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"1",@"0",@"0",@"0",@"0",@"0",]];

    }
    if (self.type == RG_HelpCenterType_SXF) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"1",@"0",@"0",@"0",@"0",]];

    }
    if (self.type == RG_HelpCenterType_WJMM) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"1",@"0",@"0",@"0",]];

    }
    if (self.type == RG_HelpCenterType_ZCDL) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"1",@"0",@"0",]];

    }
    if (self.type == RG_HelpCenterType_JSWT) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"1",@"0",]];

    }
    if (self.type == RG_HelpCenterType_LXWM) {

        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"1",]];
    }
    

    
    [self setupMasnory];
    [self mvvmBinding];
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
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Common_data_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            [[SSKJ_User_Tool sharedUserTool]saveCommonDataWithDic:(NSDictionary *)netWorkModel.data];
            
            NSDictionary *playInfo = netWorkModel.data[@"help_info"];
            NSArray *reg_agreeArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"reg_agree"]];
            NSArray *wallet_ruleArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"wallet_rule"]];
            NSArray *problemArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"problem"]];
            NSArray *costArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"cost"]];
            NSArray *passwordArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"password"]];
            NSArray *loginArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"login"]];
            NSArray *straitArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"strait"]];
            NSArray *contactArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"contact"]];
            
            weakSelf.subTitlesArray = @[@[],
                                        reg_agreeArray,
                                        wallet_ruleArray,
                                        problemArray,
                                        costArray,
                                        passwordArray,
                                        loginArray,
                                        straitArray,
                                        contactArray];
            [weakSelf.tableView reloadData];
            
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
    }];
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate
- (void)didSelectedWithSection:(NSInteger)section {
    NSString *s = [self.selectedArray objectAtIndex:section];
    if ([s isEqualToString:@"1"]) {
        [self.selectedArray replaceObjectAtIndex:section withObject:@"0"];
        [self.tableView reloadData];
        return;
    }
    
    for (NSInteger i = 0; i<self.selectedArray.count; i++) {
        [self.selectedArray replaceObjectAtIndex:i withObject:@"0"];
    }
    [self.selectedArray replaceObjectAtIndex:section withObject:@"1"];
    [self.tableView reloadData];


}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *selected = self.selectedArray[section];
    if ([selected isEqualToString:@"0"] ||
        section == 0) {
        return 0;
    }else{
        NSArray *array = self.subTitlesArray[section];
        return array.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.secondTitlesArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        RG_QuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Topheader"];
        [headerView configureWithTitle:Localized(@"帮助中心", nil)
                              subTitle:Localized(@"我们的客服团队时刻准备为您服务！您可以24/7全天候联系我们", nil)];
        return headerView;
    }
    
    RG_QuestionSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.delegate = self;
    NSString *title = self.secondTitlesArray[section];
    [headerView configureViewWithTitle:title section:section];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    RG_QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section != 0) {
        NSArray *modelArray = self.subTitlesArray[indexPath.section];
        [cell configureCellWithModel:modelArray[indexPath.row]];
    }
    return cell;
}

#pragma mark -- Getter Method
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar) style:UITableViewStyleGrouped];
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
        [_tableView registerClass:[RG_QuestionSectionView class] forHeaderFooterViewReuseIdentifier:@"header"];
        [_tableView registerClass:[RG_QuestionHeaderView class] forHeaderFooterViewReuseIdentifier:@"Topheader"];
        
    }
    return _tableView;
}

#pragma mark -- Setter Method
@end
