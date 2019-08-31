//
//  BLAlertView.h
//  ZYW_MIT
//
//  Created by 李赛 on 2017/02/14.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

typedef void(^cancelBlock)(NSString *message);

typedef void(^sureBlock)(NSString *message);

@interface BLAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;

@property (nonatomic, copy)cancelBlock cancelBlock;

@property (nonatomic, copy)sureBlock sureBlock;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showBLAlertView;

@end
