//
//  RG_DownSidelipView.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_DownSidelipView.h"

@interface RG_DownSidelipView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArray;
@end

@implementation RG_DownSidelipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.titlesArray = @[Localized(@"战绩", nil),
//                             Localized(@"我的资产", nil),
//                             Localized(@"安全设置", nil),
//                             Localized(@"通知中心", nil),
//                             Localized(@"支付密码", nil),
//                             Localized(@"退出", nil)];
        self.titlesArray = @[Localized(@"我的资产", nil),
                             Localized(@"安全设置", nil),
                             Localized(@"通知中心", nil),
                             Localized(@"支付密码", nil),
                             Localized(@"退出", nil)];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.tableView];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.width.mas_equalTo(ScaleW(100));
        make.height.mas_equalTo(ScaleH(35)*self.titlesArray.count+ScaleH(8));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(ScaleH(8));
        make.height.mas_equalTo(ScaleH(35)*self.titlesArray.count);
        make.bottom.equalTo(self.bgView).offset(-ScaleH(8));
//        make.bottom.equalTo(self.bgView).offset(-ScaleH(8));
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method
- (void)showSideslipView {
    self.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(250);
        }];
        [self.superview layoutIfNeeded];
    }];
}

- (void)dismissSideslipView {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma mark -- Getter Method

#pragma mark -- Setter Method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kMainBackgroundColor;
    cell.textLabel.font = [UIFont systemFontOfSize:ScaleFont(12)];
    cell.textLabel.textColor = kMainGaryWhiteColor;
    cell.textLabel.text = self.titlesArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDownSideslipWithIndex:)]) {
//        self.hidden = YES;
        [self.delegate didSelectedDownSideslipWithIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark -- Getter Method
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScaleW(100),0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = ScaleW(35);
        _tableView.rowHeight = ScaleW(35);
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kMainBackgroundColor;
    }
    return _bgView;
}
@end
