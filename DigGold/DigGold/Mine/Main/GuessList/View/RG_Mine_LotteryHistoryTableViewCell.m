//
//  RG_MineLotteryHistoryTableViewCell.m
//  DigGold
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_Mine_LotteryHistoryTableViewCell.h"

@interface RG_Mine_LotteryHistoryTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *qsLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *inputLabel;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *hashF;
@end

@implementation RG_Mine_LotteryHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.iconImageView];
        [self.bgView addSubview:self.qsLabel];
        [self.bgView addSubview:self.resultLabel];
        [self.bgView addSubview:self.inputLabel];
        [self.bgView addSubview:self.checkButton];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(ScaleW(10));
        make.right.equalTo(self).offset(-ScaleW(10));
        make.height.mas_equalTo(35);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(12));
        make.centerY.equalTo(self.bgView);
        make.width.height.mas_offset(ScaleW(12));
    }];
    [self.qsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(60));
        make.centerY.equalTo(self.bgView);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(130));
        make.centerY.equalTo(self.bgView);
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(240));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(128));
    }];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-ScaleW(10));
        make.centerY.equalTo(self.bgView);
    }];
}

- (void)configureCell:(RG_Mine_LotteryModel *)model {
    self.hashF = model.boomHash?:@"";
    self.qsLabel.text = model.periodID?:@"";
    self.resultLabel.text = F(@"%@X", model.boomValue?:@"");
    self.inputLabel.text =  model.boomHash?:@"";
    [self layoutIfNeeded];
}

#pragma mark -- Public Method
- (void)initWithIndexPath:(NSIndexPath *)indexpath
{
    self.index = indexpath.row;
    if (indexpath.row % 2 == 1)
    {
        self.bgView.backgroundColor = kMainBackgroundColor;
    }
    else
    {
        self.bgView.backgroundColor = kMainSubBackgroundColor;
    }
}
#pragma mark -- Public Method
- (void)checkButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCheckButtonClickWithHash:)]) {
        [self.delegate didSelectedCheckButtonClickWithHash:self.hashF?:@""];
    }
}
#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = ScaleW(3);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = ScaleW(10);
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = [UIImage imageNamed:@"white_yinghua"];
        
    }
    return _iconImageView;
}

- (UILabel *)qsLabel {
    if (!_qsLabel) {
        _qsLabel = [[UILabel alloc]init];
        _qsLabel.textColor = kMainGaryWhiteColor;
        _qsLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _qsLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _qsLabel;
}
- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.textColor = kMainGaryWhiteColor;
        _resultLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _resultLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _resultLabel;
}
- (UILabel *)inputLabel {
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc]init];
        _inputLabel.textColor = kMainGaryWhiteColor;
        _inputLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        //        _inputLabel.adjustsFontSizeToFitWidth = YES;
        _inputLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _inputLabel;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [[UIButton alloc]init];
        [_checkButton setTitle:@"校验" forState:UIControlStateNormal];
        [_checkButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        [_checkButton addTarget:self action:@selector(checkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}
#pragma mark -- Setter Method

@end
