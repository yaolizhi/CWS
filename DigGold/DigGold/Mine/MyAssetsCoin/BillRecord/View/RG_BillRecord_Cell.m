//
//  RG_BillRecord_Cell.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_BillRecord_Cell.h"

@interface RG_BillRecord_Cell()

@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,strong) UILabel * typeLabel;

@property (nonatomic,strong) UILabel * timeLabel;

@property (nonatomic,strong) UILabel * priceLabel;

@property (nonatomic,strong) UILabel * newPriceLabel;
@property (nonatomic, strong) UIView *bottomView;



@end

@implementation RG_BillRecord_Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = kMainBackgroundColor;
        
        [self typeLabel];
        
        [self timeLabel];
        
        [self newPriceLabel];
        
        [self priceLabel];
//        [self setupMasonry];
        
    }
    return self;
}

- (void)setupMasonry {
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        
        make.left.equalTo(self).offset(15);
        
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(14);
        make.left.equalTo(self.baseView).offset(10);
        
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(12);
        make.left.equalTo(self.baseView).offset(10);
        make.bottom.equalTo(self.baseView).offset(-10);
        
    }];
    
    [self.newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.baseView.mas_centerY).offset(ScaleH(4));
        make.right.equalTo(self.baseView.mas_right).offset(-10);
        
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.baseView.mas_centerY).offset(ScaleH(4));
        make.centerX.equalTo(self.baseView.mas_left).offset(ScaleW(185));
        
//        make.right.equalTo(self.newPriceLabel.mas_left).offset(-5);
        
//        make.left.equalTo(self.typeLabel.mas_right).offset(5);
        
//        make.height.equalTo(@(15));
        
    }];
}
- (void)configureWithModel:(RG_BillRecordModel *)model {
    self.typeLabel.text = model.memo?:@"";
    
    self.priceLabel.text = model.price?:@"";
    if ([model.price integerValue] >= 0) {
        self.priceLabel.text = F(@"+%@",model.price?:@"");
        self.priceLabel.textColor = kMainYellowColor;
    }else{
        self.priceLabel.textColor = kMainTitleColor;
    }
    self.newPriceLabel.text = model.nprice?:@"";
    self.timeLabel.text = [NSString timeWithTimeIntervalString:model.addtime?:@""];
    [self setupMasonry];
}

- (UIView *)baseView
{
    if (_baseView == nil)
    {
        _baseView = [[UIView alloc]init];
        
        _baseView.backgroundColor = kMainSubBackgroundColor;
        
        _baseView.layer.cornerRadius = 3;
        
        _baseView.layer.masksToBounds = YES;
        
        [self addSubview:_baseView];
        
 
    }
    return _baseView;
}

- (UILabel *)typeLabel
{
    if (_typeLabel == nil) {
        
        _typeLabel = [WLTools allocLabel:Localized(@"", nil) font:systemFont(12) textColor:kMainGaryWhiteColor frame:CGRectZero textAlignment:NSTextAlignmentLeft];
        
        _typeLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.baseView addSubview:_typeLabel];
        
 
    }
    return _typeLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        
        _timeLabel = [WLTools allocLabel:@"" font:systemFont(10) textColor:kMainGaryWhiteColor frame:CGRectZero textAlignment:NSTextAlignmentLeft];
        
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.baseView addSubview:_timeLabel];
        

    }
    return _timeLabel;
}

- (UILabel *)newPriceLabel
{
    if (_newPriceLabel == nil) {
        
        _newPriceLabel = [WLTools allocLabel:@"" font:systemFont(14) textColor:kMainGaryWhiteColor frame:CGRectZero textAlignment:NSTextAlignmentRight];
        
        _newPriceLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.baseView addSubview:_newPriceLabel];
        

    }
    return _newPriceLabel;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        
        _priceLabel = [WLTools allocLabel:@"" font:systemFont(14) textColor:kMainYellowColor frame:CGRectZero textAlignment:NSTextAlignmentCenter];
        
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.baseView addSubview:_priceLabel];
        
  
    }
    return _priceLabel;
}

//- (UIView *)bottomView {
//    if (!_bottomView) {
//        _bottomView = [[UIView alloc]init];
//        _bottomView.backgroundColor = kMainBackgroundColor;
//        [self.baseView addSubview:_bottomView];
//        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(@(10));
//
//            make.bottom.equalTo(@(-10));
//
//            make.height.equalTo(@(15));
//
//            make.width.equalTo(@(120));
//
//        }];
//    }
//    return _bottomView;
//}
@end
