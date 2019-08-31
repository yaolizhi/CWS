//
//  RG_AgencyPlanTableViewCell.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyPlanTableViewCell.h"
#import "RG_AgencyTopTitleView.h"
#import "RG_AgencyMiddleView.h"
#import "RG_AgencyBottomView.h"
@interface RG_AgencyPlanTableViewCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RG_AgencyTopTitleView *topTitleView;
@property (nonatomic, strong) UIButton *saveCardButton;
@property (nonatomic, strong) UIButton *ccopyUrlButton;
@property (nonatomic, strong) UIButton *enterAgencyButton;
@property (nonatomic, strong) UIButton *applyAgencyButton;




@property (nonatomic, strong) UIView *middleLineView;
@property (nonatomic, strong) RG_AgencyMiddleView *middleView;
@property (nonatomic, strong) UIView *middleBottomLineView;
@property (nonatomic, strong) RG_AgencyBottomView *bottomView;

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *bottomTitleLable;
@property (nonatomic, strong) UIButton *contactUsButton;
@property (nonatomic, strong) UIButton *readButton;

@property (nonatomic, strong) UILabel *waitLabel;

@property (nonatomic, strong) UIButton *resetAgencyButton;
@property (nonatomic, strong) UILabel *reasonLabel;
@end

@implementation RG_AgencyPlanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kMainBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.topTitleView];
        [self.bgView addSubview:self.saveCardButton];
        [self.bgView addSubview:self.ccopyUrlButton];
        [self.bgView addSubview:self.enterAgencyButton];
        
        [self.bgView addSubview:self.applyAgencyButton];
        
        
        [self.bgView addSubview:self.middleLineView];
        [self.bgView addSubview:self.middleView];
        [self.bgView addSubview:self.middleBottomLineView];
        [self.bgView addSubview:self.bottomView];
        
        [self.bgView addSubview:self.bottomLineView];
        [self.bgView addSubview:self.bottomTitleLable];
        [self.bgView addSubview:self.contactUsButton];
        [self.bgView addSubview:self.readButton];
        
        [self.bgView addSubview:self.waitLabel];
        [self.bgView addSubview:self.resetAgencyButton];
        [self.bgView addSubview:self.reasonLabel];
        
        
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.topTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    //申请代理商并通过
    [self.saveCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(38));
        make.top.equalTo(self.topTitleView.mas_bottom).offset(ScaleH(47));
        make.width.mas_equalTo(ScaleW(135));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.ccopyUrlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-ScaleW(38));
        make.top.equalTo(self.topTitleView.mas_bottom).offset(ScaleH(47));
        make.width.mas_equalTo(ScaleW(135));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.enterAgencyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.saveCardButton.mas_bottom).offset(ScaleH(20));
        make.width.mas_equalTo(ScaleW(135));
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    //没有申请代理商
    [self.applyAgencyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.topTitleView.mas_bottom).offset(ScaleH(47));
        make.width.mas_equalTo(ScaleW(135));
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    //审核中
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.topTitleView.mas_bottom).offset(ScaleH(40));
    }];
    
    //审核被拒
    
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.waitLabel.mas_bottom).offset(ScaleH(15));
    }];
    
    [self.resetAgencyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(ScaleH(20));
        make.width.mas_equalTo(ScaleW(135));
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    [self.middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.enterAgencyButton.mas_bottom).offset(ScaleH(40));
        make.height.mas_equalTo(1);
        
    }];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.middleLineView.mas_bottom).offset(ScaleH(40));
        
    }];
    [self.middleBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.middleView.mas_bottom).offset(ScaleH(31));
        make.height.mas_equalTo(1);
        
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.middleBottomLineView.mas_bottom).offset(ScaleH(40));
        
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.bottomView.mas_bottom).offset(ScaleH(40));
        make.height.mas_equalTo(1);
        
    }];
    [self.bottomTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(ScaleH(41));
        make.centerX.equalTo(self.bgView);
    }];
    [self.contactUsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(33));
        make.top.equalTo(self.bottomTitleLable.mas_bottom).offset(ScaleH(41));
        make.width.mas_equalTo(ScaleW(135));
        make.height.mas_equalTo(ScaleH(45));
    }];
    [self.readButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-ScaleW(33));
        make.top.equalTo(self.bottomTitleLable.mas_bottom).offset(ScaleH(41));
        make.width.mas_equalTo(ScaleW(135));
        make.height.mas_equalTo(ScaleH(45));
        make.bottom.equalTo(self.bgView).offset(-ScaleH(40));
    }];
}

