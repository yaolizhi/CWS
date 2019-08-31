//
//  WJBezierCurveView.m
//  WJCharts
//
//  Created by James on 2018/12/25.
//  Copyright © 2018年 JamesWu. All rights reserved.
//

#import "WJBezierCurveView.h"
#import "Masonry.h"
#import "RG_ScatteringFlowers_View.h"
#import "RG_EscapeModel.h"
#import "UIImage+GIF.h"
#import <CoreText/CoreText.h>

static CGRect myFrame;
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define HRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RandomColor  XYJColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define KDeviceWidth    [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight   [UIScreen mainScreen].bounds.size.height

#define KPortionNumber 100.0//分成的份额
#define LeftPadding    40.0 //X坐标轴的左侧与画布距离
#define RightPadding    15.0 //X坐标轴的右侧与画布距离
#define TopPadding    0.0 //Y坐标轴的上侧侧与画布距离
#define BottomPadding    20.0 //X坐标轴的下侧与画布距离
#define FaultPadding    20.0 //X轴和Y轴的容错距离
#define YLabelWith  40.0 //Y轴Label宽度
#define YLabelHeight  20.0 //Y轴Label宽度
#define XLabelWith  20.0 //Y轴Label宽度
#define XLabelHeight  20.0 //Y轴Label宽度


@interface WJBezierCurveView()
@property (nonatomic, strong) NSArray *x_names;
@property (nonatomic, strong) NSArray *y_names;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) double changeTime;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *multipleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *warmLabel;
@property (nonatomic, strong) UILabel *gameBeginLabel;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) CGFloat secondsFloat;//记录当秒数

@property (nonatomic, strong) UILabel *bzLabel;
@property (nonatomic, strong) UILabel *bzSubLabel;
@property (nonatomic, strong) RG_ScatteringFlowers_View *scatterFlowerView;
@property (nonatomic, assign) CGFloat maxTime;

@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, assign) WJBezierCurveViewType pointType;
@property (nonatomic, strong) NSMutableArray *eacapeArray;;

@property (nonatomic, assign) NSTimeInterval timeInterval;
//@property (nonatomic, assign) NSTimeInterval countDownInterval;
@property (nonatomic, assign) NSTimeInterval crashDownInterval;
@property (nonatomic, assign) BOOL hasEnterBack;

@end

@implementation WJBezierCurveView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kMainSubBackgroundColor;
        self.eacapeArray = [[NSMutableArray alloc]init];
        myFrame = frame;
        self.changeTime = 0.0;
        self.secondsFloat = 0.0;
        self.maxTime = 10.0f;
        self.hasEnterBack = NO;
        [self addSubview:self.bgImageView];
        [self addSubview:self.multipleLabel];
        [self addSubview:self.valueLabel];
        [self addSubview:self.warmLabel];
        [self addSubview:self.gameBeginLabel];
        [self addSubview:self.bzLabel];
        [self addSubview:self.bzSubLabel];
        
        [self addSubview:self.gifImageView];
        
        [self setupMasonry];
        [self addObserver:self forKeyPath:@"changeTime" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopDrawNotifion) name:kWebSocketConnentFailedNotifition object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hadEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hadEnterForeGround) name:UIApplicationDidBecomeActiveNotification object:nil];

    }
    return self;
}
- (void)hadEnterBackGround {
    self.hasEnterBack = YES;
}
- (void)hadEnterForeGround {
    self.hasEnterBack = NO;
}

- (NSTimeInterval)dateTimeDifference{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    NSDate *endD = [formatter dateFromString:currentDateString];
    NSTimeInterval start = [endD timeIntervalSince1970]*1;
    return start;
}


- (void)stopDrawNotifion {
    [self stopErrorDrawView];
}

