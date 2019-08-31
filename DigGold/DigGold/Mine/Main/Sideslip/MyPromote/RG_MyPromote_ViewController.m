//
//  RG_MyPromote_ViewController.m
//  DigGold
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_MyPromote_ViewController.h"
#import <Photos/Photos.h>
#import "RG_MyPromoteModel.h"
@interface RG_MyPromote_ViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UILabel *qrLabel;
@property (nonatomic, strong) UILabel *promoteLabel;
@property (nonatomic, strong) UIButton *ccopyButton;
@property (nonatomic, strong) RG_MyPromoteModel *model;
@end

@implementation RG_MyPromote_ViewController

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
    self.title = Localized(@"我的推广", nil);
    self.view.backgroundColor = kMainBackgroundColor;
    
    
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.titleImageView];
    [self.bgImageView addSubview:self.qrImageView];
    [self.bgImageView addSubview:self.qrLabel];
    [self.bgImageView addSubview:self.promoteLabel];
    [self.bgImageView addSubview:self.ccopyButton];
    [self setupMasnory];
    [self mvvmBinding];
}

- (void)mvvmBinding {
    [self fetchInfoData];
}

- (void)fetchInfoData {
    WS(weakSelf);
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Link_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            weakSelf.model = [RG_MyPromoteModel mj_objectWithKeyValues:netWorkModel.data];
            weakSelf.promoteLabel.text = F(@"邀请码：%@", weakSelf.model.account?:@"");
            [[SDImageCache sharedImageCache]removeImageForKey:weakSelf.model.qrc?:@"" withCompletion:^{
                [weakSelf.qrImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.qrc?:@""]];
            }];
            
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.top.equalTo(self.bgImageView).offset(ScaleH(58));
        make.width.mas_equalTo(ScaleW(240));
        make.height.mas_equalTo(ScaleH(122));
    }];
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.top.equalTo(self.titleImageView.mas_bottom).offset(ScaleH(40+50));
        make.width.height.mas_equalTo(ScaleW(97));
    }];
    [self.qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.top.equalTo(self.qrImageView.mas_bottom).offset(ScaleH(15));
    }];
    [self.promoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView).offset(-20);
        make.top.equalTo(self.qrLabel.mas_bottom).offset(ScaleH(20));
        
    }];
    [self.ccopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promoteLabel.mas_right).offset(ScaleW(10));
        make.centerY.equalTo(self.promoteLabel);
    }];
//    [self.warmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.bgImageView);
//        make.top.equalTo(self.ccopyButton.mas_bottom).offset(ScaleH(46));
//    }];
}



#pragma mark -- Public Method
- (void)ccopyButtonClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.account?:@"";
    [RCHUDPop popupTipText:@"复制成功" toView:nil];
}
- (void)longPress {
    [self saveImage];
//        [self loadImageFinished:self.qrImageView.image];
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
    UIImage *img = self.qrImageView.image;
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}
//- (void)loadImageFinished:(UIImage *)image
//{
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//
//        NSLog(@"success = %d, error = %@", success, error);
//
//    }];
//}
#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"mine_promote2"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
- (UIImageView *)qrImageView {
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc]init];
        _qrImageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
        longPress.minimumPressDuration = 0.5;
        [_qrImageView addGestureRecognizer:longPress];
    }
    return _qrImageView;
}
- (UILabel *)qrLabel {
    if (!_qrLabel) {
        _qrLabel = [[UILabel alloc]init];
        _qrLabel.textColor = kMainGaryWhiteColor;
        _qrLabel.text = Localized(@"长按保存二维码", nil);
        _qrLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
    }
    return _qrLabel;
}
- (UILabel *)promoteLabel {
    if (!_promoteLabel) {
        _promoteLabel = [[UILabel alloc]init];
        _promoteLabel.textColor = kMainGaryWhiteColor;
        _promoteLabel.text = @"邀请码：";
        _promoteLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
    }
    return _promoteLabel;
}
- (UIButton *)ccopyButton {
    if (!_ccopyButton) {
        _ccopyButton = [[UIButton alloc]init];
        _ccopyButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(13)];
        [_ccopyButton setTitle:Localized(@"复制", nil) forState:UIControlStateNormal];
        [_ccopyButton setTitle:Localized(@"复制", nil) forState:UIControlStateHighlighted];
        [_ccopyButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
        [_ccopyButton setTitleColor:kMainTitleColor forState:UIControlStateHighlighted];
        [_ccopyButton addTarget:self action:@selector(ccopyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ccopyButton;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc]init];
        _titleImageView.image = [UIImage imageNamed:@"mine_yqhy"];
        _titleImageView.hidden = YES;
    }
    return _titleImageView;
}
#pragma mark -- Setter Method
@end
