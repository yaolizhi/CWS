//
//  RG_PullDownView.m
//  DigGold
//
//  Created by James on 2019/1/8.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import "RG_PullDownView.h"
#import "RG_PullDownTableViewCell.h"
@interface RG_PullDownView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation RG_PullDownView

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showIntro = NO;
        self.iconsArray = @[@"",@""];
        self.backgroundColor = kMainSubBackgroundColor;
        self.titlesArray = titlesArray;
        [self addSubview:self.tableView];
        [self setupMasnory];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray canSlide:(BOOL)canSlide
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canSlide = canSlide;
        self.showIntro = NO;
        self.iconsArray = @[@"",@""];
        self.backgroundColor = kMainSubBackgroundColor;
        self.titlesArray = titlesArray;
        [self addSubview:self.tableView];
        [self setupMasnory];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    [self.tableView reloadData];
}

- (void)setShowIntro:(BOOL)showIntro {
    _showIntro = showIntro;
    [self.tableView reloadData];
}

#pragma mark -- Private Method

- (void)setupMasnory {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        if (self.canSlide) {
            make.height.mas_equalTo(ScaleH(180));
        }else{
            make.height.mas_equalTo(PullDownViewCellHeight *self.titlesArray.count);
        }
        
        make.bottom.equalTo(self);
    }];
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    [self.tableView reloadData];
}

- (void)setIconsArray:(NSArray *)iconsArray {
    _iconsArray = iconsArray;
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RG_PullDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = self.bgColor?:kMainSubBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *title = self.titlesArray[indexPath.row];
    if (self.showIntro) {
        if ([title containsString:@"USDT"] && ![title containsString:@"1USDT = $1"]) {
            title = F(@"%@ (1USDT = $1)", title);
        }
    }
    if (self.canSlide) {
        [cell configureCellWithIcon:@""
                              title:title];
    }else{
        [cell configureCellWithIcon:self.iconsArray[indexPath.row]
                              title:title];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPullDownTitle:)]) {
        NSString *title = self.titlesArray[indexPath.row];
        if (self.showIntro) {
            if ([title containsString:@"USDT"] && ![title containsString:@"1USDT = $1"]) {
                title = F(@"%@ (1USDT = $1)", title);
            }
        }
        [self.delegate didSelectedPullDownTitle:title];
    }
}
#pragma mark -- Getter Method
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (self.canSlide) {
            _tableView.scrollEnabled = YES;
        }else{
            _tableView.scrollEnabled = NO;
        }
        
        _tableView.rowHeight = PullDownViewCellHeight;
        _tableView.backgroundColor = self.bgColor?:kMainSubBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[RG_PullDownTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark -- Setter Method

@end
