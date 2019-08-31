//
//  RG_WithdrawAddressTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_WithdrawAddressTableViewCell.h"

@interface RG_WithdrawAddressTableViewCell()
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *addressFunView;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UIView *addressLineView;
@property (nonatomic, strong) UIButton *addressButton;
@property (nonatomic, assign) NSInteger index;
@end

@implementation RG_WithdrawAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.addressLabel];
        [self addSubview:self.addressFunView];
        [self.addressFunView addSubview:self.addressTF];
        [self.addressFunView addSubview:self.addressButton];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.top.equalTo(self).offset(ScaleH(14));
    }];
    [self.addressFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(14));
        make.right.equalTo(self).offset(-ScaleW(14));
        make.top.equalTo(self.addressLabel.mas_bottom).offset(ScaleH(10));
        make.height.mas_equalTo(ScaleH(50));
        make.bottom.equalTo(self);
    }];
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressFunView.mas_right).offset(-ScaleW(12));
        make.centerY.equalTo(self.addressFunView);
        make.height.mas_equalTo(ScaleH(50));
        make.width.mas_equalTo(ScaleW(32));
    }];

    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressFunView);
        make.right.equalTo(self.addressButton.mas_left).offset(-ScaleW(5));
        make.top.equalTo(self.addressFunView);
        make.height.mas_equalTo(ScaleH(50));
        
    }];
}

- (void)configureCell:(RG_WithdrawModel *)model index:(NSInteger)index {
    self.addressLabel.text = model.remark?:@"";
    self.addressTF.text = model.address?:@"";
    self.index = index;
    [self layoutIfNeeded];
}

#pragma mark -- Public Method
- (void)delegateAddressButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteAddressWithIndex:)]) {
        [self.delegate didDeleteAddressWithIndex:self.index];
    }
}
#pragma mark -- Getter Method
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
//        _addressLabel.text = Localized(@"提币地址", nil);
        _addressLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _addressLabel.textColor = kMainGaryWhiteColor;
    }
    return _addressLabel;
}

- (UIView *)addressFunView {
    if (!_addressFunView) {
        _addressFunView = [[UIView alloc]init];
        _addressFunView.backgroundColor = kMainSubBackgroundColor;
        _addressFunView.layer.cornerRadius = ScaleW(5);
        _addressFunView.layer.masksToBounds = YES;
    }
    return _addressFunView;
}

- (UITextField *)addressTF {
    if (!_addressTF) {
        _addressTF = [[UITextField alloc]init];
        _addressTF.backgroundColor = kMainSubBackgroundColor;
        _addressTF.keyboardType = UIKeyboardTypeNumberPad;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.textColor = kMainGaryWhiteColor;
        _addressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _addressTF.leftViewMode = UITextFieldViewModeAlways;
        _addressTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _addressTF.enabled = NO;
        [_addressTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _addressTF;
}

- (UIButton *)addressButton {
    if (!_addressButton) {
        _addressButton = [[UIButton alloc]init];
//        [_addressButton setImage:[UIImage imageNamed:@"ma_dzlb"] forState:UIControlStateNormal];
        [_addressButton setTitle:Localized(@"删除", nil) forState:UIControlStateNormal];
        [_addressButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        _addressButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_addressButton addTarget:self action:@selector(delegateAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressButton;
}

#pragma mark -- Setter Method

@end
