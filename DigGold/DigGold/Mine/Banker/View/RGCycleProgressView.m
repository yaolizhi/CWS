//
//  WJCycleProgressView.m
//  WJRollNumber
//
//  Created by James on 2019/1/3.
//  Copyright © 2019年 JamesWu. All rights reserved.
//

#import "RGCycleProgressView.h"
#import "Masonry.h"
#import "UIView+Layout.h"
#define Radius 116.0f
#define StartA M_PI_4 * 4
#define EndA M_PI * 2
@interface RGCycleProgressView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *backBorderLayer;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *subTitle;

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation RGCycleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = 1.0f;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.leftLabel];
        [self.bgView addSubview:self.rightLabel];
        [self.bgView addSubview:self.progressLabel];
        [self.bgView addSubview:self.subTitle];
        
        [self setupMasonry];
        [self setupBackgroundCyclePath];
    }
    return self;
}

- (void)setupMasonry {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(WJCycleProgressViewHeight);
        make.bottom.equalTo(self);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat pad = ScreenWidth/2+Radius+18;
        make.right.equalTo(self.bgView).offset(-pad);
        make.bottom.equalTo(self.bgView);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat pad = ScreenWidth/2+Radius+18;
        make.left.equalTo(self.bgView).offset(pad);
        make.bottom.equalTo(self.bgView);
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(72);
    }];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.progressLabel.mas_bottom).offset(9);
    }];
}

- (void)setupBackgroundCyclePath {
    CGPoint pathCenter = CGPointMake(self.bgView.width/2, self.bgView.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:pathCenter
                                                        radius:Radius
                                                    startAngle:StartA
                                                      endAngle:EndA
                                                     clockwise:YES];
    self.backBorderLayer.path = path.CGPath;
    [self.bgView.layer addSublayer:self.backBorderLayer];
    [self.bgView.layer addSublayer:self.progressLayer];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, WJCycleProgressViewHeight)];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.text = @"0%";
        _leftLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _leftLabel.textColor = kMainTitleColor;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.text = @"100%";
        _rightLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _rightLabel.textColor = kMainTitleColor;
    }
    return _rightLabel;
}

- (CAShapeLayer *)backBorderLayer {
    if (!_backBorderLayer) {
        _backBorderLayer = [CAShapeLayer layer];
        _backBorderLayer.frame = CGRectMake(0, 0, WJCycleProgressViewWidth, WJCycleProgressViewHeight);
        _backBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        _backBorderLayer.strokeColor = [UIColor whiteColor].CGColor;
        _backBorderLayer.opacity = 1;
        _backBorderLayer.lineCap = kCALineCapButt;
        _backBorderLayer.lineWidth = 25;
    }
    return _backBorderLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = CGRectMake(0, 0, WJCycleProgressViewWidth, WJCycleProgressViewHeight);
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = kMainTitleColor.CGColor;
        _progressLayer.opacity = 1;
        _progressLayer.lineCap = kCALineCapButt;
        _progressLayer.lineWidth = 25;
    }
    return _progressLayer;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]init];
        _progressLabel.text = @"0.00%";
        _progressLabel.font = [UIFont systemFontOfSize:ScaleFont(31)];
        _progressLabel.textColor = kMainTitleColor;
    }
    return _progressLabel;
}
- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [[UILabel alloc]init];
        _subTitle.text = @"您的股份";
        _subTitle.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _subTitle.textColor = kMainTitleColor;
    }
    return _subTitle;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateProgressLabelWithProgress:_progress];
    CGPoint pathCenter = CGPointMake(self.bgView.width/2.0f, self.bgView.height);
    CGFloat endA = M_PI_4 * 4.0f + M_PI_2 * 2.0f * _progress;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:pathCenter
                                                        radius:Radius
                                                    startAngle:StartA
                                                      endAngle:endA
                                                     clockwise:YES];
    self.progressLayer.path = path.CGPath;
    [self.progressLayer removeAnimationForKey:@"animationProgress"];
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAniamtion.duration = self.animationDuration;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    [self.progressLayer addAnimation:pathAniamtion forKey:@"animationProgress"];
}

- (void)updateProgressLabelWithProgress:(CGFloat)progress {
    __block double num = 0.0f;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC*(self.animationDuration/(progress*100.0f)), 0);
    dispatch_source_set_event_handler(self.timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (num < progress*100.0) {
                self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",num];
                num++;
            }else{
                self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",self.progress*100.0f];
                dispatch_source_cancel(self.timer);
            }
        });
    });
    //启动
    dispatch_resume(_timer);
}


@end
