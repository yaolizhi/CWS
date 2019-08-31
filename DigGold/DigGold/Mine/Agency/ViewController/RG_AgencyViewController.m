//
//  RG_AgencyViewController.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyViewController.h"
#import "RG_QuestionHeaderView.h"
#import "RG_QuestionTableViewCell.h"
#import "RG_QuestionSectionView.h"
#import "RG_CommonModel.h"
#import "RG_AgencyPlanTableViewCell.h"
#import "RG_AgencyApplyViewController.h"
#import "RGAgencyModel.h"
#import "RG_HelpCenterViewController.h"
#import "RG_MyPromoteModel.h"
@interface RG_AgencyViewController ()<UITableViewDelegate,UITableViewDataSource,RG_QuestionSectionViewDelegate,RG_AgencyPlanTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *secondTitlesArray;
@property (nonatomic, strong) NSArray *subTitlesArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) RG_QuestionHeaderView *headerView;
@property (nonatomic, assign) RG_AgencyViewType type;
@property (nonatomic, strong) RGAgencyModel *agencyModel;
@property (nonatomic, strong) RG_MyPromoteModel *promoteModel;

@property (nonatomic, assign) BOOL hasApply;
@property (nonatomic, assign) BOOL dicHasNull;
@end

@implementation RG_AgencyViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithSelectedType:(RG_AgencyViewType)type
{
    self = [super init];
    if (self) {
        self.hasApply = NO;
        self.dicHasNull = NO;
        self.type = type;
        self.secondTitlesArray = @[@"",
                                   Localized(@"代理计划", nil),
                                   Localized(@"代理条款", nil),
                                   Localized(@"佣金规则", nil)];
        self.subTitlesArray = @[@[],
                                @[@""],
                                @[],
                                @[]];
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"1",@"0",@"0"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全民代理";
    self.view.backgroundColor = kMainBackgroundColor;
    [self.view addSubview:self.tableView];
    if (self.type == RG_AgencyViewType_DLJH) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"1",@"0",@"0"]];
        
    }
    if (self.type == RG_AgencyViewType_DLTK) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"1",@"0"]];
        
    }
    if (self.type == RG_AgencyViewType_YJGZ) {
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"1"]];
        
    }

    [self.tableView reloadData];

    [self setupMasnory];
    [self mvvmBinding];
}


- (void)mvvmBinding {
    
    [self fetchUserInfoData];
    [self fetchCommonData];
    [self fetchInfoData];//获取全民代理链接
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notif) name:kApplyDLSSuccessNotifition object:nil];
}

- (void)notif {
    [self fetchUserInfoData];
    [self fetchInfoData];//获取全民代理链接
}


- (void)fetchUserInfoData {
    NSDictionary *params = @{};
    WS(weakSelf);
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_UserInfo_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            weakSelf.hasApply = [netWorkModel.data[@"is_daili"] boolValue];
            NSDictionary *apply_info = netWorkModel.data[@"apply_info"];
            if (!apply_info ||
                [apply_info isEqual:[NSNull null]]) {
                weakSelf.dicHasNull = YES;
            }else{
                weakSelf.dicHasNull = NO;
                weakSelf.agencyModel = [RGAgencyModel mj_objectWithKeyValues:apply_info];
            }
            [weakSelf.tableView reloadData];
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
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
            NSDictionary *proxy_info = netWorkModel.data[@"proxy_info"];
            NSArray *termsArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:proxy_info[@"terms"]];
            NSArray *commissionArray = [RG_CommonModel mj_objectArrayWithKeyValuesArray:proxy_info[@"commission"]];
            
            weakSelf.subTitlesArray = @[@[],
                                        @[@""],
                                        termsArray,
                                        commissionArray];
    
            [weakSelf.tableView reloadData];
            
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
    }];
}

- (void)fetchInfoData {
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Link_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            weakSelf.promoteModel = [RG_MyPromoteModel mj_objectWithKeyValues:netWorkModel.data];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

#pragma mark -- Private Method

//RG_AgencyPlanTableViewCellDelegate
- (void)didSelectedAgencyPlanType:(RG_AgencyPlanType)type {
    if (type == RG_AgencyPlanType_Save) {//保存代理卡
        [self downloadLaunchAdvertImageWithURL:[NSURL URLWithString:self.promoteModel.qrc?:@""]];
    }
    if (type == RG_AgencyPlanType_Copy) {//复制代理链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.promoteModel.url?:@"";
        [RCHUDPop popupTipText:@"复制代理链接成功" toView:nil];
    }
    if (type == RG_AgencyPlanType_Enter) {//进入代理系统
        [RCHUDPop popupTipText:@"功能暂未开放" toView:nil];
    }
    if (type == RG_AgencyPlanType_Contact) {//联系我们
        RG_HelpCenterViewController *vc = [[RG_HelpCenterViewController alloc]initWithSelectedType:RG_HelpCenterType_LXWM];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (type == RG_AgencyPlanType_Read) {//阅读代理条款
        self.selectedArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"1",@"0"]];
        [self.tableView reloadData];
    }
    if (type == RG_AgencyPlanType_Apply) {//申请
        RG_AgencyApplyViewController *vc = [[RG_AgencyApplyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)downloadLaunchAdvertImageWithURL:(NSURL *)url {
    [RCHUDPop popupMessage:@"" toView:nil];
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:url
                                                         options:SDWebImageDownloaderUseNSURLCache
                                                        progress:nil
                                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                           if (error) {
                                                               [RCHUDPop popupTipText:@"保存失败" toView:nil];
                                                           }
                                                           if (finished) {
                                                               if (image) {
                                                                   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
                                                               }
                                                           }
                                                           [RCHUDPop dismissHUDToView:nil];
                                                       }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [RCHUDPop popupTipText:@"保存失败" toView:nil];
    } else {
        [RCHUDPop popupTipText:@"保存代理卡至相册" toView:nil];
    }
}
- (void)setupMasnory {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.equalTo(self.view);
    }];
    
}


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
        [headerView configureWithTitle:Localized(@"全民代理", nil)
                              subTitle:@""];
        headerView.titleLabel.textColor = kMainTitleColor;
        return headerView;
    }
    
    RG_QuestionSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.delegate = self;
    NSString *title = self.secondTitlesArray[section];
    [headerView configureViewWithTitle:title section:section];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        RG_AgencyPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell configureCellWithHasApply:self.hasApply model:self.agencyModel dicNull:self.dicHasNull];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
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
        [_tableView registerClass:[RG_AgencyPlanTableViewCell class] forCellReuseIdentifier:@"firstCell"];
        
    }
    return _tableView;
}
#pragma mark -- Setter Method
@end