//监听value的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"changeTime"]) {
        double value = [change[NSKeyValueChangeNewKey] doubleValue];
        self.multipleLabel.text = [NSString stringWithFormat:@"%.2fX",[self valueFormTime:value]];
        if ([self valueFormTime:value] >= 100.1f) {
            self.gifImageView.hidden = NO;
        }else{
            self.gifImageView.hidden = YES;
        }
        if (self.pointType == WJBezierCurveViewType_Draw) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(curveChangeTimeForceWithPoint:)]) {
                [self.delegate curveChangeTimeForceWithPoint:F(@"%.2f", [self valueFormTime:value])];
            }
        }
    }
}
#pragma mark -- PublichMethod
//******************************************************************
//设置倒计时方法
- (void)setupCountDownWithPerpareModel:(RG_kMainPrepareModel *)perpareModel isJCCoin:(BOOL)isJCCoin{
//    self.timeInterval = [self dateTimeDifference];
//    [self monitorDrawLineStopWithInterval:self.timeInterval];
    
    self.pointType = WJBezierCurveViewType_CountDown;
    self.valueLabel.hidden = NO;
    self.valueLabel.text = F(@"奖池：%@", isJCCoin?F(@"%@ %@", perpareModel.start_pb_pool_money?:@"",@"JC"):F(@"%@ %@", perpareModel.start_cny_pool_money?:@"",@"USDT"));
    
    self.gifImageView.hidden = YES;
//    self.countDownInterval = [self dateTimeDifference];
    if (self.delegate && [self.delegate respondsToSelector:@selector(curveCountDownForce)]) {
        [self.delegate curveCountDownForce];
    }
    
    if (self.timer) {
        return;
    }
    self.maxTime = [self fetchTimeIntWithStartTime:perpareModel.st endTime:perpareModel.pt]/1000;
    self.secondsFloat = 0.0;
    self.gameBeginLabel.hidden = NO;
    self.warmLabel.hidden = YES;
    self.multipleLabel.hidden = YES;
    self.bzLabel.hidden = YES;
    self.bzSubLabel.hidden = YES;
    
    //倒计时线为隐藏状态重置
    self.changeTime = 0.0f;
    [self setNeedsDisplay];
    
    [self openGCDTimer];
}
//设置划线方法
- (void)setupDrawLinWithProcessModel:(RG_kMainProcessModel *)processModel isJCCoin:(BOOL)isJCCoin escapeList:(NSArray *)escapeList{
    if (![[ManagerSocket sharedManager]socketIsConnected]) {//判断长连接是否连接
        [self stopErrorDrawView];
    }
    self.timeInterval = [self dateTimeDifference];
    
    self.pointType = WJBezierCurveViewType_Draw;
    self.bzLabel.hidden = YES;
    self.bzSubLabel.hidden = YES;
    self.valueLabel.hidden = NO;
    
    self.valueLabel.text = F(@"奖池：%@", isJCCoin?F(@"%@ %@", processModel.start_pb_pool_money?:@"",@"JC"):F(@"%@ %@", processModel.start_cny_pool_money?:@"",@"USDT"));
    
    CGFloat perTime = processModel.e/1000.0f;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(curveDrawLineForceWithPoint:)]) {
////        [self.delegate curveDrawLineForceWithPoint:F(@"%fX", [self valueFormTime:perTime])];
//    }
    
    self.warmLabel.hidden = YES;
    self.multipleLabel.hidden = NO;
    self.secondsFloat = self.maxTime;//防止刚启动是在倒计时
    NSInteger i = ceil(perTime);
    if (i%5 == 0 || self.changeTime == 0) {
        self.changeTime = perTime;
    }
    //逃跑人
    if (escapeList.count > 0) {
        NSMutableArray *newArray = [[NSMutableArray alloc]init];
        for (RG_EscapeModel *model in escapeList) {
            if ([model.uid isEqualToString:[[SSKJ_User_Tool sharedUserTool]getUID]]) {
                [newArray addObject:model];
                break;
            }
        }
        if (newArray.count == 1) {
            RG_EscapeModel *model = [newArray firstObject];
            [self eacapeDrawLabelWithString:F(@"%@@%.2f", model.realname?:@"",model.final_beishu)
                                 changeTime:perTime
                                     offset:0.0f];
        }
    }
    
    if (self.displayLink) {
        return;
    }
    [self startDrawView];
}

//设置爆炸方法
- (void)setupCrashWithCrashModel:(RG_kMainCrashModel *)crashModel isJCCoin:(BOOL)isJCCoin{
    self.pointType = WJBezierCurveViewType_Crash;
    self.valueLabel.hidden = NO;
    self.valueLabel.text = F(@"奖池：%@", isJCCoin?F(@"%@ %@", crashModel.start_pb_pool_money?:@"",@"JC"):F(@"%@ %@", crashModel.start_cny_pool_money?:@"",@"USDT"));
    
    
    self.gifImageView.hidden = YES;
    self.multipleLabel.hidden = YES;
    if (!self.bzLabel.hidden ||
        !self.bzSubLabel.hidden) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(curveCrashForce)]) {
        [self.delegate curveCrashForce];
    }
    self.secondsFloat = self.maxTime;//防止刚启动是在倒计时
    self.changeTime = [crashModel.e floatValue]/1000.0f;
    self.bzLabel.hidden = NO;
    self.bzSubLabel.hidden = NO;
    
    self.bzSubLabel.text = F(@"%.2fX", crashModel.boomValue);
    
    [self stopDrawView];
    
    //爆炸设置线为隐藏状态重置
    self.changeTime = 0.0f;
    [self setNeedsDisplay];
    
    if (!self.hasEnterBack) {//没进入后台
        [self.scatterFlowerView showEmitter];
    }
}

