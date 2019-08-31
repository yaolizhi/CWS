//
//  RG_Mine_MyGuessTableViewCell.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_Mine_MyGuessTableViewCell.h"

@interface RG_Mine_MyGuessTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *qsLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *inputLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *escapeLabel;
@end

@implementation RG_Mine_MyGuessTableViewCell

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
        [self.bgView addSubview:self.incomeLabel];
        [self.bgView addSubview:self.escapeLabel];
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
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(115));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(35));
    }];
    [self.escapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(170));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(35));
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(225));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(70));
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(306));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(90));
    }];
}

- (void)configureCellWithModel:(RG_MyGuessModel *)model {
    NSString *coin = [model.pid isEqualToString:@"2"]?@"JC":@"USDT";
    
    self.qsLabel.text = model.qs?:@"";
    self.resultLabel.text = F(@"%@X", model.boomValue?:@"");
    self.inputLabel.text = F(@"%ld%@", (long)[model.buy_money?:@"" integerValue],coin?:@"");
    self.incomeLabel.text = F(@"%f%@", model.income,coin?:@"");
    self.escapeLabel.text = F(@"%@X", model.final_beishu?:@"");
    if ([model.status isEqualToString:@"3"]) {//爆炸了
        self.incomeLabel.textColor = kMainTitleColor;
        self.escapeLabel.text = F(@"%@X", model.escape_beishu?:@"");
    }
    if ([model.status isEqualToString:@"2"]) {//逃跑了
        self.incomeLabel.textColor = kMainYellowColor;
        self.escapeLabel.text = F(@"%@X", model.final_beishu?:@"");
    }
    
    [self layoutIfNeeded];
}

#pragma mark -- Public Method
- (void)initWithIndexPath:(NSIndexPath *)indexpath
{
    if (indexpath.row % 2 == 1)
    {
        self.bgView.backgroundColor = kMainBackgroundColor;
    }
    else
    {
        self.bgView.backgroundColor = kMainSubBackgroundColor;
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
        _inputLabel.adjustsFontSizeToFitWidth = YES;
        _inputLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _inputLabel;
}
- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
        _incomeLabel.textColor = kMainGaryWhiteColor;
        _incomeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _incomeLabel.adjustsFontSizeToFitWidth = YES;
        _incomeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _incomeLabel;
}
- (UILabel *)escapeLabel {
    if (!_escapeLabel) {
        _escapeLabel = [[UILabel alloc]init];
        _escapeLabel.textColor = kMainGaryWhiteColor;
        _escapeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _escapeLabel.adjustsFontSizeToFitWidth = YES;
        _escapeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _escapeLabel;
}
#pragma mark -- Setter Method

@end
