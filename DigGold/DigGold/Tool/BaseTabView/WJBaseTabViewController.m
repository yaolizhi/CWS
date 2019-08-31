//
//  WJBaseTabViewController.m
//  SSKJ
//
//  Created by James on 2018/12/21.
//  Copyright © 2018年 刘小雨. All rights reserved.
//

#import "WJBaseTabViewController.h"
#import "WJSegmentView.h"
@interface WJBaseTabViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *ctrlContanier;/**<控制器容器*/
@property (nonatomic, strong)WJSegmentView *segment;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *vcsArray;
@end

@implementation WJBaseTabViewController

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
    self.title = Localized(@"", nil);
    self.view.backgroundColor = kMainBackgroundColor;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //只有这个方法中拿到了ctrlContanier的frame后才能去设置当前的控制器
//    [self scrollViewDidEndScrollingAnimation:self.ctrlContanier];
}

#pragma mark -- Private Method

- (void)setupUI {
    [self.view addSubview:self.segment];
    [self.view addSubview:self.ctrlContanier];
//    [self createChildCtrls];
    
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, KWJBaseTabHeight));
    }];
    [self.ctrlContanier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.segment.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    self.ctrlContanier.contentSize = CGSizeMake(self.childViewControllers.count*ScreenWidth, 0);
}

#pragma mark -- Public Method

#pragma mark -- UIScrollViewDelegate
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    CGFloat width = scrollView.frame.size.width;
//    CGFloat offsetX = scrollView.contentOffset.x;
//    NSInteger index = offsetX / width;
//    if (index<0) return;
//    [self loadViewWithIndex:index];
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self scrollViewDidEndScrollingAnimation:scrollView];
//}

- (void)loadViewWithIndex:(NSInteger)index {
    UIView *subView = [self.dataSource tabViewController:self didScrollToPageIndx:index];
    BOOL enableAddSubView = YES;
    for (UIView *v in self.ctrlContanier.subviews) {
        if (v == subView) {
            enableAddSubView = NO;
            break;
        }
    }
    if (enableAddSubView) {
        [self.ctrlContanier addSubview:subView];
    }
    [subView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ctrlContanier);
        make.width.mas_equalTo(ScreenWidth);
        make.height.equalTo(self.ctrlContanier);
        make.left.equalTo(self.ctrlContanier).offset(index*ScreenWidth);
    }];
}

- (void)triggerActionWithIndex:(NSUInteger)tabIndex {
    [self loadViewWithIndex:tabIndex];
}

#pragma mark -- Getter Method
- (WJSegmentView *)segment
{
    if (!_segment) {
        _segment = [[WJSegmentView alloc] initWithSegmentWithTitleArray:self.titlesArray];
        WS(weakSelf);
        _segment.clickSegmentButton = ^(NSInteger index) {
            CGPoint offset = weakSelf.ctrlContanier.contentOffset;
            offset.x = index * weakSelf.ctrlContanier.frame.size.width;
            [weakSelf.ctrlContanier setContentOffset:offset animated:YES];
            [weakSelf loadViewWithIndex:index];
 
            //点击
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tabViewController:didSelectedPageIndex:)]) {
//                [weakSelf.delegate tabViewController:weakSelf didSelectedPageIndex:index];
            }
        };
    }
    return _segment;
}

-(UIScrollView *)ctrlContanier {
    if (!_ctrlContanier) {
        _ctrlContanier = [[UIScrollView alloc] init];
        _ctrlContanier.scrollsToTop = NO;
        _ctrlContanier.showsVerticalScrollIndicator = NO;
        _ctrlContanier.showsHorizontalScrollIndicator = NO;
        _ctrlContanier.pagingEnabled = YES;
        _ctrlContanier.delegate = self;
    }
    return _ctrlContanier;
}
#pragma mark -- Setter Method

- (void)setDataSource:(id<WJBaseTabViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titlesOfTabViewController:)]) {
        self.titlesArray = [self.dataSource titlesOfTabViewController:self];
    }
    if (self.titlesArray.count > 0) {
        [self setupUI];
    }
}

@end