//******************************************************************

//开启倒计时定时器
- (void)openGCDTimer {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.1*NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf timerAction];
        
    });
    dispatch_resume(self.timer);
}
//定时器结束后需要执行的操作
- (void)timerAction {
//    [self monitorDrawLineStopWithInterval:self.countDownInterval];
    self.secondsFloat += 0.1;
    self.gameBeginLabel.text = F(@"将在%.1f s后开始", self.maxTime-self.secondsFloat);
    if ((self.maxTime-self.secondsFloat) <= 0) {
        [self pauseTimer];
        self.gameBeginLabel.hidden = YES;
        self.warmLabel.hidden = YES;
        self.multipleLabel.hidden = NO;
    }
}

//停止倒计时定时器
-(void)pauseTimer {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    
}

//开始划线
- (void)startDrawView {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeLinkTime)];
    self.displayLink = displayLink;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)changeLinkTime {
    
    [self monitorDrawLineStopWithInterval:self.timeInterval];
    
    self.changeTime += self.displayLink.duration;
    [self setNeedsDisplay];
}

- (void)monitorDrawLineStopWithInterval:(NSTimeInterval)timeInterval {
    NSTimeInterval endTimeInt = [self dateTimeDifference];
    NSTimeInterval startTimeInt = timeInterval;
    NSInteger space = endTimeInt - startTimeInt;
    if (space > SpaceTimes) {
        [self stopErrorDrawView];
        [[NSNotificationCenter defaultCenter]postNotificationName:kWebSocketConnentFailedNotifition object:nil];
    }
}

//停止画线
- (void)stopDrawView {
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.displayLink.paused = YES;
    
    [self.scatterFlowerView showEmitter];
}
- (void)stopErrorDrawView {
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.displayLink.paused = YES;

}







































- (CGFloat)fetchTimeIntWithStartTime:(CGFloat)startTime endTime:(CGFloat)endTime {
    
    NSTimeInterval balance = startTime - endTime;
    NSString *timeString = [[NSString alloc]init];
    timeString = [NSString stringWithFormat:@"%f",balance];
    timeString = [timeString substringToIndex:timeString.length-7];
    CGFloat timeInt = [timeString floatValue];
    return timeInt;
}


- (void)drawMoveXYCGContextLine {

    //1.画XY轴直线 X轴
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, kMainGaryWhiteColor.CGColor);
    CGContextSetLineWidth(context, 1.5);
    CGContextMoveToPoint(context, LeftPadding, CGRectGetHeight(myFrame)-BottomPadding);
    CGContextAddLineToPoint(context, CGRectGetWidth(myFrame)-RightPadding, CGRectGetHeight(myFrame)-BottomPadding);
    //Y轴
    CGContextMoveToPoint(context, LeftPadding, CGRectGetHeight(myFrame)-BottomPadding);
    CGContextAddLineToPoint(context, LeftPadding, TopPadding);
    CGContextStrokePath(context);
    
    //绘制移动的X
    [self drawMoveX];
    [self drawMoveY];
    [self drawMoveLine];
    
}

- (void)drawMoveX {
    CGFloat drawXWidth = CGRectGetWidth(myFrame)-LeftPadding-RightPadding-FaultPadding;
    CGFloat originalHeight = CGRectGetHeight(myFrame);
    double gap = 2;
    double gapNumber = 5;
    double totalTime = 10;
    if (self.changeTime > 10) {
        gap = 10;
        if (self.changeTime > 50 && self.changeTime < 250) {
            gap = 50;
        }else if (self.changeTime > 250){
            gap = 250;
        }
        totalTime = self.changeTime;
        gapNumber = totalTime / gap;
    }
    NSInteger totalCount = (totalTime / gap) + 1;
    for (NSInteger i = 0; i < totalCount; i++) {
        CGFloat frameScale = drawXWidth / gapNumber;
        NSString *time = [NSString stringWithFormat:@"%ld",(NSInteger)(i * gap)];
        [time drawInRect:CGRectMake(i * frameScale + LeftPadding-4 , originalHeight - BottomPadding+3, XLabelWith, XLabelHeight)
          withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],
                           NSForegroundColorAttributeName:kMainGaryWhiteColor}];
    }
}