- (void)configureCellWithHasApply:(BOOL)hasApply model:(RGAgencyModel *)model dicNull:(BOOL)dicNull {
    
    if (dicNull) {
        [self noApplyAgency];
    }else{
        if (hasApply) {//已经审核通过
            [self applyAgency];
        }else{
            if ([model.status isEqualToString:@"1"]) {//正在审核中
                [self applyWaitAgency];
            }else if ([model.status isEqualToString:@"3"]) {//审核被拒
                self.reasonLabel.text = F(@"失败原因：%@", model.msg?:@"");
                [self applyResetAgency];
            }
        }
    }
    [self layoutIfNeeded];
}

- (void)applyResetAgency {
    self.saveCardButton.hidden = YES;
    self.ccopyUrlButton.hidden = YES;
    self.enterAgencyButton.hidden = YES;
    self.applyAgencyButton.hidden = YES;
    self.waitLabel.hidden = NO;
    self.resetAgencyButton.hidden = NO;
    self.waitLabel.text = @"申请失败!";
    self.reasonLabel.hidden = NO;
    self.waitLabel.textColor = kMainGaryWhiteColor;
    
    [self.middleLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.resetAgencyButton.mas_bottom).offset(ScaleH(40));
        make.height.mas_equalTo(1);
    }];
}

- (void)applyWaitAgency {
    self.saveCardButton.hidden = YES;
    self.ccopyUrlButton.hidden = YES;
    self.enterAgencyButton.hidden = YES;
    self.applyAgencyButton.hidden = YES;
    self.waitLabel.hidden = NO;
    self.resetAgencyButton.hidden = YES;
    self.waitLabel.text = @"正在审核中...";
    self.reasonLabel.hidden = YES;
    self.waitLabel.textColor = kMainTitleDColor;
    
    
    [self.middleLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.waitLabel.mas_bottom).offset(ScaleH(40));
        make.height.mas_equalTo(1);
        
    }];
}

- (void)noApplyAgency {
    self.saveCardButton.hidden = YES;
    self.ccopyUrlButton.hidden = YES;
    self.enterAgencyButton.hidden = YES;
    self.applyAgencyButton.hidden = NO;
    self.waitLabel.hidden = YES;
    self.resetAgencyButton.hidden = YES;
    self.reasonLabel.hidden = YES;
    
    
    [self.middleLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.applyAgencyButton.mas_bottom).offset(ScaleH(40));
        make.height.mas_equalTo(1);
    }];
}

- (void)applyAgency {
    self.saveCardButton.hidden = NO;
    self.ccopyUrlButton.hidden = NO;
    self.enterAgencyButton.hidden = NO;
    self.applyAgencyButton.hidden = YES;
    self.waitLabel.hidden = YES;
    self.resetAgencyButton.hidden = YES;
    self.reasonLabel.hidden = YES;
    
    [self.middleLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ScaleW(15));
        make.right.equalTo(self.bgView).offset(-ScaleW(15));
        make.top.equalTo(self.enterAgencyButton.mas_bottom).offset(ScaleH(40));
        make.height.mas_equalTo(1);
        
    }];
}


