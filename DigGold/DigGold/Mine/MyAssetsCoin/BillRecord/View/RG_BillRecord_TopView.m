//
//  RG_BillRecord_TopView.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_BillRecord_TopView.h"

@interface RG_BillRecord_TopView()



@end

@implementation RG_BillRecord_TopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kMainBackgroundColor;
        //搜索按钮
        [self searchBtn];
        //开始时间父试图
        [self startView];
        //结束时间如父试图
        [self endView];
        //中间箭头
        [self timeImg];
        //开始日期img
        [self startimg];
        //结束日期img
        [self endimg];
        //开始日期
        [self startbtn];
        //结束日期
        [self endbtn];
        
        [self typeLabel];
        
        [self newpriceLabel];
        
        [self priceLabel];
    }
    return self;
}

- (UIButton *)searchBtn
{
    if (_searchBtn == nil) {
        
        _searchBtn = [WLTools allocButton:@"搜索" textColor:kMainGaryWhiteColor nom_bg:[UIImage imageNamed:@""] hei_bg:[UIImage imageNamed:@""] frame:CGRectZero];
        
        _searchBtn.backgroundColor = kMainTitleColor;
        
        [self addSubview:_searchBtn];
        
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@15);
            
            make.right.equalTo(@(-15));
            
            make.height.equalTo(@(40));
            
            make.width.equalTo(@(80));
        }];
    }
    return _searchBtn;
}


- (UIView *)startView
{
    if (_startView == nil) {
        
        _startView = [[UIView alloc]init];
        
        _startView.backgroundColor = kMainSubBackgroundColor;
        _startView.layer.cornerRadius = ScaleW(5);
        _startView.layer.masksToBounds = YES;
        [self addSubview:_startView];
        
        [_startView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self.searchBtn.mas_centerY);
            
            make.left.equalTo(self.mas_left).offset(15);
            
            make.height.equalTo(@(40));
            
            make.width.equalTo(@((ScreenWidth - 165) / 2));
            
        }];
    }
    return _startView;
}



- (UIView *)endView
{
    if (_endView == nil) {
        
        _endView = [[UIView alloc]init];
        
        _endView.backgroundColor = kMainSubBackgroundColor;
        _endView.layer.cornerRadius = ScaleW(5);
        _startView.layer.masksToBounds = YES;
        [self addSubview:_endView];
        
        [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.searchBtn.mas_centerY);
            
            make.right.equalTo(self.searchBtn.mas_left).offset(-15);
            
            make.height.equalTo(@(40));
            
            make.width.equalTo(@((ScreenWidth - 165) / 2));
            
        }];
    }
    return _endView;
}

- (UIImageView *)timeImg
{
    if (_timeImg == nil) {
        
        _timeImg = [WLTools allocImageView:CGRectZero image:[UIImage imageNamed:@""]];
        
        _timeImg.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_timeImg];
        
        [_timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.startView.mas_right);
            
            make.centerY.equalTo(self.searchBtn.mas_centerY);
            
            make.right.equalTo(self.endView.mas_right);
            
            make.height.equalTo(@(40));
            
        }];
    }
    return _timeImg;
}

- (UIButton *)startimg
{
    if (_startimg == nil) {
        
        UIImage *image = [UIImage imageNamed:@"mine_rili"];
        
        _startimg = [WLTools allocButton:@"" textColor:kMainGaryWhiteColor nom_bg:image hei_bg:[UIImage imageNamed:@""] frame:CGRectZero];
        
        
        [self.startView addSubview:_startimg];
        
        [_startimg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.startView.mas_centerY);
            
            make.right.equalTo(@(-5));
            
            make.height.equalTo(@(20));
            
            make.width.equalTo(@(20));
        }];
    }
    return _startimg;
}

- (UIButton *)startbtn
{
    if (_startbtn == nil) {
        
        UIImage *image = [UIImage imageNamed:@""];
        
        _startbtn = [WLTools allocButton:@"起始日期" textColor:kMainGaryWhiteColor nom_bg:image hei_bg:image frame:CGRectZero];
        
        _startbtn.titleLabel.font = systemFont(12);
        
        _startbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.startView addSubview:_startbtn];
        
        [_startbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@0);
            
            make.right.equalTo(self.startimg.mas_left).offset(-2);
            
            make.height.equalTo(@(40));
            
            make.left.equalTo(@(2));
        }];
    }
    return _startbtn;
}


- (UIButton *)endimg
{
    if (_endimg == nil) {
        
        UIImage *image = [UIImage imageNamed:@"mine_rili"];
        
        _endimg = [WLTools allocButton:@"" textColor:kMainGaryWhiteColor nom_bg:image hei_bg:[UIImage imageNamed:@""] frame:CGRectZero];
        

        
        [self.endView addSubview:_endimg];
        
        [_endimg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.endView.mas_centerY);
            
            make.right.equalTo(@(-5));
            
            make.height.equalTo(@(20));
            
            make.width.equalTo(@(20));
        }];
    }
    return _endimg;
}

- (UIButton *)endbtn
{
    if (_endbtn == nil) {
        
        UIImage *image = [UIImage imageNamed:@""];
        
        _endbtn = [WLTools allocButton:@"截止日期" textColor:kMainGaryWhiteColor nom_bg:image hei_bg:image frame:CGRectZero];
        
        _endbtn.titleLabel.font = systemFont(12);
        
        _endbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.endView addSubview:_endbtn];
        
        [_endbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@0);

            make.right.equalTo(self.endimg.mas_left).offset(-2);
            
            make.height.equalTo(@(40));
            
            make.left.equalTo(@(2));
        }];
    }
    return _endbtn;
}



- (UILabel *)typeLabel
{
    if (_typeLabel == nil) {
        
        _typeLabel = [WLTools allocLabel:@"变动类型/时间" font:systemFont(14) textColor:kMainGaryWhiteColor frame:CGRectZero textAlignment:NSTextAlignmentLeft];
        
        _typeLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15));
            
            make.bottom.equalTo(@(-10));
            
            make.height.equalTo(@(15));
            
            make.width.equalTo(@(120));
            
        }];
    }
    return _typeLabel;
}

- (UILabel *)newpriceLabel
{
    if (_newpriceLabel == nil) {
        
        _newpriceLabel = [WLTools allocLabel:@"变动后金额" font:systemFont(14) textColor:kMainGaryWhiteColor frame:CGRectZero textAlignment:NSTextAlignmentRight];
        
        _newpriceLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:_newpriceLabel];
        
        [_newpriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-15));
            
            make.bottom.equalTo(@(-10));
            
            make.height.equalTo(@(15));
            
            make.width.equalTo(@(80));
            
        }];
    }
    return _typeLabel;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {

        _priceLabel = [WLTools allocLabel:@"变动金额" font:systemFont(14) textColor:kMainGaryWhiteColor frame:CGRectZero textAlignment:NSTextAlignmentCenter];

        _priceLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:_priceLabel];

        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(@(-95));

            make.bottom.equalTo(@(-10));

            make.height.equalTo(@(15));

            make.left.equalTo(@(135));

        }];
    }
    return _priceLabel;
}

@end
