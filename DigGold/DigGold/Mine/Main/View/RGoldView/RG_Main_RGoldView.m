//
//  RG_Main_RGoldView.m
//  DigGold
//
//  Created by James on 2018/12/27.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_Main_RGoldView.h"
#import "RG_Mine_RGoldItemView.h"

@interface RG_Main_RGoldView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) RG_Mine_RGoldItemView *firstItem;
@property (nonatomic, strong) RG_Mine_RGoldItemView *secondItem;
@property (nonatomic, strong) RG_Mine_RGoldItemView *thirdItem;
@property (nonatomic, strong) RG_Mine_RGoldItemView *fourthItem;
@property (nonatomic, strong) RG_Mine_RGoldItemView *fifthItem;

//点我坐庄
@property (nonatomic, strong) UIButton *pickMeButton;
@property (nonatomic, strong) UIView *dashedView;
@property (nonatomic, strong) UILabel *escapeLabel;


@end

@implementation RG_Main_RGoldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        //topShow
        [self.bgView addSubview:self.firstItem];
        [self.bgView addSubview:self.secondItem];
        [self.bgView addSubview:self.thirdItem];
        [self.bgView addSubview:self.fourthItem];
        [self.bgView addSubview:self.fifthItem];
        
        //点我坐庄
        [self.bgView addSubview:self.dashedView];
        [self.bgView addSubview:self.pickMeButton];
        [self.bgView addSubview:self.curveView];
        
        //投注
        [self.bgView addSubview:self.betButton];
        [self.bgView addSubview:self.betSettingView];
        
        [self.betButton addSubview:self.escapeLabel];
        [self setupMasnory];
    
//        [self addBorderToLayer2:self.bgView];
    }
    return self;
}

- (void)addBorderToLayer2:(UIView *)view
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setBounds:CGRectMake(0, 0, ScreenWidth, 1)];
    [shapeLayer setPosition:CGPointMake(ScreenWidth / 2, 100/2)];
    
    [shapeLayer setStrokeColor:kImaginaryLineColor.CGColor];
    [shapeLayer setLineWidth:1];
    [shapeLayer setLineDashPattern:@[@6,@3]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (ScreenWidth > 100) {
        CGPathAddLineToPoint(path, NULL, ScreenWidth,0);
    }else{
        CGPathAddLineToPoint(path, NULL, 0,100);
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [view.layer addSublayer:shapeLayer];
}


#pragma mark -- Private Method

- (void)setupMasnory {
    CGFloat normalWidth = ScreenWidth-ScaleW(20);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(ScaleW(10));
        make.right.equalTo(self).offset(-ScaleW(10));
//        make.height.mas_equalTo(ScaleH(467));
        make.bottom.equalTo(self);
    }];
    [self.firstItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
        make.width.mas_equalTo(normalWidth/5);
        make.height.mas_equalTo(ScaleH(36));
    }];
    [self.secondItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.firstItem.mas_right);
        make.width.mas_equalTo(normalWidth/5);
        make.height.mas_equalTo(ScaleH(36));
    }];
    [self.thirdItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.secondItem.mas_right);
        make.width.mas_equalTo(normalWidth/5);
        make.height.mas_equalTo(ScaleH(36));
    }];
    [self.fourthItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.thirdItem.mas_right);
        make.width.mas_equalTo(normalWidth/5);
        make.height.mas_equalTo(ScaleH(36));
    }];
    [self.fifthItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.fourthItem.mas_right);
        make.width.mas_equalTo(normalWidth/5);
        make.height.mas_equalTo(ScaleH(36));
    }];
    
    //pickme
    [self.dashedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(ScaleH(50));
        make.width.mas_equalTo(normalWidth);
        make.height.mas_equalTo(1);
    }];

    [self.pickMeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(ScaleH(48));
    }];
    [self.curveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.width.mas_equalTo(normalWidth);
        make.height.mas_equalTo(ScaleH(180));
        make.top.equalTo(self.pickMeButton.mas_bottom).offset(ScaleH(10));
    }];
    
    [self.betButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(25));
        make.right.equalTo(self.bgView).offset(-ScaleW(25));
        make.height.mas_equalTo(ScaleH(50));
        make.top.equalTo(self.curveView.mas_bottom).offset(ScaleH(35));
    }];
    [self.betSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.betButton.mas_bottom).offset(ScaleH(12));
        make.bottom.equalTo(self.bgView);
    }];
    [self.escapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.betButton);
        make.bottom.equalTo(self.betButton).offset(-ScaleH(6));
    }];
}

