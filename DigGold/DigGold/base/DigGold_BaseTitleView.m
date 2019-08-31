//
//  DigGold_BaseTitleView.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "DigGold_BaseTitleView.h"

@interface DigGold_BaseTitleView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DigGold_BaseTitleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        
        _titleLabel.font = [UIFont systemFontOfSize:20];
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.textColor = kMainTextColor;
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
        
    }
    return _titleLabel;
}

-(void)changeTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)changeTitleColor:(UIColor *)titleColor
{
    self.titleLabel.textColor = titleColor;
}

-(void)changeTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
