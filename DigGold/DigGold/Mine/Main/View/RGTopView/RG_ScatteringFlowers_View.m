//
//  RG_ScatteringFlowers_View.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/26.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_ScatteringFlowers_View.h"

@interface RG_ScatteringFlowers_View()

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RG_ScatteringFlowers_View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self addEmitterCells];
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeEmitter) userInfo:nil repeats:NO];
        
    }
    return self;
}

- (void)showEmitter {
    if ([[UIViewController topViewController] isKindOfClass:NSClassFromString(@"RG_MainViewController")]) {
        UIViewController *topVC = [UIViewController topViewController];
        [topVC.view addSubview:self];
        [self addEmitterCells];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeEmitter) userInfo:nil repeats:NO];
    }

}

//定时器方法  移除粒子效果
- (void)removeEmitter {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.emitterLayer.birthRate = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emitterLayer removeAllAnimations];
        [self.emitterLayer removeFromSuperlayer];
        [self removeFromSuperview];
    });

}
//销毁定时器
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

-(CAEmitterLayer *)emitterLayer
{
    if (nil == _emitterLayer) {
        
        _emitterLayer = [CAEmitterLayer layer];
        
        _emitterLayer.frame = CGRectMake(0, 100, ScreenWidth,-100);
        //发射位置
        _emitterLayer.emitterPosition = CGPointMake(self.frame.size.width / 2, 10);
        //发射器的尺寸
        _emitterLayer.emitterSize    = CGSizeMake(self.frame.size.width, 0);
        //发射的模式
        _emitterLayer.emitterMode    = kCAEmitterLayerOutline;
        //发射的形状
        _emitterLayer.emitterShape    = kCAEmitterLayerLine;
        //渲染模式
        _emitterLayer.renderMode        = kCAEmitterLayerOldestFirst;
        //粒子产生系数，默认为1
        _emitterLayer.birthRate = 1;

}
    
    return _emitterLayer;
}

-(void)addEmitterCells
{
    
    CAEmitterCell *cell1 = [self emitterCellWithName:[UIImage imageNamed:@"jb1"]];
    CAEmitterCell *cell2 = [self emitterCellWithName:[UIImage imageNamed:@"jb2"]];
    CAEmitterCell *cell3 = [self emitterCellWithName:[UIImage imageNamed:@"jb3"]];
    self.emitterLayer.emitterCells = @[cell1,cell2,cell3];
    [self.layer addSublayer:self.emitterLayer];
    self.emitterLayer.beginTime = CACurrentMediaTime();
    
}

-(CAEmitterCell *)emitterCellWithName:(UIImage *)image
{
    
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    
    cell.name = @"";
    
    cell.contents = (__bridge id _Nullable)image.CGImage;

    //设置粒子速度
    cell.velocity = 250;
    //速度范围波动
    cell.velocityRange = 100;
    
    //设置粒子的大小
    cell.scale = 0.5;
    //粒子大小范围
    cell.scaleRange = 0.3;
    //Y方向的加速度
    cell.yAcceleration = 100;
    
    //设置粒子方向
    cell.emissionLongitude = M_PI;
    //    cell.emissionRange = M_PI_2 / 4;
    
    //设置粒子的存活时间
    cell.lifetime = 3;
    //    cell.lifetimeRange = 1.5;
    
    //设置粒子旋转
    cell.spin = M_PI;
    cell.spinRange = M_PI / 2;
    
    //设置粒子美妙弹出的个数
    cell.birthRate = 6;
    
    return cell;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 30, 30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
