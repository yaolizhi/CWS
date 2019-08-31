//
//  RG_AgencyApplyViewController.m
//  DigGold
//
//  Created by James on 2019/1/21.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_AgencyApplyViewController.h"
#import "FRCameraViewController.h"
@interface RG_AgencyApplyViewController ()<CameraAchieveToImageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UILabel *frontLabel;
@property (nonatomic, strong) UIButton *frontButton;
@property (nonatomic, strong) UILabel *forntSubLabel;

@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *backSubLabel;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, assign) BOOL selectedFront;
@property (nonatomic, copy) NSString *frontUrl;
@property (nonatomic, copy) NSString *backUrl;
@end

@implementation RG_AgencyApplyViewController

#pragma mark -- LifeCycle

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedFront = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全民代理申请";
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupUI];
    [self setupMasnory];
}

- (void)sureButtonClick {
    if (self.nameTF.text.length == 0) {
        [RCHUDPop popupTipText:@"请输入您的真实姓名" toView:nil];
        return;
    }
    if (self.phoneTF.text.length == 0 ||
        ![RegularExpression validateMobile:self.phoneTF.text]) {
        [RCHUDPop popupTipText:@"请输入正确的手机号" toView:nil];
        return;
    }
    if (self.frontUrl.length == 0) {
        [RCHUDPop popupTipText:@"请上传身份证正面照" toView:nil];
        return;
    }
    if (self.backUrl.length == 0) {
        [RCHUDPop popupTipText:@"请上传身份证背面照" toView:nil];
        return;
    }
    [self saveImageWith];
}

- (void)frontButtonClick {
    self.selectedFront = YES;
    [self alertController];
}

- (void)backButtonClick {
    self.selectedFront = NO;
    [self alertController];
}

- (void)saveImageWith {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"name":self.nameTF.text?:@"",
                             @"mobile":self.phoneTF.text?:@"",
                             @"card1":self.frontUrl?:@"",
                             @"card2":self.backUrl?:@""};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Deiliapply_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:kApplyDLSSuccessNotifition object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}


- (void)upLoadImgImage:(UIImage *)image {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    [[WLHttpManager shareManager]upLoadImageByUrl:Port_CommonFileUpImg_URL ImageName:@"headimg" Params:@{} Image:image CallBack:^(id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue]== 200) {
            if (weakSelf.selectedFront) {
                weakSelf.frontUrl = netWorkModel.data;
            }else{
                weakSelf.backUrl = netWorkModel.data;
            }
            [RCHUDPop dismissHUDToView:nil];
        }else{
            [RCHUDPop dismissHUDToView:nil];
        }
    } Failure:^(NSError *error) {
        [RCHUDPop dismissHUDToView:nil];
    }];
}

#pragma mark -- Public Method

- (void)alertController {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.view.backgroundColor = kMainBackgroundColor;
    if ([imagePickerController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [imagePickerController.navigationBar setBarTintColor:kMainBackgroundColor];
        [imagePickerController.navigationBar setTranslucent:NO];
        [imagePickerController.navigationBar setTintColor:[UIColor whiteColor]];
    }else{
        [imagePickerController.navigationBar setBackgroundColor:kMainBackgroundColor];
    }
    //    更改titieview的字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [imagePickerController.navigationBar setTitleTextAttributes:attrs];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self presentPickerConroller:imagePickerController sourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPickerConroller:imagePickerController sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [alertVc addAction:photo];
    [self presentViewController:alertVc animated:YES completion:nil];
}
- (void)presentPickerConroller:(UIImagePickerController *)imagePickerController sourceType:(UIImagePickerControllerSourceType)sourceType {
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}
#pragma mark -- OtherDelegate
#pragma mark - Camera Delegate

- (void)CameraAchieveToImageDelegate:(FRCameraViewController *)ViewController Withimage:(UIImage *)image {
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
}

- (void)saveImage:(UIImage *)image {
    [self upLoadImgImage:image];
    if (self.selectedFront) {
        [self.frontButton setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        [self.backButton setBackgroundImage:image forState:UIControlStateNormal];
    }
}

#pragma mark - photo delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.nameTF];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.phoneTF];
    
    [self.contentView addSubview:self.frontLabel];
    [self.contentView addSubview:self.frontButton];
    [self.contentView addSubview:self.forntSubLabel];
    
    [self.contentView addSubview:self.backLabel];
    [self.contentView addSubview:self.backButton];
    [self.contentView addSubview:self.backSubLabel];
    [self.contentView addSubview:self.sureButton];
}





- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.contentView).offset(ScaleH(32));
    }];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.nameTF.mas_bottom).offset(ScaleH(17));
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(41));
    }];
    
    [self.frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.phoneTF.mas_bottom).offset(ScaleH(17));
    }];
    
    [self.frontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.frontLabel.mas_bottom).offset(ScaleH(20));
        make.height.mas_equalTo(ScaleH(163));
    }];
    [self.forntSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.frontButton.mas_bottom).offset(ScaleH(12));
        make.right.equalTo(self.contentView).offset(-ScaleH(14));
    }];
    
    [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.forntSubLabel.mas_bottom).offset(ScaleH(25));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.backLabel.mas_bottom).offset(ScaleH(20));
        make.height.mas_equalTo(ScaleH(163));
    }];
    [self.backSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.top.equalTo(self.backButton.mas_bottom).offset(ScaleH(12));
        make.right.equalTo(self.contentView).offset(-ScaleH(14));
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.backSubLabel.mas_bottom).offset(ScaleH(26));
        make.height.mas_equalTo(ScaleH(45));
        make.bottom.equalTo(self.contentView).offset(-ScaleH(40));
    }];
}













