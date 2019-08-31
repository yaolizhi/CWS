//
//  RG_AM_WCView.h
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RG_AM_WCViewDelegate <NSObject>

- (void)didSelectedTypeTitle:(NSString *)title;

@end

@interface RG_AM_WCView : UIView
@property (nonatomic, weak) id <RG_AM_WCViewDelegate> delegate;

@property (nonatomic, strong) UITextField *usableTF;
@property (nonatomic, strong) UITextField *numberTF;
@property (nonatomic, strong) UITextField *payPwdTF;
@property (nonatomic, strong) UITextField *verifyCodeTF;
@property (nonatomic, strong) UILabel *numberWCLabel;
@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) UIButton *verifyCodeButton;
@property (nonatomic, strong) UIButton *typeButton;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *carryCoinWayButton;

- (void)updateCNY;
- (void)updateUSDT;
- (void)updateTDEUSDT;
@end

NS_ASSUME_NONNULL_END
