//
//  RG_Main_GoldAmountView.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Main_GoldAmountView.h"
#import "RG_PullDownView.h"
@interface RG_Main_GoldAmountView()
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *walletView;
@property (nonatomic, strong) UIImageView *walletImage;

@end

@implementation RG_Main_GoldAmountView

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.bgView];
        [self.bgView addSubview:self.amountButton];
        [self.bgView addSubview:self.walletView];
        [self.walletView addSubview:self.walletImage];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(ScaleH(55));
    }];
    [self.amountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(12));
        make.top.equalTo(self.bgView).offset(ScaleH(11));
        make.right.equalTo(self.walletView.mas_left).offset(-ScaleW(6));
        make.height.mas_equalTo(ScaleH(33));
    }];
    
    [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(ScaleH(11));
        make.right.equalTo(self.bgView).offset(-ScaleW(12));
        make.width.mas_equalTo(ScaleW(35));
        make.height.mas_equalTo(ScaleH(33));
    }];
    
    [self.walletImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.walletView);
        make.width.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleH(19));
    }];
}

- (void)configureView {
    
}




#pragma mark -- Public Method
- (void)walletClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWallet)]) {
        [self.delegate didSelectedWallet];
    }
}

- (void)amountButtonClick {
    //只显示一种货币
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAmountButton)]) {
//        [self.delegate didSelectedAmountButton];
//    }
}
#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainSubBackgroundColor;
        _bgView.layer.cornerRadius = ScaleW(5);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)amountButton {
    if (!_amountButton) {
        _amountButton = [[UIButton alloc]init];
        [_amountButton  setTitle:@"0.00000USDT" forState:UIControlStateNormal];
        [_amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_amountButton setImage:[UIImage imageNamed:@"USDT-smallicon"] forState:UIControlStateNormal];
        _amountButton.imageView.size = CGSizeMake(ScaleW(14), ScaleW(14));
        _amountButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _amountButton.layer.cornerRadius = ScaleW(5);
        _amountButton.layer.masksToBounds = YES;
        _amountButton.backgroundColor = kMainBackgroundColor;
        _amountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _amountButton.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        _amountButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_amountButton addTarget:self action:@selector(amountButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _amountButton;
}
- (UIView *)walletView {
    if (!_walletView) {
        _walletView = [[UIView alloc]init];
        _walletView.backgroundColor = kMainBackgroundColor;
        _walletView.layer.cornerRadius = ScaleW(5);
        _walletView.layer.masksToBounds = YES;
        _walletView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(walletClick)];
        [_walletView addGestureRecognizer:tap];
    }
    return _walletView;
}
- (UIImageView *)walletImage {
    if (!_walletImage) {
        _walletImage = [[UIImageView alloc]init];
        _walletImage.image = [UIImage imageNamed:@"mine_wallet"];
    }
    return _walletImage;
}


#pragma mark -- Setter Method

@end
