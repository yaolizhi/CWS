//
//  RG_SideslipView.m
//  DigGold
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_SideslipView.h"
#import "RG_SideslipTableViewCell.h"
@interface RG_SideslipView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *sideslipView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *iconsArray;
@end

@implementation RG_SideslipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.titlesArray = @[Localized(@"BSG", nil),
                             @"我的推广",
                             Localized(@"帮助中心", nil),
                             Localized(@"APP下载", nil),
                             @"版本升级"];
        self.iconsArray = @[@"mine_qj",@"mine_mytuiguang",@"mine_help",@"mine_download",@"mine_versionupload"];
//                self.iconsArray = @[@"mine_qj",@"mine_tuiguang",@"mine_mytuiguang",@"mine_help",@"mine_download",@"mine_versionupload"];
        
        [self addSubview:self.shadowView];
        [self addSubview:self.sideslipView];
        [self.sideslipView addSubview:self.logoImageView];
        [self.sideslipView addSubview:self.tableView];
        [self setupMasnory];
    }
    return self;
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    [self.sideslipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-ScreenWidth/2);
        make.top.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sideslipView);
        make.top.equalTo(self.sideslipView).offset(ScaleH(35));
//        make.width.mas_equalTo(ScaleW(123));
//        make.height.mas_equalTo(ScaleW(51));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sideslipView);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(ScaleH(30));
        make.width.mas_equalTo(ScreenWidth/2);
        make.bottom.equalTo(self.sideslipView);
    }];
}

- (void)configureView {
    
}

#pragma mark -- Public Method
- (void)showSideslipView {
    self.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.sideslipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
        }];
        [self.sideslipView.superview layoutIfNeeded];
    }];
}

- (void)dismissSideslipView {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.24 animations:^{
        [self.sideslipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(-ScreenWidth/2);
        }];
        [self.sideslipView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma mark -- Getter Method
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc]init];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.4;
    }
    return _shadowView;
}
- (UIView *)sideslipView {
    if (!_sideslipView) {
        _sideslipView = [[UIView alloc]init];
        _sideslipView.backgroundColor = kMainBackgroundColor;
    }
    return _sideslipView;
}
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.image = [UIImage imageNamed:@"mine_logo"];
    }
    return _logoImageView;
}


#pragma mark -- Setter Method


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_SideslipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kMainBackgroundColor;
    if (indexPath.row == 0) {
        cell.backgroundColor = kMainSubBackgroundColor;
    }
    [cell configureCellWithIcon:self.iconsArray[indexPath.row]
                    titleString:self.titlesArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSideslipWithIndex:)]) {
        [self dismissSideslipView];
        [self.delegate didSelectedSideslipWithIndex:indexPath.row];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2,0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = ScaleW(45);
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            
        }
        [_tableView registerClass:[RG_SideslipTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}


@end
