//
//  RG_Mian_ViewController.m
//  DigGold
//
//  Created by James on 2018/12/26.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mian_ViewController.h"

@interface RG_Mian_ViewController ()
@property (nonatomic, strong) UIView *rightBarView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *notifyImageView;
@property (nonatomic, strong) UIImageView *downArrowImageView;
@property (nonatomic, strong) UIView *notifyRedView;
@end

@implementation RG_Mian_ViewController

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
    self.title = Localized(@"抢金", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self setupNavbar];
    [self setupMasnory];
    [self mvvmBinding];
}

#pragma mark -- Private Method

- (void)setupNavbar {
    [self addLeftNavItemWithImage:[UIImage imageNamed:@"mine_menu"]];
    [self.rightBarView addSubview:self.headerImageView];
    [self.rightBarView addSubview:self.downArrowImageView];
    [self.rightBarView addSubview:self.notifyImageView];
    [self.rightBarView addSubview:self.notifyRedView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rightBarView);
        make.width.height.mas_equalTo(WJScaleW(23));
    }];
    [self.downArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView);
        make.bottom.equalTo(self.headerImageView);
        make.width.height.mas_equalTo(WJScaleW(6));
    }];
    [self.notifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView.mas_left).offset(-WJScaleW(12));
        make.center.equalTo(self.rightBarView);
        make.width.mas_equalTo(WJScaleW(12));
        make.height.mas_equalTo(WJScaleH(15));
    }];
    [self.notifyRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.notifyImageView).offset(WJScaleW(4));
        make.top.equalTo(self.notifyImageView).offset(-WJScaleW(4));
        make.width.height.mas_equalTo(WJScaleW(7));
    }];
    
    UIBarButtonItem *rightView = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarView];
    self.navigationItem.rightBarButtonItem = rightView;
}

- (void)setupMasnory {
    
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (UIView *)rightBarView {
    if (!_rightBarView) {
        _rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        _rightBarView.backgroundColor = [UIColor whiteColor];
    }
    return _rightBarView;
}
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.backgroundColor = [UIColor orangeColor];
        _headerImageView.layer.cornerRadius = WJScaleW(23/2);
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}
- (UIImageView *)notifyImageView {
    if (!_notifyImageView) {
        _notifyImageView = [[UIImageView alloc]init];
        _notifyImageView.image = [UIImage imageNamed:@"mine_notify"];
    }
    return _notifyImageView;
}
- (UIImageView *)downArrowImageView {
    if (!_downArrowImageView) {
        _downArrowImageView = [[UIImageView alloc]init];
        _downArrowImageView.image = [UIImage imageNamed:@"mine_downArrow"];
    }
    return _downArrowImageView;
}

- (UIView *)notifyRedView {
    if (!_notifyRedView) {
        _notifyRedView = [[UIView alloc]init];
        _notifyRedView.layer.cornerRadius = WJScaleW(7/2);
        _notifyRedView.layer.masksToBounds = YES;
        _notifyRedView.backgroundColor = [UIColor redColor];
    }
    return _notifyRedView;
}
#pragma mark -- Setter Method
@end
