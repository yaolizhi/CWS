//
//  DatePickerView.m

//
//  Created by liuyang on 2017/7/12.
//  Copyright © 2017年 . All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define KtitleLab_Tag 7175
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#import "DatePickerView.h"
@interface DatePickerView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pickbgView;

@property (nonatomic, strong) NSString *selectDate;
@property(nonatomic,strong)UIDatePicker * datePickerView;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)UIButton * cannelBtn;
@property (nonatomic, assign) DateType type;
@end

@implementation DatePickerView


- (instancetype)initWithFrame:(CGRect)frame type:(DateType)type dataString:(NSString *)dataString
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        [self addSubview:self.pickbgView];
        self.type = type;
        if (type == DateTypeOfStart) {
            [self.datePickerView setMaximumDate:[NSDate date]];
        }
        if (type == DateTypeOfEnd) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *minDate = [formatter dateFromString:dataString];
            [self.datePickerView setMinimumDate:minDate];
            [self.datePickerView setMaximumDate:[NSDate date]];
        }
    }
    return self;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.4;
    }
    return _bgView;
}

- (UIView *)pickbgView {
    if (!_pickbgView) {
        _pickbgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 257)];
        _pickbgView.backgroundColor = [UIColor whiteColor];
        UIView * toolView = [[UIView alloc]init];
        [self.pickbgView addSubview:toolView];
        toolView.frame = CGRectMake(0, 0, kScreen_Width, 42);
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(kScreen_Width-18-33, 10, 33, 22);
        [toolView addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        _cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cannelBtn.frame = CGRectMake(18, 10, 33, 22);
        [toolView addSubview:_cannelBtn];
        
        [_cannelBtn addTarget:self action:@selector(cannelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cannelBtn setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        [_cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UILabel * titleLab = [[UILabel alloc]init];
        [toolView addSubview:titleLab];
        titleLab.frame = CGRectMake((kScreen_Width-130)/2, 12, 130, 17);
        titleLab.text = @"";
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.textColor = UIColorFromRGB(0x061631);
        
        UIView * lineView = [[UIView alloc]init];
        [_pickbgView addSubview:lineView];
        lineView.frame = CGRectMake(0, 42, kScreen_Width, 0.5);
        lineView.backgroundColor = UIColorFromRGB(0xBDBDBD);
        
        
        _datePickerView = [[UIDatePicker alloc]init];
        [_datePickerView setDatePickerMode:UIDatePickerModeDate];
        _datePickerView.locale = [[NSLocale alloc]
                                  initWithLocaleIdentifier:@"zh_CN"];
        _datePickerView.frame = CGRectMake(0, 52, kScreen_Width, 195);
        [_pickbgView addSubview:_datePickerView];
    }
    return _pickbgView;
}

- (void)showDataPickView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.pickbgView.frame = CGRectMake(0, kScreen_Height-257, kScreen_Width, 257);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissDataPickView {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.pickbgView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 257);
    } completion:^(BOOL finished) {
        [self.pickbgView removeFromSuperview];
        self.pickbgView = nil;
        [self removeFromSuperview];
    }];
}


- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}


-(void)cannelBtnClick{
    [self dismissDataPickView];
}

-(void)sureBtnClick
{
    self.selectDate = [self timeFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectDate:type:)]) {
        [self.delegate getSelectDate:self.selectDate type:self.type];
        [self dismissDataPickView];
    }
}

@end
