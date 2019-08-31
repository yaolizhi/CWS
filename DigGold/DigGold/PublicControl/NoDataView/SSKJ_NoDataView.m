//
//  QBWShowNoDataView.m
//  ZYW_MIT
//
//  Created by 张本超 on 2018/4/28.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import "SSKJ_NoDataView.h"


#define textLabelFontHeight  12.f
#define spetorHeight 10.f
@interface SSKJ_NoDataView()
//主视图
@property(nonatomic,strong)UIImageView *img;

@property (nonatomic, strong) UILabel *textLabel;


@end
@implementation SSKJ_NoDataView
//
+(instancetype)showNoData:(NSArray *)dataArr  toView:(UIView *)view offY:(CGFloat) offY
{
    
    BOOL haveData;
    
    if (dataArr.count == 0) {
        
        haveData = NO;
        
    }else{
        
        haveData = YES;
    }
    
    SSKJ_NoDataView *viewResult = [[SSKJ_NoDataView alloc]initWithFrame:CGRectMake(view.x, offY, view.width, view.height - offY)];
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[SSKJ_NoDataView class]]) {
            [v removeFromSuperview];
            break;
        }
    }
    if (haveData)
    {
        
    }else{
      [view addSubview:viewResult];
    }
    return viewResult;
};

+(instancetype)showNoData:(NSArray *)dataArr   toView:(UIView *)view frame:(CGRect)frame
{
    BOOL haveData;
    
    if (dataArr.count == 0) {
        
        haveData = NO;
        
    }else{
        
        haveData = YES;
    }
    
    SSKJ_NoDataView *viewResult = [[SSKJ_NoDataView alloc]initWithFrame:view.bounds];
    viewResult.frame = frame;
    viewResult.img.centerY = viewResult.height / 2;
    viewResult.textLabel.top = viewResult.img.bottom + spetorHeight;
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[SSKJ_NoDataView class]]) {
            [v removeFromSuperview];
            break;
        }
    }
    if (haveData)
    {
        
    }
    else
    {
        [view addSubview:viewResult];
    }
    return viewResult;
};
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"public_noData"]];
        self.img.centerX = self.centerX;
        self.img.centerY = self.centerY - self.img.image.size.height;
        [self addSubview:self.img];
        [self addSubview:self.textLabel];
        self.backgroundColor = kMainBackgroundColor;
    }
    return self;
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.width = self.width;
        _textLabel.height = textLabelFontHeight;
        _textLabel.left = 0;
        _textLabel.top = _img.bottom + spetorHeight;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel label:_textLabel font:textLabelFontHeight textColor:UIColorFromRGB(0xC0CDDD) text:Localized(@"暂无记录", nil)];
        
    }
    return _textLabel;
}
@end
