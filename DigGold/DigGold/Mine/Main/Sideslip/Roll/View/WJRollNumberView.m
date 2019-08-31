//
//  WJRollNumberView.m
//  WJRollNumber
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 JamesWu. All rights reserved.
//

#import "WJRollNumberView.h"

@interface WJRollNumberView()
@property (nonatomic, strong) UIImageView *rollImageView;
@property (nonatomic, strong) UIView *rollView;
@property (nonatomic, strong) UILabel *rollLabel;

@property (nonatomic, assign) NSInteger currentRollNumber;
@property (nonatomic, assign) NSInteger recordLabelHeight;
@property (nonatomic, copy) void (^rollBlock)(NSInteger rollNumber);
@property (nonatomic, assign) CGFloat intervalTime;

@end

@implementation WJRollNumberView

- (instancetype)initWithFrame:(CGRect)frame rollBlock:(void (^)(NSInteger rollNumber))rollBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.intervalTime = 5.0f;
        self.rollBlock = rollBlock;
        self.currentRollNumber = 0;
        [self addSubview:self.rollImageView];
        [self.rollImageView addSubview:self.rollView];
        [self.rollView addSubview:self.rollLabel];
        [self setupMasonry];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasonry {
    [self.rollImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(WJRollNumberViewWidth);
        make.height.mas_equalTo(WJRollNumberViewHeight);
        make.bottom.equalTo(self);
    }];
}

#pragma mark -- Public Method
- (void)setupRandomScrollRollAssign:(NSInteger)rollNumber rollLength:(NSInteger)rollLength {
    NSMutableString *mutString = [NSMutableString stringWithFormat:@"%ld",self.currentRollNumber];
    for (NSInteger i = 1; i< rollLength-1; ++i) {
        [mutString appendFormat:@"\n%ld",random()%10];
    }
    [mutString appendFormat:@"\n%ld",rollNumber];
    self.rollLabel.numberOfLines = 0;
    self.rollLabel.text = (NSString *)mutString;
    self.recordLabelHeight = self.rollLabel.size.height;
    self.rollLabel.height = self.recordLabelHeight*rollLength;
    self.currentRollNumber = rollNumber;
}

- (void)startRollScrollWithRollNumber:(NSInteger)rollNumber rollLength:(NSInteger)rollLength intervalTime:(CGFloat)intervalTime {
    self.intervalTime = intervalTime;
    [self setupRandomScrollRollAssign:rollNumber rollLength:rollLength];
    [self rollAnimation];
}

- (void)rollAnimation {
    self.rollLabel.top = -10;
    [UIView animateWithDuration:self.intervalTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.rollLabel.top = self.recordLabelHeight - self.rollLabel.height+6;
    } completion:^(BOOL finished) {
        if (finished) {
            self.rollBlock(self.currentRollNumber);
            [self resetRollLabel];
        }
    }];
}

- (void)resetRollLabel {
    
    CGRect rect = CGRectMake((48-40)/2, 0, 40, self.recordLabelHeight);
    self.rollLabel.frame = rect;
    self.rollLabel.text = [NSString stringWithFormat:@"%ld",self.currentRollNumber];
}


#pragma mark -- Getter Method
- (UIImageView *)rollImageView {
    if (!_rollImageView) {
        _rollImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WJRollNumberViewWidth, WJRollNumberViewHeight)];
        _rollImageView.image = [UIImage imageNamed:@"roll"];
        _rollImageView.layer.masksToBounds = YES;
    }
    return _rollImageView;
}
- (UIView *)rollView {
    if (!_rollView) {
        _rollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 48, 60)];
        _rollView.centerY = self.rollImageView.centerY-10;
        _rollView.centerX = self.rollImageView.centerX;
        _rollView.layer.masksToBounds = YES;

    }
    return _rollView;
}

- (UILabel *)rollLabel {
    if (!_rollLabel) {
        _rollLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 0)];
        _rollLabel.text = [NSString stringWithFormat:@"%ld",self.currentRollNumber];
        _rollLabel.font = [UIFont boldSystemFontOfSize:60];
        _rollLabel.textColor = [UIColor whiteColor];
        _rollLabel.textAlignment = NSTextAlignmentCenter;
        _rollLabel.left = (48-40)/2;
        CGFloat height = [self getStringHeightWithText:_rollLabel.text fontSize:60 viewWidth:40];
        _rollLabel.height = height;
    }
    return _rollLabel;
}

- (CGFloat)getStringHeightWithText:(NSString *)text fontSize:(float)fontSize viewWidth:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    return  ceilf(size.height);
}

@end
