//
//  RG_AgencyMiddleView.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyMiddleView.h"
#import "RG_AgencyMiddleItemView.h"
@interface RG_AgencyMiddleView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RG_AgencyMiddleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
    }];
    
    [self createMiddleView];
}

- (void)createMiddleView {
    NSArray *icons = @[@"icon_gp",@"icon_yj",@"icon_sywd",@"icon_dl",@"icon_boss",@"icon_game"];
    NSArray *titles = @[@"公平、公正",@"佣金高达40%",@"收益稳定",@"三级代理",@"独立BOSS系统",@"独立游戏域名"];
    NSArray *subTitles = @[@"BSG.GAME提供区块链的竞猜游戏，让玩家玩得放心",
                           @"我们优秀的代理计划，可以让您获得高达40%的收益",
                           @"我们的收益是抽取用户投注流水，每月结算",
                           @"不只是您推荐的玩家有佣金，玩家推荐的玩家你也会获得额外的佣金，一共有三级",
                           @"针对每个代理商，会给予独立的BOSS系统进行数据统计和管理",
                           @"我们可以根据代理商单独币种的要求，给予独立游戏域名"];
    
    for (NSInteger i = 0; i<icons.count; i++) {
        RG_AgencyMiddleItemView *view = [[RG_AgencyMiddleItemView alloc]initWithFrame:CGRectZero
                                                                                 icon:icons[i]
                                                                                title:titles[i]
                                                                             subTitle:subTitles[i]];
        [self.bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            NSInteger row = i / 2;
            NSInteger col = i % 2;
            CGFloat margin = (ScreenWidth-AgencyMiddleItemWidth*2)/3;
            CGFloat picX = margin + (AgencyMiddleItemWidth + margin) * col;
            CGFloat picY = margin + (AgencyMiddleItemHeight + margin) * row;
            make.left.equalTo(self.bgView).offset(picX);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(picY+ ScaleH(18));
            make.width.mas_equalTo(AgencyMiddleItemWidth);
            make.height.mas_equalTo(AgencyMiddleItemHeight);
            if (i == icons.count-1) {
                make.bottom.equalTo(self.bgView);
            }
        }];
    }
}

- (void)configureView {
    
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kMainGaryWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:ScaleFont(21)];
        _titleLabel.text = @"BSG的优点";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
#pragma mark -- Setter Method

@end
