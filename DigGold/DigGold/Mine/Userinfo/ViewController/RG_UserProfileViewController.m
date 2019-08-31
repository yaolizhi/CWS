//
//  RG_UserProfileViewController.m
//  DigGold
//
//  Created by James on 2018/12/31.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_UserProfileViewController.h"
#import "RG_UserProfileHeaderView.h"
#import "RG_UserProfileItemView.h"
#import "SSKJ_UserInfo_Model.h"
@interface RG_UserProfileViewController ()<RG_UserProfileHeaderViewDelegate>
@property (nonatomic, strong) RG_UserProfileHeaderView *headerView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *titlesDataArray;

@property (nonatomic, copy) NSString *dataTitle;
@property (nonatomic, strong) SSKJ_UserInfo_Model *userProfileModel;
@property (nonatomic, strong) SSKJ_UserInfoItem_Model *userInfoModel;

@end

@implementation RG_UserProfileViewController

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
    self.title = Localized(@"战绩", nil);
    self.view.backgroundColor = kMainBackgroundColor;
//    self.titlesArray = @[@"JC",@"USDT"];
//    self.titlesDataArray = @[@"pb",@"cny"];
    self.titlesArray = @[@"USDT"];
    self.titlesDataArray = @[@"cny"];
    self.dataTitle = self.titlesDataArray[0];
    [self setupMasnory];
    [self mvvmBinding];
    
}

- (void)mvvmBinding {
    [self.headerView configureViewWithHeader:@"headerProfile" name:@""];
    [self fetchData];
}
- (void)fetchData {
    WS(weakSelf);
    
    NSDictionary *params = @{@"money_type":self.dataTitle?:@""};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_UserInfo_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
            SSKJ_UserInfo_Model *model = [SSKJ_UserInfo_Model mj_objectWithKeyValues:netWorkModel.data];
            weakSelf.userProfileModel = model;
            weakSelf.userInfoModel = model.list[0];
            [[SSKJ_User_Tool sharedUserTool]saveUserInfoWithModel:model];
            [weakSelf createItems];
            [weakSelf.headerView configureViewWithHeader:model.upic.length>0?F(@"%@%@",ProductBaseServer, model.upic):@"headerProfile" name:model.realname?:@""];
            weakSelf.subTitleLabel.text = [NSString timeWithTimeIntervalString:model.reg_time?:@""];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}


#pragma mark -- Private Method

- (void)setupMasnory {
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
    }];
    [self createItems];
    [self.view addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(ScaleW(-15));
        make.top.equalTo(self.headerView.mas_bottom).offset(ScaleH(136));
    }];
    
}

#pragma mark -- Public Method
- (void)createItems {
    for (RG_UserProfileItemView *view in self.view.subviews) {
        if ([view isKindOfClass:[RG_UserProfileItemView class]]) {
            [view removeFromSuperview];
        }
    }
    NSArray *titlesArray = @[@"当前收益",@"投注总额",@"最高盈利",@"最高亏损",@"盈利排名",@"投注次数"];
    NSArray *imagesArray = @[@"user_dangqian",@"user_touzi",@"user_renjungao",@"user_renjundi",@"user_paiming",@"user_tzcs"];
    
    NSArray *dataArray = @[self.userInfoModel.income?:@"",self.userInfoModel.leiji?:@"",self.userInfoModel.zuigao?:@"",self.userInfoModel.loss?:@"",F(@"%ld", self.userInfoModel.ranking),self.userInfoModel.num?:@""];
    for (NSInteger i = 0; i<titlesArray.count; i++) {
        RG_UserProfileItemView *view = [[RG_UserProfileItemView alloc]initWithFrame:CGRectZero iconImageS:imagesArray[i] titleS:titlesArray[i] subTitleS:dataArray[i]];
        
        view.layer.cornerRadius = ScaleW(3);
        view.layer.masksToBounds = YES;
        view.backgroundColor = kMainSubBackgroundColor;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = (ScreenWidth-ScaleW(60))/3;
            CGFloat height = ScaleH(50);
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat left = ScaleW(15)+(width +ScaleW(15))*col;
            CGFloat top = ScaleW(12)+(height +ScaleW(12))*row;
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(ScaleH(50));
            make.top.equalTo(self.headerView.mas_bottom).offset(top);
            make.left.equalTo(self.view).offset(left);
        }];
        
    }
}
#pragma mark -- OtherDelegate
- (void)didSelectedChooseButtonClickType:(NSString *)type {
    NSInteger index = [self.titlesArray indexOfObject:type];
    self.dataTitle = self.titlesDataArray[index];
    [self fetchData];
    
}
#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (RG_UserProfileHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[RG_UserProfileHeaderView alloc]initWithFrame:CGRectZero titles:self.titlesArray title:self.titlesArray[0]];
        _headerView.delegate = self;
        _headerView.backgroundColor = kMainBackgroundColor;
    }
    return _headerView;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _subTitleLabel.textColor = kMainGaryWhiteColor;
//        _subTitleLabel.text = @"注册于 2018-10-19 09:03:35";
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method
@end
