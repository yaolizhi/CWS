//
//  Mine_AM_RCViewController.m
//  SSKJ
//
//  Created by James on 2018/12/19.
//  Copyright © 2018年 刘小雨. All rights reserved.
//

#import "RG_AM_RCViewController.h"
#import "UILabel+WJFUN.h"
#import <Photos/Photos.h>
#import "RG_AM_RCModel.h"
@interface RG_AM_RCViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *QRImageView;
@property (nonatomic, strong) UIButton *subTitleButton;
@property (nonatomic, strong) UIView *ccopyView;
@property (nonatomic, strong) UILabel *ccopyLabel;
@property (nonatomic, strong) UIButton *ccopyButton;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation RG_AM_RCViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"充值", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}

#pragma mark -- Private Method
- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.QRImageView];
    [self.contentView addSubview:self.subTitleButton];
    [self.contentView addSubview:self.ccopyView];
    [self.ccopyView addSubview:self.ccopyLabel];
    [self.ccopyView addSubview:self.ccopyButton];
    [self.contentView addSubview:self.bottomLabel];
}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.QRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(ScaleH(49));
        make.width.height.mas_equalTo(ScaleH(105));
    }];
    [self.subTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.QRImageView.mas_bottom).offset(ScaleH(20));
    }];
    [self.ccopyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleButton.mas_bottom).offset(ScaleH(41));
        make.left.equalTo(self.contentView).offset(ScaleW(15));
        make.right.equalTo(self.contentView.mas_right).offset(-ScaleW(15));
        make.height.mas_equalTo(ScaleH(75));
    }];
    [self.ccopyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ccopyView).offset(ScaleH(17));
        make.centerX.equalTo(self.ccopyView);
        
    }];
    [self.ccopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ccopyLabel).offset(ScaleH(20));
        make.centerX.equalTo(self.ccopyView);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ccopyView.mas_bottom).offset(ScaleH(21));
        make.left.equalTo(self.ccopyView).offset(ScaleW(0));
        make.right.equalTo(self.ccopyView.mas_right).offset(-ScaleW(1));
        make.bottom.equalTo(self.contentView);
    }];
    
}

- (void)mvvmBinding {
    [self FetchData];
}

- (void)FetchData {
    WS(weakSelf);
    NSDictionary *params = @{};
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Bpay_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            RG_AM_RCModel *model = [RG_AM_RCModel mj_objectWithKeyValues:netWorkModel.data];
            weakSelf.ccopyLabel.text = model.url?:@"";
            
            [weakSelf.QRImageView sd_setImageWithURL:[NSURL URLWithString:model.qrc?:@""]];
            
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}




#pragma mark -- Public Method

- (void)longPress {
    [self saveImage];
    
}

- (void)subTitleButtonClick {
    //保存到相册
    [self saveImage];
}
- (void)ccopyButtonClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.ccopyLabel.text?:@"";
    [RCHUDPop popupTipText:@"复制成功" toView:nil];
}


// 需要实现下面的方法,或者传入三个参数即可
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [RCHUDPop popupTipText:@"保存失败" toView:nil];
    } else {
        [RCHUDPop popupTipText:@"保存成功" toView:nil];
    }
}

- (void)saveImage {
    
    UIImage *img = self.QRImageView.image;
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = kMainBackgroundColor;
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}
- (UIImageView *)QRImageView {
    if (!_QRImageView) {
        _QRImageView = [[UIImageView alloc]init];
        _QRImageView.backgroundColor = kMainBackgroundColor;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
        longPress.minimumPressDuration = 2;
        [_QRImageView addGestureRecognizer:longPress];
    }
    return _QRImageView;
}
- (UIButton *)subTitleButton {
    if (!_subTitleButton) {
        _subTitleButton = [[UIButton alloc]init];
        [_subTitleButton setTitle:Localized(@"保存二维码至相册", nil) forState:UIControlStateNormal];
        [_subTitleButton setTitle:Localized(@"保存二维码至相册", nil) forState:UIControlStateHighlighted];
        [_subTitleButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        [_subTitleButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateHighlighted];
        _subTitleButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        [_subTitleButton addTarget:self action:@selector(subTitleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subTitleButton;
}
- (UIView *)ccopyView {
    if (!_ccopyView) {
        _ccopyView = [[UIView alloc]init];
        _ccopyView.backgroundColor = kMainSubBackgroundColor;
    }
    return _ccopyView;
}

- (UILabel *)ccopyLabel {
    if (!_ccopyLabel) {
        _ccopyLabel = [[UILabel alloc]init];
        _ccopyLabel.text = @"";
        _ccopyLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _ccopyLabel.textColor = kMainTitleColor;
    }
    return _ccopyLabel;
}
- (UIButton *)ccopyButton {
    if (!_ccopyButton) {
        _ccopyButton = [[UIButton alloc]init];
        [_ccopyButton setTitle:Localized(@"复制地址", nil) forState:UIControlStateNormal];
        [_ccopyButton setTitle:Localized(@"复制地址", nil) forState:UIControlStateHighlighted];
        [_ccopyButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateNormal];
        [_ccopyButton setTitleColor:kMainGaryWhiteColor forState:UIControlStateHighlighted];
        _ccopyButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_ccopyButton addTarget:self action:@selector(ccopyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _ccopyButton;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.text = Localized(@"请勿向上述地址充值任何非USDT资产，否则资产将不可找回。您充值至上述地址后，需要整个网络节点的确认，6次网络确认后到账。\n您可以在充值记录里查看充值状态！", nil);
        _bottomLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
        _bottomLabel.textColor = kMainGaryWhiteColor;
        _bottomLabel.numberOfLines = 0;
        [UILabel changeLineSpaceForLabel:_bottomLabel WithSpace:6];
    }
    return _bottomLabel;
}
#pragma mark -- Setter Method
@end

