//
//  RG_MessageDetail_ViewController.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/27.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "RG_MessageDetail_ViewController.h"
#import "RG_MessageModel.h"
@interface RG_MessageDetail_ViewController ()
/**contentView*/
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *contengView;
/**头信息*/
@property (nonatomic,strong) UIView *headerView;
/**标题*/
@property (nonatomic,strong) UILabel *titleLabel;
/**发布时间*/
@property (nonatomic,strong) UILabel *publicTimeLabel;
/**内容*/
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic, copy) NSString *messageID;
@end

@implementation RG_MessageDetail_ViewController

- (instancetype)initWithID:(NSString *)messageID
{
    self = [super init];
    if (self) {
        self.messageID = messageID?:@"";
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"通知中心";
    
    [self scrollView];
    
    [self contengView];
    
    [self headerView];
    
    [self titleLabel];
    
    [self publicTimeLabel];
    
    [self contentLabel];
    

    
//    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.contentLabel.bottom + 1000);
    [self fetchData];
}

- (void)fetchData {
    WS(weakSelf);
    NSDictionary *params = @{@"id":@([self.messageID integerValue]),
                             @"account":[[SSKJ_User_Tool sharedUserTool] getAccount]
                             };
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Notice_one_Post_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            RG_MessageModel *model = [RG_MessageModel mj_objectWithKeyValues:netWorkModel.data[@"list"]];
            weakSelf.titleLabel.text = model.content?:@"";
            weakSelf.publicTimeLabel.text = model.update_time?:@"";
            weakSelf.contentLabel.text = model.remark?:@"";
            [UILabel changeLineSpaceForLabel:weakSelf.contentLabel WithSpace:4];
        }else{
            [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
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

- (UIView *)headerView
{
    if (_headerView == nil) {
        
        _headerView = [[UIView alloc]init];
        
        _headerView.backgroundColor = kMainBackgroundColor;
        
        [self.contengView addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@(50));
            
            make.left.equalTo(@(0));
            
            make.width.equalTo(@(ScreenWidth));
            
            make.height.equalTo(@(80));
        }];
    }
    return _headerView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc]init];
        
//        _titleLabel.text = @"恭喜进入通知中心";
        
        _titleLabel.textColor = kMainTextColor;
        
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
//        CGFloat height = [WLTools getHeightLineWithString:@"恭喜进入通知中心" withWidth:ScreenWidth - 20 withFont:[UIFont systemFontOfSize:16]];
        
        [self.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@(10));
            
            make.left.equalTo(@(10));
            
            make.right.equalTo(@(-10));
            
//            make.height.equalTo(@(height));
        }];
    }
    
    return _titleLabel;
}

-(UILabel *)publicTimeLabel
{
    if (_publicTimeLabel == nil) {
        
        _publicTimeLabel = [[UILabel alloc]init];
        
//        _publicTimeLabel.text = @"2019-01-01 12:00:00";
        
        _publicTimeLabel.textColor = UIColorFromRGB(0xD4D5F6);
        
        _publicTimeLabel.font = [UIFont systemFontOfSize:14];
        
        _publicTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.headerView addSubview:_publicTimeLabel];
        
        [_publicTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            
            make.left.equalTo(@(10));
            
            make.right.equalTo(@(-10));
            
            make.height.equalTo(@(15));
        }];
    }
    
    return _publicTimeLabel;
}

-(UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        
        _contentLabel = [[UILabel alloc]init];
        
        _contentLabel.textColor = kMainTextColor;
        
        _contentLabel.font = [UIFont systemFontOfSize:14];
        
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        
        _contentLabel.numberOfLines = 0;
        
    
        
        [self.contengView addSubview:_contentLabel];
        
//         CGFloat height = [WLTools getHeightLineWithString:labelText withWidth:ScreenWidth -30 withFont:[UIFont systemFontOfSize:14]];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headerView.mas_bottom).offset(30);
            
            make.left.equalTo(@(15));
            make.right.equalTo(@(-15));
            
            make.width.equalTo(@(ScreenWidth - 30));
            
//            make.height.equalTo(@(height));
            
            make.bottom.equalTo(self.contengView.mas_bottom).offset(-50);

        }];
    }
    
    return _contentLabel;
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
