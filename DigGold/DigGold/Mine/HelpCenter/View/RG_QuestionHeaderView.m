//
//  RG_QuestionHeaderView.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_QuestionHeaderView.h"

@interface RG_QuestionHeaderView()

@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation RG_QuestionHeaderView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        self.titleLabel.text = title?:@"";
        self.subTitleLabel.text = subTitle?:@"";
        [UILabel changeLineSpaceForLabel:self.subTitleLabel WithSpace:4];
        [self setupMasnory];

    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];

        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)configureWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    self.titleLabel.text = title?:@"";
    self.subTitleLabel.text = subTitle?:@"";
    [self layoutIfNeeded];
}

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(25));
        make.top.equalTo(self.bgView).offset(ScaleH(42));
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(25));
        make.right.equalTo(self.bgView).offset(-ScaleW(25));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(15));
        make.bottom.equalTo(self.bgView);
    }];
}


#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(29)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _subTitleLabel.textColor = kMainSubTextColor;
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}
#pragma mark -- Setter Method

@end