- (void)configureViewWithArray:(NSArray *)modelsArray {
    if (modelsArray.count < 0) {
        return;
    }
    if (modelsArray.count == 1) {
        RG_Mine_LotteryModel *model1 = modelsArray[0];
        [self.firstItem configureViewTitleString:model1.periodID?:@""
                                  subTitleString:F(@"%@X", model1.boomValue?:@"")
                                   subTitleColor:kMainTitleColor];
    }
    if (modelsArray.count == 2) {
        RG_Mine_LotteryModel *model1 = modelsArray[0];
        [self.firstItem configureViewTitleString:model1.periodID?:@""
                                  subTitleString:F(@"%@X", model1.boomValue?:@"")
                                   subTitleColor:[UIColor greenColor]];
        
        RG_Mine_LotteryModel *model2 = modelsArray[1];
        [self.secondItem configureViewTitleString:model2.periodID?:@""
                                  subTitleString:F(@"%@X", model2.boomValue?:@"")
                                   subTitleColor:[UIColor yellowColor]];
    }
    if (modelsArray.count == 3) {
        RG_Mine_LotteryModel *model1 = modelsArray[0];
        [self.firstItem configureViewTitleString:model1.periodID?:@""
                                  subTitleString:F(@"%@X", model1.boomValue?:@"")
                                   subTitleColor:kMainTitleColor];
        
        RG_Mine_LotteryModel *model2 = modelsArray[1];
        [self.secondItem configureViewTitleString:model2.periodID?:@""
                                  subTitleString:F(@"%@X", model2.boomValue?:@"")
                                   subTitleColor:[UIColor yellowColor]];
        
        RG_Mine_LotteryModel *model3 = modelsArray[2];
        [self.thirdItem configureViewTitleString:model3.periodID?:@""
                                  subTitleString:F(@"%@X", model3.boomValue?:@"")
                                   subTitleColor:[UIColor redColor]];
    }
    if (modelsArray.count == 4) {
        RG_Mine_LotteryModel *model1 = modelsArray[0];
        [self.firstItem configureViewTitleString:model1.periodID?:@""
                                  subTitleString:F(@"%@X", model1.boomValue?:@"")
                                   subTitleColor:[UIColor greenColor]];
        
        RG_Mine_LotteryModel *model2 = modelsArray[1];
        [self.secondItem configureViewTitleString:model2.periodID?:@""
                                  subTitleString:F(@"%@X", model2.boomValue?:@"")
                                   subTitleColor:[UIColor yellowColor]];
        
        RG_Mine_LotteryModel *model3 = modelsArray[2];
        [self.thirdItem configureViewTitleString:model3.periodID?:@""
                                  subTitleString:F(@"%@X", model3.boomValue?:@"")
                                   subTitleColor:[UIColor redColor]];
        
        RG_Mine_LotteryModel *model4 = modelsArray[3];
        [self.fourthItem configureViewTitleString:model4.periodID?:@""
                                  subTitleString:F(@"%@X", model4.boomValue?:@"")
                                   subTitleColor:[UIColor orangeColor]];
    }
    if (modelsArray.count == 5) {
        RG_Mine_LotteryModel *model1 = modelsArray[0];
        [self.firstItem configureViewTitleString:model1.periodID?:@""
                                  subTitleString:F(@"%@X", model1.boomValue?:@"")
                                   subTitleColor:[UIColor greenColor]];
        
        RG_Mine_LotteryModel *model2 = modelsArray[1];
        [self.secondItem configureViewTitleString:model2.periodID?:@""
                                  subTitleString:F(@"%@X", model2.boomValue?:@"")
                                   subTitleColor:[UIColor yellowColor]];
        
        RG_Mine_LotteryModel *model3 = modelsArray[2];
        [self.thirdItem configureViewTitleString:model3.periodID?:@""
                                  subTitleString:F(@"%@X", model3.boomValue?:@"")
                                   subTitleColor:[UIColor redColor]];
        
        RG_Mine_LotteryModel *model4 = modelsArray[3];
        [self.fourthItem configureViewTitleString:model4.periodID?:@""
                                  subTitleString:F(@"%@X", model4.boomValue?:@"")
                                   subTitleColor:[UIColor orangeColor]];
        RG_Mine_LotteryModel *model5 = modelsArray[4];
        [self.fifthItem configureViewTitleString:model5.periodID?:@""
                                  subTitleString:F(@"%@X", model5.boomValue?:@"")
                                   subTitleColor:[UIColor greenColor]];
    }
    [self layoutIfNeeded];
}

