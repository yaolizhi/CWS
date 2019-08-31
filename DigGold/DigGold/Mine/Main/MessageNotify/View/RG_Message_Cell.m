//
//  RG_Message_Cell.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_Message_Cell.h"


@interface RG_Message_Cell()

@property (nonatomic,strong) UIView * baseView;

@property (nonatomic,strong) UIView * redView;

@property (nonatomic,strong) UILabel * contentLabel;

@property (nonatomic,strong) UILabel * timeLabel;

@end

@implementation RG_Message_Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = kMainBackgroundColor;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self baseView];
        
        [self redView];
        
        [self contentLabel];
        
        [self timeLabel];
        
    }
    return self;
}

- (void)configureCellWith:(RG_MessageModel *)model {
    self.redView.hidden = model.is_read;
    self.contentLabel.text = model.content?:@"";
    self.timeLabel.text = model.create_time?:@"";
    [self layoutIfNeeded];
}

- (UIView *)baseView
{
    if (_baseView == nil)
    {
        _baseView = [[UIView alloc]init];
        _baseView.layer.cornerRadius = 5;
        
        _baseView.layer.masksToBounds = YES;
        _baseView.backgroundColor = kMainSubBackgroundColor;
        
        [self addSubview:_baseView];
        
        [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).offset(10);
            
            make.left.equalTo(self).offset(15);
            
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
        }];
    }
    return _baseView;
}

- (UIView *)redView
{
    if (_redView == nil)
    {
        _redView = [[UIView alloc]init];
        
        _redView.backgroundColor = UIColorFromRGB(0xDD6D7B);
        
        _redView.layer.cornerRadius = 5;
        
        _redView.layer.masksToBounds = YES;
        _redView.hidden = YES;
        
        [self.baseView addSubview:_redView];
        
        [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.baseView).offset(20);
            
            make.left.equalTo(self.baseView).offset(10);
            
            make.width.height.mas_equalTo(10);
            
        }];
        
    }
    return _redView;
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil)
    {
        _contentLabel = [[UILabel alloc]init];
        
        _contentLabel.textColor = kMainGaryWhiteColor;
        
        _contentLabel.font = [UIFont systemFontOfSize:14];
        
//        _contentLabel.text = @"恭喜进入通知中心，你将在这里获得不一样的体验，不了解的问题都可以在问题中心去查看";
        
        _contentLabel.numberOfLines = 0;
        
        [self.baseView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.baseView).offset(15);
            
            make.left.equalTo(self.redView.mas_right).offset(10);
        
            make.right.equalTo(self.baseView).offset(-10);
        }];
        
    }
    return _contentLabel;
}


- (UILabel *)timeLabel
{
    if (_timeLabel == nil)
    {
        _timeLabel = [[UILabel alloc]init];
        
        _timeLabel.textColor = kMainGaryWhiteColor;
        
//        _timeLabel.text = @"2019-01-01 12:00:00";
        
        _timeLabel.font = [UIFont systemFontOfSize:14];
        
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.baseView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(11);
            make.left.equalTo(self.redView.mas_right).offset(10);
            
            make.right.equalTo(self.baseView).offset(-10);
            
            make.bottom.equalTo(self.baseView.mas_bottom).offset(-15);
        }];
    }
    return _timeLabel;
}

@end