- (void)drawMoveY {
    CGFloat drawYHeight = CGRectGetHeight(myFrame)-TopPadding-BottomPadding-FaultPadding;
    CGFloat drawYBottomHeight = CGRectGetHeight(myFrame)-BottomPadding-10;
    double maxYvalue = 0;
    double gap = 0.2;
    double gapNumber = 5;
    double maxTime = 10;
    if (self.changeTime >= 10) {
        maxYvalue = [self valueFormTime:self.changeTime] -1;
        maxTime = self.changeTime;
    }
    if (maxYvalue <= 1) {
        gap = 0.2;
        gapNumber = 5;
    }else{
        if (maxYvalue > 1 && maxYvalue < 10) {
            gap = 1;
        }else if (maxYvalue >= 10 && maxYvalue < 25){
            gap = 10;
        }else if (maxYvalue >= 25 && maxYvalue < 100){
            gap = 25;
        }else if (maxYvalue >= 100 && maxYvalue < 500){
            gap = 100;
        }else if (maxYvalue >= 500 && maxYvalue < 2000){
            gap = 500;
        }else if (maxYvalue >= 2000 && maxYvalue < 10000){
            gap = 2000;
        }else{
            gap = 10000;
        }
        gapNumber = maxYvalue / gap;
    }
    for (NSInteger i = 0; i<= (int)gapNumber; i++) {
        double valueGap = 0.0;
        if (gap >=10) {
            valueGap = i * gap;
        }else {
            valueGap = i * gap +1;
        }
        NSString *value = [NSString stringWithFormat:@"%.1f%@",valueGap,@"x"];
        [value drawInRect:CGRectMake(12, drawYBottomHeight - i / gapNumber * drawYHeight, YLabelWith, YLabelHeight)
           withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],
                            NSForegroundColorAttributeName:kMainGaryWhiteColor}];
    }
    
}

- (void)drawMoveLine {
    double drawXWidth = CGRectGetWidth(myFrame)-LeftPadding-RightPadding-FaultPadding;
    double drawXHeight = CGRectGetHeight(myFrame)-TopPadding-BottomPadding-FaultPadding;
    double drawHeightBottom = CGRectGetHeight(myFrame)-BottomPadding;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, kMainTitleColor.CGColor);
    CGContextSetLineWidth(context, 2);
    double maxYvalue = 100.0;
    double maxTime = 10.0;
    if (self.changeTime < 10) {
        maxYvalue = 1;
        maxTime = 10.0;
    }else{
        maxYvalue = [self valueFormTime:self.changeTime] - 1;
        maxTime = self.changeTime;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, LeftPadding, drawHeightBottom);
    double timeScale = self.changeTime / KPortionNumber;
    drawXWidth = drawXWidth * self.changeTime / maxTime;
    for (int i = 1; i <= KPortionNumber; i++) {
        double time = i * timeScale;
        double valueScale = [self valueFormTime:time] - 1;

        CGPathAddLineToPoint(path, NULL, i / KPortionNumber * drawXWidth+LeftPadding , drawHeightBottom - (valueScale/maxYvalue)*drawXHeight);
//        CGFloat drawX = i / KPortionNumber * drawXWidth*1.0+LeftPadding;
//        CGFloat drawY = drawHeightBottom - (valueScale/maxYvalue)*drawXHeight*1.0;
    }
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
 
    
}

- (void)eacapeDrawLabelWithString:(NSString *)string changeTime:(CGFloat)changeTime offset:(CGFloat)offset {
    double drawXWidth = CGRectGetWidth(myFrame)-LeftPadding-RightPadding-FaultPadding;
    double drawXHeight = CGRectGetHeight(myFrame)-TopPadding-BottomPadding-FaultPadding;
    double drawHeightBottom = CGRectGetHeight(myFrame)-BottomPadding;
    double maxYvalue = KPortionNumber;
    double maxTime = 10.0;
    if (changeTime < 10) {
        maxYvalue = 1;
        maxTime = 10.0;
    }else{
        maxYvalue = [self valueFormTime:changeTime] - 1;
        maxTime = changeTime;
    }
    drawXWidth = drawXWidth * changeTime / maxTime;
    double valueScale = [self valueFormTime:changeTime] - 1;
    
    CGFloat drawX = KPortionNumber / KPortionNumber * drawXWidth*1.0+LeftPadding;
    CGFloat drawY = drawHeightBottom - (valueScale/maxYvalue)*drawXHeight*1.0+offset;
    
    
    UIBezierPath *path = [self getStringLayer:string];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(drawX, drawY, 0, 0);
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.backgroundColor = [[UIColor clearColor] CGColor];
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = kMainGaryWhiteColor.CGColor;
    pathLayer.fillColor = kMainGaryWhiteColor.CGColor;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinMiter;
    [self.layer addSublayer:pathLayer];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pathLayer removeFromSuperlayer];
    });
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position"];// strokeStart 是擦除效果
    pathAnimation.duration = 2.0f;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(drawX, drawY)];
    pathAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(drawX-15, drawY+50)];
    pathAnimation.removedOnCompletion = YES;
    [pathLayer addAnimation:pathAnimation forKey:@"move-layer"];

    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    basicAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    basicAnimation.duration = 2.0f;
    basicAnimation.removedOnCompletion = YES;
    [pathLayer addAnimation:basicAnimation forKey:@"op"];
}



