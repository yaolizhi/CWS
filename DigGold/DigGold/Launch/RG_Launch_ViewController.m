//
//  WL_Launch_ViewController.m
//  ZYW_MIT
//
//  Created by James on 2018/8/9.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import "RG_Launch_ViewController.h"

#import "UIImage+GIFS.h"

#import "AppDelegate.h"

#import "LLGifImageView.h"
#import "LLGifView.h"


@interface RG_Launch_ViewController ()

@property (nonatomic, strong) LLGifView *gifView;

@property (nonatomic, strong) LLGifImageView *gifImageView;

@end

@implementation RG_Launch_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *launchName = @"750x13341";
    if (ScreenHeight == 736) {//plus
        launchName = @"750x13341";
    }else if (ScreenHeight >= 812) {//x以上
        launchName = @"750x13341";
    }
    
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:launchName ofType:@"gif"]];
    
    UIImage *image = [[UIImage alloc] initWithData:localData];
    self.view.layer.contents = (id) image.CGImage;// 如果需要背景透明加上下面这句
    //    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
//    self.view.backgroundColor=[UIColor colorWithPatternImage:image];
    
     _gifView = [[LLGifView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight) data:localData];
    
    [self.view addSubview:_gifView];
    
     [_gifView startGif];
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [appDelegate performSelector:@selector(gotoMain) withObject:nil afterDelay:2.5];

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
