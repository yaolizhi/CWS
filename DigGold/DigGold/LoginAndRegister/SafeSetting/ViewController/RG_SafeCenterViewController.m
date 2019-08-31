//
//  RG_SafeCenterViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_SafeCenterViewController.h"
#import "RG_ModifiedPwdViewController.h"
#import "RG_ModifiedPhoneViewController.h"
#import "RG_AddHeadPhotoViewController.h"
#import "RG_PayMethodViewController.h"
#import "WJTabView.h"
@interface RG_SafeCenterViewController ()<WJTabViewDatsSource>
@property (nonatomic, strong) WJTabView *tabView;
@property (nonatomic, strong) RG_ModifiedPwdViewController *modifiedPwdVC;
@property (nonatomic, strong) RG_ModifiedPhoneViewController *modifiedPhoneVC;
@property (nonatomic, strong) RG_AddHeadPhotoViewController *addHeadPhotoVC;
@property (nonatomic, strong) RG_PayMethodViewController *payMethodVC;
@end

@implementation RG_SafeCenterViewController

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
    self.title = Localized(@"安全设置", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.tabView];
}

- (void)setupMasnory {
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate

- (NSArray *)titlesOfTabView:(WJTabView *)tabView {
    return @[@"收款方式",
             Localized(@"修改密码", nil),
             Localized(@"手机号修改", nil),
             Localized(@"添加头像", nil)];
}


- (UIView *)tabView:(WJTabView *)tabView didScrollToPageIndx:(NSInteger)index {
    switch (index) {
        case 0:
            return self.payMethodVC.view;
            break;
        case 1:
            return self.modifiedPwdVC.view;
            break;
        case 2:
            return self.modifiedPhoneVC.view;
            break;
        case 3:
            return self.addHeadPhotoVC.view;
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (RG_PayMethodViewController *)payMethodVC {
    if (!_payMethodVC) {
        _payMethodVC = [[RG_PayMethodViewController alloc]init];
        [self addChildViewController:_payMethodVC];
    }
    return _payMethodVC;
}

- (RG_ModifiedPwdViewController *)modifiedPwdVC {
    if (!_modifiedPwdVC) {
        _modifiedPwdVC = [[RG_ModifiedPwdViewController alloc]init];
        [self addChildViewController:_modifiedPwdVC];
    }
    return _modifiedPwdVC;
}
- (RG_ModifiedPhoneViewController *)modifiedPhoneVC {
    if (!_modifiedPhoneVC) {
        _modifiedPhoneVC = [[RG_ModifiedPhoneViewController alloc]init];
        [self addChildViewController:_modifiedPhoneVC];
    }
    return _modifiedPhoneVC;
}
- (RG_AddHeadPhotoViewController *)addHeadPhotoVC {
    if (!_addHeadPhotoVC) {
        _addHeadPhotoVC = [[RG_AddHeadPhotoViewController alloc]init];
        [self addChildViewController:_addHeadPhotoVC];
    }
    return _addHeadPhotoVC;
}

- (WJTabView *)tabView {
    if (!_tabView) {
        _tabView = [[WJTabView alloc]init];
        
        _tabView.dataSource = self;
    }
    return _tabView;
}
#pragma mark -- Setter Method
@end
