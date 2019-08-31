//
//  RG_ServiceViewController.m
//  RobGold
//
//  Created by James on 2019/1/22.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_ServiceViewController.h"
#import <WebKit/WebKit.h>
//@interface RG_ServiceViewController ()<WKUIDelegate,WKNavigationDelegate,UITextFieldDelegate,UIWebViewDelegate>
@interface RG_ServiceViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *titleS;
@property (nonatomic, copy) NSString *urlS;

/*
 *1.添加UIProgressView属性
 */
//@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation RG_ServiceViewController

#pragma mark -- LifeCycle

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url
{
    self = [super init];
    if (self) {
        self.titleS = title;
        self.urlS = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleS?:@"";
    self.view.backgroundColor = kMainBackgroundColor;

    [self setupUI];
    [self mvvmBinding];
//    [RCHUDPop popupMessage:@"" toView:self.view];
    
    [NSURL URLWithString:self.urlS?:@""];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlS?:@""]]];

}


#pragma mark -- Private Method

- (void)setupUI {

    [self.view addSubview:self.webView];
}

- (void)mvvmBinding {
    
}

#pragma mark -- Public Method

#pragma mark -- OtherDelegate

#pragma mark -- UITableViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if (![url isEqualToString:self.urlS]) {
        if ([url containsString:ProductBaseServer]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return NO;
        }
    }
    return YES;
}
#pragma mark -- Getter Method
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-Height_NavBar)];
        _webView.delegate = self;
        _webView.backgroundColor = kMainBackgroundColor;
    }
    return _webView;
}

#pragma mark - 监听

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [RCHUDPop dismissHUDToView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [RCHUDPop dismissHUDToView:self.view];
}
#pragma mark -- Setter Method


@end
