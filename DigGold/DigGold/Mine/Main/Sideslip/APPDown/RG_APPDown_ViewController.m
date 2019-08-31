//
//  RG_APPDown_ViewController.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_APPDown_ViewController.h"

@interface RG_APPDown_ViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *contengView;

@property (nonatomic,strong) UIImageView *topImg;

@property (nonatomic,strong) UILabel * qjLabel;

@property (nonatomic,strong) UILabel * qjDetailLabel;

@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) UIButton * iphoneBtn;

@property (nonatomic,strong) UIButton * androidBtn;

@property (nonatomic,strong) UIImageView *codeImg;

@end

@implementation RG_APPDown_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"APP下载", nil);
    
    [self scrollView];
    
    [self contengView];
    
    [self topImg];

    [self qjLabel];

    [self qjDetailLabel];

    [self titleLabel];

    [self iphoneBtn];

    [self androidBtn];

    [self codeImg];
    
//    self.codeImg.image = [UIImage imageNamed:@"qj_downqc"];
    
    [self fetchCommonData];

    
    self.codeImg.image = [WLTools creatQRCodeWithStr:AppDownUrl withImageSize:150.0];
}

- (void)fetchCommonData {
    NSDictionary *params = @{};
//    WS(weakSelf);
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Common_data_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            [[SSKJ_User_Tool sharedUserTool]saveCommonDataWithDic:(NSDictionary *)netWorkModel.data];
            
//            NSString *appdown = F(@"%@%@", ProductBaseURL,netWorkModel.data[@"app_down_url"]?:@"") ;
//            [weakSelf.codeImg sd_setImageWithURL:[NSURL URLWithString:appdown?:@""]];
            
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
    }];
}


- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc]init];
        
        _scrollView.backgroundColor = kMainBackgroundColor;
        
        [self.view addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.top.equalTo(self.view);
            
        }];
    }
    return _scrollView;
}

- (UIView *)contengView
{
    if (_contengView == nil) {
        
        _contengView = [[UIView alloc]init];
        
        [self.scrollView addSubview:_contengView];
        
        [_contengView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.bottom.equalTo(self.scrollView);
            
            make.width.mas_equalTo(ScreenWidth);
        }];


    }
    return _contengView;
}

- (UIImageView *)topImg
{
    if (_topImg == nil)
    {
        UIImage *image = [UIImage imageNamed:@"mine_appdown2"];

        _topImg = [[UIImageView alloc]init];

        _topImg.image = image;

        [self.contengView addSubview:_topImg];

        [_topImg mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.qjDetailLabel.mas_bottom).offset(45);
            
            make.centerX.equalTo(self.contengView);

            make.width.mas_equalTo(ScaleW(274));

            make.height.mas_equalTo(ScaleH(203));

        }];
    }
    return _topImg;
}

- (UILabel *)qjLabel
{
    if (_qjLabel == nil)
    {
        _qjLabel = [WLTools allocLabel:@"BSG" font:WLFontBoldSize(24) textColor:UIColorFromRGB(0xDEE0FB) frame:CGRectZero textAlignment:NSTextAlignmentCenter];
        _qjLabel.font = [UIFont boldSystemFontOfSize:ScaleFont(24)];

        _qjLabel.adjustsFontSizeToFitWidth = YES;

        [self.contengView addSubview:_qjLabel];

        [_qjLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.contengView.mas_top).offset(73);

            make.left.equalTo(@(0));

            make.width.equalTo(@(ScreenWidth));

            make.height.equalTo(@25);
        }];
    }
    return _qjLabel;
}

- (UILabel *)qjDetailLabel
{
    if (_qjDetailLabel == nil)
    {
        _qjDetailLabel = [WLTools allocLabel:@"让竞猜带来乐趣" font:systemFont(15) textColor:UIColorFromRGB(0xDEE0FB) frame:CGRectZero textAlignment:NSTextAlignmentCenter];

        _qjDetailLabel.adjustsFontSizeToFitWidth = YES;

        [self.contengView addSubview:_qjDetailLabel];

        [_qjDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.qjLabel.mas_bottom).offset(10);

            make.left.equalTo(@(0));

            make.width.equalTo(@(ScreenWidth));

            make.height.equalTo(@20);
        }];
    }
    return _qjDetailLabel;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [WLTools allocLabel:@"算法公开、开奖可公正、返奖率高达99%" font:[UIFont systemFontOfSize:15] textColor:UIColorFromRGB(0xe4e5ff) frame:CGRectZero textAlignment:NSTextAlignmentCenter];

        _titleLabel.adjustsFontSizeToFitWidth = YES;

        [self.contengView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.topImg.mas_bottom).offset(38);

            make.left.equalTo(@(0));

            make.width.equalTo(@(ScreenWidth));

            make.height.equalTo(@20);
        }];
    }
    return _titleLabel;
}

- (UIButton *)iphoneBtn
{
    if (_iphoneBtn == nil)
    {
        UIImage *image = [UIImage imageNamed:@"mine_ios"];

        _iphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_iphoneBtn setBackgroundImage:[UIImage imageNamed:@"mine_ios"] forState:UIControlStateNormal];

        _iphoneBtn.tag = 100;

        [_iphoneBtn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.contengView addSubview:_iphoneBtn];

        [_iphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.titleLabel.mas_bottom).offset(40);

            make.right.equalTo(self.view.mas_centerX).offset(-10);

            make.width.equalTo(@(image.size.width));

            make.height.equalTo(@(image.size.height));

        }];
    }
    return _iphoneBtn;
}

- (UIButton *)androidBtn
{
    if (_androidBtn == nil)
    {
        UIImage *image = [UIImage imageNamed:@"mine_android"];

        _androidBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_androidBtn setBackgroundImage:[UIImage imageNamed:@"mine_android"] forState:UIControlStateNormal];

        _androidBtn.tag = 101;

        [_androidBtn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.contengView addSubview:_androidBtn];

        [_androidBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.titleLabel.mas_bottom).offset(40);

            make.left.equalTo(self.view.mas_centerX).offset(10);

            make.width.equalTo(self.iphoneBtn.mas_width);

            make.height.equalTo(@(image.size.height));
        }];
    }
    return _androidBtn;
}

 - (UIImageView *)codeImg
{
    if (_codeImg == nil)
    {
        _codeImg = [[UIImageView alloc]init];

        _codeImg.image = [UIImage imageNamed:@""];

        _codeImg.backgroundColor = kMainSubBackgroundColor;

        [self.contengView addSubview:_codeImg];

        [_codeImg mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.iphoneBtn.mas_bottom).offset(30);

            make.centerX.equalTo(self.view.mas_centerX);

            make.width.equalTo(@(150));
            
            make.height.equalTo(@(150));
            
            make.bottom.equalTo(self.contengView.mas_bottom).offset(-50);

        }];
    }
    return  _codeImg;
}

- (void)typeAction:(UIButton *)sender
{
    if (sender.tag == 100)
    {
        if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:AppDownUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppDownUrl]];
        }else{
            [RCHUDPop popupTipText:@"无效链接" toView:self.view];
        }
        NSLog(@"苹果");
    }
    else
    {
        if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:AppDownUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppDownUrl]];
        }else{
            [RCHUDPop popupTipText:@"无效链接" toView:self.view];
        }
        NSLog(@"安卓");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