#pragma mark -- Public Method
- (void)buttonClick:(UIButton *)sender {
    RG_AgencyPlanType type = RG_AgencyPlanType_Save;
    if (sender.tag == 100) {//保存代理卡
        type = RG_AgencyPlanType_Save;
    }
    if (sender.tag == 101) {//复制代理链接
        type = RG_AgencyPlanType_Copy;
    }
    if (sender.tag == 102) {//申请代理
        type = RG_AgencyPlanType_Apply;
    }
    if (sender.tag == 103) {//联系我们
        type = RG_AgencyPlanType_Contact;
    }
    if (sender.tag == 104) {//阅读代理条款
        type = RG_AgencyPlanType_Read;
    }
    if (sender.tag == 105) {//进入代理系统
        type = RG_AgencyPlanType_Enter;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAgencyPlanType:)]) {
        [self.delegate didSelectedAgencyPlanType:type];
    }
}
#pragma mark -- Getter Method

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}
- (RG_AgencyTopTitleView *)topTitleView {
    if (!_topTitleView) {
        _topTitleView = [[RG_AgencyTopTitleView alloc]init];
        _topTitleView.backgroundColor = kMainBackgroundColor;
    }
    return _topTitleView;
}

- (UIButton *)saveCardButton {
    if (!_saveCardButton) {
        _saveCardButton = [[UIButton alloc]init];
        [_saveCardButton setTitle:@"保存代理卡" forState:UIControlStateNormal];
        [_saveCardButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _saveCardButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _saveCardButton.layer.cornerRadius = ScaleW(5);
        _saveCardButton.layer.masksToBounds = YES;
        _saveCardButton.layer.borderColor = kLightLineColor.CGColor;
        _saveCardButton.layer.borderWidth = 1;
        _saveCardButton.backgroundColor = kMainSubBackgroundColor;
        [_saveCardButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _saveCardButton.tag = 100;
        _saveCardButton.hidden = YES;
    }
    return _saveCardButton;
}

- (UIButton *)ccopyUrlButton {
    if (!_ccopyUrlButton) {
        _ccopyUrlButton = [[UIButton alloc]init];
        [_ccopyUrlButton setTitle:@"复制代理链接" forState:UIControlStateNormal];
        [_ccopyUrlButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _ccopyUrlButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _ccopyUrlButton.layer.cornerRadius = ScaleW(5);
        _ccopyUrlButton.layer.masksToBounds = YES;
        _ccopyUrlButton.layer.borderColor = kLightLineColor.CGColor;
        _ccopyUrlButton.layer.borderWidth = 1;
        _ccopyUrlButton.backgroundColor = kMainSubBackgroundColor;
        [_ccopyUrlButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _ccopyUrlButton.tag = 101;
        _contactUsButton.hidden = YES;
    }
    return _ccopyUrlButton;
}

- (UIButton *)enterAgencyButton {
    if (!_enterAgencyButton) {
        _enterAgencyButton = [[UIButton alloc]init];
        [_enterAgencyButton setTitle:@"进入代理系统" forState:UIControlStateNormal];
        [_enterAgencyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _enterAgencyButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _enterAgencyButton.layer.cornerRadius = ScaleW(5);
        _enterAgencyButton.layer.masksToBounds = YES;
        _enterAgencyButton.backgroundColor = kMainTitleColor;
        [_enterAgencyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _enterAgencyButton.tag = 105;
        _enterAgencyButton.hidden = YES;
    }
    return _enterAgencyButton;
}

- (UIButton *)applyAgencyButton {
    if (!_applyAgencyButton) {
        _applyAgencyButton = [[UIButton alloc]init];
        [_applyAgencyButton setTitle:@"申请全民代理" forState:UIControlStateNormal];
        [_applyAgencyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyAgencyButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _applyAgencyButton.layer.cornerRadius = ScaleW(5);
        _applyAgencyButton.layer.masksToBounds = YES;
        _applyAgencyButton.backgroundColor = kMainTitleColor;
        [_applyAgencyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _applyAgencyButton.tag = 102;
        _applyAgencyButton.hidden = YES;
    }
    return _applyAgencyButton;
}

- (UIButton *)resetAgencyButton {
    if (!_resetAgencyButton) {
        _resetAgencyButton = [[UIButton alloc]init];
        [_resetAgencyButton setTitle:@"重新申请" forState:UIControlStateNormal];
        [_resetAgencyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _resetAgencyButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _resetAgencyButton.layer.cornerRadius = ScaleW(5);
        _resetAgencyButton.layer.masksToBounds = YES;
        _resetAgencyButton.backgroundColor = kMainTitleColor;
        [_resetAgencyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _resetAgencyButton.tag = 102;
        _resetAgencyButton.hidden = YES;
    }
    return _resetAgencyButton;
}

- (UIView *)middleLineView {
    if (!_middleLineView) {
        _middleLineView = [[UIView alloc]init];
        _middleLineView.backgroundColor = kLightLineColor;
    }
    return _middleLineView;
}

- (RG_AgencyMiddleView *)middleView {
    if (!_middleView) {
        _middleView = [[RG_AgencyMiddleView alloc]init];
    }
    return _middleView;
}

- (UIView *)middleBottomLineView {
    if (!_middleBottomLineView) {
        _middleBottomLineView = [[UIView alloc]init];
        _middleBottomLineView.backgroundColor = kLightLineColor;
    }
    return _middleBottomLineView;
}

- (RG_AgencyBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[RG_AgencyBottomView alloc]init];
    }
    return _bottomView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = kLightLineColor;
    }
    return _bottomLineView;
}

- (UILabel *)bottomTitleLable {
    if (!_bottomTitleLable) {
        _bottomTitleLable = [[UILabel alloc]init];
        _bottomTitleLable.textColor = kMainGaryWhiteColor;
        _bottomTitleLable.font = [UIFont systemFontOfSize:ScaleFont(21)];
        _bottomTitleLable.text = @"您还有其他问题吗";
        _bottomTitleLable.numberOfLines = 0;
    }
    return _bottomTitleLable;
}

- (UIButton *)contactUsButton {
    if (!_contactUsButton) {
        _contactUsButton = [[UIButton alloc]init];
        [_contactUsButton setTitle:@"联系我们" forState:UIControlStateNormal];
        [_contactUsButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        _contactUsButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _contactUsButton.layer.cornerRadius = ScaleW(5);
        _contactUsButton.layer.masksToBounds = YES;
        _contactUsButton.backgroundColor = kMainTitleColor;
        [_contactUsButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _contactUsButton.tag = 103;
    }
    return _contactUsButton;
}

- (UIButton *)readButton {
    if (!_readButton) {
        _readButton = [[UIButton alloc]init];
        [_readButton setTitle:@"阅读代理条款" forState:UIControlStateNormal];
        [_readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _readButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _readButton.layer.cornerRadius = ScaleW(5);
        _readButton.layer.masksToBounds = YES;
        _readButton.backgroundColor = kMainTitleColor;
        [_readButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _readButton.tag = 104;
        
    }
    return _readButton;
}

- (UILabel *)waitLabel {
    if (!_waitLabel) {
        _waitLabel = [[UILabel alloc]init];
        _waitLabel.textColor = kMainGaryWhiteColor;
        _waitLabel.font = [UIFont systemFontOfSize:ScaleFont(18)];
        _waitLabel.text = @"正在审核中...";
        _waitLabel.numberOfLines = 0;
        _waitLabel.hidden = YES;
    }
    return _waitLabel;
}

- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc]init];
        _reasonLabel.textColor = kMainGaryWhiteColor;
        _reasonLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _reasonLabel.numberOfLines = 0;
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
        _reasonLabel.hidden = YES;
    }
    return _reasonLabel;
}

#pragma mark -- Setter Method

@end
