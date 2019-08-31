//
//  RG_Mine_AllGuessViewController.h
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigGold_Base_ViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface RG_Mine_AllGuessViewController : DigGold_Base_ViewController
@property (nonatomic, strong) UITableView *tableView;
- (void)updateTableViewDataWithDataArray:(NSArray *)dataArray;
@end

NS_ASSUME_NONNULL_END
