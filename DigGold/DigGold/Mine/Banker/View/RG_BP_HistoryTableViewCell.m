//
//  RG_BP_HistoryTableViewCell.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_BP_HistoryTableViewCell.h"

@interface RG_BP_HistoryTableViewCell()
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation RG_BP_HistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.stateLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.timeLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(19));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScaleW(60));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(100));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScaleW(80));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(ScaleW(-10));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScaleW(125));
    }];
}

- (void)configureCellWithModel:(RG_BPHistoryModel *)model coin:(NSString *)coin{
    self.stateLabel.text = [model.type isEqualToString:@"1"]?@"注入":@"抽取";
    self.priceLabel.text = F(@"%@%@",model.money,coin);
    self.timeLabel.text = [NSString timeWithTimeIntervalString:model.add_time?:@""];
    [self layoutIfNeeded];
}

#pragma mark -- Public Method
- (void)initWithIndexPath:(NSIndexPath *)indexpath
{
    if (indexpath.row % 2 == 1){
        self.backgroundColor = kMainBackgroundColor;
    }else{
        self.backgroundColor = kMainSubBackgroundColor;
    }
}
#pragma mark -- Getter Method
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _stateLabel.textColor = kMainTitleColor;
        _stateLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _stateLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _priceLabel.textColor = kMainGaryWhiteColor;
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _timeLabel.textColor = kMainGaryWhiteColor;
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

#pragma mark -- Setter Method

@end
