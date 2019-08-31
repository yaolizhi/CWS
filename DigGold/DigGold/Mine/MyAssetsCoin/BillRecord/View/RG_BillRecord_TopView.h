//
//  RG_BillRecord_TopView.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RG_BillRecord_TopView : UIView

@property (nonatomic,strong) UIView * startView;

@property (nonatomic,strong) UIButton * startbtn;

@property (nonatomic,strong) UIButton * startimg;

@property (nonatomic,strong) UIImageView * timeImg;

@property (nonatomic,strong) UIView * endView;

@property (nonatomic,strong) UIButton * endbtn;

@property (nonatomic,strong) UIButton * endimg;

@property (nonatomic,strong) UIButton * searchBtn;

@property (nonatomic,strong) UILabel * typeLabel;

@property (nonatomic,strong) UILabel * priceLabel;

@property (nonatomic,strong) UILabel * newpriceLabel;

@end

NS_ASSUME_NONNULL_END
