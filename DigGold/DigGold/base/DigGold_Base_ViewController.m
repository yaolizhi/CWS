//
//  DigGold_Base_ViewController.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "DigGold_Base_ViewController.h"

#import "DigGold_BaseTitleView.h"

@interface DigGold_Base_ViewController ()

@property (nonatomic, strong) DigGold_BaseTitleView *titleView;

@end

@implementation DigGold_Base_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = self.titleView;
    
    [self.titleView setTintColor:kMainNavbarColor];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, ScaleH(10));
    self.navigationController.navigationBar.layer.shadowOpacity = 0.2;

    
    [self setTitleFont:[UIFont boldSystemFontOfSize:ScaleFont(18)]];
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[WLTools imageOriginalWithImageName:@"nav_left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
        
        self.navigationItem.leftBarButtonItem = item;
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(DigGold_BaseTitleView *)titleView
{
    if (nil == _titleView) {
        
        _titleView = [[DigGold_BaseTitleView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 200, 40)];
        
    }
    return _titleView;
}

#pragma mark - 基本功能
/*
 * 修改导航栏字体颜色
 */
-(void)setTitleColor:(UIColor *)titleColor
{
    [self.titleView changeTitleColor:titleColor];
}

/*
 * 修改导航栏字体
 */
-(void)setTitleFont:(UIFont *)font
{
    [self.titleView changeTitleFont:font];
}

/*
 * 修改导航栏背景色
 */
-(void)setNavgationBackgroundColor:(UIColor *)navigationBackgroundColor
{
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
}

/*
 * 修改导航栏左侧按钮
 */
- (void)addLeftNavItemWithImage:(UIImage*)image
{
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    self.navigationItem.leftBarButtonItem = item;
}
/*
 * 修改导航栏左侧按钮
 */
- (void)addLeftNavItemWithTitle:(NSString*)title
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    item.tintColor = kGaryTextColor;
    self.navigationItem.leftBarButtonItem = item;
    
}
/*
 * 返回按钮点击事件
 */
- (void)leftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * 添加导航栏右侧按钮
 */
- (void)addRightNavItemWithTitle:(NSString*)title
{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rigthBtnAction:)];
    item.tintColor = kGaryTextColor;
    self.navigationItem.rightBarButtonItem = item;
    
}

/*
 * 添加导航栏右侧按钮
 */
- (void)addRightNavgationItemWithImage:(UIImage*)image
{
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rigthBtnAction:)];
    self.navigationItem.rightBarButtonItem = item;
}

/*
 * 导航栏右侧按钮点击事件
 */
- (void)rigthBtnAction:(id)sender
{
    
}

//-(void)changeTitle:(NSString *)title
//{
//
//    self.title = title;
//    [self.titleView changeTitle:title];
//
//
//}



-(void)setTitle:(NSString *)title
{
    
    [self.titleView changeTitle:title];
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
