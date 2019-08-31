//
//  RG_RollBottomView.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_RollBottomView.h"

@interface RG_RollBottomView()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation RG_RollBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentLabel];
        NSString *s1 = @"Roll点时间\n";
        NSString *s2 = @"开始时间为每天；活动结束发放奖励\n\n";
        NSString *s3 = @"Roll点玩法\n";
        NSString *s4 = @"1.平台会拿不同的币种和金额当做奖励\n";
        NSString *s5 = @"2.每天参加过投注的玩家才能获得一次机会(JC除外)，根据Roll的点数大小排名，前10名获得奖励\n";
        NSString *s6 = @"3.Roll是0-999的一个随机数，祝你好运！";
        self.contentLabel.text = F(@"%@%@%@%@%@%@", s1,s2,s3,s4,s5,s6);
        [self.contentLabel text:s1 color:[UIColor whiteColor] font:[UIFont systemFontOfSize:ScaleFont(14)]];
        [self.contentLabel text:s3 color:[UIColor whiteColor] font:[UIFont systemFontOfSize:ScaleFont(14)]];
        [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:6];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScaleW(16));
        make.right.equalTo(self).offset(-ScaleW(16));
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}



- (void)configureViewWithTime:(NSString *)time {
    NSString *s1 = @"Roll点时间\n";
    NSString *s2 = F(@"开始时间为每天%@；活动结束发放奖励\n\n", time?:@"");
    NSString *s3 = @"Roll点玩法\n";
    NSString *s4 = @"1.平台会拿不同的币种和金额当做奖励\n";
    NSString *s5 = @"2.每天参加过投注的玩家才能获得一次机会(JC除外)，根据Roll的点数大小排名，前10名获得奖励\n";
    NSString *s6 = @"3.Roll是0-999的一个随机数，祝你好运！";
    self.contentLabel.text = F(@"%@%@%@%@%@%@", s1,s2,s3,s4,s5,s6);
    [self.contentLabel text:s1 color:[UIColor whiteColor] font:[UIFont systemFontOfSize:ScaleFont(14)]];
    [self.contentLabel text:s3 color:[UIColor whiteColor] font:[UIFont systemFontOfSize:ScaleFont(14)]];
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:6];
    [self layoutIfNeeded];
}

#pragma mark -- Public Method

#pragma mark -- Getter Method
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = kMainGaryWhiteColor;
        _contentLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
#pragma mark -- Setter Method

@end
