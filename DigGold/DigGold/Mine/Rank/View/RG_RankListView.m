//
//  RG_RankListView.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_RankListView.h"
#import "RG_PullDownView.h"
@interface RG_RankListView()<RG_PullDownViewDelegate>
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *rankEnLabel;

@property (nonatomic, strong,readwrite) UIButton *amountButton;
@property (nonatomic, strong,readwrite) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *amountImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *rankpoiLabel;
@property (nonatomic, strong) UILabel *playerLabel;


@property (nonatomic, strong) RG_PullDownView *coinPullDownView;
@property (nonatomic, strong) NSArray *coinTitlesArray;
@property (nonatomic, strong) RG_PullDownView *wayPullDownView;
@property (nonatomic, strong) NSArray *wayTitlesArray;
@end

@implementation RG_RankListView

- (instancetype)initWithFrame:(CGRect)frame coinTitlesArray:(NSArray *)coinTitlesArray wayTitlesArray:(NSArray *)wayTitlesArray coinTitle:(NSString *)coinTitle wayTitle:(NSString *)wayTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coinTitlesArray = coinTitlesArray;
        self.wayTitlesArray = wayTitlesArray;
        [self addSubview:self.rankLabel];
        [self addSubview:self.rankEnLabel];
        [self addSubview:self.amountButton];
        [self addSubview:self.rightButton];
        [self.amountButton addSubview:self.amountImageView];
        [self.rightButton addSubview:self.rightImageView];
        
        [self addSubview:self.coinPullDownView];
        [self addSubview:self.wayPullDownView];
        
        [self addSubview:self.iconImageView];
        
        [self addSubview:self.rankpoiLabel];
        [self addSubview:self.playerLabel];
        [self addSubview:self.inputLabel];
        
        [self.rightButton setTitle:Localized(coinTitle, nil) forState:UIControlStateNormal];
        [self.amountButton setTitle:Localized(wayTitle, nil) forState:UIControlStateNormal];
        [self setupMasnory];
        
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(25));
        make.top.equalTo(self).offset(ScaleH(42));
    }];
    [self.rankEnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(25));
        make.top.equalTo(self.rankLabel.mas_bottom).offset(ScaleH(15));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-ScaleW(15));
        make.centerY.equalTo(self.rankEnLabel);
        make.width.mas_equalTo(ScaleW(80));
        make.height.mas_equalTo(ScaleH(30));
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightButton).offset(-ScaleW(6));
        make.centerY.equalTo(self.rightButton);
        make.width.mas_equalTo(ScaleW(11));
        make.height.mas_equalTo(ScaleH(6));
    }];
    
    [self.coinPullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightButton.mas_bottom);
        make.left.right.equalTo(self.rightButton);
        make.width.equalTo(self.rightButton);
        make.height.mas_equalTo(0);
    }];
    
    [self.amountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightButton.mas_left).offset(-ScaleW(22));
        make.centerY.equalTo(self.rankEnLabel);
        make.width.mas_equalTo(ScaleW(90));
        make.height.mas_equalTo(ScaleH(30));
    }];
    
    [self.amountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountButton).offset(-ScaleW(6));
        make.centerY.equalTo(self.amountButton);
        make.width.mas_equalTo(ScaleW(11));
        make.height.mas_equalTo(ScaleH(6));
    }];
    
    [self.wayPullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountButton.mas_bottom);
        make.left.right.equalTo(self.amountButton);
        make.width.equalTo(self.amountButton);
        make.height.mas_equalTo(0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankEnLabel.mas_bottom).offset(ScaleH(30));
        make.left.equalTo(self).offset(ScaleW(15));
        make.right.equalTo(self).offset(-ScaleW(15));
        make.height.mas_equalTo(ScaleH(95));
    }];
    
    [self.rankpoiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(ScaleH(18));
        make.left.equalTo(self).offset(ScaleW(26));
    }];
    [self.playerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankpoiLabel);
        make.left.equalTo(self).offset(ScaleW(111));
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankpoiLabel);
        make.right.equalTo(self).offset(-ScaleW(25));
        make.bottom.equalTo(self);
    }];
}

- (void)configureView {
    
}

