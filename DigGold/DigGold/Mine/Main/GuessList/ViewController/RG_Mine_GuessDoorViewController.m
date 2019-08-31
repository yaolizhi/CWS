//
//  RG_Mine_GuessDoorViewController.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mine_GuessDoorViewController.h"
#import "RG_Mine_LotteryHistoryViewController.h"
#import "RG_Mine_AllGuessViewController.h"
#import "RG_Mine_MyGuessViewController.h"
@interface RG_Mine_GuessDoorViewController ()
@property (nonatomic, strong) RG_Mine_LotteryHistoryViewController *lotteryHistoryVC;
@property (nonatomic, strong) RG_Mine_MyGuessViewController *myGuessVC;
@property (nonatomic, strong) RG_Mine_AllGuessViewController *allGuessVC;
@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);
@end

@implementation RG_Mine_GuessDoorViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)initWithSelectedIndexBlock:(void (^)(NSInteger index))selectedBlock
{
    self = [super init];
    if (self) {
        self.selectedBlock = selectedBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    self.delegate = self;
    self.dataSource = self;
    
    [self setupMasnory];
    [self mvvmBinding];
    [self triggerActionWithIndex:0];
}

#pragma mark -- Private Method

- (void)setupMasnory {

}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (CGFloat)acquireCurrentVCHeightWithIndex:(NSInteger)index {
    if (index == 0) {
        return self.allGuessVC.tableView.contentSize.height+KWJBaseTabHeight;
    }
    if (index == 1) {
        return self.myGuessVC.tableView.contentSize.height+KWJBaseTabHeight;
    }
    if (index == 2) {
        return self.lotteryHistoryVC.tableView.contentSize.height+KWJBaseTabHeight;
    }
    return KWJBaseTabHeight;
}
#pragma mark -- OtherDelegate
- (NSArray *)titlesOfTabViewController:(WJBaseTabViewController *)tabViewController {
    return @[Localized(@"所有竞猜", nil),
             Localized(@"我的竞猜", nil),
             Localized(@"开奖历史", nil)];
}

- (UIView *)tabViewController:(WJBaseTabViewController *)tabViewController didScrollToPageIndx:(NSInteger)index {
    if (index == 0) {
        return self.allGuessVC.view;
    }else if (index == 1) {
        return self.myGuessVC.view;
    }else {
        return self.lotteryHistoryVC.view;
    }
}

- (void)tabViewController:(WJBaseTabViewController *)tabViewController didSelectedPageIndex:(NSInteger)index {
    self.selectedBlock(index);
}
#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (RG_Mine_LotteryHistoryViewController *)lotteryHistoryVC {
    if (!_lotteryHistoryVC) {
        _lotteryHistoryVC = [[RG_Mine_LotteryHistoryViewController alloc]init];
        [self addChildViewController:_lotteryHistoryVC];
    }
    return _lotteryHistoryVC;
}
- (RG_Mine_MyGuessViewController *)myGuessVC {
    if (!_myGuessVC) {
        _myGuessVC = [[RG_Mine_MyGuessViewController alloc]init];
        [self addChildViewController:_myGuessVC];
    }
    return _myGuessVC;
}
- (RG_Mine_AllGuessViewController *)allGuessVC {
    if (!_allGuessVC) {
        _allGuessVC = [[RG_Mine_AllGuessViewController alloc]init];
        [self addChildViewController:_allGuessVC];
    }
    return _allGuessVC;
}
#pragma mark -- Setter Method
@end
