//
//  RG_UserProfileHeaderView.m
//  DigGold
//
//  Created by James on 2018/12/31.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_UserProfileHeaderView.h"
#import "RG_PullDownView.h"
@interface RG_UserProfileHeaderView()<RG_PullDownViewDelegate>
@property (nonatomic, strong,readwrite) UIButton *chooseButton;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *downImageView;
@property (nonatomic, strong) RG_PullDownView *pullDownView;

@property (nonatomic, strong) NSArray *titlesArray;
@end

@implementation RG_UserProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.chooseButton];
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLabel];
        self.titlesArray = titles;
        [self.chooseButton addSubview:self.downImageView];
        [self.chooseButton setTitle:title forState:UIControlStateNormal];
        [self addSubview:self.pullDownView];
//        self.nameLabel.text = @"JamesWu";
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(16));
        make.top.equalTo(self).offset(ScaleW(16));
        make.width.mas_equalTo(ScaleW(121));
        make.height.mas_equalTo(ScaleH(33));
    }];
    
    [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseButton).offset(-ScaleW(10));
        make.centerY.equalTo(self.chooseButton);
        make.width.mas_equalTo(ScaleW(11));
        make.height.mas_equalTo(ScaleH(6));
    }];
    
    [self.pullDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseButton.mas_bottom).offset(1);
        make.left.equalTo(self.chooseButton);
        make.right.equalTo(self.chooseButton);
        make.width.equalTo(self.chooseButton);
        make.height.mas_equalTo(0);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(ScaleW(74));
        make.width.height.mas_equalTo(ScaleW(91));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(ScaleW(24));
        make.bottom.equalTo(self).offset(-ScaleH(12));
    }];


}

- (void)configureViewWithHeader:(NSString *)imageString name:(NSString *)name {
    if ([imageString containsString:@"http"]) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
    }else{
        self.headerImageView.image = [UIImage imageNamed:imageString];
    }
    self.nameLabel.text = name?:@"";
    [self layoutIfNeeded];
}

- (void)chooseButtonClick {
//    if (self.chooseButton.selected) {
//        [self dismissSideslipView];
//    }else{
//        [self showSideslipView];
//    }
//    self.chooseButton.selected = !self.chooseButton.selected;
}

- (void)didSelectedPullDownTitle:(NSString *)title {
    [self dismissSideslipView];
    self.chooseButton.selected = !self.chooseButton.selected;
    [self.chooseButton setTitle:title?:@"" forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedChooseButtonClickType:)]) {
        [self.delegate didSelectedChooseButtonClickType:title];
    }
}

#pragma mark -- Public Method
- (void)showSideslipView {
    self.pullDownView.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PullDownViewCellHeight*self.titlesArray.count);
        }];
        [self.pullDownView.superview layoutIfNeeded];
    }];
}

- (void)dismissSideslipView {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.pullDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.pullDownView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -- Getter Method
- (UIButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc]init];
        _chooseButton.layer.cornerRadius = ScaleW(3);
        _chooseButton.layer.masksToBounds = YES;
        _chooseButton.backgroundColor = kMainSubBackgroundColor;
        _chooseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chooseButton.titleEdgeInsets = UIEdgeInsetsMake(0, ScaleW(10), 0, 0);
        [_chooseButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _chooseButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_chooseButton addTarget:self action:@selector(chooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseButton;
}


- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = ScaleW(90/2);
    }
    return _headerImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _nameLabel.textColor = kMainGaryWhiteColor;
    }
    return _nameLabel;
}

- (UIImageView *)downImageView {
    if (!_downImageView) {
        _downImageView = [[UIImageView alloc]init];
        _downImageView.image = [UIImage imageNamed:@"rank_down"];
        _downImageView.hidden = YES;
    }
    return _downImageView;
}

- (RG_PullDownView *)pullDownView {
    if (!_pullDownView) {
        _pullDownView = [[RG_PullDownView alloc]initWithFrame:CGRectZero titlesArray:self.titlesArray];
        _pullDownView.hidden = YES;
        _pullDownView.delegate = self;
        
    }
    return _pullDownView;
}
#pragma mark -- Setter Method

@end