- (void)didSelectedPullDownTitle:(NSString *)title {
    self.amountButton.selected = !self.amountButton.selected;
    self.rightButton.selected = !self.rightButton.selected;
    if ([self.coinTitlesArray containsObject:title]) {
        [self dismissCoinSideslipView];
        [self.rightButton setTitle:title forState:UIControlStateNormal];
    }else{
        [self dismissWaySideslipView];
        [self.amountButton setTitle:title forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedRankWithTitle:)]) {
        [self.delegate didSelectedRankWithTitle:title];
    }
}

- (void)amountButtonClick {
    if (self.amountButton.selected) {
        [self dismissWaySideslipView];
    }else{
        [self showWaySideslipView];
    }
    self.amountButton.selected = !self.amountButton.selected;
}

- (void)rightButtonClick {
//    if (self.rightButton.selected) {
//        [self dismissCoinSideslipView];
//    }else{
//        [self showCoinSideslipView];
//    }
//    self.rightButton.selected = !self.rightButton.selected;
}

#pragma mark -- Public Method
- (void)showCoinSideslipView {
    self.coinPullDownView.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.coinPullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PullDownViewCellHeight*self.coinTitlesArray.count);
        }];
        [self.coinPullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissCoinSideslipView {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.coinPullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.coinPullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.coinPullDownView.hidden = YES;
    }];
}

- (void)showWaySideslipView {
    self.wayPullDownView.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.wayPullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PullDownViewCellHeight*self.wayTitlesArray.count);
        }];
        [self.wayPullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissWaySideslipView {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.wayPullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.wayPullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.wayPullDownView.hidden = YES;
    }];
}
#pragma mark -- Getter Method
- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc]init];
        _rankLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(29)];
        _rankLabel.textColor = kMainGaryWhiteColor;
        _rankLabel.text = Localized(@"排行榜", nil);
        
    }
    return _rankLabel;
}
- (UILabel *)rankEnLabel {
    if (!_rankEnLabel) {
        _rankEnLabel = [[UILabel alloc]init];
        _rankEnLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        _rankEnLabel.textColor = kMainGaryWhiteColor;
        _rankEnLabel.text = Localized(@"PANKLING LIST", nil);
        
    }
    return _rankEnLabel;
}
- (UIButton *)amountButton {
    if (!_amountButton) {
        _amountButton = [[UIButton alloc]init];
        [_amountButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _amountButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _amountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_amountButton addTarget:self action:@selector(amountButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _amountButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        [_rightButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIImageView *)amountImageView {
    if (!_amountImageView) {
        _amountImageView = [[UIImageView alloc]init];
        _amountImageView.image = [UIImage imageNamed:@"rank_down"];

    }
    return _amountImageView;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.image = [UIImage imageNamed:@"rank_down"];
        _rightImageView.hidden = YES;
    }
    return _rightImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"rank_main"];
    }
    return _iconImageView;
}

- (UILabel *)rankpoiLabel {
    if (!_rankpoiLabel) {
        _rankpoiLabel = [[UILabel alloc]init];
        _rankpoiLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _rankpoiLabel.textColor = kMainGaryWhiteColor;
        _rankpoiLabel.text = Localized(@"#", nil);
    }
    return _rankpoiLabel;
}
- (UILabel *)playerLabel {
    if (!_playerLabel) {
        _playerLabel = [[UILabel alloc]init];
        _playerLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _playerLabel.textColor = kMainGaryWhiteColor;
        _playerLabel.text = Localized(@"玩家", nil);
    }
    return _playerLabel;
}
- (UILabel *)inputLabel {
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc]init];
        _inputLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _inputLabel.textColor = kMainGaryWhiteColor;
        _inputLabel.text = Localized(@"最高盈利", nil);
    }
    return _inputLabel;
}

- (RG_PullDownView *)coinPullDownView {
    if (!_coinPullDownView) {
        _coinPullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:self.coinTitlesArray];
        _coinPullDownView.hidden = YES;
        _coinPullDownView.delegate = self;
    }
    return _coinPullDownView;
}

- (RG_PullDownView *)wayPullDownView {
    if (!_wayPullDownView) {
        _wayPullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:self.wayTitlesArray];
        _wayPullDownView.hidden = YES;
        _wayPullDownView.delegate = self;
    }
    return _wayPullDownView;
}
#pragma mark -- Setter Method

@end
