//
//  DG_AlertUpdateView.m
//  DigGold
//
//  Created by James on 2019/1/24.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "DG_AlertUpdateView.h"

@interface DG_AlertUpdateView()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) DG_AlertUpdateStyle style;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *findLabel;
@property (nonatomic, strong) UILabel *versionLabel;


@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *updateButton;

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *bottomMiddleView;
@property (nonatomic, copy) void (^clickBlock)(void);

@end

@implementation DG_AlertUpdateView

- (instancetype)initWithStyle:(DG_AlertUpdateStyle)style title:(NSString *)title version:(NSString *)version content:(NSString *)content clickBlock:(void (^)(void))clickBlock
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.style = style;
        self.clickBlock = clickBlock;
        [self addSubview:self.shadowView];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.topImageView];
        [self.topImageView addSubview:self.findLabel];
        [self.topImageView addSubview:self.versionLabel];
        [self.bgView addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentView];
        [self.contentView addSubview:self.contentLabel];
        [self.bgView addSubview:self.bottomView];
        [self.bottomView addSubview:self.cancelButton];
        [self.bottomView addSubview:self.updateButton];
        [self.bottomView addSubview:self.bottomLineView];
        [self.bottomView addSubview:self.bottomMiddleView];
        
        self.versionLabel.text = F(@"V%@", version?:@"");
        self.contentLabel.text = content?:@"";
//        self.findLabel.text = title?:@"";
        self.findLabel.text = @"发现新版本";
        [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:ScaleW(5)];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(ScaleW(282));
        make.height.mas_equalTo(ScaleH(315));
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.height.mas_equalTo(ScaleH(130));
    }];
    [self.findLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImageView).offset(ScaleW(25));
        make.top.equalTo(self.topImageView).offset(ScaleH(30));
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImageView).offset(ScaleW(25));
        make.top.equalTo(self.findLabel.mas_bottom).offset(ScaleH(10));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.topImageView.mas_bottom);
        make.height.mas_equalTo(ScaleH(115));
        
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScaleW(282));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(ScaleW(29));
        make.right.equalTo(self.contentView).offset(-ScaleW(29));
        make.bottom.equalTo(self.contentView);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];
    if (self.style == DG_AlertUpdateStyle_Force) {
        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView);
            make.right.equalTo(self.bottomView);
            make.bottom.equalTo(self.bottomView);
            make.height.mas_equalTo(ScaleH(45));
        }];
    }else{
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView);
            make.width.mas_equalTo(ScaleW(282/2));
            make.bottom.equalTo(self.bottomView);
            make.height.mas_equalTo(ScaleH(45));
        }];
        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelButton.mas_right);
            make.width.mas_equalTo(ScaleW(282/2));
            make.bottom.equalTo(self.bottomView);
            make.height.mas_equalTo(ScaleH(45));
        }];
        [self.bottomMiddleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomView);
            make.top.equalTo(self.updateButton);
            make.height.mas_equalTo(ScaleH(45));
            make.width.mas_equalTo(1);
        }];
    }
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateButton);
        make.left.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView);
        make.height.mas_equalTo(1);
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method
- (void)showAlertUpdateView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

}

- (void)dismissAlertUpdateView {
    [self removeFromSuperview];
}

- (void)cancelButtonClick {
    [self dismissAlertUpdateView];
}

- (void)updateButtonClick {
    self.clickBlock();
    [self dismissAlertUpdateView];
}
#pragma mark -- Getter Method
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = ScaleW(5);
        _bgView.layer.masksToBounds = YES;

    }
    return _bgView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:self.bounds];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.4;
    }
    return _shadowView;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = [UIImage imageNamed:@"mine_updateVersion"];
    }
    return _topImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = UIColorFromRGB(0x101F32);
        _contentLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UILabel *)findLabel {
    if (!_findLabel) {
        _findLabel = [[UILabel alloc]init];
        _findLabel.textColor = [UIColor whiteColor];
        _findLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(19)];
        _findLabel.text = @"发现新版本";
    }
    return _findLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.textColor = [UIColor whiteColor];
        _versionLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(14)];
    }
    return _versionLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:@"残忍拒绝" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0x969696) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [[UIButton alloc]init];
        [_updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
        [_updateButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        _updateButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(16)];
        _updateButton.backgroundColor = [UIColor whiteColor];
        [_updateButton addTarget:self action:@selector(updateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    }
    return _bottomLineView;
}

- (UIView *)bottomMiddleView {
    if (!_bottomMiddleView) {
        _bottomMiddleView = [[UIView alloc]init];
        _bottomMiddleView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    }
    return _bottomMiddleView;
}
#pragma mark -- Setter Method

@end