#pragma mark -- Public Method
- (void)pickMeButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPickMeClick)]) {
        [self.delegate didSelectedPickMeClick];
    }
}
- (void)betButtonClick {
    [self.betSettingView.betTextField resignFirstResponder];
    [self.betSettingView.runAwayTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedBetWithPrice:beishu:)]) {
        [self.delegate didSelectedBetWithPrice:self.betSettingView.betTextField.text?:@""
                                        beishu:self.betSettingView.runAwayTextField.text?:@""];
    }
}

- (void)calculateBetNumber {
    
}


- (void)setupBetButtonWithEnabled:(BOOL)enabled labelHidden:(BOOL)labelHidden labelTitle:(NSString *)labelTitle buttonTitle:(NSString *)buttonTitle buttonColor:(UIColor *)buttonColor buttonInset:(BOOL)buttonInset {
    self.betButton.enabled = enabled;
    self.escapeLabel.hidden = labelHidden;
    self.escapeLabel.text = labelTitle?:@"";
    [self.betButton setTitle:buttonTitle forState:UIControlStateNormal];
    self.betButton.backgroundColor = buttonColor;
    if (buttonInset) {
        self.betButton.titleEdgeInsets = UIEdgeInsetsMake(-ScaleH(12), 0, 0, 0);
    }else{
        self.betButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}

/* 倒计时 */
- (void)setupBetButtonCountdownWithModel:(RG_BetStatusModel *)model {
    if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        [self setupBetButtonWithEnabled:YES
                            labelHidden:YES
                             labelTitle:@""
                            buttonTitle:@"投注"
                            buttonColor:kMainBetGaryColor
                            buttonInset:NO];
        return;
    }
    
    if (model.hasBet) {
        [self setupBetButtonWithEnabled:NO
                            labelHidden:YES
                             labelTitle:@""
                            buttonTitle:@"等待中..."
                            buttonColor:kMainBetGaryColor
                            buttonInset:NO];
    }else{
        
        [self setupBetButtonWithEnabled:YES
                            labelHidden:YES
                             labelTitle:@""
                            buttonTitle:@"投注"
                            buttonColor:kMainTitleColor
                            buttonInset:NO];
    }
    
}
/* 划线 */
- (void)setupBetButtonDrawLineWithModel:(RG_BetStatusModel *)model {
    if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        [self setupBetButtonWithEnabled:YES
                            labelHidden:NO
                             labelTitle:@"(下一局)"
                            buttonTitle:@"预约"
                            buttonColor:kMainBetGaryColor
                            buttonInset:YES];
        return;
    }
    if (model.hasBet) {
        [self setupBetButtonWithEnabled:YES
                            labelHidden:NO
                             labelTitle:@"(逃跑)"
                            buttonTitle:model.changeTimes?:@""
                            buttonColor:kMainTitleColor
                            buttonInset:YES];
    }else{
        if (model.cacheHasBet) {//缓存投注
            [self setupBetButtonWithEnabled:YES
                                labelHidden:NO
                                 labelTitle:@"(取消)"
                                buttonTitle:@"等待中..."
                                buttonColor:kMainTitleColor
                                buttonInset:YES];
        }else{//没有缓存投注
            [self setupBetButtonWithEnabled:YES
                                labelHidden:NO
                                 labelTitle:@"(下一局)"
                                buttonTitle:@"预约"
                                buttonColor:kMainTitleColor
                                buttonInset:YES];
        }
 
    }
    
}
/* 爆炸 */
- (void)setupBetButtonBombWithModel:(RG_BetStatusModel *)model {
    if (![[SSKJ_User_Tool sharedUserTool]isLogingState]) {
        [self setupBetButtonWithEnabled:YES
                            labelHidden:YES
                             labelTitle:@""
                            buttonTitle:@"爆炸了"
                            buttonColor:kMainBetGaryColor
                            buttonInset:NO];
        return;
    }
    
    if (model.cacheHasBet) {
        [self setupBetButtonWithEnabled:NO
                            labelHidden:NO
                             labelTitle:@""
                            buttonTitle:@"等待中..."
                            buttonColor:kMainBetGaryColor
                            buttonInset:NO];
    }else{
        [self setupBetButtonWithEnabled:NO
                            labelHidden:YES
                             labelTitle:@""
                            buttonTitle:@"爆炸了"
                            buttonColor:kMainBetGaryColor
                            buttonInset:NO];
    }    
}


