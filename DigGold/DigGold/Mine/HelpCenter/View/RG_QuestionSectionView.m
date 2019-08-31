//
//  RG_QuestionSectionView.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_QuestionSectionView.h"

@interface RG_QuestionSectionView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, assign) NSInteger section;
@end

@implementation RG_QuestionSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.bgButton];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.height.mas_equalTo(ScaleH(50));
        make.bottom.equalTo(self.bgView);
    }];
}

- (void)configureViewWithTitle:(NSString *)titleString section:(NSInteger)section{
    self.section = section;
    [self.bgButton setTitle:titleString?:@"" forState:UIControlStateNormal];
    [self layoutIfNeeded];
}

#pragma mark -- Public Method
- (void)click {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithSection:)]) {
        [self.delegate didSelectedWithSection:self.section];
    }
}
#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc]init];
        _bgButton.layer.cornerRadius = ScaleW(5);
        _bgButton.layer.masksToBounds = YES;
        _bgButton.layer.borderWidth = 1;
        _bgButton.layer.borderColor = kLightLineColor.CGColor;
        _bgButton.backgroundColor = kMainSubBackgroundColor;
        _bgButton.titleLabel.font = [UIFont systemFontOfSize:ScaleW(16)];
        [_bgButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _bgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _bgButton.titleEdgeInsets = UIEdgeInsetsMake(0, ScaleW(10), 0, 0);
        [_bgButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}
#pragma mark -- Setter Method

@end
