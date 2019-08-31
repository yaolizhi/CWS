//
//  RG_Mine_AllGuessTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Mine_AllGuessTableViewCell.h"

@interface RG_Mine_AllGuessTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *qsLabel;
@property (nonatomic, strong) UILabel *runLabel;
@property (nonatomic, strong) UILabel *inputLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@end

@implementation RG_Mine_AllGuessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.headerImageView];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.qsLabel];
        [self.bgView addSubview:self.runLabel];
        [self.bgView addSubview:self.inputLabel];
        [self.bgView addSubview:self.incomeLabel];
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
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(10));
        make.centerY.equalTo(self.bgView);
        make.width.height.mas_offset(ScaleW(18));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(ScaleW(5));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.qsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(116));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.runLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(180));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(225));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(ScaleW(306));
        make.centerY.equalTo(self.bgView);
        make.width.mas_equalTo(ScaleW(90));
    }];
}

- (void)configureCellWithModel:(RG_XiaZhuModel *)model {
    NSString *coin = [model.pid isEqualToString:@"2"]?@"JC":@"USDT";
    
    NSString *realName = model.realname?:@"";
    if ([RegularExpression validateMobile:realName]) {
        realName = [realName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    self.nameLabel.text = realName;
    self.qsLabel.text = model.qs?:@"";
    NSString *url = model.upic.length>0?F(@"%@%@",ProductBaseServer, model.upic):@"headerProfile";
    if ([url containsString:@"http"]) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }else{
        self.headerImageView.image = [UIImage imageNamed:url];
    }
    
    self.inputLabel.text = F(@"%ld%@",(long)[model.buy_money integerValue],coin?:@"");
    if (model.status == 1) {//游戏中
        self.runLabel.text = @"--";
        self.runLabel.textColor = kMainGaryWhiteColor;
        self.incomeLabel.text = @"--";
        self.incomeLabel.textColor = kMainGaryWhiteColor;
    }
    if (model.status == 2) {//逃跑
        self.runLabel.text = F(@"%.2fX",model.final_beishu);
        self.runLabel.textColor = kMainYellowColor;
        self.incomeLabel.text = F(@"%f%@", (model.final_beishu *[model.buy_money floatValue]),coin?:@"");
        self.incomeLabel.textColor = kMainYellowColor;
    }
    if (model.status == 3) {//爆炸
        self.runLabel.text = F(@"%@X",model.escape_beishu);
        self.runLabel.textColor = kMainTitleColor;
        self.incomeLabel.text = F(@"-%f%@", [model.buy_money floatValue],coin?:@"");
        self.incomeLabel.textColor = kMainTitleColor;
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

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.layer.cornerRadius = ScaleW(10);
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = kMainGaryWhiteColor;
        _nameLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
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
- (UILabel *)runLabel {
    if (!_runLabel) {
        _runLabel = [[UILabel alloc]init];
        _runLabel.textColor = kMainGaryWhiteColor;
        _runLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _runLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _runLabel;
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
#pragma mark -- Setter Method

@end
