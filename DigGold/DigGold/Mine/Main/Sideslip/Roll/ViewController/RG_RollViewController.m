//
//  RG_RollViewController.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_RollViewController.h"
#import "RG_RollTableViewCell.h"
#import "RG_RollHeaderView.h"
#import "RG_RollBottomView.h"
#import "RG_RollModel.h"
#import "RG_GetRollModel.h"
@interface RG_RollViewController ()<UITableViewDelegate,UITableViewDataSource,RG_RollHeaderViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RG_RollHeaderView *headerView;
@property (nonatomic, strong) RG_RollBottomView *bottomView;
@property (nonatomic, strong) RG_RollModel *rollModel;
@property (nonatomic, strong) RG_GetRollModel *getRollModel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger secondInt;
@end

@implementation RG_RollViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
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
    self.title = Localized(@"Roll点比大小", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self setupMasnory];
    [self mvvmBinding];
    
    [self addObserver:self forKeyPath:@"secondInt" options:NSKeyValueObservingOptionNew context:nil];
}

//监听value的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"secondInt"]) {
        NSInteger value = [change[NSKeyValueChangeNewKey] integerValue];
        if (value > 0) {
            self.headerView.rollButton.selected = NO;
            self.headerView.rollButton.enabled = NO;
            
            [self.headerView.rollButton setBackgroundColor:kMainSubBackgroundColor];
        }else{
            [self.headerView.rollButton setBackgroundColor:kMainTitleColor];
            self.headerView.rollButton.selected = YES;
            self.headerView.rollButton.enabled = YES;
        }
    }
}

- (void)mvvmBinding {
    [self fetchData];
    
}

- (void)fetchData {
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Roll_page_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            weakSelf.rollModel = [RG_RollModel mj_objectWithKeyValues:netWorkModel.data];
            weakSelf.dataArray = weakSelf.rollModel.rank;
            weakSelf.secondInt = [weakSelf.rollModel.sy_sec integerValue];
            [weakSelf.bottomView configureViewWithTime:F(@"%@-%@", weakSelf.rollModel.start?:@"",weakSelf.rollModel.end?:@"")];
            [weakSelf openGCDTimer];
            [weakSelf configureData];
        }else{
            [RCHUDPop popupTipText:netWorkModel.msg toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@""] toView:nil];
    }];
}

- (void)openGCDTimer {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1*NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf timeAction];
    });
    dispatch_resume(self.timer);
}

- (void)timeAction {
    self.secondInt--;
    NSInteger seconds = self.secondInt % 60;
    NSInteger minutes = (self.secondInt / 60) % 60;
    NSInteger hours = self.secondInt / 3600;
    
    if (self.secondInt == 0 ||
        self.secondInt < 0) {
        dispatch_cancel(self.timer);
        self.timer = nil;
        self.headerView.countDownLabel.text = F(@"倒计时 %@:%@:%@", @"00",@"00",@"00");
    }else{
        self.headerView.countDownLabel.text = F(@"倒计时 %.2ld:%.2ld:%.2ld", hours,minutes,seconds);
    }
    
}


- (void)rollRequest {
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Get_roll_num_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            weakSelf.getRollModel = [RG_GetRollModel mj_objectWithKeyValues:netWorkModel.data];
            [weakSelf.headerView startRollWithLeftRollNumber:[weakSelf.getRollModel.one integerValue]
                                                      middle:[weakSelf.getRollModel.two integerValue]
                                                       right:[weakSelf.getRollModel.three integerValue]];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        }else{
            [RCHUDPop popupTipText:netWorkModel.msg toView:nil];
        }
        self.headerView.rollButton.enabled = YES;
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@""] toView:nil];
        self.headerView.rollButton.enabled = YES;
    }];
}

- (void)configureData {
    [self.headerView configureViewWithModel:self.rollModel];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
}





#pragma mark -- Private Method

- (void)setupMasnory {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-ScaleH(16));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-ScaleH(16));
    }];
    [self setupHeaderView];
}

- (void)setupHeaderView {
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.tableView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.tableView layoutIfNeeded];
}



#pragma mark -- Public Method

#pragma mark -- OtherDelegate
- (void)rollFinished {
    [self fetchData];
}

- (void)startRollButtonClick {
    if ([self.rollModel.times integerValue] == 0) {
        [RCHUDPop popupTipText:@"您没有游戏参与次数" toView:nil];
        return;
    }
    self.headerView.rollButton.enabled = NO;
    [self rollRequest];
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_RollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithIndexPath:indexPath];
    [cell configureCellWithModel:self.dataArray[indexPath.row]];
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
        [_tableView registerClass:[RG_RollTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (RG_RollHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[RG_RollHeaderView alloc]init];
        _headerView.delegate = self;
        _headerView.backgroundColor = kMainBackgroundColor;
    }
    return _headerView;
}
- (RG_RollBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[RG_RollBottomView alloc]init];
    }
    return _bottomView;
}
#pragma mark -- Setter Method
@end