#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainSubBackgroundColor;
        _bgView.layer.cornerRadius = ScaleW(5);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (RG_Mine_RGoldItemView *)firstItem {
    if (!_firstItem) {
        _firstItem = [[RG_Mine_RGoldItemView alloc]init];
    }
    return _firstItem;
}
- (RG_Mine_RGoldItemView *)secondItem {
    if (!_secondItem) {
        _secondItem = [[RG_Mine_RGoldItemView alloc]init];
    }
    return _secondItem;
}
- (RG_Mine_RGoldItemView *)thirdItem {
    if (!_thirdItem) {
        _thirdItem = [[RG_Mine_RGoldItemView alloc]init];
    }
    return _thirdItem;
}
- (RG_Mine_RGoldItemView *)fourthItem {
    if (!_fourthItem) {
        _fourthItem = [[RG_Mine_RGoldItemView alloc]init];
    }
    return _fourthItem;
}

- (RG_Mine_RGoldItemView *)fifthItem {
    if (!_fifthItem) {
        _fifthItem = [[RG_Mine_RGoldItemView alloc]init];
        _fifthItem.rightLineView.hidden = YES;
    }
    return _fifthItem;
}
- (UIView *)dashedView {
    if (!_dashedView) {
        _dashedView = [[UIView alloc]init];
        _dashedView.backgroundColor = kLineColor;
    }
    return _dashedView;
}
- (UIButton *)pickMeButton {
    if (!_pickMeButton) {
        _pickMeButton = [[UIButton alloc]init];
        [_pickMeButton setBackgroundImage:[UIImage imageNamed:@"mine_pickme"] forState:UIControlStateNormal];
        [_pickMeButton addTarget:self action:@selector(pickMeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pickMeButton;
}
- (WJBezierCurveView *)curveView {
    if (!_curveView) {
        _curveView = [[WJBezierCurveView alloc]initWithFrame:CGRectMake(0, ScaleH(80), ScreenWidth-ScaleW(20), ScaleH(180))];
    }
    return _curveView;
}

- (UIButton *)betButton {
    if (!_betButton) {
        _betButton = [[UIButton alloc]init];
        [_betButton setBackgroundColor:kMainTitleColor];
        [_betButton setTitle:Localized(@"投注", nil) forState:UIControlStateNormal];
//        [_betButton setTitle:@"逃跑" forState:UIControlStateSelected];
        [_betButton setTitleColor:kMainTextColor forState:UIControlStateNormal];
        _betButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(18)];
        _betButton.layer.cornerRadius = ScaleW(5);
        _betButton.layer.masksToBounds = YES;
        [_betButton addTarget:self action:@selector(betButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _betButton;
}
- (RG_Mine_BetSettingView *)betSettingView {
    if (!_betSettingView) {
        _betSettingView = [[RG_Mine_BetSettingView alloc]init];
    }
    return _betSettingView;
}

- (UILabel *)escapeLabel {
    if (!_escapeLabel) {
        _escapeLabel = [[UILabel alloc]init];
        _escapeLabel.textColor = kMainGaryWhiteColor;
        _escapeLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _escapeLabel.hidden = YES;
    }
    return _escapeLabel;
}
#pragma mark -- Setter Method


@end
