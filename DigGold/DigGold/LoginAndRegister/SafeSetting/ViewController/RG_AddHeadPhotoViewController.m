//
//  RG_AddHeadPhotoViewController.m
//  DigGold
//
//  Created by James on 2018/12/28.
//  Copyright © 2018年 MingShao. All rights reserved.
//

#import "RG_AddHeadPhotoViewController.h"
#import "FRCameraViewController.h"
@interface RG_AddHeadPhotoViewController ()<CameraAchieveToImageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *addHeaderPhotoButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSString *uploadImageUrl;
@end

@implementation RG_AddHeadPhotoViewController

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
    self.title = @"";
    self.view.backgroundColor = kMainBackgroundColor;
    
    [self setupUI];
    [self setupMasnory];
    [self mvvmBinding];
}

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.addHeaderPhotoButton];
    [self.contentView addSubview:self.saveButton];
}

- (void)setupMasnory {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.addHeaderPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(ScaleH(50));
        make.width.height.mas_equalTo(ScaleW(150));
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ScaleW(14));
        make.right.equalTo(self.contentView).offset(-ScaleW(14));
        make.top.equalTo(self.addHeaderPhotoButton.mas_bottom).offset(ScaleH(65));
        make.height.mas_equalTo(ScaleW(45));
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method
- (void)saveButtonClick {
    [self saveImageWithUrlString:self.uploadImageUrl];
}
- (void)addHeaderPhotoButtonClick {
    [self alertController];
}

- (void)upLoadImgImage:(UIImage *)image {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    [[WLHttpManager shareManager]upLoadImageByUrl:Port_CommonFileUpImg_URL ImageName:@"headimg" Params:@{} Image:image CallBack:^(id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue]== 200) {
            weakSelf.uploadImageUrl = @"";
            NSString *urlS = netWorkModel.data;
            weakSelf.uploadImageUrl = urlS?:@"";
            [RCHUDPop dismissHUDToView:nil];
        }else{
            [RCHUDPop dismissHUDToView:nil];
        }
    } Failure:^(NSError *error) {
        [RCHUDPop dismissHUDToView:nil];
    }];
}

- (void)saveImageWithUrlString:(NSString *)urlString {
    WS(weakSelf);
    [RCHUDPop popupMessage:@"" toView:nil];
    NSDictionary *params = @{@"upic":urlString?:@""};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Save_Upic_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 200) {
            [RCHUDPop popupTipText:@"头像上传成功" toView:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateHeaderSuccessNotifition object:@{@"url":F(@"%@%@", ProductBaseServer,weakSelf.uploadImageUrl?:@"")}];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
    }];
}

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
    [self.addHeaderPhotoButton setImage:image forState:UIControlStateNormal];
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


#pragma mark -- UITableViewDelegate

#pragma mark -- Getter Method
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
- (UIButton *)addHeaderPhotoButton {
    if (!_addHeaderPhotoButton) {
        _addHeaderPhotoButton = [[UIButton alloc]init];
        [_addHeaderPhotoButton setImage:[UIImage imageNamed:@"addHeaderp_image"] forState:UIControlStateNormal];
        
        [_addHeaderPhotoButton addTarget:self action:@selector(addHeaderPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addHeaderPhotoButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc]init];
        [_saveButton setTitle:Localized(@"保存", nil) forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setCornerRadius:ScaleW(45/2.0)];
        _saveButton.backgroundColor = kMainTitleColor;
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFont(15)];
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
#pragma mark -- Setter Method
@end
