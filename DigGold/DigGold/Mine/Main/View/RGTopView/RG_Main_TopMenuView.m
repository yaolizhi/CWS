//
//  RG_Main_TopMenuView.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Main_TopMenuView.h"

@interface RG_Main_TopMenuView()
@property (nonatomic, strong) UIButton *guessButton;
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) UIButton *faqButton;
@property (nonatomic, strong) UIButton *lotteryButton;
@property (nonatomic, strong) UIButton *justiceButton;
@property (nonatomic, strong) UIButton *appDownButton;
@end

@implementation RG_Main_TopMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.guessButton];
//        [self addSubview:self.rankButton];
        [self addSubview:self.faqButton];
//        [self addSubview:self.lotteryButton];
        [self addSubview:self.appDownButton];
        [self addSubview:self.justiceButton];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.guessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.mas_equalTo(ScreenWidth/4);
        make.height.mas_equalTo(ScaleH(48));
        make.bottom.equalTo(self);
    }];
    [self.faqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.guessButton.mas_right);
        make.width.mas_equalTo(ScreenWidth/4);
        make.height.mas_equalTo(ScaleH(48));
    }];
//    [self.rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.left.equalTo(self.faqButton.mas_right);
//        make.width.mas_equalTo(ScreenWidth/5);
//        make.height.mas_equalTo(ScaleH(48));
//    }];
    [self.appDownButton mas_makeConstraints:^(MASConstraintMaker *make) {//app下载
        make.top.equalTo(self);
        make.left.equalTo(self.faqButton.mas_right);
        make.width.mas_equalTo(ScreenWidth/4);
        make.height.mas_equalTo(ScaleH(48));
    }];
    [self.justiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.appDownButton.mas_right);
        make.width.mas_equalTo(ScreenWidth/4);
        make.height.mas_equalTo(ScaleH(48));
        make.right.equalTo(self);
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method
- (void)topMenuButtonClick:(UIButton *)sender {
    RG_Main_TopMenuSelectedType menuType = RG_Main_TopMenuSelectedType_Guess;
    if (sender.tag == 100) {
        menuType = RG_Main_TopMenuSelectedType_Guess;
    }
    if (sender.tag == 101) {
        menuType = RG_Main_TopMenuSelectedType_Rank;
    }
    if (sender.tag == 102) {
        menuType = RG_Main_TopMenuSelectedType_FAQ;
    }
    if (sender.tag == 103) {
        menuType = RG_Main_TopMenuSelectedType_Lottery;
    }
    if (sender.tag == 104) {
        menuType = RG_Main_TopMenuSelectedType_Fair;
    }
    if (sender.tag == 105) {
        menuType = RG_Main_TopMenuSelectedType_AppDown;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(topMenuSelectedWithType:)]) {
        [self.delegate topMenuSelectedWithType:menuType];
    }
}
#pragma mark -- Getter Method
- (UIButton *)guessButton {
    if (!_guessButton) {
        _guessButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ScaleH(48))];
        [_guessButton setTitle:Localized(@"竞猜", nil) forState:UIControlStateNormal];
        [_guessButton setImage:[UIImage imageNamed:@"mine_jingcai"] forState:UIControlStateNormal];
        [_guessButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        _guessButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _guessButton.tag = 100;
        CGSize imageSize = _guessButton.imageView.frame.size;
        CGSize titleSize = _guessButton.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height + ScaleW(6));
        _guessButton.imageEdgeInsets = UIEdgeInsetsMake(
                                                - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
        _guessButton.titleEdgeInsets = UIEdgeInsetsMake(
                                                0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
        [_guessButton addTarget:self action:@selector(topMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _guessButton;
}

- (UIButton *)rankButton {
    if (!_rankButton) {
        _rankButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ScaleH(48))];
        [_rankButton setTitle:Localized(@"排行榜", nil) forState:UIControlStateNormal];
        [_rankButton setImage:[UIImage imageNamed:@"mine_rank"] forState:UIControlStateNormal];
        [_rankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rankButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _rankButton.tag = 101;
        CGSize imageSize = _rankButton.imageView.frame.size;
        CGSize titleSize = _rankButton.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height + ScaleW(6));
        _rankButton.imageEdgeInsets = UIEdgeInsetsMake(
                                                        - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
        _rankButton.titleEdgeInsets = UIEdgeInsetsMake(
                                                        0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
        [_rankButton addTarget:self action:@selector(topMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rankButton;
}
- (UIButton *)faqButton {
    if (!_faqButton) {
        _faqButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ScaleH(48))];
        [_faqButton setTitle:Localized(@"BSG", nil) forState:UIControlStateNormal];
        [_faqButton setImage:[UIImage imageNamed:@"mine_faq"] forState:UIControlStateNormal];
        [_faqButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _faqButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _faqButton.tag = 102;
        CGSize imageSize = _faqButton.imageView.frame.size;
        CGSize titleSize = _faqButton.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height + ScaleW(6));
        _faqButton.imageEdgeInsets = UIEdgeInsetsMake(
                                                       - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
        _faqButton.titleEdgeInsets = UIEdgeInsetsMake(
                                                       0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
        [_faqButton addTarget:self action:@selector(topMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faqButton;
}

- (UIButton *)lotteryButton {
    if (!_lotteryButton) {
        _lotteryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ScaleH(48))];
        [_lotteryButton setTitle:Localized(@"APP", nil) forState:UIControlStateNormal];
        [_lotteryButton setImage:[UIImage imageNamed:@"mine_lottery"] forState:UIControlStateNormal];
        [_lotteryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _lotteryButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _lotteryButton.tag = 103;
        CGSize imageSize = _lotteryButton.imageView.frame.size;
        CGSize titleSize = _lotteryButton.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height + ScaleW(6));
        _lotteryButton.imageEdgeInsets = UIEdgeInsetsMake(
                                                      - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
        _lotteryButton.titleEdgeInsets = UIEdgeInsetsMake(
                                                      0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
        [_lotteryButton addTarget:self action:@selector(topMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lotteryButton;
}

- (UIButton *)justiceButton {
    if (!_justiceButton) {
        _justiceButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ScaleH(48))];
        [_justiceButton setTitle:Localized(@"公平", nil) forState:UIControlStateNormal];
        [_justiceButton setImage:[UIImage imageNamed:@"mine_gongping"] forState:UIControlStateNormal];
        [_justiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _justiceButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _justiceButton.tag = 104;
        CGSize imageSize = _justiceButton.imageView.frame.size;
        CGSize titleSize = _justiceButton.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height + ScaleW(6));
        _justiceButton.imageEdgeInsets = UIEdgeInsetsMake(
                                                          - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
        _justiceButton.titleEdgeInsets = UIEdgeInsetsMake(
                                                          0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
        [_justiceButton addTarget:self action:@selector(topMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _justiceButton;
}

- (UIButton *)appDownButton {
    if (!_appDownButton) {
        _appDownButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/4, ScaleH(48))];
        [_appDownButton setTitle:Localized(@"APP", nil) forState:UIControlStateNormal];
        [_appDownButton setImage:[UIImage imageNamed:@"mine_appDown"] forState:UIControlStateNormal];
        [_appDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _appDownButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _appDownButton.tag = 105;
        CGSize imageSize = _appDownButton.imageView.frame.size;
        CGSize titleSize = _appDownButton.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height + ScaleW(6));
        _appDownButton.imageEdgeInsets = UIEdgeInsetsMake(
                                                          - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
        _appDownButton.titleEdgeInsets = UIEdgeInsetsMake(
                                                          0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
        [_appDownButton addTarget:self action:@selector(topMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appDownButton;
}
#pragma mark -- Setter Method

@end
