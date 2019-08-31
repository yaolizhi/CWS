//
//  RG_Mine_RewardDoorViewController.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mine_RewardDoorViewController.h"

@interface RG_Mine_RewardDoorViewController ()
@property (nonatomic, strong) UIViewController *VC1;
@property (nonatomic, strong) UIViewController *VC2;
@property (nonatomic, strong) UIViewController *VC3;
@end

@implementation RG_Mine_RewardDoorViewController

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
    self.title = Localized(@"庄家奖池", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    self.delegate = self;
    self.dataSource = self;
    
    [self triggerActionWithIndex:0];
    [self setupMasnory];
    [self mvvmBinding];
}

#pragma mark -- Private Method

- (void)setupMasnory {
    
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate
- (NSArray *)titlesOfTabViewController:(WJBaseTabViewController *)tabViewController {
    return @[Localized(@"主页", nil),
             Localized(@"坐庄", nil),
             Localized(@"历史", nil)];
}

- (UIView *)tabViewController:(WJBaseTabViewController *)tabViewController didScrollToPageIndx:(NSInteger)index {
    if (index == 0) {
        return self.VC1.view;
    }else if (index == 1) {
        return self.VC2.view;
    }else {
        return self.VC3.view;
    }
}

- (void)tabViewController:(WJBaseTabViewController *)tabViewController didSelectedPageIndex:(NSInteger)index {
    
}

- (UIViewController *)VC1 {
    if (!_VC1) {
        _VC1 = [[UIViewController alloc]init];
        _VC1.view.backgroundColor = [UIColor redColor];
        _VC1.view.height = 200;
        [self addChildViewController:_VC1];
    }
    return _VC1;
}
- (UIViewController *)VC2 {
    if (!_VC2) {
        _VC2 = [[UIViewController alloc]init];
        _VC2.view.backgroundColor = [UIColor orangeColor];
        _VC2.view.height = 200;
        [self addChildViewController:_VC2];
    }
    return _VC2;
}
- (UIViewController *)VC3 {
    if (!_VC3) {
        _VC3 = [[UIViewController alloc]init];
        _VC3.view.backgroundColor = [UIColor yellowColor];
        _VC3.view.height = 300;
        [self addChildViewController:_VC3];
    }
    return _VC3;
}
#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method

#pragma mark -- Setter Method
@end