- (void)drawRect:(CGRect)rect {
    [self drawMoveXYCGContextLine];
}

-(double)valueFormTime:(double)time
{
    double a = 1.0716;
    if (time > 10) {

    }
    double y = pow(a, time);
    if(y<1.01){
        y=1.01;
    }else{
    }
    return y;
}


- (void)setupMasonry {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftPadding);
        make.bottom.equalTo(self).offset(-BottomPadding);
        make.width.mas_equalTo(ScaleW(303));
        make.height.mas_equalTo(ScaleH(90));
    }];
    [self.multipleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-ScaleH(20));
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(TopPadding);
        make.centerX.equalTo(self);
    }];
    [self.warmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-ScaleH(30));
    }];
    [self.gameBeginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.bzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-ScaleH(20));
    }];
    [self.bzSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bzLabel.mas_bottom).offset(ScaleH(5));
    }];
    
    [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftPadding+ScaleW(10));
        make.top.equalTo(self).offset(TopPadding+ScaleH(10));
        make.width.mas_equalTo(ScaleW(130));
        make.height.mas_equalTo(ScaleH(50));
    }];
}

-(UILabel *)multipleLabel {
    if (!_multipleLabel) {
        _multipleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftPadding+FaultPadding, TopPadding, 0, 0)];
        _multipleLabel.textColor = kMainYellowColor;
        _multipleLabel.font = [UIFont systemFontOfSize:ScaleFont(30)];
        _multipleLabel.hidden = YES;
    }
    return _multipleLabel;
}

-(UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftPadding+FaultPadding, TopPadding, 0, 0)];
        _valueLabel.textColor = kMainGaryWhiteColor;
        _valueLabel.text = @"奖池 0USDT";
        _valueLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
    }
    return _valueLabel;
}

- (UILabel *)warmLabel {
    if (!_warmLabel) {
        _warmLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _warmLabel.text = Localized(@"基于区块链技术打造，庄家仅1%的优势，公平公正", nil);
        _warmLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _warmLabel.textColor = kMainGaryWhiteColor;
    }
    return _warmLabel;
}

- (UILabel *)gameBeginLabel {
    if (!_gameBeginLabel) {
        _gameBeginLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _gameBeginLabel.text = Localized(@"将在10.0 s后开始", nil);
        _gameBeginLabel.font = [UIFont systemFontOfSize:ScaleFont(17)];
        _gameBeginLabel.textColor = kMainYellowColor;
        _gameBeginLabel.hidden = YES;
    }
    return _gameBeginLabel;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"mine_quxian"];
    }
    return _bgImageView;
}

- (UILabel *)bzLabel {
    if (!_bzLabel) {
        _bzLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _bzLabel.text = Localized(@"爆炸了", nil);
        _bzLabel.font = [UIFont systemFontOfSize:ScaleFont(30)];
        _bzLabel.textColor = kMainTitleColor;
        _bzLabel.hidden = YES;
        
    }
    return _bzLabel;
}
- (UILabel *)bzSubLabel {
    if (!_bzSubLabel) {
        _bzSubLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _bzSubLabel.text = Localized(@"", nil);
        _bzSubLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _bzSubLabel.textColor = kMainGaryWhiteColor;
        _bzSubLabel.hidden = YES;
        
    }
    return _bzSubLabel;
}

- (RG_ScatteringFlowers_View *)scatterFlowerView {
    _scatterFlowerView = [[RG_ScatteringFlowers_View alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    return _scatterFlowerView;
}

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScaleW(150), ScaleH(50))];
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"timgcaishen" ofType:@"gif"];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        _gifImageView.image = [UIImage sd_animatedGIFWithData:imageData];
        _gifImageView.hidden = YES;
    }
    return _gifImageView;
}


//贝塞尔绘制名字
- (UIBezierPath *)getStringLayer:(NSString *)str{
    
    CGMutablePathRef letters = CGPathCreateMutable();
    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), 10.0f, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:str
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    CGPathRelease(letters);
    CFRelease(font);
    return path;
}
@end