#pragma mark -- OtherDelegate

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = kMainBackgroundColor;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = kMainBackgroundColor;
    }
    return _contentView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = Localized(@"姓名", nil);
        _nameLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _nameLabel.textColor = kMainGaryWhiteColor;
    }
    return _nameLabel;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc]init];
        _nameTF.backgroundColor = kMainSubBackgroundColor;
        _nameTF.layer.cornerRadius = ScaleW(5);
        _nameTF.layer.masksToBounds = YES;
        _nameTF.layer.borderWidth = 1;
        _nameTF.layer.borderColor = kLightLineColor.CGColor;
        _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTF.placeholder = Localized(@"请输入您的真实姓名", nil);
        _nameTF.textColor = kMainGaryWhiteColor;
        _nameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
        _nameTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_nameTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _nameTF;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = Localized(@"手机号", nil);
        _phoneLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _phoneLabel.textColor = kMainGaryWhiteColor;
    }
    return _phoneLabel;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc]init];
        _phoneTF.backgroundColor = kMainSubBackgroundColor;
        _phoneTF.layer.cornerRadius = ScaleW(5);
        _phoneTF.layer.masksToBounds = YES;
        _phoneTF.layer.borderWidth = 1;
        _phoneTF.layer.borderColor = kLightLineColor.CGColor;
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTF.placeholder = Localized(@"请输入您的手机号", nil);
        _phoneTF.textColor = kMainGaryWhiteColor;
        _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(10), 0)];
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneTF.font = [UIFont systemFontOfSize:ScaleFont(14)];
        [_phoneTF setValue:kMainGaryWhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _phoneTF;
}

- (UILabel *)frontLabel {
    if (!_frontLabel) {
        _frontLabel = [[UILabel alloc]init];
        _frontLabel.text = Localized(@"身份证正面", nil);
        _frontLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _frontLabel.textColor = kMainGaryWhiteColor;
    }
    return _frontLabel;
}

- (UIButton *)frontButton {
    if (!_frontButton) {
        _frontButton = [[UIButton alloc]init];
        [_frontButton setBackgroundImage:[UIImage imageNamed:@"icon_idcard"] forState:UIControlStateNormal];
        _frontButton.backgroundColor = kMainBackgroundColor;
        [_frontButton addTarget:self action:@selector(frontButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _frontButton;
}

- (UILabel *)forntSubLabel {
    if (!_forntSubLabel) {
        _forntSubLabel = [[UILabel alloc]init];
        _forntSubLabel.text = Localized(@"必须能看清证件号和姓名，支持jpg/png/jpeg 大小不要超过2M", nil);
        _forntSubLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _forntSubLabel.textColor = kMainGaryWhiteColor;
        _forntSubLabel.numberOfLines = 0;
    }
    return _forntSubLabel;
}

- (UILabel *)backLabel {
    if (!_backLabel) {
        _backLabel = [[UILabel alloc]init];
        _backLabel.text = Localized(@"身份证反面", nil);
        _backLabel.font = [UIFont systemFontOfSize:ScaleFont(14)];
        _backLabel.textColor = kMainGaryWhiteColor;
    }
    return _backLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc]init];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"icon_idcard"] forState:UIControlStateNormal];
        _backButton.backgroundColor = kMainBackgroundColor;
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)backSubLabel {
    if (!_backSubLabel) {
        _backSubLabel = [[UILabel alloc]init];
        _backSubLabel.text = Localized(@"必须能看清发证机关和有效日期，支持jpg/png/jpeg 大小不要超过2M", nil);
        _backSubLabel.font = [UIFont systemFontOfSize:ScaleFont(10)];
        _backSubLabel.textColor = kMainGaryWhiteColor;
        _backSubLabel.numberOfLines = 0;
    }
    return _backSubLabel;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        [_sureButton setTitle:Localized(@"提交申请", nil) forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = ScaleW(5);
        _sureButton.layer.masksToBounds = YES;
        _sureButton.backgroundColor = kMainTitleColor;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
#pragma mark -- Setter Method
@end
