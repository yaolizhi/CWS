//
//  RG_HelpCenterTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/29.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_QuestionTableViewCell.h"

@interface RG_QuestionTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation RG_QuestionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.lineView];
        [self.bgView addSubview:self.contentLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(ScaleH(10));
        make.left.mas_equalTo(ScaleW(27));
        make.right.mas_equalTo(-ScaleW(27));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleH(10));
        make.left.mas_equalTo(ScaleW(27));
        make.right.mas_equalTo(-ScaleW(27));
        make.height.mas_equalTo(1);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(ScaleH(10));
        make.left.mas_equalTo(ScaleW(27));
        make.right.mas_equalTo(-ScaleW(27));
        make.bottom.equalTo(self.bgView);
    }];
}

- (void)configureCellWithModel:(RG_CommonModel *)model {
    self.contentLabel.text = model.content?:@"";
    self.titleLabel.text = model.title?:@"";
    NSString *strUrl = [self.contentLabel.text stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
    self.contentLabel.text = strUrl;
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:4];
    
    [self layoutIfNeeded];
}

- (void)configureCellWithContent:(NSString *)content {

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
        _titleLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(16)];
        _titleLabel.textColor = kMainSubTextColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = kMainGaryWhiteColor;
    }
    return _lineView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _contentLabel.textColor = kMainSubTextColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
#pragma mark -- Setter Method

@end
