//
//  RG_FAQViewController.m
//  DigGold
//
//  Created by James on 2018/12/31.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_FAQViewController.h"
#import "RG_QuestionHeaderView.h"
#import "RG_QuestionTableViewCell.h"
#import "RG_QuestionSectionView.h"
#import "RG_CommonModel.h"
@interface RG_FAQViewController ()<UITableViewDelegate,UITableViewDataSource,RG_QuestionSectionViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RG_QuestionHeaderView *headerView;

@property (nonatomic, strong) NSArray *secondTitlesArray;
@property (nonatomic, strong) NSArray *subTitlesArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation RG_FAQViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithSelectedType:(RG_FAQType)type
{
    self = [super init];
    if (self) {
        
        self.secondTitlesArray = @[@"",
                                   Localized(@"游戏介绍", nil),
                                   Localized(@"奖池介绍", nil),
                                   Localized(@"游戏公平性", nil),
                                   Localized(@"自动逃跑", nil)];
        self.subTitlesArray = @[@"",
                                @"",
                                @"",
                                @"",
                                @""];
        self.subTitlesArray = @[@[],
                                @[],
                                @[],
                                @[],
                                @[]];
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"",@"1",@"0",@"0",@"0"]];
        if (type == RG_FAQType_QJ) {
            self.selectedArray = [NSMutableArray arrayWithArray:@[@"",@"1",@"0",@"0",@"0"]];
        }
        if (type == RG_FAQType_JS) {
            self.selectedArray = [NSMutableArray arrayWithArray:@[@"",@"0",@"1",@"0",@"0"]];
        }
        if (type == RG_FAQType_GP) {
            self.selectedArray = [NSMutableArray arrayWithArray:@[@"",@"0",@"0",@"1",@"0"]];
        }
        if (type == RG_FAQType_TP) {
            self.selectedArray = [NSMutableArray arrayWithArray:@[@"",@"0",@"0",@"0",@"1"]];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"常见问题", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self.view addSubview:self.tableView];
    
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
            NSDictionary *playInfo = netWorkModel.data[@"play_info"];
            NSArray *gameArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"game"]];
            NSArray *presentArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"present"]];
            NSArray *fairArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"fair"]];
            NSArray *fleeArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:playInfo[@"flee"]];
            

            weakSelf.subTitlesArray = @[@[],
                                        gameArray,
                                        presentArray,
                                        fairArray,
                                        fleeArray];
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
        [headerView configureWithTitle:Localized(@"BSG", nil)
                              subTitle:Localized(@"常见问题", nil)];
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
