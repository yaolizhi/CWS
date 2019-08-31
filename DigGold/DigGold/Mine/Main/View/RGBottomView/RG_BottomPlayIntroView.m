//
//  RG_BottomPlayIntroView.m
//  DigGold
//
//  Created by James on 2019/1/12.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_BottomPlayIntroView.h"
#import "UIImage+GIF.h"
#import "RG_MainPlayViewController.h"
#define DefineHeight ScaleH(44)
@interface RG_BottomPlayIntroView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *gifButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation RG_BottomPlayIntroView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(ScreenWidth-ScaleW(20)-ScaleW(81),
                                           ScreenHeight-ScaleH(20)-ScaleH(75)-DefineHeight-Height_NavBar,
                                           ScaleW(81),
                                           ScaleH(75))];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.gifButton];
        [self.bgView addSubview:self.cancelButton];
        
    }
    return self;
}

- (void)showBottomPlay {
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self];

}

- (void)dismissBottomPlay {
//    [self removeFromSuperview];
    self.hidden = YES;
}

- (void)cancelButtonClick {
    [self dismissBottomPlay];
}

- (void)gifButtonClick {
    RG_MainPlayViewController *vc = [[RG_MainPlayViewController alloc]init];
//    [[UIViewController topViewController].navigationController presentViewController:vc animated:YES completion:nil];
    [[UIViewController topViewController].navigationController pushViewController:vc animated:YES];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.bounds];
    }
    return _bgView;
}

- (UIButton *)gifButton {
    if (!_gifButton) {
        _gifButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ScaleW(14), ScaleW(66), ScaleH(61))];
//        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"wanfajieshao" ofType:@"gif"];
//        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
//        [_gifButton setImage:[UIImage sd_animatedGIFWithData:imageData] forState:UIControlStateNormal];
        _gifButton.backgroundColor = [UIColor clearColor];
        [_gifButton setImage:[UIImage imageNamed:@"wanfajieshao"] forState:UIControlStateNormal];
        [_gifButton addTarget:self action:@selector(gifButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gifButton;
}


- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.gifButton.right, 0, ScaleW(14), ScaleW(14))];
        [_cancelButton setImage:[UIImage imageNamed:@"cancel_image"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
@end
